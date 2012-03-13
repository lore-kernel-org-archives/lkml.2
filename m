Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758580Ab2CMBDi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 21:03:38 -0400
Received: from mail.windriver.com ([147.11.1.11]:47411 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758270Ab2CMAWD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 20:22:03 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Borislav Petkov <borislav.petkov@amd.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 049/196] x86, microcode, AMD: Extend ucode size verification
Date: Mon, 12 Mar 2012 20:19:22 -0400
Message-Id: <1331598109-31424-4-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.3
In-Reply-To: <1331598109-31424-1-git-send-email-paul.gortmaker@windriver.com>
References: <1331597724-31358-1-git-send-email-paul.gortmaker@windriver.com>
 <1331598109-31424-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 44d60c0f5c58c2168f31df9a481761451840eb54 upstream.

The different families have a different max size for the ucode patch,
adjust size checking to the family we're running on. Also, do not
vzalloc the max size of the ucode but only the actual size that is
passed on from the firmware loader.

[PG: baseline of 44d60c0f5~1 differs in multiple trivial ways from
 the 34's; this commit makes get_next_ucode() look like 44d60c0f5's]

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 arch/x86/kernel/microcode_amd.c |   74 +++++++++++++++++++++++++--------------
 1 file changed, 48 insertions(+), 26 deletions(-)

diff --git a/arch/x86/kernel/microcode_amd.c b/arch/x86/kernel/microcode_amd.c
index e1af7c0..ed47400 100644
--- a/arch/x86/kernel/microcode_amd.c
+++ b/arch/x86/kernel/microcode_amd.c
@@ -66,7 +66,6 @@ struct microcode_amd {
 	unsigned int			mpb[0];
 };
 
-#define UCODE_MAX_SIZE			2048
 #define UCODE_CONTAINER_SECTION_HDR	8
 #define UCODE_CONTAINER_HEADER_SIZE	12
 
@@ -155,6 +154,37 @@ static int apply_microcode_amd(int cpu)
 	return 0;
 }
 
+static unsigned int verify_ucode_size(int cpu, const u8 *buf, unsigned int size)
+{
+	struct cpuinfo_x86 *c = &cpu_data(cpu);
+	unsigned int max_size, actual_size;
+
+#define F1XH_MPB_MAX_SIZE 2048
+#define F14H_MPB_MAX_SIZE 1824
+#define F15H_MPB_MAX_SIZE 4096
+
+	switch (c->x86) {
+	case 0x14:
+		max_size = F14H_MPB_MAX_SIZE;
+		break;
+	case 0x15:
+		max_size = F15H_MPB_MAX_SIZE;
+		break;
+	default:
+		max_size = F1XH_MPB_MAX_SIZE;
+		break;
+	}
+
+	actual_size = buf[4] + (buf[5] << 8);
+
+	if (actual_size > size || actual_size > max_size) {
+		pr_err("section size mismatch\n");
+		return 0;
+	}
+
+	return actual_size;
+}
+
 static int get_ucode_data(void *to, const u8 *from, size_t n)
 {
 	memcpy(to, from, n);
@@ -162,37 +192,29 @@ static int get_ucode_data(void *to, const u8 *from, size_t n)
 }
 
 static void *
-get_next_ucode(const u8 *buf, unsigned int size, unsigned int *mc_size)
+get_next_ucode(int cpu, const u8 *buf, unsigned int size, unsigned int *mc_size)
 {
-	unsigned int total_size;
-	u8 section_hdr[UCODE_CONTAINER_SECTION_HDR];
-	void *mc;
+	void *mc = NULL;
+	unsigned int actual_size = 0;
 
-	if (get_ucode_data(section_hdr, buf, UCODE_CONTAINER_SECTION_HDR))
-		return NULL;
-
-	if (section_hdr[0] != UCODE_UCODE_TYPE) {
+	if (buf[0] != UCODE_UCODE_TYPE) {
 		pr_err("error: invalid type field in container file section header\n");
-		return NULL;
+		goto out;
 	}
 
-	total_size = (unsigned long) (section_hdr[4] + (section_hdr[5] << 8));
+	actual_size = verify_ucode_size(cpu, buf, size);
+	if (!actual_size)
+		goto out;
 
-	if (total_size > size || total_size > UCODE_MAX_SIZE) {
-		pr_err("error: size mismatch\n");
-		return NULL;
-	}
+	mc = vmalloc(actual_size);
+	if (!mc)
+		goto out;
 
-	mc = vmalloc(UCODE_MAX_SIZE);
-	if (mc) {
-		memset(mc, 0, UCODE_MAX_SIZE);
-		if (get_ucode_data(mc, buf + UCODE_CONTAINER_SECTION_HDR,
-				   total_size)) {
-			vfree(mc);
-			mc = NULL;
-		} else
-			*mc_size = total_size + UCODE_CONTAINER_SECTION_HDR;
-	}
+	memset(mc, 0, actual_size);
+	get_ucode_data(mc, buf + UCODE_CONTAINER_SECTION_HDR, actual_size);
+	*mc_size = actual_size + UCODE_CONTAINER_SECTION_HDR;
+
+out:
 	return mc;
 }
 
@@ -258,7 +280,7 @@ generic_load_microcode(int cpu, const u8 *data, size_t size)
 		unsigned int uninitialized_var(mc_size);
 		struct microcode_header_amd *mc_header;
 
-		mc = get_next_ucode(ucode_ptr, leftover, &mc_size);
+		mc = get_next_ucode(cpu, ucode_ptr, leftover, &mc_size);
 		if (!mc)
 			break;
 
-- 
1.7.9.3

