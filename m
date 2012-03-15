Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161146Ab2COREx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 13:04:53 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:44624 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030995Ab2COREu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 13:04:50 -0400
Date: Thu, 15 Mar 2012 10:04:34 -0700
From: Mandeep Singh Baines <msb@chromium.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Mandeep Singh Baines <msb@chromium.org>, Don Zickus <dzickus@redhat.com>,
        Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Michal Hocko <mhocko@suse.cz>
Subject: Re: [PATCH] watchdog: Make sure the watchdog thread gets CPU on
 loaded system
Message-ID: <20120315170434.GW27051@google.com>
References: <20120315014511.GT27051@google.com>
 <1331809239.18960.168.camel@twins>
 <1331809597.18960.171.camel@twins>
 <20120315124228.GA5318@elte.hu>
 <1331820051.18960.187.camel@twins>
 <20120315143549.GC3941@redhat.com>
 <20120315153907.GV27051@google.com>
 <1331827843.18960.197.camel@twins>
 <1331827890.18960.198.camel@twins>
 <1331828203.18960.200.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1331828203.18960.200.camel@twins>
X-Operating-System: Linux/2.6.38.8-gg683 (x86_64)
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra (peterz@infradead.org) wrote:
> On Thu, 2012-03-15 at 17:11 +0100, Peter Zijlstra wrote:
> > On Thu, 2012-03-15 at 17:10 +0100, Peter Zijlstra wrote:
> > > On Thu, 2012-03-15 at 08:39 -0700, Mandeep Singh Baines wrote:
> > > > Its a good tool for catching problems of scale. As we move to more and
> > > > more cores you'll uncover bugs where data structures start to blow up.
> > > > Hash tables get huge, when you have 100000s of processes or millions
> > > > of
> > > > TCP flows, or cgroups or namespace. That critical section (spinlock,
> > > > spinlock_bh, or preempt_disable) that used to be OK might no longer
> > > > be.
> > > 
> > > Or you run with the preempt latency tracer.
> > 
> > Or for that matter run cyclictest...
> 
> Thing is, if you want a latency detector, call it that and stop
> pretending its a useful debug feature. Also, if you want that, set the
> interval in the 0.1-0.5 seconds range and dump stack on every new max.
> 
> 

But preempt latency tracer is not negligible overhead while the softlockup
detector is. Softlockup is a great tool to use for detecting temporary
long duration lockups that can occur when data structures blow up.
Because of the overhead, you probably wouldn't enable preempt latency
tracking in production. If the problems is happening often enough, you
might temporarily turn it on for a few machines to get a stack trace. But
you might not have the luxury of being able to do that.

I can't predict what my users are going to do. They will do things I never
expected. So I can't test these cases in the lab, ruling out latency preempt
detector. With softlockup, I can find out about problems I never even
knew I had.

In addition, softlockup is also a great tool for find permanent lockups.

One idea for reducing preempt latency tracer overhead would use the same
approach that the HW counters use. Instead of examing every preempt
enable/disable, only examine 1 in a 1000 (some configurable numbers).
That way you could turn it on in production. Maybe a simple per_cpu
counter.

Regards,
Mandeep

