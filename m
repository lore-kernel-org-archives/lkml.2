Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754361Ab0ELJhw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 05:37:52 -0400
Received: from mail192.messagelabs.com ([216.82.241.243]:55555 "EHLO
	mail192.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753447Ab0ELJhu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 05:37:50 -0400
X-VirusChecked: Checked
X-Env-Sender: Viral.Mehta@lntinfotech.com
X-Msg-Ref: server-4.tower-192.messagelabs.com!1273657066!59979079!1
X-StarScan-Version: 6.2.4; banners=lntinfotech.com,-,-
X-Originating-IP: [203.199.118.205]
From: Viral Mehta <Viral.Mehta@lntinfotech.com>
To: Viral Mehta <Viral.Mehta@lntinfotech.com>,
       =?iso-8859-2?Q?Micha=B3_Nazarewicz?= <m.nazarewicz@samsung.com>,
       "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
CC: Kyungmin Park <kyungmin.park@samsung.com>,
       Marek Szyprowski <m.szyprowski@samsung.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Wed, 12 May 2010 15:06:06 +0530
Subject: RE: [PATCH] USB: gadget: f_mass_storage: fix in fsg_common_init()
 error recovery
Thread-Topic: [PATCH] USB: gadget: f_mass_storage: fix in fsg_common_init()
 error recovery
Thread-Index: AcrxseRzNT3yaA2BSOqTvrNBKSsxqQAAp+CvAACB9HA=
Message-ID: <70376CA23424B34D86F1C7DE6B9973430254343ABC@VSHINMSMBX01.vshodc.lntinfotech.com>
References: <994e1bf34d3b6f1fbc58c0f7ce61c7f258208ddd.1273651956.git.mina86@mina86.com>
 <70376CA23424B34D86F1C7DE6B9973430254343ABA@VSHINMSMBX01.vshodc.lntinfotech.com>,<op.vck4q0c87p4s8u@pikus>,<70376CA23424B34D86F1C7DE6B9973430254343ABB@VSHINMSMBX01.vshodc.lntinfotech.com>
In-Reply-To: <70376CA23424B34D86F1C7DE6B9973430254343ABB@VSHINMSMBX01.vshodc.lntinfotech.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


________________________________________
>From: linux-usb-owner@vger.kernel.org [linux-usb-owner@vger.kernel.org] On Behalf Of Viral Mehta [Viral.Mehta@lntinfotech.com]
>Sent: Wednesday, May 12, 2010 2:58 PM
>To: Micha³ Nazarewicz; linux-usb@vger.kernel.org
>Cc: Kyungmin Park; Marek Szyprowski; linux-kernel@vger.kernel.org
>Subject: RE: [PATCH] USB: gadget: f_mass_storage: fix in fsg_common_init() error recovery

>>> Michal Nazarewicz [m.nazarewicz@samsung.com]
>>>> In to places in fsg_common_init() an unconditional call to kfree()
>>>> on common was performed in error recovery which is not a valid

>>On Wed, 12 May 2010 10:29:02 +0200, Viral Mehta <Viral.Mehta@lntinfotech.com> wrote:
>>> If I am not wrong, common can not be NULL since it was already checked above.
>>>
>>> 2685         if (!common) {
>>> 2686                 common = kzalloc(sizeof *common, GFP_KERNEL);
>>> 2687                 if (!common)
>>> 2688                         return ERR_PTR(-ENOMEM);
>>> 2689                 common->free_storage_on_release = 1;

>>That is correct but it is not the issue.

>>fsg_common_init() as a first argument takes a pointer to a fsg_common
>>structure which, if not NULL, is reused and it is then assumed that
>>caller is responsible far maintaining allocation and deallocation of
>>this structure.

>>The idea is that one can do:

>>static struct fsg_common fsg_common;
>>/* ... */
>>fsg_common_init(&fsg_common, cdev, fsg_config);

>>or allocate fsg_common structure as a part of a larger structure.  In such
>>cases kfree() cannot be called on the object.  Which case we are dealing
>>with is indicated by the common->free_storage_on_release flag.
>>fsg_common_release() consults it and either calls or does not call krfee().

>Oh, makes sense. All instances has fsg_common_init(0, ...) and so i just missed...

>But, still the central idea was, why should we go to whole error_release path which really does removing device file and closing luns and etc.
>However, it will not make any difference since curlun->nluns will be zero and so there will be no loop in fsg_common_releas() function.

>Apart from that, IMHO,
>2894         kfree(common->luns);
>should crash in case if your error path is followed.

>common->luns is allocd
>2712         /* Create the LUNs, open their backing files, and register the
>2713          * LUN devices in sysfs. */
>2714         curlun = kzalloc(nluns * sizeof *curlun, GFP_KERNEL);
>2715         if (!curlun) {
>2716                 kfree(common);
>2717                 return ERR_PTR(-ENOMEM);
>2718         }


To me,
diff --git a/drivers/usb/gadget/f_mass_storage.c b/drivers/usb/gadget/f_mass_storage.c
index f4911c0..7ad9a89 100644
--- a/drivers/usb/gadget/f_mass_storage.c
+++ b/drivers/usb/gadget/f_mass_storage.c
@@ -2702,7 +2702,8 @@ static struct fsg_common *fsg_common_init(struct fsg_common *common,
        if (fsg_strings[FSG_STRING_INTERFACE].id == 0) {
                rc = usb_string_id(cdev);
                if (rc < 0) {
-                       kfree(common);
+                       if(common->free_storage_on_release)
+                               kfree(common);
                        return ERR_PTR(rc);
                }
                fsg_strings[FSG_STRING_INTERFACE].id = rc;
@@ -2713,7 +2714,8 @@ static struct fsg_common *fsg_common_init(struct fsg_common *common,
         * LUN devices in sysfs. */
        curlun = kzalloc(nluns * sizeof *curlun, GFP_KERNEL);
        if (!curlun) {
-               kfree(common);
+               if(common->free_storage_on_release)
+                       kfree(common);
                return ERR_PTR(-ENOMEM);
        }
        common->luns = curlun;


looks correct and simple fix.



Thanks,
Viral



______________________________________________________________________

This Email may contain confidential or privileged information for the intended recipient (s) If you are not the intended recipient, please do not use or disseminate the information, notify the sender and delete it from your system.

______________________________________________________________________
--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

______________________________________________________________________

This Email may contain confidential or privileged information for the intended recipient (s) If you are not the intended recipient, please do not use or disseminate the information, notify the sender and delete it from your system.

______________________________________________________________________
