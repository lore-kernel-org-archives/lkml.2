Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754462Ab1GQPyI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jul 2011 11:54:08 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:4601 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751082Ab1GQPyH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jul 2011 11:54:07 -0400
Date: Sun, 17 Jul 2011 17:53:44 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Greg KH <greg@kroah.com>, Grant Likely <grant@secretlab.ca>,
        Ben Dooks <ben-linux@fluff.org>,
        Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, Samuel Oritz <sameo@linux.intel.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] regulator: Convert tps65023 to use regmap API
Message-ID: <20110717175344.1d1bf16a@endymion.delvare>
In-Reply-To: <20110715131748.GD10026@opensource.wolfsonmicro.com>
References: <20110715062215.GN32716@opensource.wolfsonmicro.com>
	<1310710992-24462-1-git-send-email-broonie@opensource.wolfsonmicro.com>
	<1310710992-24462-4-git-send-email-broonie@opensource.wolfsonmicro.com>
	<20110715123121.735688a6@endymion.delvare>
	<20110715121646.GA10026@opensource.wolfsonmicro.com>
	<20110715145848.750a85aa@endymion.delvare>
	<20110715131748.GD10026@opensource.wolfsonmicro.com>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

On Fri, 15 Jul 2011 22:17:51 +0900, Mark Brown wrote:
> On Fri, Jul 15, 2011 at 02:58:48PM +0200, Jean Delvare wrote:
> > On Fri, 15 Jul 2011 21:16:50 +0900, Mark Brown wrote:
> 
> > > Does that sound reasonable to you?
> 
> > Yes, no objection.
> 
> BTW, if this does sound reasonable are you OK with adding your ack for
> the I2C bus interface patch or are there any updates you want me to do?

I did not review the patch carefully, so I can't ask for updates. As
none of "my" drivers will use it, I don't really feel qualified (nor
interested, honestly) to review it.

I don't quite get why you put the i2c bindings into
drivers/i2c/i2c-regmap.c. This means that Ben and I end up being the
maintainers of that file, while it's your thing. And this module is a
user of i2c, not a provider, so it doesn't really belong there anyway.
Same goes with spi. And what's the rationale for putting the regmap core
under drivers/base?

What's wrong with the more direct approach:
drivers/regmap/regmap-core.c
drivers/regmap/regmap-i2c.c
drivers/regmap/regmap-spi.c
?

At least you would have everything in one place and under your control.
With your current plan, every update is likely to spawn
cross-subsystems, which always results in delays and conflicts.

Now if you have a good reason for the current design, that's OK with
me, I can live with that. Simply it seems more complex than needed.

Also, your Kconfig setup is such that all bindings will be selected as
soon as any driver needs one. And the selection (module vs. built-in)
will be aligned on the core setting (e.g. CONFIG_I2C) rather than the
drivers which use it. I'd rather have e.g. REGULATOR_TPS65023 select
REGMAP_I2C, and in turn have REGMAP_I2C select REGMAP. This should
address the issues I pointed out.

-- 
Jean Delvare
