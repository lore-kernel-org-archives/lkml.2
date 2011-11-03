Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933497Ab1KCNBG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Nov 2011 09:01:06 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:58653 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S933143Ab1KCNBE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Nov 2011 09:01:04 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX19EIgVCkOdEglDA5MmDoo5QIxpCMPjy+90nvHqzoO
	5JbrmHpooIhFFm
Subject: Re: HT (Hyper Threading) aware process scheduling doesn't work as
 it should
From: Mike Galbraith <efault@gmx.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: "Artem S. Tashkinov" <t.artem@lycos.com>, linux-kernel@vger.kernel.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Turner <pjt@google.com>
In-Reply-To: <20111103081835.GA9330@elte.hu>
References: <269467866.49093.1320004632156.JavaMail.mail@webmail17>
	 <20111103081835.GA9330@elte.hu>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 03 Nov 2011 14:00:59 +0100
Message-ID: <1320325259.11622.94.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-11-03 at 09:18 +0100, Ingo Molnar wrote:
> 
> ( Sorry about the delay in the reply - folks are returning from and 
>   recovering from the Kernel Summit ;-) I've extended the Cc: list.
>   Please Cc: scheduler folks when reporting bugs, next time around. )
> 
> * Artem S. Tashkinov <t.artem@lycos.com> wrote:
> 
> > Hello,
> > 
> > It's known that if you want to reach maximum performance on HT 
> > enabled Intel CPUs you should distribute the load evenly between 
> > physical cores, and when you have loaded all of them you should 
> > then load the remaining virtual cores.
> > 
> > For example, if you have 4 physical cores and 8 virtual CPUs then 
> > if you have just four tasks consuming 100% of CPU time you should 
> > load four CPU pairs:
> > 
> > VCPUs: {1,2} - one task running
> > 
> > VCPUs: {3,4} - one task running
> > 
> > VCPUs: {5,6} - one task running
> > 
> > VCPUs: {7,8} - one task running
> > 
> > It's absolutely detrimental to performance to bind two tasks to 
> > e.g. two physical cores {1,2} {3,4} and then the remaining two 
> > tasks to e.g. the third core 5,6:
> > 
> > VCPUs: {1,2} - one task running
> > 
> > VCPUs: {3,4} - one task running
> > 
> > VCPUs: {5,6} - *two* task runnings
> > 
> > VCPUs: {7,8} - no tasks running
> > 
> > I've found out that even on Linux 3.0.8 the process scheduler 
> > doesn't correctly distributes the load amongst virtual CPUs. E.g. 
> > on a 4-core system (8 total virtual CPUs) the process scheduler 
> > often run some instances of four different tasks on the same 
> > physical CPU.
> > 
> > Maybe I shouldn't trust top/htop output on this matter but the same 
> > test carried out on Microsoft XP OS shows that it indeed 
> > distributes the load correctly, running tasks on different physical 
> > cores whenever possible.
> > 
> > Any thoughts? comments? I think this is quite a serious problem.
> 
> If sched_mc is set to zero then this looks like a serious load 
> balancing bug - you are perfectly right that we should balance 
> between physical packages first and ending up with the kind of 
> asymmetry you describe for any observable length is a bug.
> 
> You have not outlined your exact workload - do you run a simple CPU 
> consuming loop with no sleeping done whatsoever, or something more 
> complex?
> 
> Peter, Paul, Mike, any ideas?

SD_SHARE_PKG_RESOURCES is on in the SIBLING domain, so in the sync hint
wakeup case (given no other tasks running to muddy the water), the hint
allows us to do an affine wakeup, which allows select_idle_sibling() to
convert the CPU affine wakeup into a cache affine wakeup, waker will be
on one CPU, wakee on it's sibling.  Turning SD_SHARE_PKG_RESOURCES off
results in sync wakeup pairs landing CPU affine instead.

!sync wakeups spread to separate cores unless threads exceeds cores.

I just tested massive_intr (!sync) and tbench pairs (sync) on E5620 box,
and that's what I see happening.

sync wakee landing on a idle sibling is neither black nor white... more
of a London fog + L.A. smog.

	-Mike

