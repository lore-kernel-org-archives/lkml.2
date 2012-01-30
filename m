Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752558Ab2A3NWa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 08:22:30 -0500
Received: from terminus.zytor.com ([198.137.202.10]:46505 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752051Ab2A3NW2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 08:22:28 -0500
Date: Mon, 30 Jan 2012 05:21:39 -0800
From: tip-bot for Michael D Labriola <michael.d.labriola@gmail.com>
Message-ID: <tip-5955633e91bfc5cd0a41d8d82259e1d8b32980ef@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, mjg@redhat.com, hpa@zytor.com,
        mingo@redhat.com, torvalds@linux-foundation.org, mlabriol@gdeb.com,
        alan@lxorguk.ukuu.org.uk, michael.d.labriola@gmail.com,
        tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, mjg@redhat.com,
        linux-kernel@vger.kernel.org, michael.d.labriola@gmail.com,
        torvalds@linux-foundation.org, mlabriol@gdeb.com, tglx@linutronix.de,
        alan@lxorguk.ukuu.org.uk, mingo@elte.hu
In-Reply-To: <87wr8ab9od.fsf@gmail.com>
References: <87wr8ab9od.fsf@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86/reboot: Skip DMI checks if reboot set by user
Git-Commit-ID: 5955633e91bfc5cd0a41d8d82259e1d8b32980ef
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 30 Jan 2012 05:21:48 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  5955633e91bfc5cd0a41d8d82259e1d8b32980ef
Gitweb:     http://git.kernel.org/tip/5955633e91bfc5cd0a41d8d82259e1d8b32980ef
Author:     Michael D Labriola <michael.d.labriola@gmail.com>
AuthorDate: Sun, 29 Jan 2012 14:17:22 -0500
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 30 Jan 2012 10:52:32 +0100

x86/reboot: Skip DMI checks if reboot set by user

Skip DMI checks for vendor specific reboot quirks if the user
passed in a reboot= arg on the command line - we should never
override user choices.

Signed-off-by: Michael D Labriola <michael.d.labriola@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Michael D Labriola <mlabriol@gdeb.com>
Cc: Matthew Garrett <mjg@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: http://lkml.kernel.org/r/87wr8ab9od.fsf@gmail.com
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/reboot.c |   28 ++++++++++++++++++++++++++--
 1 files changed, 26 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/reboot.c b/arch/x86/kernel/reboot.c
index 37a458b..b257f0e 100644
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
@@ -316,7 +330,12 @@ static struct dmi_system_id __initdata reboot_dmi_table[] = {
 
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
@@ -465,7 +484,12 @@ static struct dmi_system_id __initdata pci_reboot_dmi_table[] = {
 
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
