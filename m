Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754282Ab0LGDQJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 22:16:09 -0500
Received: from mga02.intel.com ([134.134.136.20]:54945 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751905Ab0LGDQH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 22:16:07 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,308,1288594800"; 
   d="scan'208";a="684569603"
Subject: Re: [Regression] 2.6.37-rc1: Lenovo T61 mute button does not work
From: Lin Ming <ming.m.lin@intel.com>
To: Lukas Hejtmanek <xhejtman@ics.muni.cz>
Cc: "Moore, Robert" <robert.moore@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        Calvin Walton <calvin.walton@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <20101206093158.GA15702@ics.muni.cz>
References: <20101130185303.GI10354@ics.muni.cz>
	 <1291172324.14274.33.camel@nayuki> <20101203141358.GA6936@ics.muni.cz>
	 <1291599424.3688.0.camel@minggr.sh.intel.com>
	 <20101206093158.GA15702@ics.muni.cz>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 07 Dec 2010 11:19:27 +0800
Message-ID: <1291691967.3678.2.camel@minggr.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-12-06 at 17:31 +0800, Lukas Hejtmanek wrote:
> On Mon, Dec 06, 2010 at 09:37:04AM +0800, Lin Ming wrote:
> > > which apparently does not work with Lenovo T61.
> > 
> > I'm looking at this regression.
> 
> I did some debugging. It looks like this:
> [    0.000000] ACPI: DMI detected: Lenovo ThinkPad T61
> [    0.000000] ACPI: Set_osi_linux Added _OSI(Linux)
> [    0.000000] Pid: 0, comm: swapper Not tainted 2.6.37-rc3+ #122
> [    0.000000] Call Trace:
> [    0.000000]  [<ffffffff8162c0a1>] ? set_osi_linux+0x4b/0x6b
> [    0.000000]  [<ffffffff8162bbe7>] ? dmi_enable_osi_linux+0x11/0x18
> [    0.000000]  [<ffffffff812f7313>] ? dmi_check_system+0x33/0x50
> [    0.000000]  [<ffffffff8162bdc2>] ? acpi_blacklisted+0x16a/0x190
> [    0.000000]  [<ffffffff81617b6e>] ? acpi_boot_table_init+0x3a/0x75
> [    0.000000]  [<ffffffff81611cf3>] ? setup_arch+0x6d5/0x7a8
> [    0.000000]  [<ffffffff814072f2>] ? printk+0x40/0x46
> [    0.000000]  [<ffffffff816108de>] ? start_kernel+0xbe/0x323
> [    0.000000]  [<ffffffff816103de>] ? x86_64_start_kernel+0xf9/0xff
> 
> after this call, osi_linux.dmi is set.
> 
> However, after this call:
> [    0.186721] Call Trace:
> [    0.186721]  [<ffffffff8120ecad>] ? acpi_install_interface_handler+0x4d/0x56
> [    0.186750]  [<ffffffff8162c0a1>] ? set_osi_linux+0x4b/0x6b
> [    0.186777]  [<ffffffff811edefa>] ? acpi_os_initialize1+0x10f/0x13d
> [    0.186803]  [<ffffffff8162c3fa>] ? acpi_bus_init+0xa/0x1e2
> [    0.186829]  [<ffffffff811c498c>] ? kobject_create_and_add+0x3c/0x80
> [    0.186855]  [<ffffffff8162c63b>] ? acpi_init+0x69/0xdf
> [    0.186880]  [<ffffffff810002da>] ? do_one_initcall+0x3a/0x170
> [    0.186906]  [<ffffffff81610c75>] ? kernel_init+0x132/0x1be
> [    0.186932]  [<ffffffff81003b94>] ? kernel_thread_helper+0x4/0x10
> [    0.186958]  [<ffffffff81610b43>] ? kernel_init+0x0/0x1be
> [    0.187577]  [<ffffffff81003b90>] ? kernel_thread_helper+0x0/0x10
> 
> osi_linux.cmdline is set.

Hi, 

Would you please try below patch?

Thanks.

---
 drivers/acpi/osl.c |   55 ++++++++++++++++++++++++++++++---------------------
 1 files changed, 32 insertions(+), 23 deletions(-)

diff --git a/drivers/acpi/osl.c b/drivers/acpi/osl.c
index 966fedd..f620689 100644
--- a/drivers/acpi/osl.c
+++ b/drivers/acpi/osl.c
@@ -152,8 +152,7 @@ static struct osi_linux {
 	unsigned int	enable:1;
 	unsigned int	dmi:1;
 	unsigned int	cmdline:1;
-	unsigned int	known:1;
-} osi_linux = { 0, 0, 0, 0};
+} osi_linux = {0, 0, 0};
 
 static u32 acpi_osi_handler(acpi_string interface, u32 supported)
 {
@@ -1055,18 +1054,25 @@ static int __init acpi_os_name_setup(char *str)
 
 __setup("acpi_os_name=", acpi_os_name_setup);
 
+static void __init osi_setup(char *str)
+{
+	if (str == NULL || *str == '\0') {
+		printk(KERN_INFO PREFIX "_OSI method disabled\n");
+		acpi_gbl_create_osi_method = FALSE;
+	} else {
+		strncpy(osi_setup_string, str, OSI_STRING_LENGTH_MAX);
+	}
+}
+
 static void __init set_osi_linux(unsigned int enable)
 {
-	if (osi_linux.enable != enable) {
+	if (osi_linux.enable != enable)
 		osi_linux.enable = enable;
-		printk(KERN_NOTICE PREFIX "%sed _OSI(Linux)\n",
-			enable ? "Add": "Delet");
-	}
 
 	if (osi_linux.enable)
-		acpi_osi_setup("Linux");
+		osi_setup("Linux");
 	else
-		acpi_osi_setup("!Linux");
+		osi_setup("!Linux");
 
 	return;
 }
@@ -1088,8 +1094,6 @@ void __init acpi_dmi_osi_linux(int enable, const struct dmi_system_id *d)
 	if (enable == -1)
 		return;
 
-	osi_linux.known = 1;	/* DMI knows which OSI(Linux) default needed */
-
 	set_osi_linux(enable);
 
 	return;
@@ -1105,31 +1109,36 @@ void __init acpi_dmi_osi_linux(int enable, const struct dmi_system_id *d)
 static void __init acpi_osi_setup_late(void)
 {
 	char *str = osi_setup_string;
+	acpi_status status;
 
 	if (*str == '\0')
 		return;
 
-	if (!strcmp("!Linux", str)) {
-		acpi_cmdline_osi_linux(0);	/* !enable */
-	} else if (*str == '!') {
-		if (acpi_remove_interface(++str) == AE_OK)
+	if (*str == '!') {
+		status = acpi_remove_interface(++str);
+
+		if (ACPI_SUCCESS(status))
 			printk(KERN_INFO PREFIX "Deleted _OSI(%s)\n", str);
-	} else if (!strcmp("Linux", str)) {
-		acpi_cmdline_osi_linux(1);	/* enable */
 	} else {
-		if (acpi_install_interface(str) == AE_OK)
+		status = acpi_install_interface(str);
+
+		if (ACPI_SUCCESS(status))
 			printk(KERN_INFO PREFIX "Added _OSI(%s)\n", str);
 	}
 }
 
 int __init acpi_osi_setup(char *str)
 {
-	if (str == NULL || *str == '\0') {
-		printk(KERN_INFO PREFIX "_OSI method disabled\n");
-		acpi_gbl_create_osi_method = FALSE;
-	} else {
-		strncpy(osi_setup_string, str, OSI_STRING_LENGTH_MAX);
-	}
+	/* kernel command line overrides DMI */
+	osi_linux.dmi = 0;
+	osi_linux.enable = 0;
+
+	if (str && !strcmp("Linux", str))
+		acpi_cmdline_osi_linux(1);
+	else if (str && !strcmp("!Linux", str))
+		acpi_cmdline_osi_linux(0);
+	else
+		osi_setup(str);
 
 	return 1;
 }


