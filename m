Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752111Ab2LALVg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Dec 2012 06:21:36 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:63761 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751592Ab2LALVa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Dec 2012 06:21:30 -0500
Date: Sat, 1 Dec 2012 03:18:11 -0800
From: Anton Vorontsov <anton.vorontsov@linaro.org>
To: Mel Gorman <mgorman@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
        Luiz Capitulino <lcapitulino@redhat.com>
Cc: David Rientjes <rientjes@google.com>, Pekka Enberg <penberg@kernel.org>,
        Glauber Costa <glommer@parallels.com>, Michal Hocko <mhocko@suse.cz>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Greg Thelen <gthelen@google.com>,
        Leonid Moiseichuk <leonid.moiseichuk@nokia.com>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Minchan Kim <minchan@kernel.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        John Stultz <john.stultz@linaro.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        patches@linaro.org, kernel-team@android.com, aquini@redhat.com,
        riel@redhat.com, Robert Love <rlove@google.com>,
        Colin Cross <ccross@android.com>,
        Arve =?utf-8?B?SGrDuG5uZXbDpWc=?= <arve@android.com>
Subject: Re: [RFC] Add mempressure cgroup
Message-ID: <20121201111810.GA11714@lizard>
References: <20121128102908.GA15415@lizard>
 <20121128151432.3e29d830.akpm@linux-foundation.org>
 <20121129012751.GA20525@lizard>
 <20121130154725.0a81913c@doriath.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20121130154725.0a81913c@doriath.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 30, 2012 at 03:47:25PM -0200, Luiz Capitulino wrote:
[...]
> > Query-and-control scheme looks very attractive, and that's actually
> > resembles my "balance" level idea, when userland tells the kernel how much
> > reclaimable memory it has. Except the your scheme works in the reverse
> > direction, i.e. the kernel becomes in charge.
> > 
> > But there is one, rather major issue: we're crossing kernel-userspace
> > boundary. And with the scheme we'll have to cross the boundary four times:
> > query / reply-available / control / reply-shrunk / (and repeat if
> > necessary, every SHRINK_BATCH pages). Plus, it has to be done somewhat
> > synchronously (all the four stages), and/or we have to make a "userspace
> > shrinker" thread working in parallel with the normal shrinker, and here,
> > I'm afraid, we'll see more strange interactions. :)
[...]
> Andrew's idea seems to give a lot more freedom to apps, IMHO.

OK, thinking about it some more...

===
=== Long explanations below, scroll to 'END' for the short version. :)
===

The typical query-control shrinker interaction would look like this:

   Kernel: "Can you please free <Y> pages?"
 Userland: "Here you go, <Z> pages freed."

Now let's assume that we are the Activity Manager, so we know that we have
<N> reclaimable pages in total (it's not always possible to know, but
let's pretend we do know). And assume that we are the only source of
reclaimable pages (this is important). OK, the kernel asks us to reclaim
<Y> pages.

Now, what if we divide <Y> (needed pages) by <N> (total reclaimable
pages)? :)

This will be the memory pressure factor, what a coincidence. E.g. if Y >=
N, the factor would be >= 1, which was our definition of OOM. If no pages
needed, the factor is 0.

Okay, let's see how our current vmpressure notification works inside:

- The notification comes every 'window size' (<W>) pages scanned;

- Alongside with the notification itself we can also receive the pressure
  factor <F> (it is 1 - reclaimed/scanned). (We use levels nowadays, but
  internally it is still the factor.)

So, by doing <W> * <F> we can find out the amount of memory that the
kernel was missing this round (scanned - reclaimed), which pretty much the
same meaning as "Please free <Y> pages" in the "userland-shrinker" scheme
above.

Except that in the notifications case the "<Y>" was is in the past
already, so we should read "the kernel had difficulty with reclaiming <Y>
pages", and userland just received the notification about this past event.
The <Y> pages were probably reclaimed already.

Now, can we assume that in the next second, the system will need the same
<Y> pages reclaimed? Well, if the window size was small enough, it's OK to
assume that the workload didn't change much. So, yes, we can assume this,
the only "bad" thing that can happen, we can free a little bit more than
it was needed.

Let's look how we'd use the raw factor in the imaginary userland shrinker:

	while (1) {
		/* blocking, triggers every "window size" pages, <W> */
		factor = get_pressure();

		/* Finds the smallest chunk(s) w/ size >= <W> * <F> */
		resource = get_resource(factor);

		free(resource);
	}

So, in the each round we'd free at least <W> * <F> pages. Again, the
product just tells how much memory it is best to free at this time, which
by definition is 'scanned - reclaimed' (<F> = 1 - reclaimed/scanned; <W> =
scanned). That is, we don't need the factor, we need the scanned and
reclaimed difference.

In sum:

- Reporting the 'scanned - reclaimed' seems like an option for
  implementing the userland shrinker;

- B using small 'window size' we can mitigate effect of async nature of
  our shrinker.

Although, the shrinker is not a substitution to the pressure factor (or
levels). The plain "I need <Y> pages" still does not tell how bad things
there are in the system, how much scanning there are. So, the
reclaimed/scanned ratio is important, too.

===
=== END
===

The lengthy text above boils down to this:

Yes, I tend to agree that Andrew's idea gives some freedom to the apps,
and that with the three levels it is not possible to implement a good,
predictable "userland shrinker". Even though we don't need it just now.

Based on the above, I think I have a solution for this. For the next RFC,
I'd like to keep the pressure levels, but I will also add a file that will
report 'scanned - reclaimed' difference. I'll call it something like
nr_to_reclaim. Since the 'scanned - reclaimed' is still an approximation
(although I believe a good one), we may want to tune it without breaking
things.

And with the nr_to_reclaim, implementing a predictable userland shrinker
will be a piece of cake: apps will blindly free the given amount of pages,
nothing more.

Thanks,
Anton.
