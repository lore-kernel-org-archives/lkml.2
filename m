Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758103Ab1DMQAe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 12:00:34 -0400
Received: from kroah.org ([198.145.64.141]:54513 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932185Ab1DMPzx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 11:55:53 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Apr 13 08:51:49 2011
Message-Id: <20110413155148.974006996@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 13 Apr 2011 08:51:20 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Greg Kroah-Hartman <greg@kroah.com>,
        Borislav Petkov <borislav.petkov@amd.com>,
        Boris Ostrovsky <boris.ostrovsky@amd.com>
Subject: [56/74] x86, microcode, AMD: Extend ucode size verification
In-Reply-To: <20110413155406.GA22568@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------


From: Borislav Petkov <borislav.petkov@amd.com>

Upstream commit: 44d60c0f5c58c2168f31df9a481761451840eb54

The different families have a different max size for the ucode patch,
adjust size checking to the family we're running on. Also, do not
vzalloc the max size of the ucode but only the actual size that is
passed on from the firmware loader.

Cc: <stable@kernel.org>
Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 arch/x86/kernel/microcode_amd.c |   63 +++++++++++++++++++++++++++-------------
 1 file changed, 44 insertions(+), 19 deletions(-)

--- a/arch/x86/kernel/microcode_amd.c
+++ b/arch/x86/kernel/microcode_amd.c
@@ -63,7 +63,6 @@ struct microcode_amd {
 	unsigned int			mpb[0];
 };
 
-#define UCODE_MAX_SIZE			2048
 #define UCODE_CONTAINER_SECTION_HDR	8
 #define UCODE_CONTAINER_HEADER_SIZE	12
 
@@ -125,6 +124,37 @@ static int get_matching_microcode(int cp
 	return 1;
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
 static int apply_microcode_amd(int cpu)
 {
 	u32 rev, dummy;
@@ -164,11 +194,11 @@ static int get_ucode_data(void *to, cons
 }
 
 static void *
-get_next_ucode(const u8 *buf, unsigned int size, unsigned int *mc_size)
+get_next_ucode(int cpu, const u8 *buf, unsigned int size, unsigned int *mc_size)
 {
-	unsigned int total_size;
+	unsigned int actual_size = 0;
 	u8 section_hdr[UCODE_CONTAINER_SECTION_HDR];
-	void *mc;
+	void *mc = NULL;
 
 	if (get_ucode_data(section_hdr, buf, UCODE_CONTAINER_SECTION_HDR))
 		return NULL;
@@ -179,23 +209,18 @@ get_next_ucode(const u8 *buf, unsigned i
 		return NULL;
 	}
 
-	total_size = (unsigned long) (section_hdr[4] + (section_hdr[5] << 8));
+	actual_size = verify_ucode_size(cpu, buf, size);
+	if (!actual_size)
+		return NULL;
 
-	if (total_size > size || total_size > UCODE_MAX_SIZE) {
-		printk(KERN_ERR "microcode: error: size mismatch\n");
+	mc = vmalloc(actual_size);
+	if (!mc)
 		return NULL;
-	}
 
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
 	return mc;
 }
 
@@ -264,7 +289,7 @@ generic_load_microcode(int cpu, const u8
 		unsigned int uninitialized_var(mc_size);
 		struct microcode_header_amd *mc_header;
 
-		mc = get_next_ucode(ucode_ptr, leftover, &mc_size);
+		mc = get_next_ucode(cpu, ucode_ptr, leftover, &mc_size);
 		if (!mc)
 			break;
 


