Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755238Ab1DTPh1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 11:37:27 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:36185 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752787Ab1DTPh0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 11:37:26 -0400
Date: Wed, 20 Apr 2011 16:37:22 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Ashish Jangam <Ashish.Jangam@kpitcummins.com>
Cc: "cbou@mail.ru" <cbou@mail.ru>, "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv1 4/11] Power: Battery module of DA9052 PMIC driver
Message-ID: <20110420153722.GC9869@opensource.wolfsonmicro.com>
References: <E2CAE7F7B064EA49B5CE7EE9A4BB167D151B4AC1AE@KCINPUNHJCMS01.kpit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E2CAE7F7B064EA49B5CE7EE9A4BB167D151B4AC1AE@KCINPUNHJCMS01.kpit.com>
X-Cookie: Just to have it is enough.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 06, 2011 at 06:28:03PM +0530, Ashish Jangam wrote:

> +static u16 filter_sample(u16 *buffer)
> +{
> +       u8 count;
> +       u16 tempvalue = 0;
> +       u16 ret;
> +
> +       if (buffer == NULL)
> +               return -EINVAL;
> +
> +       for (count = 0; count < DA9052_FILTER_SIZE; count++)
> +               tempvalue = tempvalue + *(buffer + count);
> +
> +       ret = tempvalue/DA9052_FILTER_SIZE;
> +       return ret;

It's probably as well to pass the size of buffer in as an argument so
that it's less surprising that you don't handle a partially filled
buffer.

You probably want to call this _average() or something, it's not
actually doing any filtering, it's just taking an average.  This is
perfectly sensible but it's a bit confusing.

> +static irqreturn_t da9052_tbat_irq(int irq, void *data)
> +{
> +       struct da9052_charger_device *chg_device =
> +                                       (struct da9052_charger_device *)data;
> +
> +       chg_device->health = POWER_SUPPLY_HEALTH_OVERHEAT;
> +
> +       return IRQ_HANDLED;
> +}

Shouldn't you also be telling the core about the status change so it can
go notify userspace?

> +/* STATIC CONFIGURATION */
> +#define DA9052_LOOK_UP_TABLE_SIZE              68
> +#define DA9052_NO_OF_LOOKUP_TABLE              3
> +#define DA9052_FILTER_SIZE                     4
> +#define DA9052_NUMBER_OF_STORE_CURENT_READING  4

> +static u32 const vbat_vs_capacity_look_up[DA9052_NO_OF_LOOKUP_TABLE]
> +                                       [DA9052_LOOK_UP_TABLE_SIZE][2] = {

You probably want to be using ARRAY_SIZE() for some of this.
