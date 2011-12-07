Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757383Ab1LGQSo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 11:18:44 -0500
Received: from cantor2.suse.de ([195.135.220.15]:33271 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757361Ab1LGQSk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 11:18:40 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Dec  7 08:08:27 2011
Message-Id: <20111207160827.517532356@clark.kroah.org>
User-Agent: quilt/0.50-23.1
Date: Wed, 07 Dec 2011 08:07:20 -0800
From: Greg KH <gregkh@suse.de>
To: <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>
Cc: <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <alan@lxorguk.ukuu.org.uk>, Peter Chubb <peter.chubb@nicta.com.au>,
        Don Zickus <dzickus@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>
Subject: [60/80] x86: Fix "Acer Aspire 1" reboot hang
In-Reply-To: <20111207161256.GA7736@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Chubb <peter.chubb@nicta.com.au>

commit 1ef03890969932e9359b9a4c658f7f87771910ac upstream.

Looks like on some Acer Aspire 1s with older bioses, reboot via bios
fails.  It works on my machine, (with BIOS version 0.3310) but
not on some others (BIOS version 0.3309).

There's a log of problems at:

  https://bbs.archlinux.org/viewtopic.php?id=124136

This patch adds a different callback to the reboot quirk table,
to allow rebooting via keybaord controller.

Reported-by: Uroš Vampl <mobile.leecher@gmail.com>
Tested-by: Vasily Khoruzhick <anarsoul@gmail.com>
Signed-off-by: Peter Chubb <peter.chubb@nicta.com.au>
Cc: Don Zickus <dzickus@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1323093233-9481-1-git-send-email-anarsoul@gmail.com
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/kernel/reboot.c |   13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

--- a/arch/x86/kernel/reboot.c
+++ b/arch/x86/kernel/reboot.c
@@ -124,7 +124,7 @@ __setup("reboot=", reboot_setup);
  */
 
 /*
- * Some machines require the "reboot=b"  commandline option,
+ * Some machines require the "reboot=b" or "reboot=k"  commandline options,
  * this quirk makes that automatic.
  */
 static int __init set_bios_reboot(const struct dmi_system_id *d)
@@ -136,6 +136,15 @@ static int __init set_bios_reboot(const
 	return 0;
 }
 
+static int __init set_kbd_reboot(const struct dmi_system_id *d)
+{
+	if (reboot_type != BOOT_KBD) {
+		reboot_type = BOOT_KBD;
+		printk(KERN_INFO "%s series board detected. Selecting KBD-method for reboot.\n", d->ident);
+	}
+	return 0;
+}
+
 static struct dmi_system_id __initdata reboot_dmi_table[] = {
 	{	/* Handle problems with rebooting on Dell E520's */
 		.callback = set_bios_reboot,
@@ -295,7 +304,7 @@ static struct dmi_system_id __initdata r
 		},
 	},
 	{ /* Handle reboot issue on Acer Aspire one */
-		.callback = set_bios_reboot,
+		.callback = set_kbd_reboot,
 		.ident = "Acer Aspire One A110",
 		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "Acer"),


