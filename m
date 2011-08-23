Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755287Ab1HWQhA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 12:37:00 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:52836 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753287Ab1HWQgx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 12:36:53 -0400
Date: Tue, 23 Aug 2011 18:36:48 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Paul Menage <paul@paulmenage.org>
Cc: Avi Kivity <avi@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Anton Blanchard <anton@au1.ibm.com>, Ingo Molnar <mingo@elte.hu>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>,
        Paul Menage <menage@google.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tim Pepper <lnxninja@linux.vnet.ibm.com>
Subject: Re: [RFC PATCH 00/32] Nohz cpusets (was: Nohz Tasks)
Message-ID: <20110823163644.GA14903@somewhere.redhat.com>
References: <1313423549-27093-1-git-send-email-fweisbec@gmail.com>
 <4E4BEE1F.9060500@redhat.com>
 <20110818132531.GA10441@somewhere>
 <CALdu-PAd_sr=k1xDPgeFr4Cx2U2x+EZYUz4ykyrNUSCSOb2osQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CALdu-PAd_sr=k1xDPgeFr4Cx2U2x+EZYUz4ykyrNUSCSOb2osQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 20, 2011 at 12:45:48AM -0700, Paul Menage wrote:
> On Thu, Aug 18, 2011 at 6:25 AM, Frederic Weisbecker <fweisbec@gmail.com> wrote:
> >>
> >> Why not do it unconditionally?  That is, if all the conditions are
> >> fulfilled, disable the tick regardless of any cpuset settings.
> >
> > Because I'm not sure it's a win on every workload. This involves
> > some hooks here and there (syscall slow path), IPIs, etc...
> 
> I agree with Avi. I'd be inclined to investigate further to see if
> there are any important workloads on which it's not a win - and then
> add the extra complexity to control it from cpusets if necessary.
> Unless there's really a good reason to make it configurable, it's
> simpler to make it unconditional.

There is another things. We still need to have a CPU with the periodic
tick to maintain the jiffies and walltime progression.

Also on some workloads like HPC (I mean, that's just a personal guess),
it may make sense to also migrate the peripherals interrupts affinity
to that same CPU that keeps the periodic tick, so that we have only one
CPU handling those backrgound things and all the others can be fully
dedicated to their main task.

So with these factors combined, we need to be able to precisely choose at
least a CPU that doesn't run in adaptive nohz mode. Having that nohz cpuset
solves that issue (although I haven't forced to keep one non-nohz cpu but
I should).

Perhaps having a simple interface that defines a fixed CPU to handle
jiffies/walltime would be enough but the cpuset offers more flexibility.
I just can't test every possible workload to know if it has no downside
somewhere.

May be a global toggle in sysfs for a global adaptive nohz would be enough?
I have no idea.

Is anybody aware of any worload that involve very frequent syscalls? Like
more than 100 Hz ?
