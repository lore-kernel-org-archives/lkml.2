Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754229Ab2K3IMe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 03:12:34 -0500
Received: from mail-1-out2.atlantis.sk ([80.94.52.71]:35867 "EHLO
	mail.atlantis.sk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754122Ab2K3IMc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 03:12:32 -0500
To: hpa@zytor.com
Subject: [PATCH v3] [resend] Enable A20 using KBC for some MSI laptops to fix S3 resume
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Disposition: inline
From: Ondrej Zary <linux@rainbow-software.org>
Date: Fri, 30 Nov 2012 09:11:44 +0100
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201211300911.45102.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some MSI laptop BIOSes are broken - INT 15h code uses port 92h to enable A20
line but resume code assumes that KBC was used.
The laptop will not resume from S3 otherwise but powers off after a while
and then powers on again stuck with a blank screen.

Fix it by enabling A20 using KBC. Affected laptop list and DMI data are from
bug reports at Ubuntu Launchpad.

Also add kernel parameter to easily activate this quirk on any system.

Only compile tested. The original patch was tested with EX600 and PR200.

Fixes https://bugzilla.kernel.org/show_bug.cgi?id=12878

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
---
 Documentation/kernel-parameters.txt |    6 ++
 arch/x86/kernel/acpi/boot.c         |  122 +++++++++++++++++++++++++++++++++++
 2 files changed, 128 insertions(+), 0 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 9776f06..eb3d6a4 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -153,6 +153,12 @@ multipliers 'Kilo', 'Mega', and 'Giga', equalling 2^10, 2^20, and 2^30
 bytes respectively. Such letter suffixes can also be entirely omitted.
 
 
+	a20_enable_kbc	[ACPI,X86]
+			Enable A20 line using KBC even if it's already
+			enabled using other method.
+			This is needed for some MSI laptops to resume from
+			S3.
+
 	acpi=		[HW,ACPI,X86]
 			Advanced Configuration and Power Interface
 			Format: { force | off | strict | noirq | rsdt }
diff --git a/arch/x86/kernel/acpi/boot.c b/arch/x86/kernel/acpi/boot.c
index e651f7a..64169ca 100644
--- a/arch/x86/kernel/acpi/boot.c
+++ b/arch/x86/kernel/acpi/boot.c
@@ -1349,6 +1349,67 @@ static int __init dmi_ignore_irq0_timer_override(const struct dmi_system_id *d)
 }
 
 /*
+ * Copied from arch/x86/boot/a20.c. Direct port writes (and no locking) are safe
+ * here because this is executed very early, before any drivers (like i8042).
+ */
+#define MAX_8042_LOOPS	100000
+#define MAX_8042_FF	32
+
+static int empty_8042(void)
+{
+	u8 status;
+	int loops = MAX_8042_LOOPS;
+	int ffs   = MAX_8042_FF;
+
+	while (loops--) {
+		outb(0, 0x80); /* delay */
+
+		status = inb(0x64);
+		if (status == 0xff) {
+			/* FF is a plausible, but very unlikely status */
+			if (!--ffs)
+				return -1; /* Assume no KBC present */
+		}
+		if (status & 1) {
+			/* Read and discard input data */
+			outb(0, 0x80); /* delay */
+			(void)inb(0x60);
+		} else if (!(status & 2)) {
+			/* Buffers empty, finished! */
+			return 0;
+		}
+	}
+
+	return -1;
+}
+
+static void enable_a20_kbc(void)
+{
+	empty_8042();
+
+	outb(0xd1, 0x64);	/* Command write */
+	empty_8042();
+
+	outb(0xdf, 0x60);	/* A20 on */
+	empty_8042();
+
+	outb(0xff, 0x64);	/* Null command, but UHCI wants it */
+	empty_8042();
+}
+
+/*
+ * Enable A20 line using KBC even if it's already enabled using other method.
+ * This is needed for some MSI laptops to resume from S3.
+ */
+static int __init a20_enable_kbc(const struct dmi_system_id *d)
+{
+	printk(KERN_NOTICE "%s detected: enabling A20 using KBC\n", d->ident);
+	enable_a20_kbc();
+
+	return 0;
+}
+
+/*
  * If your system is blacklisted here, but you find that acpi=force
  * works for you, please contact linux-acpi@vger.kernel.org
  */
@@ -1423,6 +1484,60 @@ static struct dmi_system_id __initdata acpi_dmi_table[] = {
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
 
@@ -1679,6 +1794,13 @@ static int __init setup_acpi_sci(char *s)
 }
 early_param("acpi_sci", setup_acpi_sci);
 
+static int __init parse_a20_enable_kbc(char *arg)
+{
+	enable_a20_kbc();
+	return 0;
+}
+early_param("a20_enable_kbc", parse_a20_enable_kbc);
+
 int __acpi_acquire_global_lock(unsigned int *lock)
 {
 	unsigned int old, new, val;
-- 
Ondrej Zary
