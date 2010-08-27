Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752934Ab0H0MoJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 08:44:09 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:36215 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751450Ab0H0MoG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 08:44:06 -0400
Date: Fri, 27 Aug 2010 13:44:05 +0100
From: Matt Fleming <matt@console-pimps.org>
To: Will Deacon <will.deacon@arm.com>
Cc: linux-kernel@vger.kernel.org, Robert Richter <robert.richter@amd.com>,
        Paul Mundt <lethal@linux-sh.org>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-sh@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>, linux-arch@vger.kernel.org
Subject: Re: [PATCH V2 3/4] oprofile: Abstract the perf-events backend
Message-ID: <20100827124405.GA23598@console-pimps.org>
References: <cover.1282848651.git.matt@console-pimps.org> <fe3e173aaa85f4cd73ea4b5abca50976fc40a01f.1282848651.git.matt@console-pimps.org> <1282905691.16770.20.camel@e102144-lin.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1282905691.16770.20.camel@e102144-lin.cambridge.arm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 27, 2010 at 11:41:31AM +0100, Will Deacon wrote:
> Hi Matt,
> 
> I'm still not happy with the init/exit alloc/free code:
> 
> On Thu, 2010-08-26 at 20:09 +0100, Matt Fleming wrote:
> 
> [...]
> 
> > +int oprofile_perf_init(void)
> > +{
> > +       u32 counter_size = sizeof(struct op_counter_config);
> > +       int cpu;
> > +
> > +       counter_config = kcalloc(perf_num_counters, counter_size, GFP_KERNEL);
> > +
> > +       if (!counter_config) {
> > +               pr_info("oprofile: failed to allocate %d "
> > +                               "counters\n", perf_num_counters);
> > +               return -ENOMEM;
> > +       }
> > +
> > +       for_each_possible_cpu(cpu) {
> > +               perf_events[cpu] = kcalloc(perf_num_counters,
> > +                               sizeof(struct perf_event *), GFP_KERNEL);
> > +               if (!perf_events[cpu]) {
> > +                       pr_info("oprofile: failed to allocate %d perf events "
> > +                                       "for cpu %d\n", perf_num_counters, cpu);
> > +                       while (--cpu >= 0)
> > +                               kfree(perf_events[cpu]);
> > +                       kfree(counter_config);
> > +                       return -ENOMEM;
> > +               }
> > +       }
> > +
> > +       return 0;
> > +}
> 
> So here, if the perf_events allocation fails for a cpu, we free the
> stuff we've already allocated [including counter_config] and return
> -ENOMEM. Looking at drivers/oprofile/oprof.c:
> 
> static int __init oprofile_init(void)
> {
> 	int err;
> 
> 	err = oprofile_arch_init(&oprofile_ops);
> 	if (err < 0 || timer) {
> 		printk(KERN_INFO "oprofile: using timer interrupt.\n");
> 		err = oprofile_timer_init(&oprofile_ops);
> 		if (err)
> 			goto out_arch;
> 	}
> 	err = oprofilefs_register();
> 	if (err)
> 		goto out_arch;
> 	return 0;
> 
> out_arch:
> 	oprofile_arch_exit();
> 	return err;
> }
> 
> So now, if timer_init fails or oprofilefs_register fails, we will
> call oprofile_arch_exit, which calls oprofile_perf_exit:
> 
> > +void oprofile_perf_exit(void)
> > +{
> > +       int id, cpu;
> > +
> > +       for_each_possible_cpu(cpu) {
> > +               for (id = 0; id < perf_num_counters; ++id)
> > +                       oprofile_destroy_counter(cpu, id);
> > +
> > +               kfree(perf_events[cpu]);
> > +       }
> > +
> > +       kfree(counter_config);
> > +}
> 
> meaning that we will free everything again! This is what I
> was trying to avoid in patch 1/4, by moving the counter_config
> freeing into the *_exit function. Looking at it again, I think
> all the freeing should be moved to the *_exit function and the init
> function should just return error when allocation fails. What do you
> think?

*facepalm*

I dunno how I forgot to fix up that patch. Sorry. You're completely
right, I forgot to role your changes from patch 1/4 into 3/4 when I
shuffled the code around. Thank you for being diligent.

> > +/*
> > + * Create active perf events based on the perviously configured
> > + * attributes.
> > + */
> 
> typo :)

Thanks.

> For what it's worth, I tested the series on my Cortex-A9 board and
> everything seemed to work fine. I'll give the patches another spin when
> we've sorted out these memory issues.

Excellent news. Thanks for testing! I'll get the next version of patch
3/4 out tonight.
