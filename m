Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753844Ab1HKXAm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 19:00:42 -0400
Received: from smtp-out.google.com ([74.125.121.67]:33821 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753056Ab1HKXAl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 19:00:41 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:sender:date:from:to:cc:subject:message-id:
	references:mime-version:content-type:content-disposition:in-reply-to:
	x-operating-system:user-agent:x-system-of-record;
	b=cbo7+1AVt5hPPtbqqB5m5aCxwgT1AFrU2EEhdamBxdyRn77REbQJtOGz+yfaokL+5
	sy7jqwNhhxsrn3PZLpYoQ==
Date: Thu, 11 Aug 2011 16:00:05 -0700
From: Mandeep Singh Baines <msb@chromium.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Alex Neronskiy <zakmagnus@chromium.org>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>, Don Zickus <dzickus@redhat.com>,
        Mandeep Singh Baines <msb@chromium.org>
Subject: Re: [PATCH v6 2/2] Output stall data in debugfs
Message-ID: <20110811230005.GC16327@google.com>
References: <1312999364-21104-1-git-send-email-zakmagnus@chromium.org>
 <1312999364-21104-2-git-send-email-zakmagnus@chromium.org>
 <1313091323.8491.30.camel@twins>
 <CAAuSN90BtbRaqkde0iKNQJvpa22AeKJLfyjO6NYqc3kdhqHXtg@mail.gmail.com>
 <1313094223.26866.15.camel@twins>
 <CAAuSN90CXXEdco_fNYrv-ZUZPr4nB4HYPM1NCgaSgGz+Z-jaRQ@mail.gmail.com>
 <1313097475.26866.18.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1313097475.26866.18.camel@twins>
X-Operating-System: Linux/2.6.32-gg508-generic (x86_64)
User-Agent: Mutt/1.5.20 (2009-06-14)
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

Peter Zijlstra (peterz@infradead.org) wrote:
> On Thu, 2011-08-11 at 13:31 -0700, Alex Neronskiy wrote:
> > 
> > > I mean, we're at the point where a PREEMPT=y kernel has a pretty decent
> > > latency and the PREEMPT_RT kernels live at ~30us. So wth are you
> > > measuring?

In an earlier patch in the series, Alex was looking into using the timer
for getting stack traces but using a different time source (TSC, jiffies) for
measuring the worst latency seen so far.

Since you know when the watchdog should have run, you can measure the
difference between when it did run and when it should have. This would allow
you to be able to measure latency down to the ms or lower.

> > Well, not all kernels have PREEMPT. Chromebook kernels don't, for example.
> 
> Can one infer from that statement that the purpose is trying to measure
> non preempt latency? ...
> 

Our "current" plan is to see if we can get away with PREEMPT_VOLUNTARY
and then fix any issues that we find by adding pre-emption points and
finer grain locking (to enable pre-emption points) where needed.
We were hoping to use this patch to find those issues.

Right now we have softlockup_thresh set to 10 seconds. But we have no idea
whether this is too high or not. Ideally, you'd want to set the threshold
as low as possible but no so low that you start panicking the system
on temporary stalls.

Let's say that worst stall that every happens on our system is < 1s and
any stall that is > 1s is really a lockup. With this patch, we could
say that with confidence and push the threshold down from 10 to 2.
The quicker we can detect a lockup, the better. We minimize downtown
and get the machine up in no time (our boot is only 8 seconds).

But I suspect that there are stalls. In Alex's first run with the patch,
he saw a few lockups which we are now investigating. They were mostly
in the suspend/resume and boot/shutdown paths. One I'm confident
is a bug and we'll send a patch upstream shortly.

> ... Why not use the tracer build for that purpose?
> 

PREEMPT_TRACER is awesome for the lab or development machines but
it adds too much overhead to use in production. Its add a pretty big
overhead every time you context switch. With PREEMPT, the overhead
would be even more.

We're not 100% sure we shouldn't use PREEMPT instead of PREEMPT_VOLUNTARY.
If we had the data from this patch, we might see that latency is too
high and we might have to consider PREEMPT instead.

> Still the watchdog ticks at 1s intervals or so, anything that takes that
> long, even on voluntary preemption kernels is quite insane.
> 
> 

The timer period is 1/5 the period of the threshold. The minimum threshold
is 1s. So if we set the threshold to 1s, we could get a stack trace
for a 200 ms stall. That would rock.

We would love to set the threshold to 1s and know that we aren't seeing any
stalls above 200ms. That would give us at least 800 ms of breathing room.
But right now, we have no idea how much breathing room there is.

Regards,
Mandeep
