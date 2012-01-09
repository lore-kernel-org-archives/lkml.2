Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755419Ab2AIEIz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jan 2012 23:08:55 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:41632 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755366Ab2AIEIy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jan 2012 23:08:54 -0500
Date: Sun, 8 Jan 2012 20:08:02 -0800
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: NeilBrown <neilb@suse.de>
Cc: MyungJoo Ham <myungjoo.ham@samsung.com>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Mike Lockwood <lockwood@android.com>,
        Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Donggeun Kim <dg77.kim@samsung.com>, Greg KH <gregkh@suse.de>,
        Arnd Bergmann <arnd@arndb.de>, MyungJoo Ham <myungjoo.ham@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Morten CHRISTIANSEN <morten.christiansen@stericsson.com>,
        Grant Likely <grant.likely@secretlab.ca>, Liam Girdwood <lrg@ti.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC/PATCH] Multithread initcalls to auto-resolve ordering
 issues.
Message-ID: <20120109040802.GG29065@opensource.wolfsonmicro.com>
References: <20120109112113.07882ed9@notabene.brown>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120109112113.07882ed9@notabene.brown>
X-Cookie: You will get what you deserve.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 09, 2012 at 11:21:13AM +1100, NeilBrown wrote:

>   The solution I am proposing is to:
>    1/ allow the 'request' functions which find and provide a resource to block
>       until the resource is available
>    2/ run the init calls in multiple threads so that when one blocks waiting
>       for a resource, another starts up to run subsequent initcalls until
>       the blocking call gets its resource and can complete.

It seems like the end result of this is very similar to the idea of
retrying.  What are the advantages and disadvantages of the two
approaches?  My first thought is that retrying is going to give more
consistent results between boots but is probably going to take more work
(depending on how much context switches end up costing).

Looking at what you've done to the regulators code wise this all looks
rather more complicated than I'm entirely happy with - I'm having to
think far too much about locking and concurrency - and this work is
going to need to be duplicated in every subsystem that is affected.  I
think if we're going to do this we'd need some common infrastructure to
manage the actual waiting and waking to simplify implementation.

It also seems like there's no control given to drivers, everything is
done in the frameworks.  This means that drivers can't take decisions
about what to do which seems like something that ought to be possible.

I'd like to see some way of enumerating what's waiting for what to help
people figure out what's going wrong when things fail.

>      In this sample code I have added a call
>           regulator_has_full_constraints_listed()
>      which not only assures that all constraints are known, but list
>      them (array of pointers to regulator_init_data) so when a supply is
>      requested the regulator code can see if it expected.

This seems pretty restrictive to be honest.  It isn't going to work if
we don't know which regulators are in the system before we start
enumerating which isn't going to be possible when dealing with modular
systems that we can enumerate at runtime.  It seems like we're taking
most of the cost of fully ordering everything in data but still doing
some things dynamically here.

It also seems inelegant in that we're having to pass all the constraints
both via this and via the normal probe mechanism.  If we were going to
do this we'd be better off changing the way that regulators find their
constraints so they aren't passed in through the driver as it probes.

> +static void regulator_wake_waiters(const char *devname, const char *id,
> +	const char *reg)

I've no idea what "const char *reg" is...

> +{
> +	struct regulator_waiter *map;
> +
> +	list_for_each_entry(map, &waiters, list) {
> +		if (map->reg) {
> +			if (!reg)
> +				continue;
> +			if (strcmp(map->reg, reg) == 0)
> +				wake_up(&map->queue);
> +			continue;
> +		}
> +		if (reg)
> +			continue;

...as a result I don't really know what this is intended to do.  It does
seem like this and the second half of the function are two separate
functions that have been joined together.

> +	if (regulator_supply_expected(devname, id)) {
> +		/* wait for it to appear */
> +		struct regulator_waiter w;
> +		int status = 0;
> +		DEFINE_WAIT(wait);
> +		init_waitqueue_head(&w.queue);

I rather suspect this is going be able to deadlock if a PMIC supplies
itself (which is not unknown - use a high efficiency convertor to drop
down the system supply to a lower voltage and then lower efficiency
convertors to give a series of lower voltages, giving greater overall
efficiency).  If the PMIC registers things in the wrong order then it'll
never get as far as trying to register the parent regulator as the child
regulator will block.  We'd need to create a thread per regulator being
registered.  A similar issue applies with the retry based approach of
course.

> +		if (!found && regulator_expected(init_data->supply_regulator)) {
> +			struct regulator_waiter w;
> +			int status = 0;
> +			DEFINE_WAIT(wait);
> +			init_waitqueue_head(&w.queue);

Seems like there's some code needs to be shared.

> +static int regulator_expected(const char *reg)
> +{
> +	int i;
> +
> +	if (!init_data_list)
> +		return 0;

It looks like these tests for init_data_list are the wrong way around,
if we don't know if we can fail then surely we always have to block on
the off chance that the resource will appear?

> +	for (i = 0; init_data_list[i]; i++) {
> +		struct regulator_init_data *d = init_data_list[i];
> +		if (d->constraints.name &&
> +		    strcmp(d->constraints.name, reg) == 0)
> +			return 1;

This is really bad, the names in the constraints are optional and we
should never rely on having them.  Note that we never look directly at
the name in the bulk of the code.
