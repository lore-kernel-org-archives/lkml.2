Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757942Ab0LTPLm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 10:11:42 -0500
Received: from mx1.redhat.com ([209.132.183.28]:21451 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757740Ab0LTPLl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 10:11:41 -0500
Date: Mon, 20 Dec 2010 16:11:24 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Dave Jones <davej@redhat.com>, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, Arnd Bergmann <arnd@arndb.de>
Subject: Re: flush_to_ldisc executing 2500 times a second ?
Message-ID: <20101220151124.GG1925@jolsa.brq.redhat.com>
References: <20101201040709.GA28526@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101201040709.GA28526@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,

sorry for late reply, I just got back from vacation..
is this still an issue?

thanks,
jirka

On Tue, Nov 30, 2010 at 11:07:09PM -0500, Dave Jones wrote:
> While poking at an unrelated bug, I came up with a perf
> command line that showed something curious.
> 
> perf record -a -e workqueue:workqueue_execute_start sleep 1
> perf trace
> 
> shows flush_to_ldisc being executed ~2500 times.
> (http://codemonkey.org.uk/junk/flush_to_ldisc.txt)
> 
> Steve Rostedt gave me a tip about trace-cmd to get a backtrace,
> 
> trace-cmd record -e workqueue_queue_work -O stacktrace sleep 1
> 
> which yields thousands of ..
> 
>            sleep-17431 [000] 35746.452637: workqueue_queue_work: work struct=0xffff880113f2a2a0 function=flush_to_ldisc workqueue=0xffff88013f80cb68 req_cpu=0 cpu=0
>            sleep-17431 [000] 35746.452638: kernel_stack:         <stack trace>
> => __queue_work (ffffffff81068c25)
> => delayed_work_timer_fn (ffffffff81068cc8)
> => run_timer_softirq (ffffffff8105e651)
> => __do_softirq (ffffffff810571af)
> => call_softirq (ffffffff8100bbdc)
> => do_softirq (ffffffff8100d358)
> => irq_exit (ffffffff81057366)
> => smp_apic_timer_interrupt (ffffffff81482b9e)
> 
> Which doesn't really tell me much.
> 
> 
> At the time of the profiling, there's nothing being output on any tty's
> (and the profiling tools are also silent during the actual profiling) so
> I'm curious as to what's causing the flushing to be necessary.
> 
> Anyone have any ideas what's going on here ? or something further
> I could dig into ?
> 
> This is with 2.6.37-rc4.
> 
> The only other machine I have to test on right now is running 2.6.34, which
> doesn't exhibit this behaviour.  I'll try to narrow it down further tomorrow.
> 
> 	Dave
> 
