Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965321Ab2CAVuM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 16:50:12 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:35253 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965283Ab2CAVuI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 16:50:08 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of gregkh@linuxfoundation.org designates 10.68.74.74 as permitted sender) smtp.mail=gregkh@linuxfoundation.org
MIME-Version: 1.0
Message-Id: <20120301213925.010712470@linuxfoundation.org>
User-Agent: quilt/0.51-17.1
Date: Thu, 01 Mar 2012 13:39:39 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Adam Radford <aradford@gmail.com>,
        James Bottomley <James.Bottomley@suse.de>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: [ 17/34] SCSI: 3w-9xxx fix bug in sgl loading
In-Reply-To: <20120301214654.GA13231@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: adam radford <aradford@gmail.com>

commit 53ca353594a254e6bd45ccf2d405aa31bcbb7091 upstream.

This small patch fixes a bug in the 3w-9xxx driver where it would load
an invalid sgl address in the ioctl path even if request length was zero.

Signed-off-by: Adam Radford <aradford@gmail.com>
Signed-off-by: James Bottomley <James.Bottomley@suse.de>
Cc: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/scsi/3w-9xxx.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

--- a/drivers/scsi/3w-9xxx.c
+++ b/drivers/scsi/3w-9xxx.c
@@ -76,6 +76,7 @@
                  Fix bug in twa_get_param() on 4GB+.
                  Use pci_resource_len() for ioremap().
    2.26.02.012 - Add power management support.
+   2.26.02.013 - Fix bug in twa_load_sgl().
 */
 
 #include <linux/module.h>
@@ -100,7 +101,7 @@
 #include "3w-9xxx.h"
 
 /* Globals */
-#define TW_DRIVER_VERSION "2.26.02.012"
+#define TW_DRIVER_VERSION "2.26.02.013"
 static TW_Device_Extension *twa_device_extension_list[TW_MAX_SLOT];
 static unsigned int twa_device_extension_count;
 static int twa_major = -1;
@@ -1378,10 +1379,12 @@ static void twa_load_sgl(TW_Device_Exten
 		newcommand = &full_command_packet->command.newcommand;
 		newcommand->request_id__lunl =
 			cpu_to_le16(TW_REQ_LUN_IN(TW_LUN_OUT(newcommand->request_id__lunl), request_id));
-		newcommand->sg_list[0].address = TW_CPU_TO_SGL(dma_handle + sizeof(TW_Ioctl_Buf_Apache) - 1);
-		newcommand->sg_list[0].length = cpu_to_le32(length);
+		if (length) {
+			newcommand->sg_list[0].address = TW_CPU_TO_SGL(dma_handle + sizeof(TW_Ioctl_Buf_Apache) - 1);
+			newcommand->sg_list[0].length = cpu_to_le32(length);
+		}
 		newcommand->sgl_entries__lunh =
-			cpu_to_le16(TW_REQ_LUN_IN(TW_LUN_OUT(newcommand->sgl_entries__lunh), 1));
+			cpu_to_le16(TW_REQ_LUN_IN(TW_LUN_OUT(newcommand->sgl_entries__lunh), length ? 1 : 0));
 	} else {
 		oldcommand = &full_command_packet->command.oldcommand;
 		oldcommand->request_id = request_id;


