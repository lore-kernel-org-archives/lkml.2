Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753500Ab2G2Ugk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2012 16:36:40 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:46481 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753363Ab2G2Ugj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2012 16:36:39 -0400
Date: Sun, 29 Jul 2012 21:36:36 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Liam Girdwood <lrg@ti.com>, linux-kernel@vger.kernel.org,
        Samuel Ortiz <sameo@linux.intel.com>,
        Stephen Warren <swarren@nvidia.com>
Subject: Re: [PATCH 3/3] regmap: enhance regmap-irq to handle 1 IRQ feeding n
 chips
Message-ID: <20120729203636.GE4384@opensource.wolfsonmicro.com>
References: <1343415716-27134-1-git-send-email-swarren@wwwdotorg.org>
 <1343415716-27134-3-git-send-email-swarren@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1343415716-27134-3-git-send-email-swarren@wwwdotorg.org>
X-Cookie: You dialed 5483.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 27, 2012 at 01:01:56PM -0600, Stephen Warren wrote:
> From: Stephen Warren <swarren@nvidia.com>
> 
> Some devices contain a single interrupt output, and multiple separate
> interrupt controllers that all trigger that interrupt output, yet provide
> no top-level interrupt controller/registers to allow determination of
> which child interrupt controller caused the interrupt.

This isn't really anything to do with regmap, it's about implementing
shared IRQ support for threaded interrupts.  This is generally useful
and shouldn't be tied to regmap, it's common enough for hardware
designers to want to use wired or interrupts and it's a limitation of
Linux that it can't cope currently.

If are were going to implement it in regmap we shouldn't be faffing
around setting up the virtual interrupts, we should just do the right
thing and call round all the chips without bouncing it through the IRQ
core.

>   * Copyright 2011 Wolfson Microelectronics plc
> + * Copyright (c) 2012, NVIDIA CORPORATION.  All rights reserved.

All rights reserved?  Hrm...

> +static irqreturn_t regmaps_irq_thread(int irq, void *data)
> +{
> +	struct regmap_irq_chips_data *d = data;
> +	int ret, i;
> +
> +	ret = pm_runtime_get_sync(d->dev);
> +	if (ret < 0) {

This is conditional in the core regmap runtime PM support, it may be
actively harmful if the device doesn't need it.
