Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753140Ab3AGArb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2013 19:47:31 -0500
Received: from perceval.ideasonboard.com ([95.142.166.194]:42622 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752294Ab3AGAr3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2013 19:47:29 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-omap@vger.kernel.org
Cc: mturquette@ti.com
Subject: Common clock framework: mutex recursion when calling clk_prepare from prepare handler
Date: Mon, 07 Jan 2013 01:49:02 +0100
Message-ID: <3826517.zOi8FASM36@avalon>
User-Agent: KMail/4.9.2 (Linux/3.6.11-gentoo; KDE/4.9.2; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I ran into a mutex recursion issue while trying to port the OMAP3 ISP driver 
(drivers/media/platform/omap3isp) over to the common clock framework.

The OMAP3 ISP generates two programmable clocks named xclka and xclkb that are 
routed out of the SoC. My goal is to expose them as common clock instances 
through the common clock framework.

The xclk[ab] clocks are children of the cam_mclk clock. They are controlled 
through ISP registers that sit in the cam_fclk clock domain. The cam_mclk and 
cam_fclk clocks sit in separate power domains.

To program the xclk clocks I need to enable the cam_fclk clock. As xclk[ab] 
are not descendants of the cam_fclk clock, this operation needs to be 
performed manually. I thus call clk_prepare_enable on the cam_fclk clock in 
the xclk[ab] prepare handler. This is where things break, as the common clock 
framework takes the prepare_lock mutex in clk_prepare, which results in a 
mutex recursion deadlock as the prepare_lock mutex isn't recursive.

What's the best way to solve this ? __clk_prepare (the unlocked version of 
clk_prepare) isn't exported to drivers, and I'm not convinced it should be. 
Turning prepare_lock into a recursive mutex might also work, but I'm not sure 
what drawbacks this would have. Advices would be appreciated.

-- 
Regards,

Laurent Pinchart

