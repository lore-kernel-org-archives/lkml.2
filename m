Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754129Ab2BWASj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 19:18:39 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:6967 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753799Ab2BWASi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 19:18:38 -0500
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Wed, 22 Feb 2012 16:18:16 -0800
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
Date: Wed, 22 Feb 2012 16:18:15 -0800
Subject: RE: [PATCH 15/20] pinctrl: Fix and simplify locking
Thread-Topic: [PATCH 15/20] pinctrl: Fix and simplify locking
Thread-Index: AczxiNh+md0rkNuvSDypeKD8TuxdqQABJzUQAAvB0AA=
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF17BD8BC86A@HQMAIL01.nvidia.com>
References: <1329720360-23227-1-git-send-email-swarren@nvidia.com>
	<1329720360-23227-16-git-send-email-swarren@nvidia.com>
 <CACRpkdaxgUi1f_CpNRCVrza=TG6-H70o4BqTcCn6_68CGN3k+g@mail.gmail.com>
 <74CDBE0F657A3D45AFBB94109FB122FF17BD8BC6BE@HQMAIL01.nvidia.com>
In-Reply-To: <74CDBE0F657A3D45AFBB94109FB122FF17BD8BC6BE@HQMAIL01.nvidia.com>
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

Stephen Warren wrote at Wednesday, February 22, 2012 11:27 AM:
> Linus Walleij wrote at Wednesday, February 22, 2012 10:39 AM:
> > On Mon, Feb 20, 2012 at 7:45 AM, Stephen Warren <swarren@nvidia.com> wrote:
> >
> > > struct pinctrl_dev's pin_desc_tree_lock and pinctrl_hogs_lock aren't
> > > useful; the data they protect is read-only except when registering or
> > > unregistering a pinctrl_dev, and at those times, it doesn't make sense to
> > > protect one part of the structure independently from the rest.
> >
> > OK makes sense, please split this into a separate patch.
> >
> > > struct pinctrl_dev's gpio_ranges_lock isn't effective;
> > > pinctrl_match_gpio_range() only holds this lock while searching for a gpio
> > > range, but the found range is return and manipulated after releading the
> > > lock. This could allow pinctrl_remove_gpio_range() for that range while it
> > > is in use, and the caller may very well delete the range after removing it,
> > > causing pinctrl code to touch the now-free range object.
> > >
> > > Solving this requires the introduction of a higher-level lock, at least
> > > a lock per pin controller, which both gpio range registration and
> > > pinctrl_get()/put() will acquire.
> >
> > I don't really like this "big pinctrl lock" approach, atleast for the
> > gpio ranges the proper approach would rather be to use RCU,
> > would it not? The above looks like a textbook example of where
> > RCU should be used.
> 
> I'm not familiar with RCU specifically. If it's a single-writer-or-
> multiple-reader lock, that might well solve this issue.

I don't think RCU is the answer here:

* RCU is great where the read path needs to be really fast at the (slight?)
  cost of write path speed. In pinctrl, I don't see that the paths that
  touch the GPIO ranges are especially time-critical since they're mostly
  probe/remove-time actions.

* RCU is easy to use for simple cases, but more tricky where you want to
  e.g. modify list elements in-place. While we don't right now, I'd like
  to add a "usecount" to the gpio_range, so we can guarantee one can't be
  unregistered while there's an active gpio_request() against it.
  Otherwise, it'd be impossible to gpio_free() later.

* RCU knows when you're done with something due to pre-emption. However,
  the internals of a pinctrl driver's gpio_request_enable might sleep e.g.
  if it needed to touch registers on an I2C bus. While there is a sleepable
  RCU, I don't think there's an sleepable equivalent of rculist.h.

...
> > Introducing a big pincontroller lock :-(
> >
> > As with the big kernel lock was the simplest approach to CPU
> > locking.
> >
> > I really would like to hold back on this, is it really that hard to have
> > a more fine-granular locking here? Maybe this is a sign that we need
> > to have the list of states sorted in pincontroller order simply?
> > In that case we only need a lock per pincontroller I think.
> 
> I'd rather not alter the order that the mapping table entries get applied
> in; I think that'd be confusing. I can certainly envisage use-cases where
> the order is important (e.g. must disable pin config feature X before
> enabling pin config feature Y when switching states, to avoid HW damage)
> and sorting the mapping table would violating such requirements much more
> likely.
> 
> Perhaps pinctrl_get() should keep a separate list of all pin controllers
> involved anywhere in all the struct pinctrl_settings it contains, and
> keep that list sorted, so that lock()/unlock() could be applied to that
> list up-front, rather than locking pin controllers lazily as the settings
> are applied in order. That'd be a bit more work but would probably allow
> us to avoid any global locks.
> 
> Then, I think we could get away with:
> 
> A global lock for (un)registering controllers, (un)registering mapping
> table entries, (un)registering GPIO ranges, parsing the mapping tables,
> but which would not be taken when simply programming HW.
> 
> I'm not sure whether breaking this up into multiple locks actually makes
> any sense; all of the above are relatively rare slow-paths anyway. The
> important thing would be to not take that lock when /just/ programming
> HW for state changes.
> 
> A lock per pin controller, implemented internally to the pin controller
> driver if required in begin()/end() ops.
> 
> Does that seem reasonable?
> 
> Related to that, I guess we're currently missing refcounts on pin
> controllers and GPIO ranges, so they can't be unregistered if
> pinctrl_get() returned an object that references them, or gpio_request()
> was called on a GPIO.

I did start looking into having separate locks, and I don't think it's
really feasible; I'd still like to go with the above; one lock for any
slow-path data-manipulation and one per "struct pinctrl *p" to allow
parallelism in the fast path. Some examples of issues with lots of locks:

It'd be nice to have a lock per struct pinctrl_dev.

I'd like to add a usecount to struct pinctrl_dev. Any struct pinctrl that
uses a struct pinctrl_dev, or any gpio_request will increase the usecount,
so that the struct pinctrl_dev can't be unregistered while a struct pinctrl
or GPIO could use it. That'd require something like the following at the
end of pinctrl_register():

	mutex_lock(&pinctrldev_list_mutex);
	/*
	 * Must do this first, because pinctrl_get needs to find this
	 * device in the list in order to convert mapping table entries
	 */
	list_add_tail(&pctldev->node, &pinctrldev_list);

	/*
	 * This must be held so that when pinctrldev_list_mutex is dropped,
	 * other threads still can't touch pctldev and mess with it usecount
	 * until we're through here. This could be done before the first
	 * mutex_lock above too.
	 */
	mutex_lock(&pctldev->mutex);

	/* Done with list manipulations now */
	mutex_unlock(&pinctrldev_list_mutex);

	pctldev->p = pinctrl_get(pctldev->dev, "default");
	if (!IS_ERR(pctldev->p))
		pinctrl_enable(pctldev->p);
	pctldev->usecount_post_hog = pctldev->usecount;

But, the internals of pinctrl_get() will need to increment the usecount
of every pctldev it finds referenced from the mapping table. To do this,
the pctldev must be locked since data inside it is being manipulated.
However, that'd end up attempting to recursively lock this pctldev's
lock, and Linux locks don't allow recursive locking.

Perhaps this could be solved by passing a bunch of parameters into
pinctrl_get (or rather, an internal function called both from the public
pinctrl_get and here) indicating what was already locked. However, that
seems pretty nasty, and certainly not very simple.

Or perhaps, we should write some internal pinctrl_get that knows not to
touch the pctldev's own usecount, so that we don't need the separate
usecount_post_hog field, since that pinctrl_get wouldn't increment the
regular usecount. However, that'd be a nasty special case to maintain.

So then I figured, let's just remove pctldev->mutex and use
pinctrldev_list_mutex to cover both the list, and any/all struct
pinctrl_dev manipulations. This has the nice advantage that pinctrl_get()
no longer needs to lock/unlock a mutex for every mapping table entry, so
speeds things up.

At this point, we could still have separate mutexes for:

pinctrldev_list_mutex: Any operation on a device.

pinctrl_list_mutex: Any operation on the list of struct pinctrl.

pinctrl_maps: Any operation on the mapping table list.

But then let's take a look at the public pinctrl_get: It needs to lock
pinctrldev_list_mutex and pinctrl_maps for most of its operation, and
pinctrl_list_mutex for a little.

Equally, pinctrl_put needs to lock pinctrldev_list_mutex for most of
its operation since it'd be decreasing many struct pinctrl_dev.usecount
in general, or at least doing it many times on a single pctldev. It'd
need to lock pinctrl_list_mutex for at least a little.

All the GPIO functions also manipulate pctldev usecounts, so would need
to hold pinctrldev_list_mutex for the data-manipulation portions of their
run-time.

So, pinctrldev_list_mutex is almost a single global mutex anyway, except
there are a bunch of other mutexes hanging around making life complex.

It turns out that the only real parallelism is:

pinctrl_register_mappings: Only needs pinctrl_maps, but this is probably
the rarest operation and hardly needs to run parallel.

Every other list-manipulation operation needs to lock pinctrldev_list_mutex
for either the majority of the time, or over-and-over so may as well just
do it once.

pinctrl_enable/disable: The fast path. I think we can usefully have a
separate mutex per each of these as I mentioned in the email I'm quoting.

So it seems again that we really need a single slow-path mutex, and a
per-struct-pinctrl fast-path mutex.

-- 
nvpublic

