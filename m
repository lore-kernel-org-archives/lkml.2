Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756059Ab2BMAUe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Feb 2012 19:20:34 -0500
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:34264 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754757Ab2BMAUd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Feb 2012 19:20:33 -0500
MIME-Version: 1.0
In-Reply-To: <4f346d61.3S6x22TS5RH2gGO5%Larry.Finger@lwfinger.net>
References: <4f346d61.3S6x22TS5RH2gGO5%Larry.Finger@lwfinger.net>
Date: Mon, 13 Feb 2012 03:20:32 +0300
Message-ID: <CAMo8BfL+nbOmO=jo1uqYoXOUCDW2-c7BZTL5UBcdHGuyGODiFA@mail.gmail.com>
Subject: Re: [RFC/RFT] p54spi: Convert driver to use asynchronous firmware loading
From: Max Filippov <jcmvbkbc@gmail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: chunkeey@web.de, m@bues.ch, linux-kernel@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Drivers that load firmware from their probe routine have problems with the
> latest versions of udev as they get timeouts while waiting for user
> space to start. The problem is fixed by using request_firmware_nowait()
> and delaying the start of mac80211 until the firmware is loaded.
>
> To prevent the possibility of the driver being unloaded while the firmware
> loading callback is still active, a completion queue entry is used.
>
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> ---
>
> This conversion of p54spi to use asynchronous firmware loading is based
> on the method used in p54usb. As I do not have the hardware, it is only
> compile tested. I would appreciate any feedback from people that have the
> hardware.

Hi, Larry.

Are there any prerequisites for this patch?
For now I'm applying it to the linux-omap ToT and having the following:

<7>[    2.968048] calling  p54spi_init+0x0/0x30 [p54spi] @ 456
<4>[    2.973937] ------------[ cut here ]------------
<4>[    2.974090] WARNING: at
/home/dumb/ws/osll/n8x0/linux-3.3/linux-omap-2.6/fs/sysfs/dir.c:481
sysfs_add_one+0x74/0x9c()
<4>[    2.974212] sysfs: cannot create duplicate filename
'/devices/platform/omap/omap2_mcspi.2/spi_master/spi2/spi2.0/firmware/spi2.0'
<4>[    2.974334] Modules linked in: p54spi(+)
<4>[    2.974487] [<c00182bc>] (unwind_backtrace+0x0/0xe4) from
[<c002ef0c>] (warn_slowpath_common+0x4c/0x64)
<4>[    2.974670] [<c002ef0c>] (warn_slowpath_common+0x4c/0x64) from
[<c002efa4>] (warn_slowpath_fmt+0x2c/0x3c)
<4>[    2.974792] [<c002efa4>] (warn_slowpath_fmt+0x2c/0x3c) from
[<c00e5888>] (sysfs_add_one+0x74/0x9c)
<4>[    2.974945] [<c00e5888>] (sysfs_add_one+0x74/0x9c) from
[<c00e6290>] (create_dir+0x5c/0xac)
<4>[    2.975067] [<c00e6290>] (create_dir+0x5c/0xac) from
[<c00e6394>] (sysfs_create_dir+0xb4/0xcc)
<4>[    2.975219] [<c00e6394>] (sysfs_create_dir+0xb4/0xcc) from
[<c0142ce8>] (kobject_add_internal+0xe4/0x1c0)
<4>[    2.975372] [<c0142ce8>] (kobject_add_internal+0xe4/0x1c0) from
[<c0142f30>] (kobject_add+0x44/0x54)
<4>[    2.975494] [<c0142f30>] (kobject_add+0x44/0x54) from
[<c0193c98>] (device_add+0xe0/0x530)
<4>[    2.975646] [<c0193c98>] (device_add+0xe0/0x530) from
[<c019f184>] (_request_firmware+0x190/0x394)
<4>[    2.975799] [<c019f184>] (_request_firmware+0x190/0x394) from
[<c019f3c8>] (request_firmware_work_func+0x40/0x78)
<4>[    2.975952] [<c019f3c8>] (request_firmware_work_func+0x40/0x78)
from [<c00473cc>] (kthread+0x88/0x94)
<4>[    2.976135] [<c00473cc>] (kthread+0x88/0x94) from [<c0013844>]
(kernel_thread_exit+0x0/0x8)
<4>[    2.976226] ---[ end trace 181b959cc0c448db ]---
<3>[    2.976318] kobject_add_internal failed for spi2.0 with -EEXIST,
don't try to register things with the same name in the same directory.
<4>[    2.976501] [<c00182bc>] (unwind_backtrace+0x0/0xe4) from
[<c0142d84>] (kobject_add_internal+0x180/0x1c0)
<4>[    2.976654] [<c0142d84>] (kobject_add_internal+0x180/0x1c0) from
[<c0142f30>] (kobject_add+0x44/0x54)
<4>[    2.976776] [<c0142f30>] (kobject_add+0x44/0x54) from
[<c0193c98>] (device_add+0xe0/0x530)
<4>[    2.976928] [<c0193c98>] (device_add+0xe0/0x530) from
[<c019f184>] (_request_firmware+0x190/0x394)
<4>[    2.977081] [<c019f184>] (_request_firmware+0x190/0x394) from
[<c019f3c8>] (request_firmware_work_func+0x40/0x78)
<4>[    2.977233] [<c019f3c8>] (request_firmware_work_func+0x40/0x78)
from [<c00473cc>] (kthread+0x88/0x94)
<4>[    2.977386] [<c00473cc>] (kthread+0x88/0x94) from [<c0013844>]
(kernel_thread_exit+0x0/0x8)
<3>[    2.977508] p54spi spi2.0: fw_create_instance: device_register failed
<3>[    2.977600] p54spi spi2.0: Firmware loading failed
<3>[    3.104492] firmware spi2.0: firmware_loading_store: vmap() failed
<6>[    3.108337] p54spi spi2.0: loading default eeprom...
<6>[    3.108764] ieee80211 phy0: hwaddr 00:02:ee:c0:ff:ee,
MAC:isl3820 RF:Longbow

-- 
Thanks.
-- Max
