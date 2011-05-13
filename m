Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758668Ab1EMJ7W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 May 2011 05:59:22 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:38989 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753594Ab1EMJ7U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 May 2011 05:59:20 -0400
Date: Fri, 13 May 2011 11:59:09 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Martin Persson <martin.persson@stericsson.com>,
        Lee Jones <lee.jones@linaro.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 0/4] Pinmux subsystem
Message-ID: <20110513095909.GB2429@pengutronix.de>
References: <1304363768-30338-1-git-send-email-linus.walleij@stericsson.com>
 <20110512074421.GA2429@pengutronix.de>
 <BANLkTi=N8VNh3tPxYH8dQ0UtGpN=xSzKng@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BANLkTi=N8VNh3tPxYH8dQ0UtGpN=xSzKng@mail.gmail.com>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 11:43:11 up 6 days,  1:21, 42 users,  load average: 0.52, 0.74, 0.82
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 12, 2011 at 04:02:35PM +0200, Linus Walleij wrote:
> 2011/5/12 Sascha Hauer <s.hauer@pengutronix.de>:
> 
> > What I'm missing though is a generic way a single pad/mux mode
> > combination can be described. Let me take a look around how the
> > different subarchs do this:
> >
> > omap:
> >
> >        _OMAP3_MUXENTRY(DSS_DATA21, 91,
> >                "dss_data21", NULL, "mcspi3_cs0", "dss_data3",
> >                "gpio_91", NULL, NULL, "safe_mode"),
> >        _OMAP3_MUXENTRY(DSS_DATA22, 92,
> >                "dss_data22", NULL, "mcspi3_cs1", "dss_data4",
> >                "gpio_92", NULL, NULL, "safe_mode"),
> >
> > pxa:
> >
> > #define GPIO16_FFUART_TXD       MFP_CFG_OUT(GPIO16, AF3, DRIVE_HIGH)
> > #define GPIO37_FFUART_TXD       MFP_CFG_OUT(GPIO37, AF3, DRIVE_HIGH)
> > #define GPIO39_FFUART_TXD       MFP_CFG_OUT(GPIO39, AF2, DRIVE_HIGH)
> > #define GPIO83_FFUART_TXD       MFP_CFG_OUT(GPIO83, AF2, DRIVE_HIGH)
> > #define GPIO99_FFUART_TXD       MFP_CFG_OUT(GPIO99, AF3, DRIVE_HIGH)
> >
> > i.MX:
> >
> > #define _MX51_PAD_UART3_RXD__CSI1_D0            IOMUX_PAD(0x630, 0x240, 2, 0x0000, 0, 0)
> > #define _MX51_PAD_UART3_RXD__GPIO1_22           IOMUX_PAD(0x630, 0x240, 3, 0x0000, 0, 0)
> > #define _MX51_PAD_UART3_RXD__UART1_DTR          IOMUX_PAD(0x630, 0x240, 0, 0x0000, 0, 0)
> > #define _MX51_PAD_UART3_RXD__UART3_RXD          IOMUX_PAD(0x630, 0x240, 1, 0x09f4, 4, 0)
> > #define _MX51_PAD_UART3_TXD__CSI1_D1            IOMUX_PAD(0x634, 0x244, 2, 0x0000, 0, 0)
> >
> > These all basically describe the same thing: put pad x into one of modes
> > a, b, c and apply certain flags like drive strength on this.
> >
> > the other class of pin muxing I know of is that a whole group of pads
> > can be switched to a particular mode using a mux register like I think
> > is used used in your ux300 driver.
> >
> > I'd like to have a unified way to describe this.
> 
> Hm, so some of the structure I currently have inside the specific U300 driver
> need to become generic, in such way that say by activating 8 different
> padmux functions at the same, this can boil down to a single register
> write instead of 8 different register writes?
> 
> > Do you think it's possible to do some consolidation on this level
> > aswell? It would really bring different SoCs more together.
> 
> I am thinking on the abstract level, now we would have:
> 
> Board:
> static struct pinmux_map pmx_map[] = {
>         PINMUX_MAP("foo0", "foo0-1"),
>         PINMUX_MAP("bar0", "bar0-1"),
> };
> pinmux_register_mappings(pmx_map, ARRAY_SIZE(pmx_map));
> 
> Driver:
> pmx = pinmux_get("foo0", NULL);
> pinmux_enable(pmx);
> 
> For each of the mux functions. Now we need a grouping of
> these functions.

No, the driver API is fine. pinmux_enable can enable multiple pins in
the background and in fact it already does in your U300 example since
the hardware does not allow handling single pins.

What I'm asking for is to get rid of the differing definitions for
pin muxing. That is more an extension to your patches rather than
a change to your patches.

What omap/i.MX/pxa.. need is something like this:

/* describe all functions of a single pad, SoC or package specific */
struct padmux {
	int padno;
	const char *function; /* "uart1-txd", "spi3-mosi", "gpio127" */
	int num_functions;
};

/* select a particular function and additional settings */
struct function_selector {
	int padno;
	int function;	/* function to select from struct padmux above
			 * (could be const char * to match the function name
			 * instead of the number.
			 */
	unsigned long flags; /* drive strength, open drain, ... */
};

/*
 * map multiple pads to a device. Can be passed by the board or
 * filled from device tree.
 */
struct padgroup {
	const char *devname; /* imxspi.0, atmeluart.1,... */
	struct function_selector *functions;
	int num_functions;
};

(I don't know whether we can agree on a common set of flags, at least I
hope so)

I hope that we can agree on this or a similar set of structs to share
between different architectures.

Sascha

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
