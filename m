Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755210Ab1A1Mk6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jan 2011 07:40:58 -0500
Received: from casper.infradead.org ([85.118.1.10]:37662 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750982Ab1A1Mk5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jan 2011 07:40:57 -0500
Subject: Re: [tip:sched/core] sched: Untangle cpu-load and timekeeping code
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Yong Zhang <yong.zhang0@gmail.com>
Cc: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, mingo@elte.hu, linux-tip-commits@vger.kernel.org
In-Reply-To: <AANLkTinM8oeCSxRfj=WQPc1-6W05O0XmvDK0Hde6zckL@mail.gmail.com>
References: <tip-18a57c3b43781ea83c3bb21c3add84ba890d5fb3@git.kernel.org>
	 <20110126122900.GA8387@zhy> <1296072183.15234.12.camel@laptop>
	 <AANLkTinM8oeCSxRfj=WQPc1-6W05O0XmvDK0Hde6zckL@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 28 Jan 2011 12:34:43 +0100
Message-ID: <1296214483.15234.313.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-01-27 at 14:55 +0800, Yong Zhang wrote:
> On Thu, Jan 27, 2011 at 4:03 AM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> >> We should not do this checking any more. In normal case,
> >> it will always return false.
> >> If it indeed returns true for some reason, we will lose the
> >> timer forever.
> >
> > Its needed for the nohz case, arguably we could move it inside
> > calc_global_nohz().
> 
> I have no idea why we need that checking in  calc_global_nohz().
> 
> Before this patch, time_before(jiffies, calc_load_update) is
> needed in calc_global_nohz() because it will reduce the ovehead
> on dealing with calc_load_fold_idle if we have idle dance in one
> LOAD_FREQ.
> 
> Now we have calc_global_load() called at every LOAD_FREQ
> instead of every tick, that problem is gone.

It was (the patch has been killed due to the nohz problem you pointed
out) because it could hit at an arbitrary long interval due to it being
a deferred timer.



  ----|---------|---------|-----
    ^                   ^   ^
    t0                  t1  t2

Suppose the cpu goes into nohz at t0, and wakes up at t{1,2}, spanning
{2,3} LOAD_FREQ boundaries, then the code in calc_global_nohz does:
n := (t{1,2}-t0)/LOAD_FREQ and finds 2, the check you refer to will make
the difference between t1 and t2 and will for t2 apply the 3rd period.

But you were right in pointing out that missing the mod_timer() call in
that case would have been disastrous.

Anyway, its all moot since the patch is gone now.


