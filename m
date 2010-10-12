Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932167Ab0JLK0v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Oct 2010 06:26:51 -0400
Received: from home.kolivas.org ([59.167.196.135]:41064 "EHLO home.kolivas.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756118Ab0JLK0u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Oct 2010 06:26:50 -0400
From: Con Kolivas <kernel@kolivas.org>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH try 5] CFS: Add hierarchical tree-based penalty.
Date: Tue, 12 Oct 2010 20:57:36 +1100
User-Agent: KMail/1.13.5 (Linux/2.6.36-rc7-ck1; KDE/4.4.5; x86_64; ; )
Cc: William Pitcock <nenolod@dereferenced.org>, linux-kernel@vger.kernel.org,
        peterz@infradead.org, efault@gmx.de
References: <20101012093044.GD20366@elte.hu> <8358526.1721286876359420.JavaMail.root@ifrit.dereferenced.org> <20101012094735.GH20366@elte.hu>
In-Reply-To: <20101012094735.GH20366@elte.hu>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201010122057.37272.kernel@kolivas.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 12 Oct 2010 20:47:35 Ingo Molnar wrote:
> * William Pitcock <nenolod@dereferenced.org> wrote:
> > Hi,
> > 
> > ----- "Ingo Molnar" <mingo@elte.hu> wrote:
> > > * William Pitcock <nenolod@dereferenced.org> wrote:
> > > > Inspired by the recent change to BFS by Con Kolivas, this patch
> > > 
> > > causes
> > > 
> > > > vruntime to be penalized based on parent depth from their root task
> > > > 
> > > > group.
> > > > 
> > > > I have, for the moment, decided to make it a default feature since
> > > 
> > > the
> > > 
> > > > design of CFS ensures that broken applications depending on task
> > > > enqueue behaviour behaving traditionally will continue to work.
> > > 
> > > Just curious, is this v5 submission a reply to Peter's earlier review
> > > of
> > > your v3 patch? If yes then please explicitly outline the changes you
> > > did
> > > so that Peter and others do not have to guess about the direction your
> > > 
> > > work is taking.
> > 
> > I just did that in the email I just sent.  Simply put, I was talking
> > with Con a few weeks ago about the concept of having a maximum amount
> > of service for all threads belonging to a process.  This did not work
> > out so well, so Con proposed penalizing based on fork depth, which
> > still allows us to maintain interactivity with make -j64 running in
> > the background.
> > 
> > Actually, I lie: it works great for server scenarios where you have
> > some sysadmin also running azureus.  Azureus gets penalized instead,
> > but other apps like audacious get penalized too.
> 
> Thanks for the explanation!
> 
> 	Ingo

It's a fun feature I've been playing with that was going to make it into the 
next -ck, albeit disabled by default. Here's what the patch changelog was 
going to say:

---
Make it possible to have interactivity and responsiveness at very high load
levels by having a hierarchical tree based penalty. This is achieved by
making deadlines offset by the fork depth from init. This has a similar effect
to 'nice'ing loads that are fork heavy (such as 'make'), and biases CPU and
latency towards threaded desktop applications.

When a new process is forked, its fork depth is inherited from its parent
across fork() and then is incremented by one. That fork_depth is then used
to cause a relative offset of its deadline. Threads keep the same fork_depth
as their parent process as these tend to belong to threaded desktop apps.

Using a dual core machine as an example, and running the "browser benchmark"
at http://service.futuremark.com/peacekeeper/index.action shows the effect
this patch has.

The benchmark runs a number of different browser based workloads, and gives
a score in points, where higher is better.

Running the benchmark under various different loads with the feature enabled/
disabled:

Load            Disabled        Enabled
None            2437            2437
make -j2        1642            2293
make -j24       208             2187
make -j42       failed          1626

As can be seen, on the dual core machine, a load of 2 makes the benchmark run
almost precisely 1/3 slower as would be expected with BFS' fair CPU
distribution of 3 processes between 2 CPUs. Enabling this feature makes this
benchmark progress almost unaffected at this load, and only once the load is
more than 20 times higher does it hinder the benchmark to the same degree.

Other side effects of this patch are that it weakly partitions CPU entitlement
to different users, and provides some protection against fork bombs.

Note that this drastically affects CPU distribution,  No assumption as to CPU
distribution should be made based on past behaviour. It can be difficult to
apportion a lot of CPU to a fork heavy workload with this enabled, and the
effects of 'nice' are compounded.

Unlike other approaches to improving latency under load of smaller timeslices,
enabling this feature has no detrimental effect on throughput under load.

This feature is disabled in this patch by default as it may lead to unexpected
changes in CPU distribution and there may be real world regressions.

There is a sysctl to enable/disable this feature in
/proc/sys/kernel/fork_depth_penalty


-- 
-ck
