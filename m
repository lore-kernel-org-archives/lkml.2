Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932197Ab2JIHqF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 03:46:05 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:51767 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754536Ab2JIHp6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 03:45:58 -0400
Date: Tue, 9 Oct 2012 09:45:49 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Fabio Estevam <fabio.estevam@freescale.com>
Cc: kernel@pengutronix.de, FlorianSchandinat@gmx.de,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] video: imxfb: Do not crash on reboot
Message-ID: <20121009074549.GG18531@pengutronix.de>
References: <1349703336-8105-1-git-send-email-fabio.estevam@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1349703336-8105-1-git-send-email-fabio.estevam@freescale.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 08, 2012 at 10:35:36AM -0300, Fabio Estevam wrote:
> Issuing a "reboot" command after the LCD times out causes the following
> warnings:
> 
> Requesting system reboot
> ------------[ cut here ]------------
> WARNING: at drivers/clk/clk.c:471 clk_disable+0x24/0x50()
> Modules linked in:
> [<c001ad90>] (unwind_backtrace+0x0/0xf4) from [<c0025aac>] (warn_slowpath_common+0x48/0x60)
> [<c0025aac>] (warn_slowpath_common+0x48/0x60) from [<c0025ae0>] (warn_slowpath_null+0x1c/0x24)
> [<c0025ae0>] (warn_slowpath_null+0x1c/0x24) from [<c03960a0>] (clk_disable+0x24/0x50)
> [<c03960a0>] (clk_disable+0x24/0x50) from [<c02695a0>] (imxfb_disable_controller+0x48/0x7c)
> [<c02695a0>] (imxfb_disable_controller+0x48/0x7c) from [<c029d838>] (platform_drv_shutdown+0x18/0x1c)
> [<c029d838>] (platform_drv_shutdown+0x18/0x1c) from [<c02990fc>] (device_shutdown+0x48/0x14c)
> [<c02990fc>] (device_shutdown+0x48/0x14c) from [<c003d09c>] (kernel_restart_prepare+0x2c/0x3c)
> [<c003d09c>] (kernel_restart_prepare+0x2c/0x3c) from [<c003d0e4>] (kernel_restart+0xc/0x48)
> [<c003d0e4>] (kernel_restart+0xc/0x48) from [<c003d1e8>] (sys_reboot+0xc0/0x1bc)
> [<c003d1e8>] (sys_reboot+0xc0/0x1bc) from [<c0014ca0>] (ret_fast_syscall+0x0/0x2c)
> ---[ end trace da6b502ca79c854f ]---
> ------------[ cut here ]------------
> WARNING: at drivers/clk/clk.c:380 clk_unprepare+0x1c/0x2c()
> Modules linked in:
> [<c001ad90>] (unwind_backtrace+0x0/0xf4) from [<c0025aac>] (warn_slowpath_common+0x48/0x60)
> [<c0025aac>] (warn_slowpath_common+0x48/0x60) from [<c0025ae0>] (warn_slowpath_null+0x1c/0x24)
> [<c0025ae0>] (warn_slowpath_null+0x1c/0x24) from [<c0396338>] (clk_unprepare+0x1c/0x2c)
> [<c0396338>] (clk_unprepare+0x1c/0x2c) from [<c02695a8>] (imxfb_disable_controller+0x50/0x7c)
> [<c02695a8>] (imxfb_disable_controller+0x50/0x7c) from [<c029d838>] (platform_drv_shutdown+0x18/0x1c)
> [<c029d838>] (platform_drv_shutdown+0x18/0x1c) from [<c02990fc>] (device_shutdown+0x48/0x14c)
> [<c02990fc>] (device_shutdown+0x48/0x14c) from [<c003d09c>] (kernel_restart_prepare+0x2c/0x3c)
> [<c003d09c>] (kernel_restart_prepare+0x2c/0x3c) from [<c003d0e4>] (kernel_restart+0xc/0x48)
> [<c003d0e4>] (kernel_restart+0xc/0x48) from [<c003d1e8>] (sys_reboot+0xc0/0x1bc)
> [<c003d1e8>] (sys_reboot+0xc0/0x1bc) from [<c0014ca0>] (ret_fast_syscall+0x0/0x2c)
> ---[ end trace da6b502ca79c8550 ]---
> ------------[ cut here ]------------
> 
> This happens because "reboot" triggers imxfb_shutdown(), which calls
> imxfb_disable_controller with the clocks already disabled.
> 
> To prevent this, add a clock enabled status so that we can check if the clocks
> are enabled before disabling them. 
> 
> Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
> ---
>  drivers/video/imxfb.c |   19 +++++++++++++------
>  1 file changed, 13 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/video/imxfb.c b/drivers/video/imxfb.c
> index f3363b2..6acf98a 100644
> --- a/drivers/video/imxfb.c
> +++ b/drivers/video/imxfb.c
> @@ -134,6 +134,7 @@ struct imxfb_info {
>  	struct clk		*clk_ipg;
>  	struct clk		*clk_ahb;
>  	struct clk		*clk_per;
> +	int			enabled;
I didn't really know the driver, but I wonder if the name "enabled" is a
tad too generic. Maybe better "clks_enabled"?

Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
