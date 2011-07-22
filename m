Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754733Ab1GVPL2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jul 2011 11:11:28 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:33015 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754524Ab1GVPL1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jul 2011 11:11:27 -0400
Date: Fri, 22 Jul 2011 17:10:36 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>, Borislav Petkov <bp@alien8.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86/microcode changes for v3.1
Message-ID: <20110722151036.GA19484@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-microcode-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-microcode-for-linus

 Thanks,

	Ingo

------------------>
Borislav Petkov (2):
      x86, microcode, AMD: Correct buf references
      x86, microcode, AMD: Fix section header size check


 arch/x86/kernel/microcode_amd.c |   21 +++++++++++----------
 1 files changed, 11 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kernel/microcode_amd.c b/arch/x86/kernel/microcode_amd.c
index c561038..591be0e 100644
--- a/arch/x86/kernel/microcode_amd.c
+++ b/arch/x86/kernel/microcode_amd.c
@@ -66,8 +66,8 @@ struct microcode_amd {
 	unsigned int			mpb[0];
 };
 
-#define UCODE_CONTAINER_SECTION_HDR	8
-#define UCODE_CONTAINER_HEADER_SIZE	12
+#define SECTION_HDR_SIZE	8
+#define CONTAINER_HDR_SZ	12
 
 static struct equiv_cpu_entry *equiv_cpu_table;
 
@@ -157,7 +157,7 @@ static int apply_microcode_amd(int cpu)
 static unsigned int verify_ucode_size(int cpu, const u8 *buf, unsigned int size)
 {
 	struct cpuinfo_x86 *c = &cpu_data(cpu);
-	unsigned int max_size, actual_size;
+	u32 max_size, actual_size;
 
 #define F1XH_MPB_MAX_SIZE 2048
 #define F14H_MPB_MAX_SIZE 1824
@@ -175,9 +175,9 @@ static unsigned int verify_ucode_size(int cpu, const u8 *buf, unsigned int size)
 		break;
 	}
 
-	actual_size = buf[4] + (buf[5] << 8);
+	actual_size = *(u32 *)(buf + 4);
 
-	if (actual_size > size || actual_size > max_size) {
+	if (actual_size + SECTION_HDR_SIZE > size || actual_size > max_size) {
 		pr_err("section size mismatch\n");
 		return 0;
 	}
@@ -191,7 +191,7 @@ get_next_ucode(int cpu, const u8 *buf, unsigned int size, unsigned int *mc_size)
 	struct microcode_header_amd *mc = NULL;
 	unsigned int actual_size = 0;
 
-	if (buf[0] != UCODE_UCODE_TYPE) {
+	if (*(u32 *)buf != UCODE_UCODE_TYPE) {
 		pr_err("invalid type field in container file section header\n");
 		goto out;
 	}
@@ -204,8 +204,8 @@ get_next_ucode(int cpu, const u8 *buf, unsigned int size, unsigned int *mc_size)
 	if (!mc)
 		goto out;
 
-	get_ucode_data(mc, buf + UCODE_CONTAINER_SECTION_HDR, actual_size);
-	*mc_size = actual_size + UCODE_CONTAINER_SECTION_HDR;
+	get_ucode_data(mc, buf + SECTION_HDR_SIZE, actual_size);
+	*mc_size = actual_size + SECTION_HDR_SIZE;
 
 out:
 	return mc;
@@ -229,9 +229,10 @@ static int install_equiv_cpu_table(const u8 *buf)
 		return -ENOMEM;
 	}
 
-	get_ucode_data(equiv_cpu_table, buf + UCODE_CONTAINER_HEADER_SIZE, size);
+	get_ucode_data(equiv_cpu_table, buf + CONTAINER_HDR_SZ, size);
 
-	return size + UCODE_CONTAINER_HEADER_SIZE; /* add header length */
+	/* add header length */
+	return size + CONTAINER_HDR_SZ;
 }
 
 static void free_equiv_cpu_table(void)
