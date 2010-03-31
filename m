Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932311Ab0CaH55 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Mar 2010 03:57:57 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:58778 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757238Ab0CaH5u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Mar 2010 03:57:50 -0400
Date: Wed, 31 Mar 2010 09:57:46 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Bryan Wu <bryan.wu@canonical.com>
Cc: gerg@uclinux.org, amit.kucheria@canonical.com,
       kernel-team@lists.ubuntu.com, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
       w.sang@pengutronix.de
Subject: Re: [PATCH] netdev/fec.c: add phylib supporting to enable carrier
	detection
Message-ID: <20100331075746.GO2241@pengutronix.de>
References: <1269597052-10104-1-git-send-email-bryan.wu@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1269597052-10104-1-git-send-email-bryan.wu@canonical.com>
X-Sent-From: Pengutronix Entwicklungszentrum Nord - Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Impressum: Pengutronix - Industrial Linux Solutions Handelsregister:
	Amtsgericht Hildesheim, HRA 2686 Peiner Strasse 6-8, 31137
	Hildesheim, Germany Phone: +49-5121-206917-0 |  Fax:
	+49-5121-206917-5555 Inhaber: Dipl.-Ing. Robert Schwebel
X-Message-Flag: See Message Headers for Impressum
X-Uptime: 09:37:12 up 10 days, 20:26, 20 users,  load average: 0.24, 0.42,
	0.50
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 26, 2010 at 05:50:52PM +0800, Bryan Wu wrote:
> BugLink: http://bugs.launchpad.net/bugs/457878
> 
>  - removed old MII phy control code
>  - add phylib supporting
>  - add ethtool interface to make user space NetworkManager works
> 
> Tested on Freescale i.MX51 Babbage board.
> 
> This patch is based on a patch from Frederic Rodo <fred.rodo@gmail.com>
> 


Hi Bryan,

The MII speed is calculated twice with this patch applied, one time
in fec_enet_mii_init and one time in fec_enet_init.

The patch didn't work for me because the calculation is wrong (which of
course is not your fault, it was wrong before).
According to the Datasheet the MII clock is clk_get_rate() / (MII * 2).
When we want to have a clock of 2.5MHz we have to do:

clk_get_rate() / 5000000

With rounding this would be:

(clk_get_rate() + 4999999) / 5000000

So you might want to add the following to your patch:

	fep->phy_speed = ((clk_get_rate(fep->clk) + 4999999) / 5000000) << 1;

Otherwise the patch looks good to me.

Sascha

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
