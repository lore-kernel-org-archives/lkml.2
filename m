Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757438Ab2HTQuA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 12:50:00 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:49491 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755514Ab2HTQtz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 12:49:55 -0400
Date: Mon, 20 Aug 2012 17:49:50 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Linus Walleij <linus.walleij@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: [PATCH 5/8] mfd: Provide the PRCMU with its own IRQ domain
Message-ID: <20120820164949.GB22749@gmail.com>
References: <1344527635-6163-1-git-send-email-lee.jones@linaro.org>
 <1344527635-6163-6-git-send-email-lee.jones@linaro.org>
 <CACRpkdZ7bMBytyDppV2sB1d1sUbDpPRqAQVOq8k4UOYdmg+Mkw@mail.gmail.com>
 <201208140942.54773.arnd@arndb.de>
 <CACRpkdYbOBEPNbCdfi+=gupdqS8_7t7MpOgXs7VCVTs8Y3j_mQ@mail.gmail.com>
 <20120820083640.GH8450@gmail.com>
 <20120820121055.GA26991@opensource.wolfsonmicro.com>
 <20120820125531.GA20242@gmail.com>
 <20120820162923.GF26991@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20120820162923.GF26991@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 20, 2012 at 05:29:23PM +0100, Mark Brown wrote:
> On Mon, Aug 20, 2012 at 01:55:32PM +0100, Lee Jones wrote:
> 
> > Right, that was the initial intention. It would be a trivial semantic
> > change if drivers without DT support wished to use the functionality
> > though. However, the only examples I found of a non-DT enabled driver
> > that could make good use of it in order to strip out some cruft would
> > be the Arizona and one of the Samsung drivers, and they each have
> 
> All of the regmap devices could use this.

Only if they have linear domains and don't support DT.

If they don't have linear domains there's no point, if they support DT
then they can use it as it is.

> > their own hand-rolled methods of hwirq -> virq conversion now, so any
> > change to support them would result in multiple invocations of
> > irq_create_mapping which would likely cause breakage.
> 
> Multiple calls to irq_create_mapping() are totally fine.

Sorry, perhaps I wasn't clear.

<mfd_parent_device>_probe()
|
+-> mfd_add_device()
    |
    +-> res->start = res->end = irq_create_mapping(res->start); // Now a VIRQ


<mfd_child_device>_probe()
|
+-> <mfd_parent_device>_irq_get_virq(res->start) // Ahhh, double VIRQ conversion

To stop being DT dependent we'd need to remove all hand-rolled stuff 
that these drivers are currently using, or else they will be attempting
to convert and already converted VIRQ value. 

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
