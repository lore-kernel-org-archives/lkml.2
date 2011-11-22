Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758816Ab1KVWDl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 17:03:41 -0500
Received: from smtp5-g21.free.fr ([212.27.42.5]:33566 "EHLO smtp5-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758773Ab1KVWDi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 17:03:38 -0500
From: Corentin Chary <corentincj@iksaif.net>
To: platform-driver-x86@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
        Corentin Chary <corentincj@iksaif.net>,
        Matthew Garrett <mjg@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 07/15] samsung-laptop: remove selftest
Date: Tue, 22 Nov 2011 23:02:38 +0100
Message-Id: <1321999366-23784-8-git-send-email-corentincj@iksaif.net>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1321999366-23784-1-git-send-email-corentincj@iksaif.net>
References: <1321999366-23784-1-git-send-email-corentincj@iksaif.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We can now do the self test using debugfs, so remove the code
and keep the debug flag to enable more traces.

Signed-off-by: Corentin Chary <corentincj@iksaif.net>
---
 drivers/platform/x86/samsung-laptop.c |   77 +++-----------------------------
 1 files changed, 8 insertions(+), 69 deletions(-)

diff --git a/drivers/platform/x86/samsung-laptop.c b/drivers/platform/x86/samsung-laptop.c
index 8dc71a3..6493542 100644
--- a/drivers/platform/x86/samsung-laptop.c
+++ b/drivers/platform/x86/samsung-laptop.c
@@ -350,52 +350,6 @@ static int sabi_set_commandb(struct samsung_laptop *samsung,
 	return sabi_command(samsung, command, &in, NULL);
 }
 
-static void test_backlight(struct samsung_laptop *samsung)
-{
-	const struct sabi_commands *commands = &samsung->config->commands;
-	struct sabi_data sretval;
-
-	sabi_command(samsung, commands->get_backlight, NULL, &sretval);
-	printk(KERN_DEBUG "backlight = 0x%02x\n", sretval.data[0]);
-
-	sabi_set_commandb(samsung, commands->set_backlight, 0);
-	printk(KERN_DEBUG "backlight should be off\n");
-
-	sabi_command(samsung, commands->get_backlight, NULL, &sretval);
-	printk(KERN_DEBUG "backlight = 0x%02x\n", sretval.data[0]);
-
-	msleep(1000);
-
-	sabi_set_commandb(samsung, commands->set_backlight, 1);
-	printk(KERN_DEBUG "backlight should be on\n");
-
-	sabi_command(samsung, commands->get_backlight, NULL, &sretval);
-	printk(KERN_DEBUG "backlight = 0x%02x\n", sretval.data[0]);
-}
-
-static void test_wireless(struct samsung_laptop *samsung)
-{
-	const struct sabi_commands *commands = &samsung->config->commands;
-	struct sabi_data sretval;
-
-	sabi_command(samsung, commands->get_wireless_button, NULL, &sretval);
-	printk(KERN_DEBUG "wireless led = 0x%02x\n", sretval.data[0]);
-
-	sabi_set_commandb(samsung, commands->set_wireless_button, 0);
-	printk(KERN_DEBUG "wireless led should be off\n");
-
-	sabi_command(samsung, commands->get_wireless_button, NULL, &sretval);
-	printk(KERN_DEBUG "wireless led = 0x%02x\n", sretval.data[0]);
-
-	msleep(1000);
-
-	sabi_set_commandb(samsung, commands->set_wireless_button, 1);
-	printk(KERN_DEBUG "wireless led should be on\n");
-
-	sabi_command(samsung, commands->get_wireless_button, NULL, &sretval);
-	printk(KERN_DEBUG "wireless led = 0x%02x\n", sretval.data[0]);
-}
-
 static int read_brightness(struct samsung_laptop *samsung)
 {
 	const struct sabi_config *config = samsung->config;
@@ -828,12 +782,14 @@ static void samsung_sabi_exit(struct samsung_laptop *samsung)
 	samsung->config = NULL;
 }
 
-static __init void samsung_sabi_infos(struct samsung_laptop *samsung, int loca)
+static __init void samsung_sabi_infos(struct samsung_laptop *samsung, int loca,
+				      unsigned int ifaceP)
 {
 	const struct sabi_config *config = samsung->config;
 
 	printk(KERN_DEBUG "This computer supports SABI==%x\n",
 	       loca + 0xf0000 - 6);
+
 	printk(KERN_DEBUG "SABI header:\n");
 	printk(KERN_DEBUG " SMI Port Number = 0x%04x\n",
 	       readw(samsung->sabi + config->header_offsets.port));
@@ -847,23 +803,8 @@ static __init void samsung_sabi_infos(struct samsung_laptop *samsung, int loca)
 	       readw(samsung->sabi + config->header_offsets.data_offset));
 	printk(KERN_DEBUG " SABI data segment = 0x%04x\n",
 	       readw(samsung->sabi + config->header_offsets.data_segment));
-}
-
-static void __init samsung_sabi_selftest(struct samsung_laptop *samsung,
-					unsigned int ifaceP)
-{
-	const struct sabi_config *config = samsung->config;
-	struct sabi_data sretval;
-
-	printk(KERN_DEBUG "ifaceP = 0x%08x\n", ifaceP);
-	printk(KERN_DEBUG "sabi_iface = %p\n", samsung->sabi_iface);
 
-	if (samsung->handle_backlight)
-		test_backlight(samsung);
-	test_wireless(samsung);
-
-	sabi_command(samsung, config->commands.get_brightness, NULL, &sretval);
-	printk(KERN_DEBUG "brightness = 0x%02x\n", sretval.data[0]);
+	printk(KERN_DEBUG " SABI pointer = 0x%08x\n", ifaceP);
 }
 
 static int __init samsung_sabi_init(struct samsung_laptop *samsung)
@@ -904,12 +845,13 @@ static int __init samsung_sabi_init(struct samsung_laptop *samsung)
 	loca += 1;
 	samsung->sabi = (samsung->f0000_segment + loca);
 
-	if (debug)
-		samsung_sabi_infos(samsung, loca);
-
 	/* Get a pointer to the SABI Interface */
 	ifaceP = (readw(samsung->sabi + config->header_offsets.data_segment) & 0x0ffff) << 4;
 	ifaceP += readw(samsung->sabi + config->header_offsets.data_offset) & 0x0ffff;
+
+	if (debug)
+		samsung_sabi_infos(samsung, loca, ifaceP);
+
 	samsung->sabi_iface = ioremap_nocache(ifaceP, 16);
 	if (!samsung->sabi_iface) {
 		pr_err("Can't remap %x\n", ifaceP);
@@ -917,9 +859,6 @@ static int __init samsung_sabi_init(struct samsung_laptop *samsung)
 		goto exit;
 	}
 
-	if (debug)
-		samsung_sabi_selftest(samsung, ifaceP);
-
 	/* Turn on "Linux" mode in the BIOS */
 	if (commands->set_linux != 0xff) {
 		int retval = sabi_set_commandb(samsung,
-- 
1.7.5.4

