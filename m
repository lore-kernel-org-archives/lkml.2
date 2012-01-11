Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757185Ab2AKI2x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jan 2012 03:28:53 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:50708 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754282Ab2AKI2u convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jan 2012 03:28:50 -0500
MIME-Version: 1.0
X-Originating-IP: [212.179.42.66]
In-Reply-To: <1326265449_1658@mail4.comsite.net>
References: <1326040026-7285-1-git-send-email-gilad@benyossef.com>
	<1326265449_1658@mail4.comsite.net>
Date: Wed, 11 Jan 2012 10:28:49 +0200
Message-ID: <CAOtvUMf6v5iqdLaf6qocfso-HwEdJbHNt_SbY_7vWz6-1gA73g@mail.gmail.com>
Subject: Re: [PATCH v6 0/8] Reduce cross CPU IPI interference
From: Gilad Ben-Yossef <gilad@benyossef.com>
To: Milton Miller <miltonm@bga.com>
Cc: linux-kernel@vger.kernel.org, Christoph Lameter <cl@linux.com>,
        Chris Metcalf <cmetcalf@tilera.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Russell King <linux@arm.linux.org.uk>, linux-mm@kvack.org,
        Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        Rik van Riel <riel@redhat.com>, Andi Kleen <andi@firstfloor.org>,
        Sasha Levin <levinsasha928@gmail.com>, Mel Gorman <mel@csn.ul.ie>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, Avi Kivity <avi@redhat.com>,
        Michal Nazarewicz <mina86@mina86.org>,
        Kosaki Motohiro <kosaki.motohiro@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 11, 2012 at 9:04 AM, Milton Miller <miltonm@bga.com> wrote:
>
> Hi Gilad.   A few minor corrections for several of the patch logs, but some
> meater discussions on several of the patches.
>
> Overall I like the series and hope you see it through.


Hi Milton. Thanks so much for the detailed review.

As you've no doubt noticed, English is not my mother tongue (as opposed to
 C), so a special thank you for the patch logs review :-)


>
> <SNIP>



>
> > +void on_each_cpu_mask(const struct cpumask *mask, void (*func)(void *),
> > +                     void *info, bool wait)
> > +{
> > +     int cpu = get_cpu();
> > +
> > +     smp_call_function_many(mask, func, info, wait);
> > +     if (cpumask_test_cpu(cpu, mask)) {
> > +             local_irq_disable();
> > +             func(info);
> > +             local_irq_enable();
> > +     }
> > +     put_cpu();
> > +}
> > +EXPORT_SYMBOL(on_each_cpu_mask);
>
> It should be less code if we rewrite on_each_cpu as the one liner
> on_each_cpu_mask(cpu_online_mask).  I think the trade off of less
> code is worth the cost of the added test of cpu being in online_mask.
>
> That could be a seperate patch, but will be easier to read the result
> if on_each_cpu_mask is placed above on_each_cpu in this one.


Yes, it does look cleaner and I agree that the extra test is not a big
price to pay for simplee code.

However, to do that, on_each_cpu return value need to go away and
all caller needs to be adjusted. I figured this is out of scope for this
patch set.

I did send out a separate patch set to do the needed work  (see:
https://lkml.org/lkml/2012/1/8/48) and I suggest that after both of
them go in, I'll send a patch to do exactly what you suggested.

Thanks!
Gilad
--
Gilad Ben-Yossef
Chief Coffee Drinker
gilad@benyossef.com
Israel Cell: +972-52-8260388
US Cell: +1-973-8260388
http://benyossef.com

"Unfortunately, cache misses are an equal opportunity pain provider."
-- Mike Galbraith, LKML
