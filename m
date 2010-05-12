Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755509Ab0ELKG0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 06:06:26 -0400
Received: from mail192.messagelabs.com ([216.82.241.243]:9654 "EHLO
	mail192.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751685Ab0ELKGY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 06:06:24 -0400
X-VirusChecked: Checked
X-Env-Sender: Viral.Mehta@lntinfotech.com
X-Msg-Ref: server-8.tower-192.messagelabs.com!1273658758!34779133!4
X-StarScan-Version: 6.2.4; banners=lntinfotech.com,-,-
X-Originating-IP: [203.199.118.205]
From: Viral Mehta <Viral.Mehta@lntinfotech.com>
To: =?iso-8859-2?Q?Micha=B3_Nazarewicz?= <m.nazarewicz@samsung.com>,
       "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
CC: Kyungmin Park <kyungmin.park@samsung.com>,
       Marek Szyprowski <m.szyprowski@samsung.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Wed, 12 May 2010 15:36:11 +0530
Subject: RE: [PATCH] USB: gadget: f_mass_storage: fix in fsg_common_init()
 error recovery
Thread-Topic: [PATCH] USB: gadget: f_mass_storage: fix in fsg_common_init()
 error recovery
Thread-Index: AcrxuPZrXi4ood6nQrGmbvKQk+OtsAAANbAM
Message-ID: <70376CA23424B34D86F1C7DE6B9973430254343ABD@VSHINMSMBX01.vshodc.lntinfotech.com>
References: <994e1bf34d3b6f1fbc58c0f7ce61c7f258208ddd.1273651956.git.mina86@mina86.com>
 <70376CA23424B34D86F1C7DE6B9973430254343ABA@VSHINMSMBX01.vshodc.lntinfotech.com>
 <op.vck4q0c87p4s8u@pikus>
 <70376CA23424B34D86F1C7DE6B9973430254343ABB@VSHINMSMBX01.vshodc.lntinfotech.com>,<op.vck63vc77p4s8u@pikus>
In-Reply-To: <op.vck63vc77p4s8u@pikus>
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

>> Apart from that, IMHO,
>> 2894         kfree(common->luns);
>> should crash in case if your error path is followed.
>>
>> common->luns is allocd
>> 2712         /* Create the LUNs, open their backing files, and register the
>> 2713          * LUN devices in sysfs. */
>> 2714         curlun = kzalloc(nluns * sizeof *curlun, GFP_KERNEL);
>> 2715         if (!curlun) {
>> 2716                 kfree(common);
>> 2717                 return ERR_PTR(-ENOMEM);
>> 2718         }

>Yes, that's why the submitted patch changes that to "rc = -ENOMEM;
>goto errer_release;".

I think you misread.
In fsg_common_release(), we are freeing common->luns.
2894         kfree(common->luns);

However, these gets allocd in fsg_common_init()
2712         /* Create the LUNs, open their backing files, and register the
2713          * LUN devices in sysfs. */
2714         curlun = kzalloc(nluns * sizeof *curlun, GFP_KERNEL);
2715         if (!curlun) {
2716                 kfree(common);
2717                 return ERR_PTR(-ENOMEM);
2718         }


Now, if this kzalloc at line 2714 failed
And if your patch is applied, you will follow error_release path which in turn will call kfree on a pointer whose allocation is failed.

And this is true for the HUNK#1 as well.

Getting ? So, i still think the patch I sent looks simple and correct.




--
Best regards,                                        _     _
| Humble Liege of Serenely Enlightened Majesty of  o' \,=./ `o
| Computer Science,  Micha³ "mina86" Nazarewicz       (o o)
+----[mina86*mina86.com]---[mina86*jabber.org]----ooO--(_)--Ooo--

______________________________________________________________________

This Email may contain confidential or privileged information for the intended recipient (s) If you are not the intended recipient, please do not use or disseminate the information, notify the sender and delete it from your system.

______________________________________________________________________
