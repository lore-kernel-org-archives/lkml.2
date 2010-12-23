Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752649Ab0LWNAP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Dec 2010 08:00:15 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:45916 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751739Ab0LWNAO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Dec 2010 08:00:14 -0500
Date: Thu, 23 Dec 2010 14:00:02 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86 fix
Message-ID: <20101223130002.GA6401@elte.hu>
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

Please pull the latest x86-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-fixes-for-linus

 Thanks,

	Ingo

------------------>
H. Peter Anvin (1):
      x86, kexec: Limit the crashkernel address appropriately


 arch/x86/kernel/setup.c |   17 ++++++++++++++---
 1 files changed, 14 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 21c6746..c9089a1 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -501,7 +501,18 @@ static inline unsigned long long get_total_mem(void)
 	return total << PAGE_SHIFT;
 }
 
-#define DEFAULT_BZIMAGE_ADDR_MAX 0x37FFFFFF
+/*
+ * Keep the crash kernel below this limit.  On 32 bits earlier kernels
+ * would limit the kernel to the low 512 MiB due to mapping restrictions.
+ * On 64 bits, kexec-tools currently limits us to 896 MiB; increase this
+ * limit once kexec-tools are fixed.
+ */
+#ifdef CONFIG_X86_32
+# define CRASH_KERNEL_ADDR_MAX	(512 << 20)
+#else
+# define CRASH_KERNEL_ADDR_MAX	(896 << 20)
+#endif
+
 static void __init reserve_crashkernel(void)
 {
 	unsigned long long total_mem;
@@ -520,10 +531,10 @@ static void __init reserve_crashkernel(void)
 		const unsigned long long alignment = 16<<20;	/* 16M */
 
 		/*
-		 *  kexec want bzImage is below DEFAULT_BZIMAGE_ADDR_MAX
+		 *  kexec want bzImage is below CRASH_KERNEL_ADDR_MAX
 		 */
 		crash_base = memblock_find_in_range(alignment,
-			       DEFAULT_BZIMAGE_ADDR_MAX, crash_size, alignment);
+			       CRASH_KERNEL_ADDR_MAX, crash_size, alignment);
 
 		if (crash_base == MEMBLOCK_ERROR) {
 			pr_info("crashkernel reservation failed - No suitable area found.\n");
