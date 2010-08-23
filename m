Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754756Ab0HWV2d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 17:28:33 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:50335 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754677Ab0HWV2b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 17:28:31 -0400
Date: Mon, 23 Aug 2010 22:28:28 +0100
From: Matt Fleming <matt@console-pimps.org>
To: Will Deacon <will.deacon@arm.com>
Cc: linux-kernel@vger.kernel.org, Robert Richter <robert.richter@amd.com>,
        Paul Mundt <lethal@linux-sh.org>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-sh@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [PATCH 0/3] Generalise ARM perf-events backend for oprofile
Message-ID: <20100823212828.GD6510@console-pimps.org>
References: <1282560381-7700-1-git-send-email-matt@console-pimps.org>
 <1282578677.17710.14.camel@e102144-lin.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1282578677.17710.14.camel@e102144-lin.cambridge.arm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 23, 2010 at 04:51:17PM +0100, Will Deacon wrote:
> Hi Matt,
> 
> On Mon, 2010-08-23 at 11:46 +0100, Matt Fleming wrote:
> > The perf-events backend for OProfile that Will Deacon wrote in
> > 8c1fc96f6fd1f361428ba805103af0d0eee65179 ("ARM: 6072/1: oprofile: use
> > perf-events framework as backend") is of use to more architectures
> > than just ARM. Move the code into drivers/oprofile/ so that SH can use
> > it instead of the nearly identical copy of its OProfile code.
> > 
> > The benefit of the backend is that it becomes necessary to only
> > maintain one copy of the PMU accessor functions for each architecture,
> > with bug fixes and new features benefiting both OProfile and perf.
> > 
> The downside is that it's only really applicable if all the subarch
> targets which have OProfile support have equivalent perf support. I know
> this is the case for SH and ARM, but I'm not sure about other
> architectures.

Sure. This doesn't have to be a flag day. Architectures can move over if and
when they're ready. I haven't looked very closely at any other architectures
but I'm sure some of them could make use of this series.

> > Note that I haven't been able to test these patches on an ARM board to
> > see if I've caused any regressions. If anyone else could do that I'd
> > appreciate it.
> > 
> I tried to test them but they don't compile:
> 
> arch/arm/oprofile/common.c: In function 'oprofile_arch_exit':
> arch/arm/oprofile/common.c:234: error: 'perf_events' undeclared (first use in this function)
> arch/arm/oprofile/common.c:234: error: (Each undeclared identifier is reported only once
> arch/arm/oprofile/common.c:234: error: for each function it appears in.)
> arch/arm/oprofile/common.c:237: error: 'perf_num_counters' undeclared (first use in this function)
> arch/arm/oprofile/common.c:246: error: 'counter_config' undeclared (first use in this function)
> 
> This is because the oprofile_arch_exit implementation for ARM frees
> data structures that were previously allocated in oprofile_arch_init.
> Since this is now done in op_perf_create_files, I'm not sure where the
> freeing should be done. OProfile can be compiled as a module, so this
> does need to be implemented somewhere (plus, if oprofile_arch_init fails
> oprofile_arch_exit is called immediately). Perhaps an op_perf_exit()
> function could be called from the arch code?

Eek! I totally messed this up, sorry. Thanks very much for compiling
these and reviewing them. I've just grabbed an ARM toolchain so I'll
compile the next version before I post it ;-)

You've highlighted a good point - the allocation and freeing is done in
the wrong places. We need a function in drivers/oprofile/oprofile_perf.c
that is called from oprofile_arch_init() that allocates the
'counter_config' and 'perf_events[]' data structures. These can then be
freed by a similiar function in oprofile_arch_exit().

> Looking at the existing ARM implementation, it's not entirely safe in
> the case that oprofile_arch_init fails and needs something like:
> 
> diff --git a/arch/arm/oprofile/common.c b/arch/arm/oprofile/common.c
> index 0691176..15d379f 100644
> --- a/arch/arm/oprofile/common.c
> +++ b/arch/arm/oprofile/common.c
> @@ -275,10 +275,12 @@ out:
>         return ret;
>  }
>  
> -static void  exit_driverfs(void)
> +static void __exit exit_driverfs(void)
>  {
> -       platform_device_unregister(oprofile_pdev);
> -       platform_driver_unregister(&oprofile_driver);
> +       if (!IS_ERR_OR_NULL(oprofile_pdev)) {
> +               platform_device_unregister(oprofile_pdev);
> +               platform_driver_unregister(&oprofile_driver);
> +       }
>  }
>  #else
>  static int __init init_driverfs(void) { return 0; }
> @@ -363,10 +365,8 @@ int __init oprofile_arch_init(struct oprofile_operations *ops)
>         }
>  
>         ret = init_driverfs();
> -       if (ret) {
> -               kfree(counter_config);
> +       if (ret)
>                 return ret;
> -       }
>  
>         for_each_possible_cpu(cpu) {
>                 perf_events[cpu] = kcalloc(perf_num_counters,
> @@ -396,13 +396,14 @@ int __init oprofile_arch_init(struct oprofile_operations *ops)
>         return ret;
>  }
>  
> -void oprofile_arch_exit(void)
> +void __exit oprofile_arch_exit(void)
>  {
>         int cpu, id;
>         struct perf_event *event;
>  
> +       exit_driverfs();
> +
>         if (*perf_events) {
> -               exit_driverfs();
>                 for_each_possible_cpu(cpu) {
>                         for (id = 0; id < perf_num_counters; ++id) {
>                                 event = perf_events[cpu][id];
> @@ -422,5 +423,5 @@ int __init oprofile_arch_init(struct oprofile_operations *ops)
>         pr_info("oprofile: hardware counters not available\n");
>         return -ENODEV;
>  }
> -void oprofile_arch_exit(void) {}
> +void __exit oprofile_arch_exit(void) {}
>  #endif /* CONFIG_HW_PERF_EVENTS */
> 
> 
> I can submit this as a separate patch or you can fold it into your changes
> to avoid any conflicts.

Ah, I see what you mean. I'll fold this change into my series to avoid
conflicts, but as a separate patch. I'll retain your authorship in the
commit just be sure to check it when I send out V2 of this series to
make sure I haven't messed your patch up.

Thanks for the review!
