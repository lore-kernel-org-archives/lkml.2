Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933319Ab0HLALT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 20:11:19 -0400
Received: from kroah.org ([198.145.64.141]:47961 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933253Ab0HLAI7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 20:08:59 -0400
X-Mailbox-Line: From gregkh@clark.site Wed Aug 11 17:06:18 2010
Message-Id: <20100812000618.136567094@clark.site>
User-Agent: quilt/0.48-11.2
Date: Wed, 11 Aug 2010 17:06:14 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        =?ISO-8859-15?q?Eric=20B=C3=A9nard?= <eric@eukrea.com>,
        Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
        David Woodhouse <David.Woodhouse@intel.com>
Subject: [59/67] mtd: mxc_nand: fix unbalanced enable for IRQ
In-Reply-To: <20100812000641.GA6348@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Eric Bénard <eric@eukrea.com>

commit 6a8cfcfb0de881735df4031eb5cc99be3d0971e9 upstream.

* preset should be done before sending the reset command

* without this, I get the following error on an i.MX35 :
[    0.900000] ------------[ cut here ]------------
[    0.900000] WARNING: at kernel/irq/manage.c:290 __enable_irq+0x4c/0x88()
[    0.900000] Unbalanced enable for IRQ 33
[    0.900000] Modules linked in:
[    0.900000] [<c002ffb8>] (unwind_backtrace+0x0/0xf0) from [<c02f7d0c>] (dump_stack+0x18/0x1c)
[    0.900000] [<c02f7d0c>] (dump_stack+0x18/0x1c) from [<c0049a44>] (warn_slowpath_common+0x54/0x6c)
[    0.900000] [<c0049a44>] (warn_slowpath_common+0x54/0x6c) from [<c0049b00>] (warn_slowpath_fmt+0x38/0x40)
[    0.900000] [<c0049b00>] (warn_slowpath_fmt+0x38/0x40) from [<c008f65c>] (__enable_irq+0x4c/0x88)
[    0.900000] [<c008f65c>] (__enable_irq+0x4c/0x88) from [<c008fca0>] (enable_irq+0x54/0x98)
[    0.900000] [<c008fca0>] (enable_irq+0x54/0x98) from [<c021e618>] (wait_op_done+0x40/0x134)
[    0.900000] [<c021e618>] (wait_op_done+0x40/0x134) from [<c021e808>] (send_cmd+0x30/0x38)
[    0.900000] [<c021e808>] (send_cmd+0x30/0x38) from [<c021eb8c>] (mxc_nand_command+0x26c/0x328)
[    0.900000] [<c021eb8c>] (mxc_nand_command+0x26c/0x328) from [<c021aa60>] (nand_scan_ident+0x188/0x6c0)
[    0.900000] [<c021aa60>] (nand_scan_ident+0x188/0x6c0) from [<c001a9cc>] (mxcnd_probe+0x2b8/0x3d0)
[    0.900000] [<c001a9cc>] (mxcnd_probe+0x2b8/0x3d0) from [<c01f9e88>] (platform_drv_probe+0x20/0x24)
[    0.900000] [<c01f9e88>] (platform_drv_probe+0x20/0x24) from [<c01f8c38>] (driver_probe_device+0xb0/0x164)
[    0.900000] [<c01f8c38>] (driver_probe_device+0xb0/0x164) from [<c01f8d54>] (__driver_attach+0x68/0x8c)
[    0.900000] [<c01f8d54>] (__driver_attach+0x68/0x8c) from [<c01f8348>] (bus_for_each_dev+0x50/0x84)
[    0.900000] [<c01f8348>] (bus_for_each_dev+0x50/0x84) from [<c01f8a9c>] (driver_attach+0x20/0x28)
[    0.900000] [<c01f8a9c>] (driver_attach+0x20/0x28) from [<c01f7c00>] (bus_add_driver+0x144/0x2dc)
[    0.900000] [<c01f7c00>] (bus_add_driver+0x144/0x2dc) from [<c01f906c>] (driver_register+0xb0/0x13c)
[    0.900000] [<c01f906c>] (driver_register+0xb0/0x13c) from [<c01fa13c>] (platform_driver_register+0x4c/0x60)
[    0.900000] [<c01fa13c>] (platform_driver_register+0x4c/0x60) from [<c01fa170>] (platform_driver_probe+0x20/0xa0)
[    0.900000] [<c01fa170>] (platform_driver_probe+0x20/0xa0) from [<c001a708>] (mxc_nd_init+0x18/0x24)
[    0.900000] [<c001a708>] (mxc_nd_init+0x18/0x24) from [<c002938c>] (do_one_initcall+0x64/0x1bc)
[    0.900000] [<c002938c>] (do_one_initcall+0x64/0x1bc) from [<c00084c4>] (kernel_init+0xe8/0x1ac)
[    0.900000] [<c00084c4>] (kernel_init+0xe8/0x1ac) from [<c002aee8>] (kernel_thread_exit+0x0/0x8)
[    0.900000] ---[ end trace 8bf72ac6ba089a19 ]---
[    1.140000] NAND device: Manufacturer ID: 0x2c, Chip ID: 0xda (Micron NAND 256MiB 3,3V 8-bit)

Signed-off-by: Eric Bénard <eric@eukrea.com>
Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/mtd/nand/mxc_nand.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/mtd/nand/mxc_nand.c
+++ b/drivers/mtd/nand/mxc_nand.c
@@ -604,8 +604,8 @@ static void mxc_nand_command(struct mtd_
 	/* Command pre-processing step */
 	switch (command) {
 	case NAND_CMD_RESET:
-		send_cmd(host, command, false);
 		preset(mtd);
+		send_cmd(host, command, false);
 		break;
 
 	case NAND_CMD_STATUS:


