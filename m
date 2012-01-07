Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753323Ab2AGTK7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jan 2012 14:10:59 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:34244 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753223Ab2AGTK6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jan 2012 14:10:58 -0500
Date: Sat, 7 Jan 2012 11:10:48 -0800
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: Laxman Dewangan <ldewangan.com@nvidia.com>,
        "lrg@slimlogic.co.uk" <lrg@slimlogic.co.uk>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>
Subject: Re: [PATCH V1] TPS62360: Add tps62360 regulator driver
Message-ID: <20120107191047.GA3590@opensource.wolfsonmicro.com>
References: <1325668818-1096-1-git-send-email-ldewangan@nvidia.com>
 <20120105062919.GI11867@opensource.wolfsonmicro.com>
 <96C9D994977DD0439FB6D3FE3B13DD907DBD3A9E9B@BGMAIL01.nvidia.com>
 <20120106185755.GC2893@opensource.wolfsonmicro.com>
 <96C9D994977DD0439FB6D3FE3B13DD907DBD3AA0DE@BGMAIL01.nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <96C9D994977DD0439FB6D3FE3B13DD907DBD3AA0DE@BGMAIL01.nvidia.com>
X-Cookie: You will triumph over your enemy.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 07, 2012 at 11:16:55PM +0530, Laxman Dewangan wrote:

> > Though frankly it seems rather broken if the hardware doesn't
> > automatically remove the clamp when

> The enable through external input line does not remove the clamp.
> It need to do the reset of the pmu chip (through power off) to
> remove the clamp automatically. The fast discharging is require

Oh, wow.  That's a bit special.

> in shutdown if we want to again power ON device quickly.

That's kind of what's concerning me - I'd expect that if we need to
power on quickly after shutdown it'd be at least as important to do this
if the regulator is just disabled in normal operation or during system
suspend.  But from what you're saying above it sounds like the feature
is just too hard to use outside of shutdown.

> I think I should  go with your suggestion to allow the VSEL0/1 to be
> dynamically changeable. If I implement this then client need to provide
> 4 sets of the regulator init data to register regulator. Each will have
> different sets of consumer. Client will get regulator for all sets of

That's one option, another option is to have the driver automatically
choose voltages to assign to the slots, for example using a LRU approach
to expire old voltages.  You can also do things like make sure that the
top voltage in the ranges specified are assigned slots to help with fast
ramping.

I'm actually starting to think we should factor this out into the core,
at least the slot assignment stuff.  There's a bunch of devices doing
variations on the theme already.  Let's not worry about that for now,
though - let's just get this in and factor out later.

> In the platform data, I will take 4 sets of regulator_init_data
> corresponding to VSEL0/1. If client is not interested in all and tied
> to fixed high/low, he will just pass NULL to unused index and proper
> information to used option.

Taking multiple different regulator_init_data is definitely not what we
want, there's a whole bunch of information in there, not just the
voltages.  You should just use platform data to specify the GPIOs (and
a set of voltages if you go with that approach).
