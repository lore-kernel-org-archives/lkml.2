Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755631Ab1LAXrT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 18:47:19 -0500
Received: from mail.openrapids.net ([64.15.138.104]:47853 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755420Ab1LAXrS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 18:47:18 -0500
Date: Thu, 1 Dec 2011 18:47:15 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Greg KH <greg@kroah.com>
Cc: Peter Zijlstra <peterz@infradead.org>, devel@driverdev.osuosl.org,
        lttng-dev@lists.lttng.org, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org, Darren Hart <darren@dvhart.com>
Subject: Re: [PATCH 09/11] sched: export task_prio to GPL modules
Message-ID: <20111201234715.GA12909@Krystal>
References: <1322775683-8741-1-git-send-email-mathieu.desnoyers@efficios.com> <1322775683-8741-10-git-send-email-mathieu.desnoyers@efficios.com> <1322776568.4699.52.camel@twins> <20111201220445.GA10552@Krystal> <1322777407.4699.59.camel@twins> <20111201221500.GC10552@Krystal> <1322780797.4699.61.camel@twins> <20111201231831.GB4961@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111201231831.GB4961@kroah.com>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 18:24:34 up 373 days,  4:27,  6 users,  load average: 0.00, 0.04,
	0.07
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Greg KH (greg@kroah.com) wrote:
> On Fri, Dec 02, 2011 at 12:06:37AM +0100, Peter Zijlstra wrote:
> > On Thu, 2011-12-01 at 17:15 -0500, Mathieu Desnoyers wrote:
> > > 
> > > If you don't want to trace sched_switch, but just conveniently prepend
> > > this information to all your events 
> > 
> > Oh so you want to debug a scheduler issue but don't want to use the
> > scheduler tracepoint, I guess that makes perfect sense for clueless
> > people.
> 
> Matheiu, can't lttng use the scheduler tracepoint for this information?

LTTng allows user to choose between both methods, each one being suited
to a particular use of the tracer:

A) Extraction through the scheduler tracepoint:

   LTTng viewers have a full-fledged current state reconstruction of the
   traced OS (for any point in time during the trace) performed as one
   of the bottom layers of our trace analysis tools. This makes sense
   for use-cases where the data needs to be transported, and/or stored,
   and where the amount of data throughput needs to be minimized. We use
   this technique a lot, of course. This state-tracking requires
   CPU/memory resource usage by the viewer.

B) Extraction through "optional" event context information:

   We have, in development, a new "enhanced top" called lttngtop that
   uses tracing information, directly read from mmap'd buffers, to
   provide second-by-second profile information of the system. It is
   not as sensitive to data compactness as the transport/disk storage
   use-case, mainly because no data copy is ever required -- the buffers
   simply get overwritten after lttngtop has finished aggregating the
   information. This has less performance overhead that the big hammer
   "top" that periodically reads all files in /proc, and can provide
   much more detailed profiles.

   This use-case favors sending additional data from kernel to
   user-space rather than recomputing the OS state within lttngtop, due
   to the very low overhead of direct mmap data transport, over
   recomputing state needlessly.

We could very well "cheat" and use a scheduler tracepoint to keep a
duplicate of the current priority value for each CPU within the tracer
kernel module. Let me know if you want me to do this.

Also, as a matter of fact, the "prio" information exported from the
sched_switch event in mainline trace events does not match the prio
shown in /proc stat files. The "MAX_RT_PRIO" offset is missing.

Thanks,

Mathieu


-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
