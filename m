Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752311Ab1GUH0U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 03:26:20 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:65074 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751425Ab1GUH0T convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 03:26:19 -0400
MIME-Version: 1.0
In-Reply-To: <CACna6rxAKMp-2wqwz4k4S3nTkY_3Qz7=hEZk9F2Zig7T5kp_HA@mail.gmail.com>
References: <CACna6rxAKMp-2wqwz4k4S3nTkY_3Qz7=hEZk9F2Zig7T5kp_HA@mail.gmail.com>
Date: Thu, 21 Jul 2011 09:18:17 +0200
Message-ID: <CACna6rwPqeW5Bhc7A0FnkCaRq-a-nA4ziUQdoiakN_DvMyL_RQ@mail.gmail.com>
Subject: Re: Bug in BCMA: device_unregister causing "NULL pointer dereference at"
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

W dniu 7 lipca 2011 17:25 użytkownik Rafał Miłecki <zajec5@gmail.com> napisał:
> I've problem with bcma and bus subsystem.
>
> This works fine:
> modprobe bcma; rmmod bcma
>
> This:
> modprobe bcma; modprobe b43; rmmod b43; rmmod bcma
> causes:
> BUG: unable to handle kernel NULL pointer dereference at   (null)
>
> My BCMA has only 3 fores, out of them only 1 is registered as device:
> bcma: Core 0 found: ChipCommon (manuf 0x4BF, id 0x800, rev 0x22, class 0x0)
> bcma: Core 1 found: IEEE 802.11 (manuf 0x4BF, id 0x812, rev 0x17, class 0x0)
> bcma: Core 2 found: PCIe (manuf 0x4BF, id 0x820, rev 0x0F, class 0x0)
>
> The dereference comes out from
> static void bcma_unregister_cores(struct bcma_bus *bus)
>
> There is a simple loop:
> list_for_each_entry(core, &bus->cores, list) {
>        if (core->dev_registered)
>                device_unregister(&core->dev);
> }
>
>
> So when I unload bcma after I got driver (b43) for 0x812 core, I get
> NULL pointer dereference.
>
> Any tip, why does it happen?

I've tracked where does crash really happen (kobject_del does not
really say much). The real forwardtrace is:
device_unregister → device_del → kobject_del → kobj_kset_leave →
kobj_kset_leave → list_del_init

If you take a look at list_del_init, it touches "prev" and "next". So
I've added some debugging:
pr_info("core->dev.kobj.entry.prev: 0x%p\n", core->dev.kobj.entry.prev);
pr_info("core->dev.kobj.entry.next: 0x%p\n", core->dev.kobj.entry.next);

modprobe bcma && rmmod bcma:
[  342.866366] bcma: Unregistering device for core 0x812
[  342.866380] bcma: core->dev.kobj.entry.prev: 0xdb82780c
[  342.866382] bcma: core->dev.kobj.entry.next: 0xda044980

modprobe bcma && modprobe b43 && rmmod b43 && rmmod bcma:
[  612.819306] bcma: Unregistering device for core 0x812
[  612.819320] bcma: core->dev.kobj.entry.prev: 0x  (null)
[  612.819322] bcma: core->dev.kobj.entry.next: 0xd7fe6614
[  612.819971] BUG: unable to handle kernel NULL pointer dereference at   (null)
[  612.819989] IP: [<c03dcfbe>] kobject_del+0x2e/0x60

I've no idea why kobj entry list gets corrupted after loading b43
driver supporting device for core 0x812.

Any help now maybe?

-- 
Rafał
