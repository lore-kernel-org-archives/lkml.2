Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933129Ab0IXQld (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 12:41:33 -0400
Received: from kroah.org ([198.145.64.141]:37266 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933062Ab0IXQfa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 12:35:30 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Sep 24 09:33:47 2010
Message-Id: <20100924163347.662791994@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 24 Sep 2010 09:32:05 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Zhang Rui <rui.zhang@intel.com>, Len Brown <len.brown@intel.com>,
        maximilian attems <max@stro.at>, Paolo Ornati <ornati@gmail.com>
Subject: [41/68] ACPI: disable _OSI(Windows 2009) on Asus K50IJ
In-Reply-To: <20100924163357.GA15741@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Zhang Rui <rui.zhang@intel.com>

commit 81074e90f5c150ca70ab8dfcc77860cbe76f364d upstream.

Fix a win7 compability issue on Asus K50IJ.

Here is the _BCM method of this laptop:
                    Method (_BCM, 1, NotSerialized)
                    {
                        If (LGreaterEqual (OSFG, OSVT))
                        {
                            If (LNotEqual (OSFG, OSW7))
                            {
                                Store (One, BCMD)
                                Store (GCBL (Arg0), Local0)
                                Subtract (0x0F, Local0, LBTN)
                                ^^^SBRG.EC0.STBR ()
                                ...
                            }
                            Else
                            {
                                DBGR (0x0B, Zero, Zero, Arg0)
                                Store (Arg0, LBTN)
                                ^^^SBRG.EC0.STBR ()
                                ...
                            }
                        }
                    }
LBTN is used to store the index of the brightness level in the _BCL.
GCBL is a method that convert the percentage value to the index value.
If _OSI(Windows 2009) is not disabled, LBTN is stored a percentage
value which is surely beyond the end of _BCL package.

http://bugzilla.kernel.org/show_bug.cgi?id=14753

Signed-off-by: Zhang Rui <rui.zhang@intel.com>
Signed-off-by: Len Brown <len.brown@intel.com>
Cc: maximilian attems <max@stro.at>
Cc: Paolo Ornati <ornati@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/acpi/blacklist.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

--- a/drivers/acpi/blacklist.c
+++ b/drivers/acpi/blacklist.c
@@ -185,6 +185,12 @@ static int __init dmi_disable_osi_vista(
 	acpi_osi_setup("!Windows 2006");
 	return 0;
 }
+static int __init dmi_disable_osi_win7(const struct dmi_system_id *d)
+{
+	printk(KERN_NOTICE PREFIX "DMI detected: %s\n", d->ident);
+	acpi_osi_setup("!Windows 2009");
+	return 0;
+}
 
 static struct dmi_system_id acpi_osi_dmi_table[] __initdata = {
 	{
@@ -211,6 +217,14 @@ static struct dmi_system_id acpi_osi_dmi
 		     DMI_MATCH(DMI_PRODUCT_NAME, "Sony VGN-SR290J"),
 		},
 	},
+	{
+	.callback = dmi_disable_osi_win7,
+	.ident = "ASUS K50IJ",
+	.matches = {
+		     DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK Computer Inc."),
+		     DMI_MATCH(DMI_PRODUCT_NAME, "K50IJ"),
+		},
+	},
 
 	/*
 	 * BIOS invocation of _OSI(Linux) is almost always a BIOS bug.


