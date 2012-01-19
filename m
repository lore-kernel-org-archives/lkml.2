Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932611Ab2ASRrO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jan 2012 12:47:14 -0500
Received: from mx2.gd-ms.com ([153.11.250.41]:50989 "EHLO mx2.gd-ms.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932129Ab2ASRrN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jan 2012 12:47:13 -0500
In-Reply-To: <OF8642E997.5ED041E1-ON8525798A.0056983A-8525798A.0056E05B@LocalDomain>
References: <OF70B406E9.8D4A6789-ON85257988.0052C104-85257988.0053DE1E@gdeb.com>	<20120117195841.48fe8236@pyramind.ukuu.org.uk>
	<OFD4BB6876.6D903346-ON8525798A.00550E62-8525798A.005562A3@gdeb.com> <20120119154504.710e202e@pyramind.ukuu.org.uk> <OF8642E997.5ED041E1-ON8525798A.0056983A-8525798A.0056E05B@LocalDomain>
To: Michael D Labriola <mlabriol@gdeb.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, "H. Peter Anvin" <hpa@zytor.com>,
        Kushal Koolwal <kushalkoolwal@gmail.com>, linux-kernel@vger.kernel.org,
        michael.d.labriola@gmail.com, Ingo Molnar <mingo@elte.hu>,
        Matthew Garrett <mjg59@srcf.ucam.org>, support@versalogic.com,
        Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org
MIME-Version: 1.0
Subject: Re: [PATCH] x86, reboot: skip DMI checks if reboot set by user
X-KeepSent: 2B909250:6078896E-8525798A:0058FF49;
 type=4; name=$KeepSent
Message-ID: <OF2B909250.6078896E-ON8525798A.0058FF49-8525798A.0061AEA1@gdeb.com>
From: Michael D Labriola <mlabriol@gdeb.com>
Date: Thu, 19 Jan 2012 12:46:55 -0500
X-GDMEncrypt: FALSE
X-GDMMarking: NOT_SENSITIVE
Content-Type: text/plain; charset="US-ASCII"
X-GDM-MESSAGE-ID: X-GDM-MESSAGE-ID mx2.gd-ms.com 1Rnw4i-000510-GI
X-GDM-EVAL: score: /30; hits: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michael D Labriola/EB/GDYN wrote on 01/19/2012 10:48:53 AM:

> Alan Cox <alan@lxorguk.ukuu.org.uk> wrote on 01/19/2012 10:45:04 AM:
>
> > > checking if reboot_type's value is anything other than BOOT_ACPI 
(which
> > > is the default), but that does assume BOOT_ACPI is the default. What 
if
> > > that's ever changed?  Seems likely to me that whoever changes the 
default
> > > in the future could very easily re-break this at that point.
> > > 
> > > Thoughts?
> > 
> > Fair point - how about a BOOT_DEFAULT define value if it hasn't been 
set
> > and we can just make it do the same as ACPI in the switch ?
> 
> Sounds good to me.  I'll whip that up and resubmit.

Well, how about this.  Using a #define won't do as far as I can tell.
But I can reduce the size of the diff considerably like this.

Random question...  why do we have a reboot_init function that does DMI
checking with reboot_dmi_table (callbacks are mostly set_bios_reboot, but
there is a single set_kbd_reboot) and also a pci_reboot_init which does
the DMI check again using a separate pci_reboot_dmi_table (all callbacks
are to set_pci_reboot)?

Wouldn't it make more sense to do a single DMI scan using one big table?


diff --git a/arch/x86/kernel/reboot.c b/arch/x86/kernel/reboot.c
index 37a458b..0fc5b31 100644
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
+               /* Having anything passed on the command line via
+                * reboot= will cause us to disable DMI checking
+                * below.
+                */
+               reboot_default = 0;
+
                switch (*str) {
                case 'w':
                        reboot_mode = 0x1234;
@@ -316,7 +330,12 @@ static struct dmi_system_id __initdata 
reboot_dmi_table[] = {
 
 static int __init reboot_init(void)
 {
-       dmi_check_system(reboot_dmi_table);
+       /* Only do the DMI check if reboot_type hasn't been overridden
+        * on the command line
+        */
+       if (reboot_default) {
+               dmi_check_system(reboot_dmi_table);
+       }
        return 0;
 }
 core_initcall(reboot_init);
@@ -465,7 +484,12 @@ static struct dmi_system_id __initdata 
pci_reboot_dmi_table[] = {
 
 static int __init pci_reboot_init(void)
 {
-       dmi_check_system(pci_reboot_dmi_table);
+       /* Only do the DMI check if reboot_type hasn't been overridden
+        * on the command line
+        */
+       if (reboot_default) {
+               dmi_check_system(pci_reboot_dmi_table);
+       }
        return 0;
 }
 core_initcall(pci_reboot_init);


