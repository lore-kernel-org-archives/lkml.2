Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933468Ab2EWLek (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 07:34:40 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:63234 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759773Ab2EWLei (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 07:34:38 -0400
Date: Wed, 23 May 2012 13:34:32 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86/urgent fixes for v3.5
Message-ID: <20120523113432.GA12142@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-urgent-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-urgent-for-linus

   HEAD: b2d668da9307c4c163dd603d2bb3cadb10f9fd37 x86, relocs: Build clean fix

These are the fixes left over from the very end of the v3.4 
stabilization cycle, plus one more fix.

 Thanks,

	Ingo

------------------>
Alan Cox (1):
      x86: Fix boot on Twinhead H12Y

Jarkko Sakkinen (1):
      x86, relocs: Build clean fix

Sasha Levin (1):
      x86, printk: Add missing KERN_CONT to NMI selftest


 arch/x86/Makefile              |  1 +
 arch/x86/kernel/nmi_selftest.c | 12 ++++++------
 arch/x86/pci/fixup.c           | 17 +++++++++++++++++
 3 files changed, 24 insertions(+), 6 deletions(-)

diff --git a/arch/x86/Makefile b/arch/x86/Makefile
index 94e91e4..b1c611e 100644
--- a/arch/x86/Makefile
+++ b/arch/x86/Makefile
@@ -206,6 +206,7 @@ archclean:
 	$(Q)rm -rf $(objtree)/arch/i386
 	$(Q)rm -rf $(objtree)/arch/x86_64
 	$(Q)$(MAKE) $(clean)=$(boot)
+	$(Q)$(MAKE) $(clean)=arch/x86/tools
 
 define archhelp
   echo  '* bzImage      - Compressed kernel image (arch/x86/boot/bzImage)'
diff --git a/arch/x86/kernel/nmi_selftest.c b/arch/x86/kernel/nmi_selftest.c
index 2c39dcd..9f11dd3 100644
--- a/arch/x86/kernel/nmi_selftest.c
+++ b/arch/x86/kernel/nmi_selftest.c
@@ -117,15 +117,15 @@ static void __init dotest(void (*testcase_fn)(void), int expected)
 		unexpected_testcase_failures++;
 
 		if (nmi_fail == FAILURE)
-			printk("FAILED |");
+			printk(KERN_CONT "FAILED |");
 		else if (nmi_fail == TIMEOUT)
-			printk("TIMEOUT|");
+			printk(KERN_CONT "TIMEOUT|");
 		else
-			printk("ERROR  |");
+			printk(KERN_CONT "ERROR  |");
 		dump_stack();
 	} else {
 		testcase_successes++;
-		printk("  ok  |");
+		printk(KERN_CONT "  ok  |");
 	}
 	testcase_total++;
 
@@ -150,10 +150,10 @@ void __init nmi_selftest(void)
 
 	print_testname("remote IPI");
 	dotest(remote_ipi, SUCCESS);
-	printk("\n");
+	printk(KERN_CONT "\n");
 	print_testname("local IPI");
 	dotest(local_ipi, SUCCESS);
-	printk("\n");
+	printk(KERN_CONT "\n");
 
 	cleanup_nmi_testsuite();
 
diff --git a/arch/x86/pci/fixup.c b/arch/x86/pci/fixup.c
index d0e6e40..5dd467b 100644
--- a/arch/x86/pci/fixup.c
+++ b/arch/x86/pci/fixup.c
@@ -519,3 +519,20 @@ static void sb600_disable_hpet_bar(struct pci_dev *dev)
 	}
 }
 DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_ATI, 0x4385, sb600_disable_hpet_bar);
+
+/*
+ * Twinhead H12Y needs us to block out a region otherwise we map devices
+ * there and any access kills the box.
+ *
+ *   See: https://bugzilla.kernel.org/show_bug.cgi?id=10231
+ *
+ * Match off the LPC and svid/sdid (older kernels lose the bridge subvendor)
+ */
+static void __devinit twinhead_reserve_killing_zone(struct pci_dev *dev)
+{
+        if (dev->subsystem_vendor == 0x14FF && dev->subsystem_device == 0xA003) {
+                pr_info("Reserving memory on Twinhead H12Y\n");
+                request_mem_region(0xFFB00000, 0x100000, "twinhead");
+        }
+}
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, 0x27B9, twinhead_reserve_killing_zone);
