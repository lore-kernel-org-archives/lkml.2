Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755198Ab2IQIdA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 04:33:00 -0400
Received: from londo.lunn.ch ([80.238.139.98]:55066 "EHLO londo.lunn.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755135Ab2IQIc4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 04:32:56 -0400
Date: Mon, 17 Sep 2012 10:32:37 +0200
From: Andrew Lunn <andrew@lunn.ch>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Nicolas Pitre <nico@fluxnic.net>, Jason Cooper <jason@lakedaemon.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Lior Amsalem <alior@marvell.com>,
        Russell King <linux@arm.linux.org.uk>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, Rob Herring <rob.herring@calxeda.com>,
        Ben Dooks <ben.dooks@codethink.co.uk>,
        devicetree-discuss@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v4 03/10] pinctrl: mvebu: kirkwood pinctrl driver
Message-ID: <20120917083237.GB21928@lunn.ch>
References: <1344689809-6223-1-git-send-email-sebastian.hesselbarth@gmail.com>
 <1347550912-18021-1-git-send-email-sebastian.hesselbarth@gmail.com>
 <1347550912-18021-4-git-send-email-sebastian.hesselbarth@gmail.com>
 <20120916074652.GM28177@lunn.ch>
 <20120916124015.GI5469@titan.lakedaemon.net>
 <alpine.LFD.2.02.1209162137270.28681@xanadu.home>
 <5056C4EC.1030305@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5056C4EC.1030305@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I had a closer look at how kirkwood probes its id. I mentionend kirkwood_id()
> earlier but in fact it is kirkwood_pcie_id(). I assume pcie registers are shut
> down with pcie clk gated? That would require to have pcie running at least at
> boot-time on all boards.
> 
> While it is still possible to grab the id and power down pcie later, I still
> think that using five different compatible strings is better here. Of course,
> there is some effort to obtain the kirkwood SoC variant for all boards.

Hi Sebastian

I did the monkey work last night for converting all existing kirkwood
DT boards over to pinctrl. I noticed that in all the DT descriptions,
they all declare themselves as 88f6281. This is probably cut/paste
from the first board we ever had. For these boards, i doubt it will be
a problem, finding out what chip is really used, as there are active
maintainers. The problem comes with old style devices which we want to
convert. But if we do the monkey work for older boards, we are going
to have to find testers anyway and they can tell us what SoC is used.

Having said that, not probing the hardware, having it configurable is
a source of errors. We already probe the hardware in order to display:

Kirkwood: MV88F6282-Rev-A0, TCLK=200000000.

so we just need to cache this and make it available to anybody who
wants it.

I'm surprised we don't have the infrastructure of this already. We
have info about the CPU, e.g.

cat /proc/cpuinfo 
Processor	  : Feroceon 88FR131 rev 1 (v5l)
BogoMIPS	  : 1587.60
Features	  : swp half thumb fastmult edsp 
CPU implementer	  : 0x56
CPU architecture: 5TE
CPU variant	  : 0x2
CPU part	  : 0x131
CPU revision	  : 1

Hardware	  : Marvell Kirkwood (Flattened Device Tree)
Revision	  : 0000
Serial		    : 0000000000000000

but don't seem to have anything about the SoC the CPU is embedded in.

AT91 has at91_get_soc_type(struct at91_socinfo *c) which is what we
would need for Kirkwood. However, interestingly, its never used
outside of arch/arm/mach-at91/setup.c!

davinci has a global structure davinci_soc_info which
gpio/gpio-davinci.c uses.

So we would not be the only architecture making such information
available. We just need to make sure we do it such that its multi-arch
kernel compatible.

       Andrew




