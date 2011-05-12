Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753574Ab1ELHo2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 03:44:28 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:47675 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752673Ab1ELHo1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 03:44:27 -0400
Date: Thu, 12 May 2011 09:44:21 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Linus Walleij <linus.walleij@stericsson.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Grant Likely <grant.likely@secretlab.ca>,
        Martin Persson <martin.persson@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Lee Jones <lee.jones@linaro.org>
Subject: Re: [PATCH 0/4] Pinmux subsystem
Message-ID: <20110512074421.GA2429@pengutronix.de>
References: <1304363768-30338-1-git-send-email-linus.walleij@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1304363768-30338-1-git-send-email-linus.walleij@stericsson.com>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 09:23:53 up 4 days, 23:01, 33 users,  load average: 0.17, 0.43, 0.60
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

On Mon, May 02, 2011 at 09:16:08PM +0200, Linus Walleij wrote:
> From: Linus Walleij <linus.walleij@linaro.org>
> 
> This patchset creates a pinmux subsystem and switches U300 to use that new
> subsystem as an example. The problem is not that fantastically hard to
> solve in a general way, nobody got around to it because it requires some
> upfront code I believe, and this is my stab at it.

This is a good step in the right direction. It solves the problem of
potential conflicts between different mux functions. Also it gives a
well defined interface between drivers and board code.

What I'm missing though is a generic way a single pad/mux mode
combination can be described. Let me take a look around how the
different subarchs do this:

omap:

	_OMAP3_MUXENTRY(DSS_DATA21, 91,
		"dss_data21", NULL, "mcspi3_cs0", "dss_data3",
		"gpio_91", NULL, NULL, "safe_mode"),
	_OMAP3_MUXENTRY(DSS_DATA22, 92,
		"dss_data22", NULL, "mcspi3_cs1", "dss_data4",
		"gpio_92", NULL, NULL, "safe_mode"),

pxa:

#define GPIO16_FFUART_TXD       MFP_CFG_OUT(GPIO16, AF3, DRIVE_HIGH)
#define GPIO37_FFUART_TXD       MFP_CFG_OUT(GPIO37, AF3, DRIVE_HIGH)
#define GPIO39_FFUART_TXD       MFP_CFG_OUT(GPIO39, AF2, DRIVE_HIGH)
#define GPIO83_FFUART_TXD       MFP_CFG_OUT(GPIO83, AF2, DRIVE_HIGH)
#define GPIO99_FFUART_TXD       MFP_CFG_OUT(GPIO99, AF3, DRIVE_HIGH)

i.MX:

#define _MX51_PAD_UART3_RXD__CSI1_D0            IOMUX_PAD(0x630, 0x240, 2, 0x0000, 0, 0)
#define _MX51_PAD_UART3_RXD__GPIO1_22           IOMUX_PAD(0x630, 0x240, 3, 0x0000, 0, 0)
#define _MX51_PAD_UART3_RXD__UART1_DTR          IOMUX_PAD(0x630, 0x240, 0, 0x0000, 0, 0)
#define _MX51_PAD_UART3_RXD__UART3_RXD          IOMUX_PAD(0x630, 0x240, 1, 0x09f4, 4, 0)
#define _MX51_PAD_UART3_TXD__CSI1_D1            IOMUX_PAD(0x634, 0x244, 2, 0x0000, 0, 0)

These all basically describe the same thing: put pad x into one of modes
a, b, c and apply certain flags like drive strength on this.

the other class of pin muxing I know of is that a whole group of pads
can be switched to a particular mode using a mux register like I think
is used used in your ux300 driver.

I'd like to have a unified way to describe this. If we ever want to move
this into the device tree we need this anyway as I think it's not an
option to have completely different SoC specific descriptions in the
device tree.

Do you think it's possible to do some consolidation on this level
aswell? It would really bring different SoCs more together.

Sascha

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
