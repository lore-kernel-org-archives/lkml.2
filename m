Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756956Ab1EaP2P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 11:28:15 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:63098 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756816Ab1EaP2O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 11:28:14 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Shawn Guo <shawn.guo@freescale.com>
Subject: Re: [PATCH 2/4] ARM: mxc: migrate mach-mx5 gpio driver to gpio-mxc
Date: Tue, 31 May 2011 17:27:55 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: Olof Johansson <olof@lixom.net>, Shawn Guo <shawn.guo@linaro.org>,
        linux-kernel@vger.kernel.org, grant.likely@secretlab.ca,
        kernel@pengutronix.de, linux-arm-kernel@lists.infradead.org,
        patches@linaro.org
References: <1306767139-24763-1-git-send-email-shawn.guo@linaro.org> <201105311328.18012.arnd@arndb.de> <20110531151019.GA32275@S2100-06.ap.freescale.net>
In-Reply-To: <20110531151019.GA32275@S2100-06.ap.freescale.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201105311727.55985.arnd@arndb.de>
X-Provags-ID: V02:K0:xuhe3pByZsj5P++YmlkcFC8gjfh/LtDWuZVOwm+medi
 xzAXLsapGxLIzUPJHepapLL1r3JrEVu1Qw6975OA25wDPvj6r7
 CyeIXqed3I9EVLlFS0kph7qGeqtwnJN1D6C4z4EvqPcBqEo6LH
 2ApiIP1Ld0W39fu0iAMP5RRedopPB/BrpTyr8u1llTt8uiOUdJ
 XfMbHHoDuxirBFIkKkUSw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 31 May 2011, Shawn Guo wrote:
> 
> On Tue, May 31, 2011 at 01:28:17PM +0200, Arnd Bergmann wrote:
> > On Tuesday 31 May 2011, Shawn Guo wrote:
> > > > Just open-code the mxc_add_mxc_gpio() by moving the individual calls to
> > > > mxc_add_gpio() into the respective callers. Having a global
> > > > mxc_add_mxc_gpio() function that does something different for each
> > > > caller seems entirely pointless to me.
> > > > 
> > > Right now, mxc_add_mxc_gpio() is a postcore_initcall.  Moving
> > > individual mxc_add_gpio() call into irq_init function does not work.
> > > And I need to find a proper caller for each SoC to call mxc_add_gpio
> > > to register gpio devices.
> >  
> > Why not init_machine? That is an arch_initcall(), so it's probably close
> > enough.
> > 
> The init_machine is mostly a board specific function than SoC specific
> one.  That is to say we will call mxc_add_gpio() in every single board
> init function even for the same SoC.

But the machine is the only place that knows what SOC is being used.
Your patch right now detects it by looking at the CPU type that is
also being set by the board file using the init_early call, which
is a bit silly.

I would leave e.g. the imx51_register_gpios() in place, but only
change the definition and the caller to

void __init imx51_register_gpios(void)
{
        mxc_add_gpio(0, MX51_GPIO1_BASE_ADDR, SZ_16K, MX51_MXC_INT_GPIO1_LOW, MX51_MXC_INT_GPIO1_HIGH);
        mxc_add_gpio(1, MX51_GPIO2_BASE_ADDR, SZ_16K, MX51_MXC_INT_GPIO2_LOW, MX51_MXC_INT_GPIO2_HIGH);
        mxc_add_gpio(2, MX51_GPIO3_BASE_ADDR, SZ_16K, MX51_MXC_INT_GPIO3_LOW, MX51_MXC_INT_GPIO3_HIGH);
        mxc_add_gpio(3, MX51_GPIO4_BASE_ADDR, SZ_16K, MX51_MXC_INT_GPIO4_LOW, MX51_MXC_INT_GPIO4_HIGH);
}

Then you can call that function from each i.mx51 based board, or
from a new imx51_soc_init() function that groups multiple such
functions.

	Arnd
