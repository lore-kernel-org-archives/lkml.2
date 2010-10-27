Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761307Ab0J0N55 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 09:57:57 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:63444 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755354Ab0J0N5z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 09:57:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=b7TOeHaCRDHWksmsliDQYooVUQVnEsLPYIByJr7TwAvnQ0tNazIgTuKMEV62gG3W7i
         T+MzPJCJxmm0rIaAJCdes2VKHyJP0YA2dznQi+KHGWi8cnwwwCrG+6ashn8rth65U92G
         3DYuoiqrbGtl3hIbbQ5i8O9e7Cp3o0nxt4yHo=
Subject: Re: [PATCH] x86-32: Allocate irq stacks seperate from percpu area
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Brian Gerst <brgerst@gmail.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, mingo@elte.hu
In-Reply-To: <4CC82C2F.1020707@kernel.org>
References: <AANLkTinnc3vBSmewf7ixuOSDYxG+5VNiGaB-vSrDNRiO@mail.gmail.com>
	 <1288158182-1753-1-git-send-email-brgerst@gmail.com>
	 <1288159670.2652.181.camel@edumazet-laptop>
	 <1288173442.15336.1490.camel@twins>
	 <1288186405.2709.117.camel@edumazet-laptop>  <4CC82C2F.1020707@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 27 Oct 2010 15:57:50 +0200
Message-ID: <1288187870.2709.128.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mercredi 27 octobre 2010 à 15:42 +0200, Tejun Heo a écrit :
> Hello,
> 
> On 10/27/2010 03:33 PM, Eric Dumazet wrote:
> > Le mercredi 27 octobre 2010 à 11:57 +0200, Peter Zijlstra a écrit :
> >> On Wed, 2010-10-27 at 08:07 +0200, Eric Dumazet wrote:
> >>>> -     irqctx = &per_cpu(hardirq_stack, cpu);
> >>>> +     irqctx = (union irq_ctx *)__get_free_pages(THREAD_FLAGS, THREAD_ORDER);
> >>>
> >>> Hmm, then we lose NUMA affinity for stacks. 
> >>
> >> I guess we could use:
> >>
> >>   alloc_pages_node(cpu_to_node(cpu), THREAD_FLAGS, THREAD_ORDER);
> >>
> >>
> > 
> > Anyway, I just discovered per_cpu data on my machine (NUMA capable) all
> > sit on a single node, if 32bit kernel used.
> > 
> > # cat /proc/buddyinfo 
> > Node 0, zone      DMA      0      1      0      1      2      1      1      0      1      1      3 
> > Node 0, zone   Normal     94    251     81     16      3      2      1      2      1      2    187 
> > Node 0, zone  HighMem    113     88     47     36     18      5      4      3      2      0    268 
> > Node 1, zone  HighMem    154     97     43     16      9      4      3      2      3      2    482 
> ...
> > 
> > I presume node 1 having only HighMem could be the reason ?
> 
> What does cpu_to_node() on each cpu say?  Also, do you know why
> num_possible_cpus() is 32, not 16?
> 

I dont know, machine is HP ProLiant BL460c G6 
[    0.000000] SMP: Allowing 32 CPUs, 16 hotplug CPUs

for_each_possible_cpu(cpu) {
	pr_err("cpu=%d node=%d\n", cpu, cpu_to_node(cpu));
}

cpu=0 node=1
cpu=1 node=0
cpu=2 node=1
cpu=3 node=0
cpu=4 node=1
cpu=5 node=0
cpu=6 node=1
cpu=7 node=0
cpu=8 node=1
cpu=9 node=0
cpu=10 node=1
cpu=11 node=0
cpu=12 node=1
cpu=13 node=0
cpu=14 node=1
cpu=15 node=0
cpu=16 node=0
cpu=17 node=0
cpu=18 node=0
cpu=19 node=0
cpu=20 node=0
cpu=21 node=0
cpu=22 node=0
cpu=23 node=0
cpu=24 node=0
cpu=25 node=0
cpu=26 node=0
cpu=27 node=0
cpu=28 node=0
cpu=29 node=0
cpu=30 node=0
cpu=31 node=0




