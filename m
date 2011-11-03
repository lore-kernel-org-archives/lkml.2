Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755337Ab1KCIUU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Nov 2011 04:20:20 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:55901 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755043Ab1KCIUQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Nov 2011 04:20:16 -0400
Date: Thu, 3 Nov 2011 09:18:35 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Artem S. Tashkinov" <t.artem@lycos.com>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Mike Galbraith <efault@gmx.de>, Paul Turner <pjt@google.com>
Subject: Re: HT (Hyper Threading) aware process scheduling doesn't work as it
 should
Message-ID: <20111103081835.GA9330@elte.hu>
References: <269467866.49093.1320004632156.JavaMail.mail@webmail17>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <269467866.49093.1320004632156.JavaMail.mail@webmail17>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=AWL,BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
	0.0 AWL                    AWL: From: address is in the auto white-list
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



( Sorry about the delay in the reply - folks are returning from and 
  recovering from the Kernel Summit ;-) I've extended the Cc: list.
  Please Cc: scheduler folks when reporting bugs, next time around. )

* Artem S. Tashkinov <t.artem@lycos.com> wrote:

> Hello,
> 
> It's known that if you want to reach maximum performance on HT 
> enabled Intel CPUs you should distribute the load evenly between 
> physical cores, and when you have loaded all of them you should 
> then load the remaining virtual cores.
> 
> For example, if you have 4 physical cores and 8 virtual CPUs then 
> if you have just four tasks consuming 100% of CPU time you should 
> load four CPU pairs:
> 
> VCPUs: {1,2} - one task running
> 
> VCPUs: {3,4} - one task running
> 
> VCPUs: {5,6} - one task running
> 
> VCPUs: {7,8} - one task running
> 
> It's absolutely detrimental to performance to bind two tasks to 
> e.g. two physical cores {1,2} {3,4} and then the remaining two 
> tasks to e.g. the third core 5,6:
> 
> VCPUs: {1,2} - one task running
> 
> VCPUs: {3,4} - one task running
> 
> VCPUs: {5,6} - *two* task runnings
> 
> VCPUs: {7,8} - no tasks running
> 
> I've found out that even on Linux 3.0.8 the process scheduler 
> doesn't correctly distributes the load amongst virtual CPUs. E.g. 
> on a 4-core system (8 total virtual CPUs) the process scheduler 
> often run some instances of four different tasks on the same 
> physical CPU.
> 
> Maybe I shouldn't trust top/htop output on this matter but the same 
> test carried out on Microsoft XP OS shows that it indeed 
> distributes the load correctly, running tasks on different physical 
> cores whenever possible.
> 
> Any thoughts? comments? I think this is quite a serious problem.

If sched_mc is set to zero then this looks like a serious load 
balancing bug - you are perfectly right that we should balance 
between physical packages first and ending up with the kind of 
asymmetry you describe for any observable length is a bug.

You have not outlined your exact workload - do you run a simple CPU 
consuming loop with no sleeping done whatsoever, or something more 
complex?

Peter, Paul, Mike, any ideas?

Thanks,

	Ingo
