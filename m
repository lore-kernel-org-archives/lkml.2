Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756269Ab1HEDzn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Aug 2011 23:55:43 -0400
Received: from smtp-out.google.com ([216.239.44.51]:51442 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754409Ab1HEDzl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Aug 2011 23:55:41 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:in-reply-to:references:from:date:
	message-id:subject:to:cc:content-type:
	content-transfer-encoding:x-system-of-record;
	b=HD6SO8KprJF4lbhkZLIOFKvAwHitdZykA91MGLmxr/PzmObIwOphE77DIg+8TgZ5I
	GMwyvJXKP9FoowouSh0sA==
MIME-Version: 1.0
In-Reply-To: <20110727215816.GA2515@redhat.com>
References: <20110722003211.GA2807@redhat.com> <CAPM31R+UWijCCna5zYfn875h+KPmS4H0Lk8jW6+8JP-oDb72DA@mail.gmail.com>
 <20110722011747.GB2807@redhat.com> <CAPM31RKW+do-U8G8uL-y53BVWvr4oQbSf456A9u-SUV06tSfeg@mail.gmail.com>
 <20110727215816.GA2515@redhat.com>
From: Paul Turner <pjt@google.com>
Date: Thu, 4 Aug 2011 20:55:08 -0700
Message-ID: <CAPM31RKQyKukoNXLeiLkQ0fdOiDizZRtviR=J+93PhJD9r-SkQ@mail.gmail.com>
Subject: Re: [RFT][patch 17/18] sched: use jump labels to reduce overhead when
 bandwidth control is inactive
To: Jason Baron <jbaron@redhat.com>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Bharata B Rao <bharata@linux.vnet.ibm.com>,
        Dhaval Giani <dhaval.giani@gmail.com>,
        Balbir Singh <bsingharora@gmail.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        Ingo Molnar <mingo@elte.hu>, Pavel Emelyanov <xemul@openvz.org>,
        rth@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> --- a/kernel/Makefile
> +++ b/kernel/Makefile
> @@ -10,7 +10,7 @@ obj-y     = sched.o fork.o exec_domain.o panic.o printk.o \
>            kthread.o wait.o kfifo.o sys_ni.o posix-cpu-timers.o mutex.o \
>            hrtimer.o rwsem.o nsproxy.o srcu.o semaphore.o \
>            notifier.o ksysfs.o pm_qos_params.o sched_clock.o cred.o \
> -           async.o range.o jump_label.o
> +           async.o range.o
>  obj-y += groups.o
>
>  ifdef CONFIG_FUNCTION_TRACER
> @@ -107,6 +107,7 @@ obj-$(CONFIG_PERF_EVENTS) += events/
>  obj-$(CONFIG_USER_RETURN_NOTIFIER) += user-return-notifier.o
>  obj-$(CONFIG_PADATA) += padata.o
>  obj-$(CONFIG_CRASH_DUMP) += crash_dump.o
> +obj-$(CONFIG_JUMP_LABEL) += jump_label.o
>
>  ifneq ($(CONFIG_SCHED_OMIT_FRAME_POINTER),y)
>  # According to Alan Modra <alan@linuxcare.com.au>, the -fno-omit-frame-pointer is
>

Tested-by: Paul Turner <pjt@google.com>

Let me know if you need any result tables for the actual commit msg.
Same goes for making CONFIG_JUMP_LABEL equivalent to default in
CC_HAS_ASM_GOTO case (at least on x86 anyway).


>
> I've tested the patch using a single 'static_branch()' in the getppid() path,
> and basically running tight loops of calls to getppid(). Before, the
> patch, I was seeing results similar to what you reported, after the
> patch, things improved for all metrics. Here are my results for the
> branch disabled case:
>
> With jump labels turned on (CONFIG_JUMP_LABEL), branch disabled:
>
>  Performance counter stats for 'bash -c /tmp/timing;true' (50 runs):
>
>     3,969,510,217 instructions             #      0.864 IPC     ( +-0.000% )
>     4,592,334,954 cycles                     ( +-   0.046% )
>       751,634,470 branches                   ( +-   0.000% )
>
>        1.722635797  seconds time elapsed   ( +-   0.046% )
>
> Jump labels turned off (CONFIG_JUMP_LABEL not set), branch disabled:
>
>  Performance counter stats for 'bash -c /tmp/timing;true' (50 runs):
>
>     4,009,611,846 instructions             #      0.867 IPC     ( +-0.000% )
>     4,622,210,580 cycles                     ( +-   0.012% )
>       771,662,904 branches                   ( +-   0.000% )
>
>        1.734341454  seconds time elapsed   ( +-   0.022% )
>
>
> So all of the measured metrics improved in the jump labels case b/w
> 0.5% - 2.5%.
>
> I'm curious to see what you find with this patch.
>
> Thanks,
>
> -Jason
>
>
>
