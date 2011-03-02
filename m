Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756386Ab1CBLex (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 06:34:53 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:44244 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755668Ab1CBLew (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 06:34:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=KgJDK2yN6MNHDE6DTXIwWs5a8TQb4h6DnLnPiXgek4AqGwcFIrCVmByjBSgTuySVFD
         2phPWjpFaN/pYGo/7kQkQ/Ftv7p6AjDcmZJ+/XsS1KDWdqVrXOAbZEto7NR4ODPZo5S1
         dZ23XFQjpbwzBiy47k8VGDu7So7Z91jltKtOk=
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>, linux-usb@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH] wusb: fix find_first_zero_bit() return value check
Date: Wed,  2 Mar 2011 20:35:28 +0900
Message-Id: <1299065728-6124-1-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 1.7.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In wusb_cluster_id_get(), if no zero bits exist in wusb_cluster_id_table,
find_first_zero_bit() returns CLUSTER_IDS.

But it is impossible to detect that the bitmap is full because there
is an off-by-one error in the return value check.  It will cause
unexpected memory access by setting bit out of wusb_cluster_id_table
bitmap, and caller will get wrong cluster id.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: linux-usb@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/usb/wusbcore/wusbhc.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/usb/wusbcore/wusbhc.c b/drivers/usb/wusbcore/wusbhc.c
index 2054d4e..0faca16 100644
--- a/drivers/usb/wusbcore/wusbhc.c
+++ b/drivers/usb/wusbcore/wusbhc.c
@@ -320,7 +320,7 @@ u8 wusb_cluster_id_get(void)
 	u8 id;
 	spin_lock(&wusb_cluster_ids_lock);
 	id = find_first_zero_bit(wusb_cluster_id_table, CLUSTER_IDS);
-	if (id > CLUSTER_IDS) {
+	if (id >= CLUSTER_IDS) {
 		id = 0;
 		goto out;
 	}
-- 
1.7.4

