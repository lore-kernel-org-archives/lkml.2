Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933769Ab0FRQxP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jun 2010 12:53:15 -0400
Received: from kroah.org ([198.145.64.141]:53784 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757675Ab0FRQxN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jun 2010 12:53:13 -0400
Subject: patch staging-hv-fix-hv_utils-module-to-properly-autoload.patch added to gregkh-2.6 tree
To: haiyangz@microsoft.com, devel@driverdev.osuosl.org, gregkh@suse.de,
       hjanssen@microsoft.com, linux-kernel@vger.kernel.org, stable@kernel.org,
       virtualization@lists.osdl.org
From: <gregkh@suse.de>
Date: Fri, 18 Jun 2010 09:53:08 -0700
In-Reply-To: <1FB5E1D5CA062146B38059374562DF7266B8931E@TK5EX14MBXC128.redmond.corp.microsoft.com>
Message-ID: <12768799881800@site>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    Subject: Staging: hv: fix hv_utils module to properly autoload

to my gregkh-2.6 tree.  Its filename is

    staging-hv-fix-hv_utils-module-to-properly-autoload.patch

This tree can be found at 
    http://www.kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/patches/


>From haiyangz@microsoft.com Wed May 19 08:56:34 2010
From: Haiyang Zhang <haiyangz@microsoft.com>
Date: Wed, 19 May 2010 15:56:28 +0000
Subject: Staging: hv: fix hv_utils module to properly autoload
To: "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>, "'devel@driverdev.osuosl.org'" <devel@driverdev.osuosl.org>, "'virtualization@lists.osdl.org'" <virtualization@lists.osdl.org>, "'gregkh@suse.de'" <gregkh@suse.de>
Cc: Hank Janssen <hjanssen@microsoft.com>
Message-ID: <1FB5E1D5CA062146B38059374562DF7266B8931E@TK5EX14MBXC128.redmond.corp.microsoft.com>


From: Haiyang Zhang <haiyangz@microsoft.com>

Added autoloading based on pci id and dmi strings.

Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
Cc: stable <stable@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/staging/hv/hv_utils.c |   28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

--- a/drivers/staging/hv/hv_utils.c
+++ b/drivers/staging/hv/hv_utils.c
@@ -24,6 +24,8 @@
 #include <linux/slab.h>
 #include <linux/sysctl.h>
 #include <linux/reboot.h>
+#include <linux/dmi.h>
+#include <linux/pci.h>
 
 #include "logging.h"
 #include "osd.h"
@@ -251,10 +253,36 @@ static void heartbeat_onchannelcallback(
 	DPRINT_EXIT(VMBUS);
 }
 
+static const struct pci_device_id __initconst
+hv_utils_pci_table[] __maybe_unused = {
+	{ PCI_DEVICE(0x1414, 0x5353) }, /* Hyper-V emulated VGA controller */
+	{ 0 }
+};
+MODULE_DEVICE_TABLE(pci, hv_utils_pci_table);
+
+
+static const struct dmi_system_id __initconst
+hv_utils_dmi_table[] __maybe_unused  = {
+	{
+		.ident = "Hyper-V",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Microsoft Corporation"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Virtual Machine"),
+			DMI_MATCH(DMI_BOARD_NAME, "Virtual Machine"),
+		},
+	},
+	{ },
+};
+MODULE_DEVICE_TABLE(dmi, hv_utils_dmi_table);
+
+
 static int __init init_hyperv_utils(void)
 {
 	printk(KERN_INFO "Registering HyperV Utility Driver\n");
 
+	if (!dmi_check_system(hv_utils_dmi_table))
+		return -ENODEV;
+
 	hv_cb_utils[HV_SHUTDOWN_MSG].channel->OnChannelCallback =
 		&shutdown_onchannelcallback;
 	hv_cb_utils[HV_SHUTDOWN_MSG].callback = &shutdown_onchannelcallback;

