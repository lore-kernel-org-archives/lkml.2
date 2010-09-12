Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752834Ab0ILLqp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Sep 2010 07:46:45 -0400
Received: from mail-ww0-f42.google.com ([74.125.82.42]:45961 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751774Ab0ILLqg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Sep 2010 07:46:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:x-mailer:mime-version
         :content-type:content-transfer-encoding;
        b=xW8+8+LhNADZOKcxpXtHuT2BKljop1V7NRuoF0wQMzoU8arM3Dfx76YNqEmn1kGUAY
         4NQNW4Et3Eo/EjVDecob1M1FTuHYHt8id6MWqK2eO8lLEKNG+hO4QMzRH1nP0Ad9ld3X
         81vNBfg8gGRzInZAPMkbS8SIim4MSUaAngqz8=
Date: Sun, 12 Sep 2010 13:45:31 +0200
From: Paolo Ornati <ornati@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: stable@kernel.org, Zhang Rui <rui.zhang@intel.com>
Subject: 2.6.32.y needs ACPI workaround on ASUS K50IJ
Message-ID: <20100912134531.6a97e833@gmail.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

ASUS K50IJ needs the following ACPI workaround on 2.6.32.y (2.6.33+ is
fine).

Since many distros are based / basing on 2.6.32.y i think it makes sense
to include the fix in the upstream stable tree :)

------------------------------------------

commit 81074e90f5c150ca70ab8dfcc77860cbe76f364d
Author: Zhang Rui <rui.zhang@intel.com>
Date:   Mon Dec 21 16:13:15 2009 +0800

    ACPI: disable _OSI(Windows 2009) on Asus K50IJ
    
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

diff --git a/drivers/acpi/blacklist.c b/drivers/acpi/blacklist.c
index 23e5a05..2815df6 100644
--- a/drivers/acpi/blacklist.c
+++ b/drivers/acpi/blacklist.c
@@ -185,6 +185,12 @@ static int __init dmi_disable_osi_vista(const struct dmi_system_id *d)
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
@@ -211,6 +217,14 @@ static struct dmi_system_id acpi_osi_dmi_table[] __initdata = {
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


-- 
	Paolo Ornati
	Linux 2.6.35.4 on x86_64
