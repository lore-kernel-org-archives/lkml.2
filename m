Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755745Ab1H3RW6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Aug 2011 13:22:58 -0400
Received: from smtp.microsoft.com ([131.107.115.214]:48810 "EHLO
	smtp.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754701Ab1H3RWz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Aug 2011 13:22:55 -0400
From: KY Srinivasan <kys@microsoft.com>
To: Olaf Hering <olaf@aepfle.de>
CC: "gregkh@suse.de" <gregkh@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>
Subject: RE: [PATCH 0000/0046] Staging: hv: Driver cleanup
Thread-Topic: [PATCH 0000/0046] Staging: hv: Driver cleanup
Thread-Index: AQHMZOnf4RrKbuc3xkO79xj3e0N/35U10eAA///VXKA=
Date: Tue, 30 Aug 2011 17:22:54 +0000
Message-ID: <6E21E5352C11B742B20C142EB499E048081B5363@TK5EX14MBXC126.redmond.corp.microsoft.com>
References: <1314469874-7017-1-git-send-email-kys@microsoft.com>
 <20110830124856.GA17520@aepfle.de>
In-Reply-To: <20110830124856.GA17520@aepfle.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.54.51.33]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id p7UHNA1u027584



> -----Original Message-----
> From: Olaf Hering [mailto:olaf@aepfle.de]
> Sent: Tuesday, August 30, 2011 8:49 AM
> To: KY Srinivasan
> Cc: gregkh@suse.de; linux-kernel@vger.kernel.org;
> devel@linuxdriverproject.org; virtualization@lists.osdl.org
> Subject: Re: [PATCH 0000/0046] Staging: hv: Driver cleanup
> 
> On Sat, Aug 27, K. Y. Srinivasan wrote:
> 
> > 	2) Handle all block devices using the storvsc driver. I have modified
> > 	   the implementation here based on Christoph's feedback on my earlier
> > 	   implementation.
> 
> The upgrade path from hv_blkvsc to hv_storvsc is difficult.
> 
> hv_storvsc does not provide the vmbus:hv_block modalias, so mkinitrd
> does not know what module to choose when mkinitrd is called in a
> previous kernel (like sles11sp1).
> 
> 
> In a guest with both SCSI and IDE controllers the IDE disks are
> discovered first, so the SCSI drives will also change their names.
> Thats not a problem for data partitions because they could be mounted by
> UUID or LABEL in fstab.
> But its difficult to adjust /boot/grub/device.map for example because
> the old  IDE drives do not provide an identifier. What is the best way
> to make sure the rename from hd* to sd* in such config files is done
> correctly? Is it safe to assume that all drives with a class_id of
> 32412632-86cb-44a2-9b5c50d1417354f5 are connected to IDE ports?

The class_id is invariant as we are returning the guid of the device under class_id.

So, if you see a IDE guid under class_id, you can be sure (a) it is an ide device and (b)
it is a device managed via the PV drivers.

> 
> localhost:~ # head /sys/bus/vmbus/devices/vmbus_0_{1,2,3,10,11}/class_id
> ==> /sys/bus/vmbus/devices/vmbus_0_1/class_id <==
> {32412632-86cb-44a2-9b5c50d1417354f5}
> 
> ==> /sys/bus/vmbus/devices/vmbus_0_2/class_id <==
> {32412632-86cb-44a2-9b5c50d1417354f5}
> 
> ==> /sys/bus/vmbus/devices/vmbus_0_3/class_id <==
> {32412632-86cb-44a2-9b5c50d1417354f5}
> 
> ==> /sys/bus/vmbus/devices/vmbus_0_10/class_id <==
> {ba6163d9-04a1-4d29-b60572e2ffb1dc7f}
> 
> ==> /sys/bus/vmbus/devices/vmbus_0_11/class_id <==
> {ba6163d9-04a1-4d29-b60572e2ffb1dc7f}
> 
> 
> In my test system, the IDE drives are now discovered twice, once by
> hv_storvsc and once by libata:

This is a known (old problem). The way this was handled earlier was to have the 
modprobe rules in place to setup a dependency that would force the load of the
hyper-v driver (blk / stor) ahead of the native driver and if the load of the PV
driver succeeded, we would not load the native driver. In sles11 sp1, we had a rule for 
loading blkvsc. With the merge of blkvsc and storvsc, the only change we need to make
is to have storvsc in the rule (instaed of blkvsc).

Regards,

K. Y
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
