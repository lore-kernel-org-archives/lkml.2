Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756646Ab0EQXLV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 19:11:21 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:52289 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753802Ab0EQXLU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 19:11:20 -0400
Date: Tue, 18 May 2010 01:11:13 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86/mrst changes for v2.6.35
Message-ID: <20100517231113.GA8232@elte.hu>
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

Please pull the latest Intel Moorestown git tree 
from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-mrst-for-linus

 Thanks,

	Ingo

------------------>
Jacob Pan (3):
      x86: Avoid check hlt for newer cpus
      x86, mrst, pci: return 0 for non-present pci bars
      x86, mrst: add nop functions to x86_init mpparse functions


 arch/x86/kernel/cpu/bugs.c |    2 +-
 arch/x86/kernel/mrst.c     |    5 +++++
 arch/x86/pci/mrst.c        |    2 +-
 3 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
index 01a2652..c39576c 100644
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -86,7 +86,7 @@ static void __init check_fpu(void)
 
 static void __init check_hlt(void)
 {
-	if (paravirt_enabled())
+	if (boot_cpu_data.x86 >= 5 || paravirt_enabled())
 		return;
 
 	printk(KERN_INFO "Checking 'hlt' instruction... ");
diff --git a/arch/x86/kernel/mrst.c b/arch/x86/kernel/mrst.c
index 0aad867..e796448 100644
--- a/arch/x86/kernel/mrst.c
+++ b/arch/x86/kernel/mrst.c
@@ -237,4 +237,9 @@ void __init x86_mrst_early_setup(void)
 	x86_init.pci.fixup_irqs = x86_init_noop;
 
 	legacy_pic = &null_legacy_pic;
+
+	/* Avoid searching for BIOS MP tables */
+	x86_init.mpparse.find_smp_config = x86_init_noop;
+	x86_init.mpparse.get_smp_config = x86_init_uint_noop;
+
 }
diff --git a/arch/x86/pci/mrst.c b/arch/x86/pci/mrst.c
index 8bf2fcb..d5c7aef 100644
--- a/arch/x86/pci/mrst.c
+++ b/arch/x86/pci/mrst.c
@@ -109,7 +109,7 @@ static int pci_device_update_fixed(struct pci_bus *bus, unsigned int devfn,
 			decode++;
 			decode = ~(decode - 1);
 		} else {
-			decode = ~0;
+			decode = 0;
 		}
 
 		/*
