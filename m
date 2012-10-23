Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932733Ab2JWOvP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 10:51:15 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:30226 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757140Ab2JWOvO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 10:51:14 -0400
X-Authority-Analysis: v=2.0 cv=IZ4FqBWa c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=nN8PCGx3Up0A:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=HZYA4xdn_vcA:10 a=20KFwNOVAAAA:8 a=V6AFmmv8AAAA:8 a=KQJQGunmAAAA:8 a=yDZS9fasoJymrYYzHTwA:9 a=PUjeQqilurYA:10 a=ZkqkaVPnX0AA:10 a=jEp0ucaQiEUA:10 a=TjLX3U0Hl6jHOHmj:21 a=5TJ3qPNmSTKeE8u1:21 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-ID: <1351003871.8467.18.camel@gandalf.local.home>
Subject: Re: [tracing] WARNING: at kernel/lockdep.c:3545 check_flags()
From: Steven Rostedt <rostedt@goodmis.org>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: Steven Rostedt <srostedt@redhat.com>, LKML <linux-kernel@vger.kernel.org>
Date: Tue, 23 Oct 2012 10:51:11 -0400
In-Reply-To: <20121018114139.GA29884@localhost>
References: <20121018114139.GA29884@localhost>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-10-18 at 19:41 +0800, Fengguang Wu wrote:
> Hi Steven,

Hi Wu,

I was out of town and I don't read my redhat email address while
traveling.

> 
> This warning occur from time to time in my tests:
> 
> [  593.080133] Testing tracer function: 
> [  593.149895] ------------[ cut here ]------------
> [  593.149895] WARNING: at /c/kernel-tests/src/stable/kernel/lockdep.c:3545 check_flags+0x1c8/0x1d0()

This is:

        if (!hardirq_count()) {
                if (softirq_count()) {
                        /* like the above, but with softirqs */
                        DEBUG_LOCKS_WARN_ON(current->softirqs_enabled);
                } else {

Which means that some how softirqs are disabled but lockdep thinks they
are enabled.

> [  593.149895] Modules linked in:
> [  593.149895] Pid: 1, comm: swapper/0 Not tainted 3.7.0-rc1-12129-gee2dd3c #3
> [  593.149895] Call Trace:
> [  593.149895]  <IRQ>  [<ffffffff810734cf>] warn_slowpath_common+0x8f/0xc0
> [  593.149895]  [<ffffffff8107351a>] warn_slowpath_null+0x1a/0x20
> [  593.149895]  [<ffffffff810fac08>] check_flags+0x1c8/0x1d0
> [  593.149895]  [<ffffffff810fbfed>] lock_is_held+0x4d/0xa0
> [  593.149895]  [<ffffffff8156d570>] ? notify_die+0x30/0x30
> [  593.149895]  [<ffffffff81081b13>] ? __local_bh_enable+0x1d3/0x230
> [  593.149895]  [<ffffffff81133cdf>] rcu_read_lock_held+0x7f/0x90
> [  593.149895]  [<ffffffff81134208>] ftrace_ops_no_ops+0x188/0x190
> [  593.149895]  [<ffffffff81573872>] trace+0x55/0x93
> [  593.149895]  [<ffffffff81573872>] ? trace+0x55/0x93
> [  593.149895]  [<ffffffff81566fc9>] ? _raw_spin_unlock_irq+0x99/0xc0
> [  593.149895]  [<ffffffff8156d575>] ? sub_preempt_count+0x5/0x210
> [  593.149895]  [<ffffffff8156d575>] ? sub_preempt_count+0x5/0x210
> [  593.149895]  [<ffffffff81081b13>] ? __local_bh_enable+0x1d3/0x230

This makes sense, as function tracing of softirqs sometimes causes this
bug. It's a race where a function is traced inside enabling softirqs and
the tracer's lock causes a check of softirqs after lockdep disabled it
but before it was actually disabled. I'll try to figure out how this
happens again. It has been fixed in the past before.


> [  593.149895]  [<ffffffff810827ea>] __do_softirq+0x42a/0x710
> [  593.149895]  [<ffffffff81574c7c>] call_softirq+0x1c/0x30
> [  593.149895]  [<ffffffff81028a05>] do_softirq+0x1d5/0x2a0
> [  593.149895]  [<ffffffff81082d3d>] irq_exit+0xad/0xc0
> [  593.149895]  [<ffffffff81028035>] do_IRQ+0x75/0x100
> [  593.149895]  [<ffffffff81567c72>] common_interrupt+0x72/0x72
> [  593.149895]  <EOI>  [<ffffffff810fafbb>] ? mark_held_locks+0x9b/0x100
> [  593.149895]  [<ffffffff815675f3>] ? _raw_spin_unlock_irqrestore+0xd3/0x130
> [  593.149895]  [<ffffffff81307487>] __debug_object_init+0x1b7/0x580
> [  593.149895]  [<ffffffff813078c6>] debug_object_init_on_stack+0x36/0x40
> [  593.149895]  [<ffffffff8108a565>] init_timer_on_stack_key+0x35/0x80
> [  593.149895]  [<ffffffff815616fb>] schedule_timeout+0x8b/0x470
> [  593.149895]  [<ffffffff81573872>] ? trace+0x55/0x93
> [  593.149895]  [<ffffffff81562fb7>] ? __mutex_unlock_slowpath+0x247/0x380
> [  593.149895]  [<ffffffff81133487>] ? update_ftrace_function+0x17/0x150
> [  593.149895]  [<ffffffff81561afe>] schedule_timeout_uninterruptible+0x1e/0x20
> [  593.149895]  [<ffffffff8108ea60>] msleep+0x20/0x30
> [  593.149895]  [<ffffffff81145a6a>] trace_selftest_startup_function+0xda/0x2b0
> [  593.149895]  [<ffffffff81146c4c>] register_tracer+0x32c/0x430
> [  593.149895]  [<ffffffff81c3aee4>] ? init_trace_printk_function_export+0x48/0x48
> [  593.149895]  [<ffffffff81c3aef4>] init_function_trace+0x10/0x12
> [  593.149895]  [<ffffffff8100223a>] do_one_initcall+0x1aa/0x270
> [  593.149895]  [<ffffffff815313bc>] kernel_init+0x11c/0x370
> [  593.149895]  [<ffffffff81c17878>] ? do_early_param+0xc6/0xc6
> [  593.149895]  [<ffffffff810ca474>] ? schedule_tail+0x34/0x110
> [  593.149895]  [<ffffffff815312a0>] ? rest_init+0x170/0x170
> [  593.149895]  [<ffffffff815739ac>] ret_from_fork+0x7c/0xb0
> [  593.149895]  [<ffffffff815312a0>] ? rest_init+0x170/0x170
> 
> And it's bisected down to an unbelievable simple commit..
> 
> commit 17bb615ad4f8d2d2c0f02794d27d7f83e0009ef4
> Author: Steven Rostedt <srostedt@redhat.com>
> Date:   Mon May 23 15:27:46 2011 -0400
> 
>     tracing: Have event with function tracer check error return

This change is simply:

--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -1657,7 +1657,12 @@ static struct ftrace_ops trace_ops __initdata  =
 
 static __init void event_trace_self_test_with_function(void)
 {
-       register_ftrace_function(&trace_ops);
+       int ret;
+       ret = register_ftrace_function(&trace_ops);
+       if (WARN_ON(ret < 0)) {
+               pr_info("Failed to enable function tracer for event tests\n")
+               return;
+       }


I highly doubt that this has anything to do with the bug. The bug is a
race, and that means you can't bisect it with single runs to determine
good and bad. It can only detect bad, but just because it passes,
doesn't actually mean its good.

My search is to see what is being traced again when it shouldn't be.

-- Steve


