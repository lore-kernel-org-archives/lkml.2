Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422656Ab2JYC00 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 22:26:26 -0400
Received: from mail-ye0-f174.google.com ([209.85.213.174]:43180 "EHLO
	mail-ye0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758953Ab2JYC0Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 22:26:24 -0400
Date: Wed, 24 Oct 2012 19:23:21 -0700
From: Anton Vorontsov <anton.vorontsov@linaro.org>
To: Pekka Enberg <penberg@kernel.org>
Cc: Mel Gorman <mgorman@suse.de>,
        Leonid Moiseichuk <leonid.moiseichuk@nokia.com>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Minchan Kim <minchan@kernel.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        John Stultz <john.stultz@linaro.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        patches@linaro.org, kernel-team@android.com, linux-man@vger.kernel.org
Subject: Re: [RFC 1/2] vmevent: Implement pressure attribute
Message-ID: <20121025022321.GA8892@lizard>
References: <20121022111928.GA12396@lizard>
 <20121022112149.GA29325@lizard>
 <alpine.LFD.2.02.1210241159590.13035@tux.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.02.1210241159590.13035@tux.localdomain>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Pekka,

Thanks for taking a look into this!

On Wed, Oct 24, 2012 at 12:03:10PM +0300, Pekka Enberg wrote:
> On Mon, 22 Oct 2012, Anton Vorontsov wrote:
> > This patch introduces VMEVENT_ATTR_PRESSURE, the attribute reports Linux
> > virtual memory management pressure. There are three discrete levels:
> > 
> > VMEVENT_PRESSURE_LOW: Notifies that the system is reclaiming memory for
> > new allocations. Monitoring reclaiming activity might be useful for
> > maintaining overall system's cache level.
> > 
> > VMEVENT_PRESSURE_MED: The system is experiencing medium memory pressure,
> > there is some mild swapping activity. Upon this event applications may
> > decide to free any resources that can be easily reconstructed or re-read
> > from a disk.
> 
> Nit:
> 
> s/VMEVENT_PRESSURE_MED/VMEVENT_PRESSUDE_MEDIUM/

Sure thing, will change.

> Other than that, I'm OK with this. Mel and others, what are your thoughts 
> on this?
> 
> Anton, have you tested this with real world scenarios?

Yup, I was mostly testing it on a desktop. I.e. in a KVM instance I was
running a full fedora17 desktop w/ a lot of apps opened. The pressure
index was pretty good in the sense that it was indeed reflecting the
sluggishness in the system during swap activity. It's not ideal, i.e. the
index might drop slightly for some time, but we usually interested in
"above some value" threshold, so it should be fine.

The _LOW level is defined very strictly, and cannot be tuned anyhow. So
it's very solid, and that's what we mostly use for Android.

The _OOM level is also defined quite strict, so from the API point of
view, it's also solid, and should not be a problem.

Although the problem with _OOM is delivering the event in time (i.e. we
must be quick in predicting it, before OOMK triggers). Today the patch has
a shortcut for _OOM level: we send _OOM notification when reclaimer's
priority is below empirically found value '3' (we might make it tunable
via sysctl too, but that would expose another mm detail -- although sysctl
sounds not that bad as exposing something in the C API; we have plenty of
mm knobs in /proc/sys/vm/ already).

The real tunable is _MED level, and this should be tuned based on the
desired system's behaviour that I described in more detail in this long
post: http://lkml.org/lkml/2012/10/7/29.

Based on my observations, I wouldn't say that we have plenty of room to
tune the value, though. Usual swapping activity causes index to rise to
say to 30%, and when the system can't keep up, it raises to 50..90 (but we
still have plenty of swap space, so the system is far away from OOM,
although it is thrashing. Ideally I'd prefer to not have any sysctl, but I
believe _MED level is really based on user's definition of "medium".

> How does it stack up against Android's low memory killer, for example?

The LMK driver is effectively using what we call _LOW pressure
notifications here, so by definition it is enough to build a full
replacement for the in-kernel LMK using just the _LOW level. But in the
future, we might want to use _MED as well, e.g. kill unneeded services
based not on the cache level, but based on the pressure.

Thanks,
Anton.
