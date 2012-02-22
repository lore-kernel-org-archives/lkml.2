Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753767Ab2BVRiy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 12:38:54 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:63486 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752847Ab2BVRiw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 12:38:52 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of linus.walleij@linaro.org designates 10.50.160.131 as permitted sender) smtp.mail=linus.walleij@linaro.org
MIME-Version: 1.0
In-Reply-To: <1329720360-23227-16-git-send-email-swarren@nvidia.com>
References: <1329720360-23227-1-git-send-email-swarren@nvidia.com>
	<1329720360-23227-16-git-send-email-swarren@nvidia.com>
Date: Wed, 22 Feb 2012 18:38:51 +0100
Message-ID: <CACRpkdaxgUi1f_CpNRCVrza=TG6-H70o4BqTcCn6_68CGN3k+g@mail.gmail.com>
Subject: Re: [PATCH 15/20] pinctrl: Fix and simplify locking
From: Linus Walleij <linus.walleij@linaro.org>
To: Stephen Warren <swarren@nvidia.com>
Cc: Linus Walleij <linus.walleij@stericsson.com>, B29396@freescale.com,
        s.hauer@pengutronix.de, dongas86@gmail.com, shawn.guo@linaro.org,
        thomas.abraham@linaro.org, tony@atomide.com,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 20, 2012 at 7:45 AM, Stephen Warren <swarren@nvidia.com> wrote:

> struct pinctrl_dev's pin_desc_tree_lock and pinctrl_hogs_lock aren't
> useful; the data they protect is read-only except when registering or
> unregistering a pinctrl_dev, and at those times, it doesn't make sense to
> protect one part of the structure independently from the rest.

OK makes sense, please split this into a separate patch.

> struct pinctrl_dev's gpio_ranges_lock isn't effective;
> pinctrl_match_gpio_range() only holds this lock while searching for a gpio
> range, but the found range is return and manipulated after releading the
> lock. This could allow pinctrl_remove_gpio_range() for that range while it
> is in use, and the caller may very well delete the range after removing it,
> causing pinctrl code to touch the now-free range object.
>
> Solving this requires the introduction of a higher-level lock, at least
> a lock per pin controller, which both gpio range registration and
> pinctrl_get()/put() will acquire.

I don't really like this "big pinctrl lock" approach, atleast for the
gpio ranges the proper approach would rather be to use RCU,
would it not? The above looks like a textbook example of where
RCU should be used.

> There is missing locking on HW programming; pin controllers may pack the
> configuration for different pins/groups/config options/... into one
> register, and hence have to read-modify-write the register. This needs to
> be protected, but currently isn't.

Isn't that the responsibility of the driver? The subsystem
should not make assumptions of what locking the driver
may need of some drivers don't need it.

> Related, a future change will add a
> "complete" op to the pin controller drivers, the idea being that each
> state's programming will be programmed into the pinctrl driver followed
> by the "complete" call, which may e.g. flush a register cache to HW. For
> this to work, it must not be possible to interleave the pinctrl driver
> calls for different devices.
>
> As above, solving this requires the introduction of a higher-level lock,
> at least a lock per pin controller, which will be held for the duration
> of any pinctrl_enable()/disable() call.

I buy this reasoning though, we sure need something there, but
then it can be introduced with the complete() call, and be a
separate lock across the affected call.

> However, each pinctrl mapping table entry may affect a different pin
> controller if necessary. Hence, with a per-pin-controller lock, almost
> any pinctrl API may need to acquire multiple locks, one per controller.
> To avoid deadlock, these would need to be acquired in the same order in
> all cases. This is extremely difficult to implement in the case of
> pinctrl_get(), which doesn't know which pin controllers to lock until it
> has parsed the entire mapping table, since it contains somewhat arbitrary
> data.
>
> The simplest solution here is to introduce a single lock that covers all
> pin controllers at once. This will be acquired by all pinctrl APIs.
>
> This then makes struct pinctrl's mutex irrelevant, since that single lock
> will always be held whenever this mutex is currently held.

Introducing a big pincontroller lock :-(

As with the big kernel lock was the simplest approach to CPU
locking.

I really would like to hold back on this, is it really that hard to have
a more fine-granular locking here? Maybe this is a sign that we need
to have the list of states sorted in pincontroller order simply?
In that case we only need a lock per pincontroller I think.

Yours,
Linus Walleij
