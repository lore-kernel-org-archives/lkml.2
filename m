Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754788Ab1HES3C (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Aug 2011 14:29:02 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22035 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751190Ab1HES27 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Aug 2011 14:28:59 -0400
Date: Fri, 5 Aug 2011 14:28:35 -0400
From: Jason Baron <jbaron@redhat.com>
To: Paul Turner <pjt@google.com>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Bharata B Rao <bharata@linux.vnet.ibm.com>,
        Dhaval Giani <dhaval.giani@gmail.com>,
        Balbir Singh <bsingharora@gmail.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        Ingo Molnar <mingo@elte.hu>, Pavel Emelyanov <xemul@openvz.org>,
        rth@redhat.com, rostedt@goodmis.org
Subject: Re: [RFT][patch 17/18] sched: use jump labels to reduce overhead
 when bandwidth control is inactive
Message-ID: <20110805182835.GE2522@redhat.com>
References: <20110722003211.GA2807@redhat.com>
 <CAPM31R+UWijCCna5zYfn875h+KPmS4H0Lk8jW6+8JP-oDb72DA@mail.gmail.com>
 <20110722011747.GB2807@redhat.com>
 <CAPM31RKW+do-U8G8uL-y53BVWvr4oQbSf456A9u-SUV06tSfeg@mail.gmail.com>
 <20110727215816.GA2515@redhat.com>
 <CAPM31RKQyKukoNXLeiLkQ0fdOiDizZRtviR=J+93PhJD9r-SkQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAPM31RKQyKukoNXLeiLkQ0fdOiDizZRtviR=J+93PhJD9r-SkQ@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 04, 2011 at 08:55:08PM -0700, Paul Turner wrote:
> > --- a/kernel/Makefile
> > +++ b/kernel/Makefile
> > @@ -10,7 +10,7 @@ obj-y     = sched.o fork.o exec_domain.o panic.o printk.o \
> >            kthread.o wait.o kfifo.o sys_ni.o posix-cpu-timers.o mutex.o \
> >            hrtimer.o rwsem.o nsproxy.o srcu.o semaphore.o \
> >            notifier.o ksysfs.o pm_qos_params.o sched_clock.o cred.o \
> > -           async.o range.o jump_label.o
> > +           async.o range.o
> >  obj-y += groups.o
> >
> >  ifdef CONFIG_FUNCTION_TRACER
> > @@ -107,6 +107,7 @@ obj-$(CONFIG_PERF_EVENTS) += events/
> >  obj-$(CONFIG_USER_RETURN_NOTIFIER) += user-return-notifier.o
> >  obj-$(CONFIG_PADATA) += padata.o
> >  obj-$(CONFIG_CRASH_DUMP) += crash_dump.o
> > +obj-$(CONFIG_JUMP_LABEL) += jump_label.o
> >
> >  ifneq ($(CONFIG_SCHED_OMIT_FRAME_POINTER),y)
> >  # According to Alan Modra <alan@linuxcare.com.au>, the -fno-omit-frame-pointer is
> >
> 
> Tested-by: Paul Turner <pjt@google.com>
> 
> Let me know if you need any result tables for the actual commit msg.

Hi Paul,

Thanks for taking the time test this :) I'll post the patch shortly
with my own testing results. Hopefully, it can still be considered for
3.1 b/c of the non-invasive nature of the patch...

> Same goes for making CONFIG_JUMP_LABEL equivalent to default in
> CC_HAS_ASM_GOTO case (at least on x86 anyway).
> 

I originally had CONFIG_JUMP_LABEL implicitly turned on, but we ran into
a 32-bit compiler issue that was causing random, nasty crashes. That
issue has since been resolved in gcc, but we might need to update the
have CC_HAS_ASM_GOTO check to deal with that case better. Currently,
we're using the '-maccumulate-outgoing-args' gcc option to work around
the issue for 32 bit x86 (see: arch/x86/Makefile_32.cpu).

With the jump label interface somewhat stabilizing (I say somewhat, b/c Peter
brought up a good use case in the scheduler that it currently doesn't address,
but which we should be able to support without too much churn) and these testing
results, I think it might make sense to consider turning it on by default for
3.2. thoughts?

Thanks,

-Jason


> 
> >
> > I've tested the patch using a single 'static_branch()' in the getppid() path,
> > and basically running tight loops of calls to getppid(). Before, the
> > patch, I was seeing results similar to what you reported, after the
> > patch, things improved for all metrics. Here are my results for the
> > branch disabled case:
> >
> > With jump labels turned on (CONFIG_JUMP_LABEL), branch disabled:
> >
> >  Performance counter stats for 'bash -c /tmp/timing;true' (50 runs):
> >
> >     3,969,510,217 instructions             #      0.864 IPC     ( +-0.000% )
> >     4,592,334,954 cycles                     ( +-   0.046% )
> >       751,634,470 branches                   ( +-   0.000% )
> >
> >        1.722635797  seconds time elapsed   ( +-   0.046% )
> >
> > Jump labels turned off (CONFIG_JUMP_LABEL not set), branch disabled:
> >
> >  Performance counter stats for 'bash -c /tmp/timing;true' (50 runs):
> >
> >     4,009,611,846 instructions             #      0.867 IPC     ( +-0.000% )
> >     4,622,210,580 cycles                     ( +-   0.012% )
> >       771,662,904 branches                   ( +-   0.000% )
> >
> >        1.734341454  seconds time elapsed   ( +-   0.022% )
> >
> >
> > So all of the measured metrics improved in the jump labels case b/w
> > 0.5% - 2.5%.
> >
> > I'm curious to see what you find with this patch.
> >
> > Thanks,
> >
> > -Jason
> >
> >
> >
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
