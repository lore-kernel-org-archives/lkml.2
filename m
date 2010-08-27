Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752837Ab0H0UTx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 16:19:53 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:37372 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751141Ab0H0UTs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 16:19:48 -0400
Date: Fri, 27 Aug 2010 21:19:46 +0100
From: Matt Fleming <matt@console-pimps.org>
To: Robert Richter <robert.richter@amd.com>
Cc: linux-kernel@vger.kernel.org, Will Deacon <will.deacon@arm.com>,
        Paul Mundt <lethal@linux-sh.org>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-sh@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>, linux-arch@vger.kernel.org
Subject: Re: [PATCH V2 4/4] sh: Use the perf-events backend for oprofile
Message-ID: <20100827201946.GB18829@console-pimps.org>
References: <cover.1282848651.git.matt@console-pimps.org>
 <c741813aa911f0048cfab1a1a30534e8d7bb6765.1282848651.git.matt@console-pimps.org>
 <20100827145901.GO22783@erda.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100827145901.GO22783@erda.amd.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 27, 2010 at 04:59:01PM +0200, Robert Richter wrote:
> On 26.08.10 15:09:19, Matt Fleming wrote:
> > Use the perf-events based wrapper for oprofile available in
> > drivers/oprofile. This allows us to centralise the code to control
> > performance counters.
> > 
> > Signed-off-by: Matt Fleming <matt@console-pimps.org>
> > ---
> > 
> > Paul,
> > 
> > I dropped the CONFIG_PERF_EVENTS dependency from the Makefile in this
> > version because to do anything useful we need perf events anyway.
> 
> Initialization should simply fail with a printk message for this case,
> implement function stubs for the !CONFIG_PERF_EVENTS case instead in
> the oprofile.h header file.

I didn't do this because I was hoping that eventually we'd make
CONFIG_OPROFILE select PERF_EVENTS. Would you be OK making that change
instead? Runtime failure is best avoided where possible, especially when
we can sort this out at compile time.

> > 
> >  arch/sh/oprofile/Makefile  |    2 +-
> >  arch/sh/oprofile/common.c  |   96 ++++++++-----------------------------------
> >  arch/sh/oprofile/op_impl.h |   33 ---------------
> >  3 files changed, 19 insertions(+), 112 deletions(-)
> >  delete mode 100644 arch/sh/oprofile/op_impl.h
> > 
> > diff --git a/arch/sh/oprofile/Makefile b/arch/sh/oprofile/Makefile
> > index 4886c5c..e1015ae 100644
> > --- a/arch/sh/oprofile/Makefile
> > +++ b/arch/sh/oprofile/Makefile
> > @@ -4,6 +4,6 @@ DRIVER_OBJS = $(addprefix ../../../drivers/oprofile/, \
> >  		oprof.o cpu_buffer.o buffer_sync.o \
> >  		event_buffer.o oprofile_files.o \
> >  		oprofilefs.o oprofile_stats.o \
> > -		timer_int.o )
> > +		timer_int.o oprofile_perf.o )
> >  
> >  oprofile-y	:= $(DRIVER_OBJS) common.o backtrace.o
> > diff --git a/arch/sh/oprofile/common.c b/arch/sh/oprofile/common.c
> > index ac60493..f8d4a84 100644
> > --- a/arch/sh/oprofile/common.c
> > +++ b/arch/sh/oprofile/common.c
> > @@ -17,71 +17,23 @@
> >  #include <linux/init.h>
> >  #include <linux/errno.h>
> >  #include <linux/smp.h>
> > +#include <linux/perf_event.h>
> 
> I don't see a reason why this must be included here.
> 
> It's only for sh_pmu_name() and sh_pmu_num_events(), so the interface
> looks wrong here. It should be in oprofile_perf.c. The functions
> should be generic non-arch perf code. See below.

These functions are inherently architecture-specific. See my reply to
your response to patch 2/4.

> >  #include <asm/processor.h>
> > -#include "op_impl.h"
> > -
> > -static struct op_sh_model *model;
> > -
> > -static struct op_counter_config ctr[20];
> >  
> >  extern void sh_backtrace(struct pt_regs * const regs, unsigned int depth);
> >  
> > -static int op_sh_setup(void)
> > -{
> > -	/* Pre-compute the values to stuff in the hardware registers.  */
> > -	model->reg_setup(ctr);
> > -
> > -	/* Configure the registers on all cpus.  */
> > -	on_each_cpu(model->cpu_setup, NULL, 1);
> > -
> > -        return 0;
> > -}
> > -
> > -static int op_sh_create_files(struct super_block *sb, struct dentry *root)
> > -{
> > -	int i, ret = 0;
> > -
> > -	for (i = 0; i < model->num_counters; i++) {
> > -		struct dentry *dir;
> > -		char buf[4];
> > -
> > -		snprintf(buf, sizeof(buf), "%d", i);
> > -		dir = oprofilefs_mkdir(sb, root, buf);
> > -
> > -		ret |= oprofilefs_create_ulong(sb, dir, "enabled", &ctr[i].enabled);
> > -		ret |= oprofilefs_create_ulong(sb, dir, "event", &ctr[i].event);
> > -		ret |= oprofilefs_create_ulong(sb, dir, "kernel", &ctr[i].kernel);
> > -		ret |= oprofilefs_create_ulong(sb, dir, "user", &ctr[i].user);
> > -
> > -		if (model->create_files)
> > -			ret |= model->create_files(sb, dir);
> > -		else
> > -			ret |= oprofilefs_create_ulong(sb, dir, "count", &ctr[i].count);
> > -
> > -		/* Dummy entries */
> > -		ret |= oprofilefs_create_ulong(sb, dir, "unit_mask", &ctr[i].unit_mask);
> > -	}
> > -
> > -	return ret;
> > -}
> > -
> > -static int op_sh_start(void)
> > +static char *op_name_from_perf_name(const char *name)
> >  {
> > -	/* Enable performance monitoring for all counters.  */
> > -	on_each_cpu(model->cpu_start, NULL, 1);
> > +	if (!strcmp(name, "SH-4A"))
> > +		return "sh/sh4a";
> > +	if (!strcmp(name, "SH7750"))
> > +		return "sh/sh7750";
> 
> With that implementation we always have to touch the code for new
> cpus. Maybe we derive it from the perf name, e.g. making all lowercase
> and removing dashes?

Is this code really that bad that we need to start playing string
manipulation games?

> >  
> > -	return 0;
> > -}
> > -
> > -static void op_sh_stop(void)
> > -{
> > -	/* Disable performance monitoring for all counters.  */
> > -	on_each_cpu(model->cpu_stop, NULL, 1);
> > +	return NULL;
> >  }
> >  
> >  int __init oprofile_arch_init(struct oprofile_operations *ops)
> >  {
> > -	struct op_sh_model *lmodel = NULL;
> >  	int ret;
> >  
> >  	/*
> > @@ -91,40 +43,28 @@ int __init oprofile_arch_init(struct oprofile_operations *ops)
> >  	 */
> >  	ops->backtrace = sh_backtrace;
> >  
> > -	/*
> > -	 * XXX
> > -	 *
> > -	 * All of the SH7750/SH-4A counters have been converted to perf,
> > -	 * this infrastructure hook is left for other users until they've
> > -	 * had a chance to convert over, at which point all of this
> > -	 * will be deleted.
> > -	 */
> > -
> > -	if (!lmodel)
> > -		return -ENODEV;
> >  	if (!(current_cpu_data.flags & CPU_HAS_PERF_COUNTER))
> >  		return -ENODEV;
> >  
> > -	ret = lmodel->init();
> > -	if (unlikely(ret != 0))
> > -		return ret;
> > +	ops->setup		= oprofile_perf_setup;
> > +	ops->create_files	= oprofile_perf_create_files;
> > +	ops->start		= oprofile_perf_start;
> > +	ops->stop		= oprofile_perf_stop;
> > +	ops->cpu_type		= op_name_from_perf_name(sh_pmu_name());
> >  
> > -	model = lmodel;
> > +	oprofile_perf_set_num_counters(sh_pmu_num_events());
> >  
> > -	ops->setup		= op_sh_setup;
> > -	ops->create_files	= op_sh_create_files;
> > -	ops->start		= op_sh_start;
> > -	ops->stop		= op_sh_stop;
> > -	ops->cpu_type		= lmodel->cpu_type;
> > +	ret = oprofile_perf_init();
> 
> Instead of exporting all the functions above implement something like:
> 
> 	name = op_name_from_perf_name(sh_pmu_name());
> 	num_events = sh_pmu_num_events();
> 	ret = oprofile_perf_init(ops, name, num_events);
> 
> We will then have only oprofile_perf_init() and oprofile_perf_exit()
> as interface which is much cleaner.

Well, the reason that I left it this way is so that architectures can
choose to implement wrappers around the oprofile_perf_* functions. I
don't think ARM or SH actually need wrappers (the only extra thing that
ARM does is locking which SH should probably do too) but I assumed there
was a reason that these functions pointers were exposed originally. I
haven't look at what other architectures would do. I'll take a look at
that.
