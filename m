Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755317Ab2BBKKq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 05:10:46 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:46330 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753983Ab2BBKKp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 05:10:45 -0500
Date: Thu, 2 Feb 2012 11:10:33 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86 fixes
Message-ID: <20120202101033.GA7085@elte.hu>
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

Please pull the latest x86-urgent-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-urgent-for-linus

   HEAD: e6d36a653becc7bbc643c399a77882e02bf552cb x86/reboot: Remove VersaLogic Menlow reboot quirk

 Thanks,

	Ingo

------------------>
Jan Beulich (1):
      x86: Properly parenthesize cmpxchg() macro arguments

Michael D Labriola (2):
      x86/reboot: Skip DMI checks if reboot set by user
      x86/reboot: Remove VersaLogic Menlow reboot quirk


 arch/x86/include/asm/cmpxchg.h |    6 +++---
 arch/x86/kernel/reboot.c       |   36 ++++++++++++++++++++++++++----------
 2 files changed, 29 insertions(+), 13 deletions(-)

diff --git a/arch/x86/include/asm/cmpxchg.h b/arch/x86/include/asm/cmpxchg.h
index 0c9fa27..b3b7332 100644
--- a/arch/x86/include/asm/cmpxchg.h
+++ b/arch/x86/include/asm/cmpxchg.h
@@ -145,13 +145,13 @@ extern void __add_wrong_size(void)
 
 #ifdef __HAVE_ARCH_CMPXCHG
 #define cmpxchg(ptr, old, new)						\
-	__cmpxchg((ptr), (old), (new), sizeof(*ptr))
+	__cmpxchg(ptr, old, new, sizeof(*(ptr)))
 
 #define sync_cmpxchg(ptr, old, new)					\
-	__sync_cmpxchg((ptr), (old), (new), sizeof(*ptr))
+	__sync_cmpxchg(ptr, old, new, sizeof(*(ptr)))
 
 #define cmpxchg_local(ptr, old, new)					\
-	__cmpxchg_local((ptr), (old), (new), sizeof(*ptr))
+	__cmpxchg_local(ptr, old, new, sizeof(*(ptr)))
 #endif
 
 /*
diff --git a/arch/x86/kernel/reboot.c b/arch/x86/kernel/reboot.c
index 37a458b..d840e69 100644
--- a/arch/x86/kernel/reboot.c
+++ b/arch/x86/kernel/reboot.c
@@ -39,6 +39,14 @@ static int reboot_mode;
 enum reboot_type reboot_type = BOOT_ACPI;
 int reboot_force;
 
+/* This variable is used privately to keep track of whether or not
+ * reboot_type is still set to its default value (i.e., reboot= hasn't
+ * been set on the command line).  This is needed so that we can
+ * suppress DMI scanning for reboot quirks.  Without it, it's
+ * impossible to override a faulty reboot quirk without recompiling.
+ */
+static int reboot_default = 1;
+
 #if defined(CONFIG_X86_32) && defined(CONFIG_SMP)
 static int reboot_cpu = -1;
 #endif
@@ -67,6 +75,12 @@ bool port_cf9_safe = false;
 static int __init reboot_setup(char *str)
 {
 	for (;;) {
+		/* Having anything passed on the command line via
+		 * reboot= will cause us to disable DMI checking
+		 * below.
+		 */
+		reboot_default = 0;
+
 		switch (*str) {
 		case 'w':
 			reboot_mode = 0x1234;
@@ -295,14 +309,6 @@ static struct dmi_system_id __initdata reboot_dmi_table[] = {
 			DMI_MATCH(DMI_BOARD_NAME, "P4S800"),
 		},
 	},
-	{	/* Handle problems with rebooting on VersaLogic Menlow boards */
-		.callback = set_bios_reboot,
-		.ident = "VersaLogic Menlow based board",
-		.matches = {
-			DMI_MATCH(DMI_BOARD_VENDOR, "VersaLogic Corporation"),
-			DMI_MATCH(DMI_BOARD_NAME, "VersaLogic Menlow board"),
-		},
-	},
 	{ /* Handle reboot issue on Acer Aspire one */
 		.callback = set_kbd_reboot,
 		.ident = "Acer Aspire One A110",
@@ -316,7 +322,12 @@ static struct dmi_system_id __initdata reboot_dmi_table[] = {
 
 static int __init reboot_init(void)
 {
-	dmi_check_system(reboot_dmi_table);
+	/* Only do the DMI check if reboot_type hasn't been overridden
+	 * on the command line
+	 */
+	if (reboot_default) {
+		dmi_check_system(reboot_dmi_table);
+	}
 	return 0;
 }
 core_initcall(reboot_init);
@@ -465,7 +476,12 @@ static struct dmi_system_id __initdata pci_reboot_dmi_table[] = {
 
 static int __init pci_reboot_init(void)
 {
-	dmi_check_system(pci_reboot_dmi_table);
+	/* Only do the DMI check if reboot_type hasn't been overridden
+	 * on the command line
+	 */
+	if (reboot_default) {
+		dmi_check_system(pci_reboot_dmi_table);
+	}
 	return 0;
 }
 core_initcall(pci_reboot_init);
