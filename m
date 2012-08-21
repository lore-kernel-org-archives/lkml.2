Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754605Ab2HUI43 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 04:56:29 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:34935 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752597Ab2HUI4Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 04:56:24 -0400
Date: Tue, 21 Aug 2012 09:56:19 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Linus Walleij <linus.walleij@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: [PATCH 5/8] mfd: Provide the PRCMU with its own IRQ domain
Message-ID: <20120821085618.GA26899@gmail.com>
References: <1344527635-6163-6-git-send-email-lee.jones@linaro.org>
 <CACRpkdZ7bMBytyDppV2sB1d1sUbDpPRqAQVOq8k4UOYdmg+Mkw@mail.gmail.com>
 <201208140942.54773.arnd@arndb.de>
 <CACRpkdYbOBEPNbCdfi+=gupdqS8_7t7MpOgXs7VCVTs8Y3j_mQ@mail.gmail.com>
 <20120820083640.GH8450@gmail.com>
 <20120820121055.GA26991@opensource.wolfsonmicro.com>
 <20120820125531.GA20242@gmail.com>
 <20120820162923.GF26991@opensource.wolfsonmicro.com>
 <20120820164949.GB22749@gmail.com>
 <20120820175155.GH26991@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20120820175155.GH26991@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > If they don't have linear domains there's no point, if they support DT
> > then they can use it as it is.
> 
> All this stuff just works for any IRQ domain type, there's no
> requirement for a particular one.  It's not urgently exciting for legacy
> domains but it's not harmful either and pushes all the handling of this
> stuff out of the MFD core and into the irqdomain code which is
> definitely an abstraction win.

Wherever we do this from to be able to obtain the IRQ domain pointer, 
which is where I'm currently struggling. Our options are:

- Call into a helper function based in the IRQ controller from each 
child device. In turn the IRQ controller will be responsible for creating
the mapping necessary to obtain a virq. Using this method the child
device doesn't need to know if we're using an IRQ domain or not, or
whether we're using Device Tree or not. The drawback is that each child
device will be required to call the helper function prior to requesting
an IRQ. 

- If we're only talking MFD here, we can handle this stuff in the MFD
core, but we need more information. The IRQ domain subsystem only allows
domain look-up via a Device Tree node, so we need to get our hands on
the domain another way in the case of non-DT enabled devices. Either we
add another parameter to mfd_add_device(irq_domain, ...), or we
standardise the 'irq_domain' variable name and use:
        irq_domain = container_of(parent, struct irq_domain, irq_domain);

- I know that you have interest in pushing the functionality into the
IRQ domain subsystem, but I'm struggling to see how. It's calling into
the IRQ domain where we're seeing issues in the first place, specifically
irq_create_mapping(). How about if we passed 'irq_domain' as a parameter
when requesting the IRQ? That way we can pass the correct IRQ without
worry of conversion. If 'irq_domain' is !NULL the IRQ management subsystem
can do the necessary conversions. If 'irq_domain' is NULL it continues to
use the requested IRQ as a virq.

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
