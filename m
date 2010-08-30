Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754641Ab0H3D1P (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Aug 2010 23:27:15 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:43575 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754390Ab0H3D1O convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Aug 2010 23:27:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=HOPMhExOrkSE8g+w0Pwn67fm+cE/EtQHPWkTWYbOmFA8iAKNr0QGiLBoOGm455l9ct
         3JtxB1jsMLQ+4TRPBTSk4qOQXkHZ1HwmUASAiMf5XIuS1PJVojwzIjsO3LmAQGrOrs74
         bQ4IXf1GtAnE3DFc9hdnKcJJP6GgMNwJmjXl0=
MIME-Version: 1.0
In-Reply-To: <4C7A806D.4010106@linux.intel.com>
References: <1283094309-6635-1-git-send-email-yong.zhang0@gmail.com>
	<4C7A806D.4010106@linux.intel.com>
Date: Mon, 30 Aug 2010 11:27:13 +0800
Message-ID: <AANLkTime0pid_ToCSmPW1duW+G+RFNKK+UxdtiN-VaLq@mail.gmail.com>
Subject: Re: [RFC PATCHSET 0/6] timer/hrtimer/timer_stats: Improvement on timer_stats
From: Yong Zhang <yong.zhang0@gmail.com>
To: Arjan van de Ven <arjan@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de,
        akpm@linux-foundation.org, mingo@elte.hu, a.p.zijlstra@chello.nl,
        tj@kernel.org, oleg@redhat.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 29, 2010 at 11:44 PM, Arjan van de Ven
<arjan@linux.intel.com> wrote:
> On 8/29/2010 8:05 AM, Yong Zhang wrote:
>>
>> Hi,
>>
>> This patchset focus on two problem:
>>
>> 1)timer_stats_timer_*_start_info() should belong to timer core only.
>>   It should not be seen by outsider, such as workqueue. And should
>>   not resident in timer.h.
>>   Patch-0001~0003 first remove the only explicit out call, then move
>>   timer_stats_timer_*_start_info() from timer.h to timer.c.
>>
>> 2)call site recorded by timer_stats sometimes show the timer core
>> functions
>>   instead of the real call site.
>>   Now /proc/timer_stats is like below on my machine:
>> ---now---
>>
>
>
> one question; have you tested this with powertop? (powertop being one of the
> prime consumers of this interface)
>

Now, vanilla kernel with powtop is
Top causes for wakeups:
  49.4% (250.3)       kworker/0:0 : hrtimer_start_range_ns (tick_sched_timer)
  49.4% (250.3)     <kernel core> : hrtimer_start_range_ns (tick_sched_timer)
   0.4% (  2.0)     <kernel core> : clocksource_watchdog (clocksource_watchdog)
   0.4% (  1.8)       <interrupt> : eth1
   0.2% (  1.0)       kworker/0:0 : add_timer (tg3_timer)
   0.1% (  0.3)     <kernel core> : dev_watchdog (dev_watchdog)
   0.0% (  0.2)          sendmail : hrtimer_start_range_ns (hrtimer_wakeup)
   0.0% (  0.2)              init : hrtimer_start_range_ns (hrtimer_wakeup)
   0.0% (  0.1)     <kernel core> : bdi_arm_supers_timer (sync_supers_timer_fn)
   0.0% (  0.1)        flush-0:13 : bdi_writeback_thread (process_timeout)
   0.0% (  0.1)     <kernel core> : __enqueue_rt_entity (sched_rt_period_timer)

And the patched kernel:
Top causes for wakeups:
  34.9% (  2.0)       kworker/0:0 : clocksource_watchdog (clocksource_watchdog)
  29.1% (  1.7)       <interrupt> : eth1
  17.4% (  1.0)       kworker/0:0 : tg3_timer (tg3_timer)
   3.5% (  0.2)          sendmail : schedule_hrtimeout_range_clock
(hrtimer_wakeup)
   3.5% (  0.2)     <kernel core> : dev_watchdog (dev_watchdog)
   3.5% (  0.2)              init : schedule_hrtimeout_range_clock
(hrtimer_wakeup)
   2.3% (  0.1)     <kernel core> : bdi_arm_supers_timer (sync_supers_timer_fn)
   2.3% (  0.1)        flush-0:13 : bdi_writeback_thread (process_timeout)
   1.2% (  0.1)     <kernel core> : __enqueue_rt_entity (sched_rt_period_timer)
   1.2% (  0.1)           syslogd : do_setitimer (it_real_fn)

The difference is tick_sched_timer() is gone in the patches version.

And after taking a look at powertop, I think you want to get rid of the tick
events, right?  Or maybe I'm missing something?

Thanks,
Yong
