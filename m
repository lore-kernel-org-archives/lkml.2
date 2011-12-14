Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932142Ab1LNSJu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 13:09:50 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:51522 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755466Ab1LNSJs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 13:09:48 -0500
X-Authority-Analysis: v=2.0 cv=HeWWv148 c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=mkvx9NrORpUA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=VwQbUJbxAAAA:8 a=hhqcuK1eAdb1zdfbOQwA:9 a=E__T9JyLl9c_WLqqbF4A:7 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1323886185.23971.55.camel@gandalf.stny.rr.com>
Subject: RE: [PATCH 2/2] trace,x86: Add x86 irq vector entry/exit tracepoints
From: Steven Rostedt <rostedt@goodmis.org>
To: Seiji Aguchi <seiji.aguchi@hds.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Vaibhav Nagarnaik <vnagarnaik@google.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Michael Rubin <mrubin@google.com>, David Sharp <dhsharp@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        Satoru Moriya <satoru.moriya@hds.com>
Date: Wed, 14 Dec 2011 13:09:45 -0500
In-Reply-To: <5C4C569E8A4B9B42A84A977CF070A35B2C57F7A805@USINDEVS01.corp.hds.com>
References: <1311983978-10350-1-git-send-email-vnagarnaik@google.com>
	 <1311983978-10350-3-git-send-email-vnagarnaik@google.com>
	 <5C4C569E8A4B9B42A84A977CF070A35B2C57EE47BC@USINDEVS01.corp.hds.com>
	 <20111213192556.GD2421@somewhere.redhat.com>
	 <5C4C569E8A4B9B42A84A977CF070A35B2C57F7A6D7@USINDEVS01.corp.hds.com>
	 <20111214163407.GE10791@somewhere.redhat.com>
	 <5C4C569E8A4B9B42A84A977CF070A35B2C57F7A805@USINDEVS01.corp.hds.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.0.3-3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-12-14 at 12:46 -0500, Seiji Aguchi wrote:
> >Well ftrace is a whole subsystem that includes the function tracer and also an interface
> >for tracepoints in debugfs. I was rather suggesting the latter one. This is a good
> >choice for background tracing. And it supports stacktraces. If those generate too much
> >overhead perhaps you can tune the number of entries in the stacktrace, I don't remember
> >if we can do that currently but this can be an interesting feature.
> 
> I would like to periodically check which function call is executed
> rather than seeing stacktrace.
> 
> AFAIK, purpose of stack tracing is showing where the biggest use of the stack takes place.
> I don't think stack tracing achieves my goal.

You may be getting confused with /proc/sys/kernel/stack_tracer_enabled
and /debug/tracing/options/stacktrace
+ /debug/tracing/options/func_stack_trace

The "stack_tracer" is started via the proc file system and detects the
largest stack:

where doing echo 1 > /proc/sys/kernel/stack_tracer_enabled
gives you:

# cat /debug/tracing/stack_trace 
        Depth    Size   Location    (16 entries)
        -----    ----   --------
  0)     2976     416   find_busiest_group+0x6ff/0x7b6
  1)     2560     272   load_balance+0xa3/0x6c7
  2)     2288     144   __schedule+0x31a/0x6c5
  3)     2144      16   schedule+0x5a/0x5c
  4)     2128     160   schedule_timeout+0x37/0xf7
  5)     1968     112   wait_for_common+0xab/0x105
  6)     1856      16   wait_for_completion+0x1d/0x1f
  7)     1840     176   flush_work+0x46/0x60
  8)     1664      16   tty_flush_to_ldisc+0x15/0x17
  9)     1648      32   input_available_p+0x17/0x57
 10)     1616      48   n_tty_poll+0x6b/0x136
 11)     1568      64   tty_poll+0x64/0x7f
 12)     1504     880   do_select+0x327/0x519
 13)      624     400   core_sys_select+0x190/0x22f
 14)      224      96   sys_select+0x91/0xb9
 15)      128     128   system_call_fastpath+0x16/0x1b

But this is not what we are talking about. We are talking about either:

echo 1 > /debug/tracing/options/stacktrace
echo 1 > /debug/tracing/options/irq/irq_handler_entry
# tracer: nop
#
# entries-in-buffer/entries-written: 690/690   #P:2
#
#                              _-----=> irqs-off
#                             / _----=> need-resched
#                            | / _---=> hardirq/softirq
#                            || / _--=> preempt-depth
#                            ||| /     delay
#           TASK-PID   CPU#  ||||    TIMESTAMP  FUNCTION
#              | |       |   ||||       |         |
     rb_consumer-35    [001] d.h2   435.246779: irq_handler_entry: irq=21 name=uhci_hcd:usb4
     rb_consumer-35    [001] d.h2   435.246788: <stack trace>
 => handle_irq_event_percpu
 => handle_irq_event
 => handle_fasteoi_irq
 => handle_irq
 => do_IRQ
 => ret_from_intr
 => ring_buffer_consume
 => ring_buffer_consumer_thread
 => kthread
 => kernel_thread_helper
     rb_consumer-35    [001] d.h2   435.246789: irq_handler_entry: irq=21 name=eth0
     rb_consumer-35    [001] d.h2   435.246796: <stack trace>
 => handle_irq_event_percpu
 => handle_irq_event
 => handle_fasteoi_irq
 => handle_irq
 => do_IRQ
 => ret_from_intr
 => ring_buffer_consume
 => ring_buffer_consumer_thread
 => kthread
 => kernel_thread_helper
     rb_consumer-35    [001] d.h2   435.247027: irq_handler_entry: irq=21 name=uhci_hcd:usb4
     rb_consumer-35    [001] d.h2   435.247034: <stack trace>
 => handle_irq_event_percpu
 => handle_irq_event
 => handle_fasteoi_irq
 => handle_irq
 => do_IRQ
 => ret_from_intr
 => ring_buffer_consume
 => ring_buffer_consumer_thread
 => kthread
 => kernel_thread_helper
     rb_consumer-35    [001] d.h2   435.247035: irq_handler_entry: irq=21 name=eth0
     rb_consumer-35    [001] d.h2   435.247041: <stack trace>
 => handle_irq_event_percpu
 => handle_irq_event
 => handle_fasteoi_irq
 => handle_irq
 => do_IRQ
 => ret_from_intr
 => ring_buffer_consume
 => ring_buffer_consumer_thread
 => kthread
 => kernel_thread_helper


(Note, the new header isn't pushed to mainline yet).

Or with function tracing:

echo do_irq > /debug/tracing/set_ftrace_filter
echo function > /debug/tracing/current_tracer
echo 1 > /debug/tracing/options/ftrace_stack_trace

# tracer: function
#
# entries-in-buffer/entries-written: 18/18   #P:2
#
#                              _-----=> irqs-off
#                             / _----=> need-resched
#                            | / _---=> hardirq/softirq
#                            || / _--=> preempt-depth
#                            ||| /     delay
#           TASK-PID   CPU#  ||||    TIMESTAMP  FUNCTION
#              | |       |   ||||       |         |
          <idle>-0     [001] d..1   609.407279: do_IRQ <-ret_from_intr
          <idle>-0     [001] d..1   609.407286: <stack trace>
 => ret_from_intr
 => cpu_idle
 => start_secondary
          <idle>-0     [001] d..1   609.407527: do_IRQ <-ret_from_intr
          <idle>-0     [001] d..1   609.407532: <stack trace>
 => ret_from_intr
 => cpu_idle
 => start_secondary
          <idle>-0     [001] d..1   609.407777: do_IRQ <-ret_from_intr
          <idle>-0     [001] d..1   609.407781: <stack trace>
 => ret_from_intr
 => cpu_idle
 => start_secondary
          <idle>-0     [001] d..1   609.814166: do_IRQ <-ret_from_intr
          <idle>-0     [001] d..1   609.814171: <stack trace>
 => ret_from_intr
 => cpu_idle
 => start_secondary
            sshd-2293  [001] d.s3   609.814416: do_IRQ <-ret_from_intr
            sshd-2293  [001] d.s3   609.814430: <stack trace>
 => ret_from_intr
 => _raw_spin_unlock_irqrestore
 => __queue_work
 => delayed_work_timer_fn
 => run_timer_softirq
 => __do_softirq
 => call_softirq
 => do_softirq
 => irq_exit
 => smp_apic_timer_interrupt
 => apic_timer_interrupt
 => _raw_spin_unlock_irqrestore
 => __wake_up
 => put_ldisc
 => tty_ldisc_deref
 => tty_poll
 => do_select
 => core_sys_select
 => sys_select
 => system_call_fastpath


Note, the above commands can be done easier if you download trace-cmd:

git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/trace-cmd.git

The first operation is:

trace-cmd start -e irq_handler_entry -O stacktrace
# cat /sys/kernel/debug/tracing/trace

the second is:

trace-cmd start -p function -l do_IRQ --func-stack
# cat /sys/kernel/debug/tracing/trace


> 
> Rip in local timer interrupt is more accurate information 
> for achieving my goal than stacktrace

Does the above change your mind?

-- Steve


