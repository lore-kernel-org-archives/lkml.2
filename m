Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932236Ab2JJOgN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 10:36:13 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:43054 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756642Ab2JJOgH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 10:36:07 -0400
From: "Karicheri, Muralidharan" <m-karicheri2@ti.com>
To: "Nori, Sekhar" <nsekhar@ti.com>
CC: "mturquette@linaro.org" <mturquette@linaro.org>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "shawn.guo@linaro.org" <shawn.guo@linaro.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "viresh.linux@gmail.com" <viresh.linux@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Hilman, Kevin" <khilman@ti.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-keystone@list.ti.com - Linux developers for Keystone family of
	devices (May contain non-TIers)" <linux-keystone@list.ti.com>,
        "linux-c6x-dev@linux-c6x.org" <linux-c6x-dev@linux-c6x.org>,
        "Chemparathy, Cyril" <cyril@ti.com>
Subject: RE: [PATCH 02/13] clk: davinci - add PSC clock driver
Thread-Topic: [PATCH 02/13] clk: davinci - add PSC clock driver
Thread-Index: AQHNpuPJ3ZG8RkfixU2CzP6weaSYtpeymw5g
Date: Wed, 10 Oct 2012 14:35:54 +0000
Message-ID: <3E54258959B69E4282D79E01AB1F32B7041FB753@DFLE12.ent.ti.com>
References: <1348682889-9509-1-git-send-email-m-karicheri2@ti.com>
 <1348682889-9509-3-git-send-email-m-karicheri2@ti.com>
 <50756B96.1070008@ti.com>
In-Reply-To: <50756B96.1070008@ti.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.170.170.90]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id q9AIUgek002698

>> -----Original Message-----
>> From: Nori, Sekhar
>> Sent: Wednesday, October 10, 2012 8:36 AM
>> To: Karicheri, Muralidharan
>> Cc: mturquette@linaro.org; arnd@arndb.de; akpm@linux-foundation.org;
>> shawn.guo@linaro.org; rob.herring@calxeda.com; linus.walleij@linaro.org;
>> viresh.linux@gmail.com; linux-kernel@vger.kernel.org; Hilman, Kevin;
>> linux@arm.linux.org.uk; davinci-linux-open-source@linux.davincidsp.com; linux-arm-
>> kernel@lists.infradead.org; linux-keystone@list.ti.com - Linux developers for Keystone
>> family of devices (May contain non-TIers); linux-c6x-dev@linux-c6x.org; Chemparathy,
>> Cyril
>> Subject: Re: [PATCH 02/13] clk: davinci - add PSC clock driver
>> 
>> On 9/26/2012 11:37 PM, Murali Karicheri wrote:
>> > This is the driver for the Power Sleep Controller (PSC) hardware found
>> > on DM SoCs as well Keystone SoCs (c6x). This driver borrowed code from
>> > arch/arm/mach-davinci/psc.c and implemented the driver as per common
>> > clock provider API. The PSC module is responsible for
>> > enabling/disabling the Power Domain and Clock domain for different IPs
>> > present in the SoC. The driver is configured through the platform data
>> > structure struct clk_davinci_psc_data.
>> >
>> > Signed-off-by: Murali Karicheri <m-karicheri2@ti.com>
>> >
>> > diff --git a/drivers/clk/davinci/clk-davinci-psc.c
>> > b/drivers/clk/davinci/clk-davinci-psc.c
>> > new file mode 100644
>> > index 0000000..b7aa332
>> > --- /dev/null
>> > +++ b/drivers/clk/davinci/clk-davinci-psc.c
>> > @@ -0,0 +1,197 @@
>> > +/*
>> > + * PSC clk driver for DaVinci devices
>> > + *
>> > + * Copyright (C) 2006-2012 Texas Instruments.
>> > + * Copyright (C) 2008-2009 Deep Root Systems, LLC
>> > + *
>> > + * This program is free software; you can redistribute it and/or
>> > +modify
>> > + * it under the terms of the GNU General Public License as published
>> > +by
>> > + * the Free Software Foundation; either version 2 of the License, or
>> > + * (at your option) any later version.
>> > + */
>> > +#include <linux/clk.h>
>> > +#include <linux/clk-provider.h>
>> > +#include <linux/delay.h>
>> > +#include <linux/err.h>
>> > +#include <linux/io.h>
>> > +#include <linux/slab.h>
>> > +#include <linux/platform_data/clk-davinci-psc.h>
>> 
>> Sort these alphabetically.
>> 
>> > +
>> > +/* PSC register offsets */
>> > +#define EPCPR		0x070
>> > +#define PTCMD		0x120
>> > +#define PTSTAT		0x128
>> > +#define PDSTAT		0x200
>> > +#define PDCTL		0x300
>> > +#define MDSTAT		0x800
>> > +#define MDCTL		0xA00
>> > +
>> > +/* PSC module states */
>> > +#define PSC_STATE_SWRSTDISABLE	0
>> > +#define PSC_STATE_SYNCRST	1
>> > +#define PSC_STATE_DISABLE	2
>> > +#define PSC_STATE_ENABLE	3
>> > +
>> > +#define MDSTAT_STATE_MASK	0x3f
>> > +#define PDSTAT_STATE_MASK	0x1f
>> > +#define MDCTL_FORCE		BIT(31)
>> > +#define PDCTL_NEXT		BIT(0)
>> > +#define PDCTL_EPCGOOD		BIT(8)
>> > +
>> > +/* PSC flags */
>> > +#define PSC_SWRSTDISABLE	BIT(0) /* Disable state is SwRstDisable */
>> > +#define PSC_FORCE		BIT(1) /* Force module state transtition */
>> > +#define PSC_HAS_EXT_POWER_CNTL	BIT(2) /* PSC has external power control
>> > +					* available (for DM6446 SoC) */
>> 
>> Can you try and keep the comment above on a single line?
>> 
>> > +/**
>> > + * struct clk_psc - DaVinci PSC clock
>> > + * @hw: clk_hw for the psc
>> > + * @psc_data: PSC driver specific data
>> > + * @lock: Spinlock used by the driver  */ struct clk_psc {
>> > +	struct clk_hw hw;
>> > +	struct clk_davinci_psc_data *psc_data;
>> > +	spinlock_t *lock;
>> > +};
>> > +
>> > +#define to_clk_psc(_hw) container_of(_hw, struct clk_psc, hw)
>> > +
>> > +/* Enable or disable a PSC domain */
>> > +static void clk_psc_config(void __iomem *base, unsigned int domain,
>> > +		unsigned int id, bool enable, u32 flags) {
>> > +	u32 epcpr, ptcmd, ptstat, pdstat, pdctl, mdstat, mdctl;
>> > +	u32 next_state = PSC_STATE_ENABLE;
>> > +	void __iomem *psc_base = base;
>> > +
>> > +	if (!enable) {
>> > +		if (flags & PSC_SWRSTDISABLE)
>> > +			next_state = PSC_STATE_SWRSTDISABLE;
>> > +		else
>> > +			next_state = PSC_STATE_DISABLE;
>> > +	}
>> > +
>> > +	mdctl = __raw_readl(psc_base + MDCTL + 4 * id);
>> 
>> Please convert all __raw_ variants to simple readl/writel() calls.
>> 
>> > +	mdctl &= ~MDSTAT_STATE_MASK;
>> > +	mdctl |= next_state;
>> > +	if (flags & PSC_FORCE)
>> > +		mdctl |= MDCTL_FORCE;
>> > +	__raw_writel(mdctl, psc_base + MDCTL + 4 * id);
>> > +
>> > +	pdstat = __raw_readl(psc_base + PDSTAT + 4 * domain);
>> > +	if ((pdstat & PDSTAT_STATE_MASK) == 0) {
>> > +		pdctl = __raw_readl(psc_base + PDCTL + 4 * domain);
>> > +		pdctl |= PDCTL_NEXT;
>> > +		__raw_writel(pdctl, psc_base + PDCTL + 4 * domain);
>> > +
>> > +		ptcmd = 1 << domain;
>> > +		__raw_writel(ptcmd, psc_base + PTCMD);
>> > +
>> > +		if (flags & PSC_HAS_EXT_POWER_CNTL) {
>> > +			do {
>> > +				epcpr = __raw_readl(psc_base + EPCPR);
>> > +			} while ((((epcpr >> domain) & 1) == 0));
>> > +		}
>> > +
>> > +		pdctl = __raw_readl(psc_base + PDCTL + 4 * domain);
>> > +		pdctl |= 0x100;
>> > +		__raw_writel(pdctl, psc_base + PDCTL + 4 * domain);
>> > +
>> > +		pdctl = __raw_readl(psc_base + PDCTL + 4 * domain);
>> > +		pdctl |= PDCTL_EPCGOOD;
>> > +		__raw_writel(pdctl, psc_base + PDCTL + 4 * domain);
>> > +	} else {
>> > +		ptcmd = 1 << domain;
>> > +		__raw_writel(ptcmd, psc_base + PTCMD);
>> > +	}
>> > +
>> > +	do {
>> > +		ptstat = __raw_readl(psc_base + PTSTAT);
>> > +	} while (!(((ptstat >> domain) & 1) == 0));
>> > +
>> > +	do {
>> > +		mdstat = __raw_readl(psc_base + MDSTAT + 4 * id);
>> > +	} while (!((mdstat & MDSTAT_STATE_MASK) == next_state)); }
>> > +
>> > +static int clk_psc_is_enabled(struct clk_hw *hw) {
>> > +	struct clk_psc *psc = to_clk_psc(hw);
>> > +	struct clk_davinci_psc_data *psc_data = psc->psc_data;
>> > +	u32 mdstat;
>> > +
>> > +	mdstat = __raw_readl(psc_data->base + MDSTAT + 4 * psc_data->lpsc);
>> > +	/* if clocked, state can be "Enable" or "SyncReset" */
>> > +	return (mdstat & BIT(12)) ? 1 : 0;
>> 
>> Can you include a blank line before the return. Also, since the API seems to expect a 0 or
>> 1, you can simply do:
>> 
>> 	return !!(mdstat & BIT(12);
>> 
>> > +}
>> > +
>> > +static int clk_psc_enable(struct clk_hw *hw) {
>> > +	struct clk_psc *psc = to_clk_psc(hw);
>> > +	struct clk_davinci_psc_data *psc_data = psc->psc_data;
>> > +	unsigned long flags = 0;
>> 
>> No need to initialize flags here.
>> 
>> > +
>> > +	if (psc->lock)
>> > +		spin_lock_irqsave(psc->lock, flags);
>> 
>> Is locking really optional here?
>> 
>> > +
>> > +	clk_psc_config(psc_data->base, psc_data->domain, psc_data->lpsc,
>> > +			1, psc_data->psc_flags);
>> > +
>> > +	if (psc->lock)
>> > +		spin_unlock_irqrestore(psc->lock, flags);
>> > +
>> > +	return 0;
>> > +}
>> > +
>> > +static void clk_psc_disable(struct clk_hw *hw) {
>> > +	struct clk_psc *psc = to_clk_psc(hw);
>> > +	struct clk_davinci_psc_data *psc_data = psc->psc_data;
>> > +	unsigned long flags = 0;
>> > +
>> > +	if (psc->lock)
>> > +		spin_lock_irqsave(psc->lock, flags);
>> > +
>> > +	clk_psc_config(psc_data->base, psc_data->domain, psc_data->lpsc,
>> > +			0, psc_data->psc_flags);
>> > +
>> > +	if (psc->lock)
>> > +		spin_unlock_irqrestore(psc->lock, flags); }
>> > +
>> > +static const struct clk_ops clk_psc_ops = {
>> > +	.enable = clk_psc_enable,
>> > +	.disable = clk_psc_disable,
>> > +	.is_enabled = clk_psc_is_enabled,
>> > +};
>> > +
>> > +struct clk *clk_register_davinci_psc(struct device *dev, const char *name,
>> > +			const char *parent_name,
>> > +			struct clk_davinci_psc_data *psc_data,
>> > +			spinlock_t *lock)
>> 
>> Why do you need the lock to be provided from outside of this file? You can initialize a lock
>> for serializing writes to PSC registers within this file, no?
>> 
>> > +{
>> > +	struct clk_init_data init;
>> > +	struct clk_psc *psc;
>> > +	struct clk *clk;
>> > +
>> > +	psc = kzalloc(sizeof(*psc), GFP_KERNEL);
>> > +	if (!psc)
>> > +		return ERR_PTR(-ENOMEM);
>> > +
>> > +	init.name = name;
>> > +	init.ops = &clk_psc_ops;
>> > +	init.flags = psc_data->flags;
>> > +	init.parent_names = (parent_name ? &parent_name : NULL);
>> > +	init.num_parents = (parent_name ? 1 : 0);
>> > +
>> > +	psc->psc_data = psc_data;
>> > +	psc->lock = lock;
>> > +	psc->hw.init = &init;
>> > +
>> > +	clk = clk_register(NULL, &psc->hw);
>> > +	if (IS_ERR(clk))
>> > +		kfree(psc);
>> > +
>> > +	return clk;
>> > +}
>> 
>> I guess, an unregister API will be useful here as well.
>> 
>> > diff --git a/include/linux/platform_data/clk-davinci-psc.h
>> > b/include/linux/platform_data/clk-davinci-psc.h
>> > new file mode 100644
>> > index 0000000..b805f72
>> > --- /dev/null
>> > +++ b/include/linux/platform_data/clk-davinci-psc.h
>> > @@ -0,0 +1,53 @@
>> > +/*
>> > + *  DaVinci Power & Sleep Controller (PSC) clk driver platform data
>> > + *
>> > + *  Copyright (C) 2006-2012 Texas Instruments.
>> > + *
>> > + *  This program is free software; you can redistribute  it and/or
>> > +modify it
>> > + *  under  the terms of  the GNU General  Public License as published
>> > +by the
>> > + *  Free Software Foundation;  either version 2 of the  License, or
>> > +(at your
>> > + *  option) any later version.
>> > + *
>> > + *  THIS  SOFTWARE  IS PROVIDED   ``AS  IS'' AND   ANY  EXPRESS OR IMPLIED
>> > + *  WARRANTIES,   INCLUDING, BUT NOT  LIMITED  TO, THE IMPLIED WARRANTIES
>> OF
>> > + *  MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
>> DISCLAIMED.  IN
>> > + *  NO  EVENT  SHALL   THE AUTHOR  BE    LIABLE FOR ANY   DIRECT, INDIRECT,
>> > + *  INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
>> (INCLUDING, BUT
>> > + *  NOT LIMITED   TO, PROCUREMENT OF  SUBSTITUTE GOODS  OR SERVICES;
>> LOSS OF
>> > + *  USE, DATA,  OR PROFITS; OR  BUSINESS INTERRUPTION) HOWEVER CAUSED
>> > +AND ON
>> > + *  ANY THEORY OF LIABILITY, WHETHER IN  CONTRACT, STRICT LIABILITY,
>> > +OR TORT
>> > + *  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE
>> > +USE OF
>> > + *  THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
>> 
>> Is this taken from GPL text? There should be no need to have this here.
>> 
>> > + *
>> > + *  You should have received a copy of the  GNU General Public
>> > + License along
>> > + *  with this program; if not, write  to the Free Software
>> > + Foundation, Inc.,
>> > + *  675 Mass Ave, Cambridge, MA 02139, USA.
>> 
>> This is not needed as well. ;-)
>> 
>> Thanks,
>> Sekhar

Thanks. I will take care of this in the next revision.

Murali
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
