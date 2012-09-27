Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753594Ab2I0Oey (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 10:34:54 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:59640 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752499Ab2I0Oex (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 10:34:53 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: [PATCH] mfd: da9052-core: Fix request_threaded_irq() parameter
Date: Thu, 27 Sep 2012 14:34:45 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: Fabio Estevam <festevam@gmail.com>, sameo@linux.intel.com, marex@denx.de,
        ashish.jangam@kpitcummins.com, dchen@diasemi.com,
        linux-kernel@vger.kernel.org,
        Fabio Estevam <fabio.estevam@freescale.com>
References: <1348718135-10300-1-git-send-email-festevam@gmail.com> <20120927140843.GX4428@opensource.wolfsonmicro.com>
In-Reply-To: <20120927140843.GX4428@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201209271434.45516.arnd@arndb.de>
X-Provags-ID: V02:K0:Wcrj94fiRPTVHhwiNUDuMj+K//at+bFOcrTr0x7mPc7
 Xzxmfhk2f1P7yMvEZY8BAgneAwYONEQhvIaAMXU6V29R9ylBVe
 dqVwrF1ntjN3AQJKa6LStHuv6j87VDe8dTahxqjt9Qregq2PCi
 3frYI8kMkczQsWWrzzwHbUI91ZlK33BndXGrnfj4fpkAsGndNS
 v+qzTCwkQe/keMl4RAFWSio4vIymetb+yLOVt/4/r2UIjIryjN
 u7fQh0LjSZ1kVzs4dd0QD1K1bh0LYcol/0HcNO2AZAk8L0Qe1m
 SF1ERn0vLVC5GYhhezcNIX6HkTbR7aNNhbrXxuGzUsQ9lFvKkm
 UFXjv6hU416r1+ChnzVs=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 27 September 2012, Mark Brown wrote:
> On Thu, Sep 27, 2012 at 12:55:35AM -0300, Fabio Estevam wrote:
> > From: Fabio Estevam <fabio.estevam@freescale.com>
> > 
> > On a mx53qsb dt-kernel the da9052-core driver fails to probe:
> > 
> > da9052 1-0048: DA9052 ADC IRQ failed ret=-22
> > 
> > In request_threaded_irq() the first parameter is missing the da9052->irq_base.
> > 
> > Fix it and avoid the error.
> 
> The driver shouldn't be relying on irq_base at all, it should use
> regmap_get_virq() to look up the interrupt number.  If it relies on
> irq_base then the user is forced to assign one (or rely on automatic
> assignment, which is a bit erratic.  Otherwise it can use a linear
> domain which doesn't rely on being able to allocate a big block of
> interrupt numbers.

For all I can tell, the driver implements the automatic assignment
correctly, but I was also going to ask for removing the da9052->irq_base
variable and using the linear domain instead.

We don't have any platforms actually setting the irq_base in the
mainline kernel (I assume some of out tree platforms do this), but there
are a few drivers that need to be adapted to use regmap_irq_get_virq
or irq_to_desc(irq)->hw_irq, respectively:

drivers/gpio/gpio-da9052.c:     return da9052->irq_base + DA9052_IRQ_GPI0 + offset;
drivers/input/touchscreen/da9052_tsi.c: tsi->irq_pendwn = da9052->irq_base + irq_pendwn;
drivers/input/touchscreen/da9052_tsi.c: tsi->irq_datardy = da9052->irq_base + irq_datardy;
drivers/power/da9052-battery.c: irq -= bat->da9052->irq_base;
drivers/power/da9052-battery.c:         ret = request_threaded_irq(bat->da9052->irq_base + irq,
drivers/power/da9052-battery.c:         free_irq(bat->da9052->irq_base + irq, bat);
drivers/power/da9052-battery.c:         free_irq(bat->da9052->irq_base + irq, bat);

	Arnd
