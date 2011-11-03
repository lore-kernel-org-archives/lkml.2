Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755081Ab1KCKbg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Nov 2011 06:31:36 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:34836 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752652Ab1KCKbd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Nov 2011 06:31:33 -0400
Date: Thu, 3 Nov 2011 11:29:51 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Artem S. Tashkinov" <t.artem@lycos.com>
Cc: linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, efault@gmx.de,
        pjt@google.com
Subject: Re: Re: HT (Hyper Threading) aware process scheduling doesn't work
 as it should
Message-ID: <20111103102951.GA11503@elte.hu>
References: <269467866.49093.1320004632156.JavaMail.mail@webmail17>
 <20111103081835.GA9330@elte.hu>
 <1758553229.334475.1320313445172.JavaMail.mail@webmail11>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1758553229.334475.1320313445172.JavaMail.mail@webmail11>
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


* Artem S. Tashkinov <t.artem@lycos.com> wrote:

> > On Nov 3, 2011, Ingo Molnar wrote: 
> > 
> > If sched_mc is set to zero then this looks like a serious load 
> > balancing bug - you are perfectly right that we should balance 
> > between physical packages first and ending up with the kind of 
> > asymmetry you describe for any observable length is a bug.
> > 
> > You have not outlined your exact workload - do you run a simple CPU 
> > consuming loop with no sleeping done whatsoever, or something more 
> > complex?
> > 
> > Peter, Paul, Mike, any ideas?
> 
> Actually I am just running 4 copies of bzip2 compressor (< 
> /dev/zero > /dev/null).
> 
> A person named ffab ffa said ( http://lkml.org/lkml/2011/11/1/11 ) 
> that I probably misunderstand/misinterpret physical cores. He says 
> that cores thread siblings on e.g., Intel Core 2600K are 0-4, 1-5, 
> 2-6 and 3-7
> 
> and when I am running this test I have the following VCPUs distribution:
> 
> 1, 6, 7, 8 (0-4, 1-5, 2-6, 7-8 - all four physical cores loaded)
> 1, 2, 7, 8 (0-4, 1-5, 2-6, 7-8 - all four physical cores loaded)
> 
> According to the cores thread siblings distribution the HT aware 
> process scheduler indeed works correctly.

Ok, good - and that correct behavior is what we are seeing elsewhere 
as well so your bugreport was somewhat puzzling.

> However sometimes I see this picture:
> 
> 3, 4, 5, 6 (2-6, 1-5, 2-6, 7-8 - three physical cores loaded)

It's hard to tell how normal this is without better tooling and 
better data capture. Especially when visualization runs its normal 
for tasks to reshuffle a bit: Xorg and the visualization task is 
running as well and are treated preferentially to any CPU hogs - but 
once only the CPU-intense tasks are running they'll rebalance 
correctly.

That having said it's always a possibility that there's a balancing 
bug.

One way you could decide it is to measure actual CPU-intense task 
performance versus pinning them to the 'right' cores via taskset. If 
the 'pinned' variant measurably outperforms for 'free running' 
version then there's a balancing problem.

(Of course tracing it and checking how well we schedule is the most 
powerful tool.)

> So, now the question is whether VCPUs quite an illogical 
> enumeration is good for power users as I highly doubt that 0-4, 
> 1-5, 2-6 and 3-7 order can be easily remembered and grasped. 
> Besides neither top, not htop are HT aware so just by looking at 
> their output it gets very difficult to see and understand if the 
> process scheduler works as it should.

That enumeration order likely just comes from the BIOS and there's 
little the scheduler can do about it. We could try to re-shape the 
topology if the BIOS messes up but that's probably quite fragile to 
do.

Thanks,

	Ingo
