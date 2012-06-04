Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760675Ab2FDNhQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 09:37:16 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:49997 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760652Ab2FDNhJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 09:37:09 -0400
Date: Mon, 4 Jun 2012 06:35:28 -0700
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Minchan Kim <minchan@kernel.org>
Cc: Pekka Enberg <penberg@kernel.org>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Leonid Moiseichuk <leonid.moiseichuk@nokia.com>,
        John Stultz <john.stultz@linaro.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        patches@linaro.org, kernel-team@android.com
Subject: Re: [PATCH 0/5] Some vmevent fixes...
Message-ID: <20120604133527.GA13650@lizard>
References: <CAOJsxLHQcDZSHJZg+zbptqmT9YY0VTkPd+gG_zgMzs+HaV_cyA@mail.gmail.com>
 <CAHGf_=q1nbu=3cnfJ4qXwmngMPB-539kg-DFN2FJGig8+dRaNw@mail.gmail.com>
 <CAOJsxLFAavdDbiLnYRwe+QiuEHSD62+Sz6LJTk+c3J9gnLVQ_w@mail.gmail.com>
 <CAHGf_=pSLfAue6AR5gi5RQ7xvgTxpZckA=Ja1fO1AkoO1o_DeA@mail.gmail.com>
 <CAOJsxLG1+zhOKgi2Rg1eSoXSCU8QGvHVED_EefOOLP-6JbMDkg@mail.gmail.com>
 <20120601122118.GA6128@lizard>
 <alpine.LFD.2.02.1206032125320.1943@tux.localdomain>
 <4FCC7592.9030403@kernel.org>
 <20120604113811.GA4291@lizard>
 <20120604121722.GA2768@barrios>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20120604121722.GA2768@barrios>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 04, 2012 at 09:17:22PM +0900, Minchan Kim wrote:
[...]
> But keep in mind about killing. killer should be a kernel, not user.
> https://lkml.org/lkml/2011/12/19/330

There you're discussing out-of-memory condition vs. low memory
situation, and I don't see LMK as a substitution for the OOMK,
or vice versa.

LMK triggers when we have plenty of free memory (and thus time);
and OOMK is a last resort thing: it is super-fast, as the kernel
may have literally nothing to do but start killing tasks.

Sure, if LMK won't react fast and low-memory turns into "out
of memory", then OOMK will "help", which is totally fine. And
it is no different from current in-kernel Android low memory
killer (which gives no guarantees that OOMK will not trigger,
it is still possible to make OOM condition, even with LMK
enabled).

Anyway, personally I don't mind if LMK would live in the kernel,
but I don't see it as a mandatory thing (unlike OOMK, which is
kernel-only thing, of course).

> > > Frankly speaking, I don't know vmevent's other use cases except low memory notification 
> > 
> > I won't speak for realistic use-cases, but that is what comes to
> > mind:
> > 
> > - DB can grow its caches/in-memory indexes infinitely, and start dropping
> >   them on demand (based on internal LRU list, for example). No more
> >   guessed/static configuration for DB daemons?
> > - Assuming VPS hosting w/ dynamic resources management, notifications
> >   would be useful to readjust resources?
> > - On desktops, apps can drop their caches on demand if they want to
> >   and can avoid swap activity?
> 
> I don't mean VMEVENT_ATTR_LOWMEM_PAGES but following as,
> 
> VMEVENT_ATTR_NR_FREE_PAGES
> VMEVENT_ATTR_NR_SWAP_PAGES
> VMEVENT_ATTR_NR_AVAIL_PAGES
> 
> I'm not sure how it is useful.

Yep, these raw values are mostly useless, and personally I don't use
these plain attributes. I use heuristics, i.e. "blended" attributes.
If we can come up with levels-based approach w/o using vmstat, well..
OK then.

But note that we actually want to know how much "free", "cheap to
reclaim" and "can reclaim, but at cost" pages there are. It should
not be just "ouch, we're out of cheap pages" signal, since the whole
point of Android low memory killer is to act in advance, its idea
is to try to free memory before the condition happens, and thus make
the phone UI more smooth. And the threshold is actually load/HW
specific, so I guess folks want to tune it (e.g. "trigger when
there are XX MB of 'cheap to reclaim' pages left").

Thanks,

-- 
Anton Vorontsov
Email: cbouatmailru@gmail.com
