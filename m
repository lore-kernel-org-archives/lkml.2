Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752452Ab1AFJ5t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 04:57:49 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:47932 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752249Ab1AFJ5s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 04:57:48 -0500
Date: Thu, 6 Jan 2011 10:57:31 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>, Borislav Petkov <bp@alien8.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86/microcode changes for v2.6.38
Message-ID: <20110106095731.GA18821@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
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
Borislav Petkov (1):
      x86, microcode, AMD: Cleanup code a bit

Jesper Juhl (1):
      x86, microcode, AMD: Replace vmalloc+memset with vzalloc


 arch/x86/include/asm/microcode.h |    6 ++++++
 arch/x86/kernel/microcode_amd.c  |   34 ++++++++++------------------------
 2 files changed, 16 insertions(+), 24 deletions(-)

diff --git a/arch/x86/include/asm/microcode.h b/arch/x86/include/asm/microcode.h
index ef51b50..2421507 100644
--- a/arch/x86/include/asm/microcode.h
+++ b/arch/x86/include/asm/microcode.h
@@ -48,6 +48,12 @@ static inline struct microcode_ops * __init init_intel_microcode(void)
 
 #ifdef CONFIG_MICROCODE_AMD
 extern struct microcode_ops * __init init_amd_microcode(void);
+
+static inline void get_ucode_data(void *to, const u8 *from, size_t n)
+{
+	memcpy(to, from, n);
+}
+
 #else
 static inline struct microcode_ops * __init init_amd_microcode(void)
 {
diff --git a/arch/x86/kernel/microcode_amd.c b/arch/x86/kernel/microcode_amd.c
index e1af7c0..15831336 100644
--- a/arch/x86/kernel/microcode_amd.c
+++ b/arch/x86/kernel/microcode_amd.c
@@ -155,12 +155,6 @@ static int apply_microcode_amd(int cpu)
 	return 0;
 }
 
-static int get_ucode_data(void *to, const u8 *from, size_t n)
-{
-	memcpy(to, from, n);
-	return 0;
-}
-
 static void *
 get_next_ucode(const u8 *buf, unsigned int size, unsigned int *mc_size)
 {
@@ -168,8 +162,7 @@ get_next_ucode(const u8 *buf, unsigned int size, unsigned int *mc_size)
 	u8 section_hdr[UCODE_CONTAINER_SECTION_HDR];
 	void *mc;
 
-	if (get_ucode_data(section_hdr, buf, UCODE_CONTAINER_SECTION_HDR))
-		return NULL;
+	get_ucode_data(section_hdr, buf, UCODE_CONTAINER_SECTION_HDR);
 
 	if (section_hdr[0] != UCODE_UCODE_TYPE) {
 		pr_err("error: invalid type field in container file section header\n");
@@ -183,16 +176,13 @@ get_next_ucode(const u8 *buf, unsigned int size, unsigned int *mc_size)
 		return NULL;
 	}
 
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
+	mc = vzalloc(UCODE_MAX_SIZE);
+	if (!mc)
+		return NULL;
+
+	get_ucode_data(mc, buf + UCODE_CONTAINER_SECTION_HDR, total_size);
+	*mc_size = total_size + UCODE_CONTAINER_SECTION_HDR;
+
 	return mc;
 }
 
@@ -202,8 +192,7 @@ static int install_equiv_cpu_table(const u8 *buf)
 	unsigned int *buf_pos = (unsigned int *)container_hdr;
 	unsigned long size;
 
-	if (get_ucode_data(&container_hdr, buf, UCODE_CONTAINER_HEADER_SIZE))
-		return 0;
+	get_ucode_data(&container_hdr, buf, UCODE_CONTAINER_HEADER_SIZE);
 
 	size = buf_pos[2];
 
@@ -219,10 +208,7 @@ static int install_equiv_cpu_table(const u8 *buf)
 	}
 
 	buf += UCODE_CONTAINER_HEADER_SIZE;
-	if (get_ucode_data(equiv_cpu_table, buf, size)) {
-		vfree(equiv_cpu_table);
-		return 0;
-	}
+	get_ucode_data(equiv_cpu_table, buf, size);
 
 	return size + UCODE_CONTAINER_HEADER_SIZE; /* add header length */
 }
