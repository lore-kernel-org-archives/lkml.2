Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756564Ab0EQXGr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 19:06:47 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:48866 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756407Ab0EQXGq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 19:06:46 -0400
Date: Tue, 18 May 2010 01:06:28 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86/microcode changes for v2.6.35
Message-ID: <20100517230628.GA5703@elte.hu>
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
Arnd Bergmann (1):
      x86/microcode: Use nonseekable_open()

Dimitri Sivanich (1):
      x86: Improve Intel microcode loader performance


 arch/x86/kernel/microcode_core.c  |    4 ++--
 arch/x86/kernel/microcode_intel.c |   22 ++++++++++++++++------
 2 files changed, 18 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kernel/microcode_core.c b/arch/x86/kernel/microcode_core.c
index cceb5bc..2cd8c54 100644
--- a/arch/x86/kernel/microcode_core.c
+++ b/arch/x86/kernel/microcode_core.c
@@ -201,9 +201,9 @@ static int do_microcode_update(const void __user *buf, size_t size)
 	return error;
 }
 
-static int microcode_open(struct inode *unused1, struct file *unused2)
+static int microcode_open(struct inode *inode, struct file *file)
 {
-	return capable(CAP_SYS_RAWIO) ? 0 : -EPERM;
+	return capable(CAP_SYS_RAWIO) ? nonseekable_open(inode, file) : -EPERM;
 }
 
 static ssize_t microcode_write(struct file *file, const char __user *buf,
diff --git a/arch/x86/kernel/microcode_intel.c b/arch/x86/kernel/microcode_intel.c
index 85a343e..3561702 100644
--- a/arch/x86/kernel/microcode_intel.c
+++ b/arch/x86/kernel/microcode_intel.c
@@ -343,10 +343,11 @@ static enum ucode_state generic_load_microcode(int cpu, void *data, size_t size,
 				int (*get_ucode_data)(void *, const void *, size_t))
 {
 	struct ucode_cpu_info *uci = ucode_cpu_info + cpu;
-	u8 *ucode_ptr = data, *new_mc = NULL, *mc;
+	u8 *ucode_ptr = data, *new_mc = NULL, *mc = NULL;
 	int new_rev = uci->cpu_sig.rev;
 	unsigned int leftover = size;
 	enum ucode_state state = UCODE_OK;
+	unsigned int curr_mc_size = 0;
 
 	while (leftover) {
 		struct microcode_header_intel mc_header;
@@ -361,9 +362,15 @@ static enum ucode_state generic_load_microcode(int cpu, void *data, size_t size,
 			break;
 		}
 
-		mc = vmalloc(mc_size);
-		if (!mc)
-			break;
+		/* For performance reasons, reuse mc area when possible */
+		if (!mc || mc_size > curr_mc_size) {
+			if (mc)
+				vfree(mc);
+			mc = vmalloc(mc_size);
+			if (!mc)
+				break;
+			curr_mc_size = mc_size;
+		}
 
 		if (get_ucode_data(mc, ucode_ptr, mc_size) ||
 		    microcode_sanity_check(mc) < 0) {
@@ -376,13 +383,16 @@ static enum ucode_state generic_load_microcode(int cpu, void *data, size_t size,
 				vfree(new_mc);
 			new_rev = mc_header.rev;
 			new_mc  = mc;
-		} else
-			vfree(mc);
+			mc = NULL;	/* trigger new vmalloc */
+		}
 
 		ucode_ptr += mc_size;
 		leftover  -= mc_size;
 	}
 
+	if (mc)
+		vfree(mc);
+
 	if (leftover) {
 		if (new_mc)
 			vfree(new_mc);
