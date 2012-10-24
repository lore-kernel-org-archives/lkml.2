Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964793Ab2JXGsf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 02:48:35 -0400
Received: from mail-1.atlantis.sk ([80.94.52.57]:39923 "EHLO mail.atlantis.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933722Ab2JXGsd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 02:48:33 -0400
From: Ondrej Zary <linux@rainbow-software.org>
To: hpa@zytor.com
Subject: [PATCH] Enable A20 using KBC for some MSI laptops to fix S3 resume
Date: Wed, 24 Oct 2012 08:47:52 +0200
User-Agent: KMail/1.9.10 (enterprise35 0.20100827.1168748)
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201210240847.52417.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some MSI laptop BIOSes are broken - INT 15h code uses port 92h to enable A20
line but resume code assumes that KBC was used.
The laptop will not resume from S3 otherwise but powers off after a while
and then powers on again stuck with a blank screen.

Fix it by enabling A20 using KBC. Affected laptop list and DMI data are from
bug reports at Ubuntu Launchpad.

Tested with EX600 and PR200.

Fixes https://bugzilla.kernel.org/show_bug.cgi?id=12878

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>

--- a/arch/x86/kernel/acpi/boot.c
+++ b/arch/x86/kernel/acpi/boot.c
@@ -1349,6 +1349,20 @@ static int __init dmi_ignore_irq0_timer_override(const struct dmi_system_id *d)
 }
 
 /*
+ * Enable A20 line using KBC even if it's already enabled using other method.
+ * This is needed for some MSI laptops to resume from S3.
+ */
+static int __init a20_enable_kbc(const struct dmi_system_id *d)
+{
+	printk(KERN_NOTICE "%s detected: enabling A20 using KBC\n", d->ident);
+	outb(0xd1, 0x64);	/* Command write */
+	outb(0xdf, 0x60);	/* A20 on */
+	outb(0xff, 0x64);	/* Null command, but UHCI wants it */
+
+	return 0;
+}
+
+/*
  * If your system is blacklisted here, but you find that acpi=force
  * works for you, please contact linux-acpi@vger.kernel.org
  */
@@ -1423,6 +1437,60 @@ static struct dmi_system_id __initdata acpi_dmi_table[] = {
 		     DMI_MATCH(DMI_PRODUCT_NAME, "TravelMate 360"),
 		     },
 	 },
+	/*
+	 * Some MSI laptop BIOSes are broken - INT 15h code uses port 92h to
+	 * enable A20 line but resume code assumes that KBC was used.
+	 * The laptop will not resume from S3 otherwise but powers off
+	 * after a while and then powers on again stuck with a blank screen.
+	 */
+	{
+	 .callback = a20_enable_kbc,
+	 .ident = "MSI EX600 Laptop",
+	 .matches = {
+		     DMI_MATCH(DMI_SYS_VENDOR, "Micro-Star International"),
+		     DMI_MATCH(DMI_PRODUCT_NAME, "MSI Notebook EX600"),
+		     },
+	 },
+	{
+	 .callback = a20_enable_kbc,
+	 .ident = "MSI EX700 Laptop",
+	 .matches = {
+		     DMI_MATCH(DMI_SYS_VENDOR, "Micro-Star International"),
+		     DMI_MATCH(DMI_PRODUCT_NAME, "EX700"),
+		     },
+	 },
+	{
+	 .callback = a20_enable_kbc,
+	 .ident = "MSI GX700 Laptop",
+	 .matches = {
+		     DMI_MATCH(DMI_SYS_VENDOR, "Micro-Star International"),
+		     DMI_MATCH(DMI_PRODUCT_NAME, "GX700"),
+		     },
+	 },
+	{
+	 .callback = a20_enable_kbc,
+	 .ident = "MSI VR201 Laptop",
+	 .matches = {
+		     DMI_MATCH(DMI_SYS_VENDOR, "Micro-Star International"),
+		     DMI_MATCH(DMI_PRODUCT_NAME, "MSI Notebook VR201"),
+		     },
+	 },
+	{
+	 .callback = a20_enable_kbc,
+	 .ident = "MSI VR601 Laptop",
+	 .matches = {
+		     DMI_MATCH(DMI_SYS_VENDOR, "Micro-Star International"),
+		     DMI_MATCH(DMI_PRODUCT_NAME, "MSI Notebook VR601"),
+		     },
+	 },
+	{
+	 .callback = a20_enable_kbc,
+	 .ident = "MSI PR200 Laptop",
+	 .matches = {
+		     DMI_MATCH(DMI_SYS_VENDOR, "Micro-Star International"),
+		     DMI_MATCH(DMI_PRODUCT_NAME, "MSI Notebook PR200"),
+		     },
+	 },
 	{}
 };
 


-- 
Ondrej Zary
