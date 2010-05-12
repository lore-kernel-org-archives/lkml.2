Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753075Ab0ELKfF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 06:35:05 -0400
Received: from mail192.messagelabs.com ([216.82.241.243]:38543 "EHLO
	mail192.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752487Ab0ELKfB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 06:35:01 -0400
X-VirusChecked: Checked
X-Env-Sender: Viral.Mehta@lntinfotech.com
X-Msg-Ref: server-7.tower-192.messagelabs.com!1273660491!25077789!2
X-StarScan-Version: 6.2.4; banners=lntinfotech.com,-,-
X-Originating-IP: [203.199.118.206]
From: Viral Mehta <Viral.Mehta@lntinfotech.com>
To: =?iso-8859-2?Q?Micha=B3_Nazarewicz?= <m.nazarewicz@samsung.com>,
       "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
CC: Kyungmin Park <kyungmin.park@samsung.com>,
       Marek Szyprowski <m.szyprowski@samsung.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Wed, 12 May 2010 16:03:43 +0530
Subject: RE: [PATCH] USB: gadget: f_mass_storage: fix in fsg_common_init()
 error recovery
Thread-Topic: [PATCH] USB: gadget: f_mass_storage: fix in fsg_common_init()
 error recovery
Thread-Index: AcrxuYsL6HUvzTG7TU2A9w1U+bwVHgABQ1Bx
Message-ID: <70376CA23424B34D86F1C7DE6B9973430254343ABF@VSHINMSMBX01.vshodc.lntinfotech.com>
References: <994e1bf34d3b6f1fbc58c0f7ce61c7f258208ddd.1273651956.git.mina86@mina86.com>
 <70376CA23424B34D86F1C7DE6B9973430254343ABA@VSHINMSMBX01.vshodc.lntinfotech.com>
 <op.vck4q0c87p4s8u@pikus>
 <70376CA23424B34D86F1C7DE6B9973430254343ABB@VSHINMSMBX01.vshodc.lntinfotech.com>
 <70376CA23424B34D86F1C7DE6B9973430254343ABC@VSHINMSMBX01.vshodc.lntinfotech.com>,<op.vck7aofj7p4s8u@pikus>
In-Reply-To: <op.vck7aofj7p4s8u@pikus>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>Because of that, I the "goto error_release" to be cleaner in the sense that
>there is a single error recovery path and only one place where
>free_storage_on_release flag is checked and common freed.

In that case, in addition to your previous patch, below hunk is needed


diff --git a/drivers/usb/gadget/f_mass_storage.c b/drivers/usb/gadget/f_mass_storage.c
index f4911c0..b1648fc 100644
--- a/drivers/usb/gadget/f_mass_storage.c
+++ b/drivers/usb/gadget/f_mass_storage.c
@@ -2883,15 +2883,16 @@ static void fsg_common_release(struct kref *ref)

        /* Beware tempting for -> do-while optimization: when in error
         * recovery nluns may be zero. */
+       if(common->luns) {
+               for (; i; --i, ++lun) {
+                       device_remove_file(&lun->dev, &dev_attr_ro);
+                       device_remove_file(&lun->dev, &dev_attr_file);
+                       fsg_lun_close(lun);
+                       device_unregister(&lun->dev);
+               }

-       for (; i; --i, ++lun) {
-               device_remove_file(&lun->dev, &dev_attr_ro);
-               device_remove_file(&lun->dev, &dev_attr_file);
-               fsg_lun_close(lun);
-               device_unregister(&lun->dev);
+               kfree(common->luns);
        }
-
-       kfree(common->luns);
        if (common->free_storage_on_release)
                kfree(common);
 }


Thanks,
Viral

This Email may contain confidential or privileged information for the intended recipient (s) If you are not the intended recipient, please do not use or disseminate the information, notify the sender and delete it from your system.

______________________________________________________________________
