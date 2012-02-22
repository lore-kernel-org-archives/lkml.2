Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755077Ab2BVS1N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 13:27:13 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:5794 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751444Ab2BVS1K convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 13:27:10 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Wed, 22 Feb 2012 10:26:45 -0800
From: Stephen Warren <swarren@nvidia.com>
To: Linus Walleij <linus.walleij@linaro.org>
CC: Linus Walleij <linus.walleij@stericsson.com>,
        "B29396@freescale.com" <B29396@freescale.com>,
        "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>,
        "dongas86@gmail.com" <dongas86@gmail.com>,
        "shawn.guo@linaro.org" <shawn.guo@linaro.org>,
        "thomas.abraham@linaro.org" <thomas.abraham@linaro.org>,
        "tony@atomide.com" <tony@atomide.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Wed, 22 Feb 2012 10:26:43 -0800
Subject: RE: [PATCH 15/20] pinctrl: Fix and simplify locking
Thread-Topic: [PATCH 15/20] pinctrl: Fix and simplify locking
Thread-Index: AczxiNh+md0rkNuvSDypeKD8TuxdqQABJzUQ
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF17BD8BC6BE@HQMAIL01.nvidia.com>
References: <1329720360-23227-1-git-send-email-swarren@nvidia.com>
	<1329720360-23227-16-git-send-email-swarren@nvidia.com>
 <CACRpkdaxgUi1f_CpNRCVrza=TG6-H70o4BqTcCn6_68CGN3k+g@mail.gmail.com>
In-Reply-To: <CACRpkdaxgUi1f_CpNRCVrza=TG6-H70o4BqTcCn6_68CGN3k+g@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Walleij wrote at Wednesday, February 22, 2012 10:39 AM:
> On Mon, Feb 20, 2012 at 7:45 AM, Stephen Warren <swarren@nvidia.com> wrote:
> 
> > struct pinctrl_dev's pin_desc_tree_lock and pinctrl_hogs_lock aren't
> > useful; the data they protect is read-only except when registering or
> > unregistering a pinctrl_dev, and at those times, it doesn't make sense to
> > protect one part of the structure independently from the rest.
> 
> OK makes sense, please split this into a separate patch.
> 
> > struct pinctrl_dev's gpio_ranges_lock isn't effective;
> > pinctrl_match_gpio_range() only holds this lock while searching for a gpio
> > range, but the found range is return and manipulated after releading the
> > lock. This could allow pinctrl_remove_gpio_range() for that range while it
> > is in use, and the caller may very well delete the range after removing it,
> > causing pinctrl code to touch the now-free range object.
> >
> > Solving this requires the introduction of a higher-level lock, at least
> > a lock per pin controller, which both gpio range registration and
> > pinctrl_get()/put() will acquire.
> 
> I don't really like this "big pinctrl lock" approach, atleast for the
> gpio ranges the proper approach would rather be to use RCU,
> would it not? The above looks like a textbook example of where
> RCU should be used.

I'm not familiar with RCU specifically. If it's a single-writer-or-
multiple-reader lock, that might well solve this issue.

> > There is missing locking on HW programming; pin controllers may pack the
> > configuration for different pins/groups/config options/... into one
> > register, and hence have to read-modify-write the register. This needs to
> > be protected, but currently isn't.
> 
> Isn't that the responsibility of the driver? The subsystem
> should not make assumptions of what locking the driver
> may need of some drivers don't need it.

Deferring this to drivers might make sense. However, drivers don't have
any way to do this right now, since they don't know when the start of
a programming operation is. I suppose when adding complete() we could
add a start() operation too, so the lock could be acquired there.

> > Related, a future change will add a
> > "complete" op to the pin controller drivers, the idea being that each
> > state's programming will be programmed into the pinctrl driver followed
> > by the "complete" call, which may e.g. flush a register cache to HW. For
> > this to work, it must not be possible to interleave the pinctrl driver
> > calls for different devices.
> >
> > As above, solving this requires the introduction of a higher-level lock,
> > at least a lock per pin controller, which will be held for the duration
> > of any pinctrl_enable()/disable() call.
> 
> I buy this reasoning though, we sure need something there, but
> then it can be introduced with the complete() call, and be a
> separate lock across the affected call.
> 
> > However, each pinctrl mapping table entry may affect a different pin
> > controller if necessary. Hence, with a per-pin-controller lock, almost
> > any pinctrl API may need to acquire multiple locks, one per controller.
> > To avoid deadlock, these would need to be acquired in the same order in
> > all cases. This is extremely difficult to implement in the case of
> > pinctrl_get(), which doesn't know which pin controllers to lock until it
> > has parsed the entire mapping table, since it contains somewhat arbitrary
> > data.
> >
> > The simplest solution here is to introduce a single lock that covers all
> > pin controllers at once. This will be acquired by all pinctrl APIs.
> >
> > This then makes struct pinctrl's mutex irrelevant, since that single lock
> > will always be held whenever this mutex is currently held.
> 
> Introducing a big pincontroller lock :-(
> 
> As with the big kernel lock was the simplest approach to CPU
> locking.
> 
> I really would like to hold back on this, is it really that hard to have
> a more fine-granular locking here? Maybe this is a sign that we need
> to have the list of states sorted in pincontroller order simply?
> In that case we only need a lock per pincontroller I think.

I'd rather not alter the order that the mapping table entries get applied
in; I think that'd be confusing. I can certainly envisage use-cases where
the order is important (e.g. must disable pin config feature X before
enabling pin config feature Y when switching states, to avoid HW damage)
and sorting the mapping table would violating such requirements much more
likely.

Perhaps pinctrl_get() should keep a separate list of all pin controllers
involved anywhere in all the struct pinctrl_settings it contains, and
keep that list sorted, so that lock()/unlock() could be applied to that
list up-front, rather than locking pin controllers lazily as the settings
are applied in order. That'd be a bit more work but would probably allow
us to avoid any global locks.

Then, I think we could get away with:

A global lock for (un)registering controllers, (un)registering mapping
table entries, (un)registering GPIO ranges, parsing the mapping tables,
but which would not be taken when simply programming HW.

I'm not sure whether breaking this up into multiple locks actually makes
any sense; all of the above are relatively rare slow-paths anyway. The
important thing would be to not take that lock when /just/ programming
HW for state changes.

A lock per pin controller, implemented internally to the pin controller
driver if required in begin()/end() ops.

Does that seem reasonable?

Related to that, I guess we're currently missing refcounts on pin
controllers and GPIO ranges, so they can't be unregistered if
pinctrl_get() returned an object that references them, or gpio_request()
was called on a GPIO.

-- 
nvpublic

