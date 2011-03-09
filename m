Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932462Ab1CINyN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 08:54:13 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:53281 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932208Ab1CINyJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 08:54:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=QiOCD7kjLBi8p+M/aLWpuRMCOfitIkZng6gvP5/Oi/MGaoYuWP2ZlyYYDvhccX3wZx
         Ry9Sbv+Qf1K/Wbn2Iyb9teYIAnOC9Ro9uEe4y+Ru+ymEJlOo8Us36EyG945HPMVVbrlw
         yoDWF7S8vAYXYHO2+XleHV+X6BGP3kKhdGmoo=
Date: Wed, 9 Mar 2011 14:52:55 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        LKML <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 1/2] perf: Fix the software events state check
Message-ID: <20110309135252.GB1730@nowhere>
References: <1299529629-18280-1-git-send-email-fweisbec@gmail.com>
 <20110309092818.GC25004@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110309092818.GC25004@elte.hu>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 09, 2011 at 10:28:18AM +0100, Ingo Molnar wrote:
> 
> * Frederic Weisbecker <fweisbec@gmail.com> wrote:
> 
> > Fix the mistakenly inverted check of events state.
> > 
> > Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> > Cc: Ingo Molnar <mingo@elte.hu>
> > Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> > Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
> > Cc: Paul Mackerras <paulus@samba.org>
> > Cc: Stephane Eranian <eranian@google.com>
> > ---
> >  kernel/perf_event.c |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> > 
> > diff --git a/kernel/perf_event.c b/kernel/perf_event.c
> > index ed253aa..974e2e6 100644
> > --- a/kernel/perf_event.c
> > +++ b/kernel/perf_event.c
> > @@ -5122,7 +5122,7 @@ static int perf_exclude_event(struct perf_event *event,
> >  			      struct pt_regs *regs)
> >  {
> >  	if (event->hw.state & PERF_HES_STOPPED)
> > -		return 0;
> > +		return 1;
> 
> Just wondering, what was/is the practical effect of this bug, and how far back does 
> it go (any need for a -stable tag)?

I wasn't sure about that so I haven't told about the impact in the
changelog.

But now that I put a deeper look into this:

It seems that ->stop() / ->start() are called from perf_adjust_period()
to update the hardware with the new settings of period_left. The events
are stopped to avoid any race with events triggering with a stale period_left
in the hardware level when the software one has been updated, I guess.

So it doesn't seem to fix any existing bug because for ->stop() and ->start()
are only useful for hardware events right now. But we may call ->stop() and
->start() for further purpose later. In fact that paves the way for the event
exclusion patchset I'm about to post.

So it should be .39 material. But a confirmation from Peter would be nice.
