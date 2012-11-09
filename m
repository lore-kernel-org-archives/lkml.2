Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751376Ab2KIF2q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 00:28:46 -0500
Received: from e28smtp08.in.ibm.com ([122.248.162.8]:44150 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750699Ab2KIF2n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 00:28:43 -0500
Message-ID: <509C947F.2000007@linux.vnet.ibm.com>
Date: Fri, 09 Nov 2012 13:28:31 +0800
From: Michael Wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Fengguang Wu <fengguang.wu@intel.com>
CC: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: WARNING: at kernel/rcutree.c:1562 rcu_do_batch()
References: <20121109042330.GA16556@localhost>
In-Reply-To: <20121109042330.GA16556@localhost>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12110905-2000-0000-0000-000009CE2CE3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Fengguang

On 11/09/2012 12:23 PM, Fengguang Wu wrote:
> Paul,
> 
> I got the below warning in stable kernel 3.6.3. linux-next does
> not have this issue. Bisect shows that the first bad commit is

Please allow me to ask few questions:
1. is it 100% sure that linux-next don't show this issue on same hardware?
2. is it 100% sure that when removed commit b1420f1, both WARN in
rcu_do_batch() and __call_rcu() disappeared?

The reason I asked the questions is that this issue looks really similar
to the one we faced previously:
	The interrupt come in after cpu has been offline.

I suppose this is caused by apic issue and no matter with the rcu
before, so I really want to figure out whether it is very related with
commit b1420f1?

Regards,
Michael Wang

> 
> commit b1420f1c8bfc30ecf6380a31d0f686884834b599
> Author: Paul E. McKenney <paul.mckenney@linaro.org>
> Date:   Thu Mar 1 13:18:08 2012 -0800
> 
>     rcu: Make rcu_barrier() less disruptive
> 
> 
> [   92.252733] do_IRQ: 1.59 No irq handler for vector (irq -1)
> [   92.253257] ------------[ cut here ]------------
> [   92.253675] WARNING: at /c/kernel-tests/src/stable/kernel/rcutree.c:1562 rcu_do_batch+0x17e/0x63b()
> [   92.254474] Hardware name: Bochs
> [   92.254766] Modules linked in:
> [   92.256689] Pid: 9, comm: migration/1 Not tainted 3.6.3 #1306
> [   92.256689] Call Trace:
> [   92.256689]  <IRQ>  [<ffffffff81033dbd>] warn_slowpath_common+0x83/0x9c
> [   92.256689]  [<ffffffff81033df0>] warn_slowpath_null+0x1a/0x1c
> [   92.256689]  [<ffffffff810a70fd>] rcu_do_batch+0x17e/0x63b
> [   92.256689]  [<ffffffff810a6705>] ? rcu_report_qs_rnp+0x28b/0x2d5
> [   92.256689]  [<ffffffff810a769d>] ? rcu_process_callbacks+0xe3/0x236
> [   92.256689]  [<ffffffff810a772c>] rcu_process_callbacks+0x172/0x236
> [   92.256689]  [<ffffffff8103b6cc>] __do_softirq+0xf6/0x231
> [   92.256689]  [<ffffffff8107fe2c>] ? tick_program_event+0x24/0x26
> [   92.256689]  [<ffffffff817d23bc>] call_softirq+0x1c/0x30
> [   92.256689]  [<ffffffff81003f7c>] do_softirq+0x4a/0xa6
> [   92.256689]  [<ffffffff8103ba98>] irq_exit+0x51/0xbc
> [   92.256689]  [<ffffffff817d2a2f>] smp_apic_timer_interrupt+0x8b/0x99
> [   92.256689]  [<ffffffff817d1c2f>] apic_timer_interrupt+0x6f/0x80
> [   92.256689]  <EOI>  [<ffffffff81067440>] ? local_clock+0x1d/0x5a
> [   92.256689]  [<ffffffff8109ea37>] ? stop_machine_cpu_stop+0x104/0x119
> [   92.256689]  [<ffffffff8109e6d5>] cpu_stopper_thread+0xdd/0x17d
> [   92.256689]  [<ffffffff8109e933>] ? queue_stop_cpus_work+0x130/0x130
> [   92.256689]  [<ffffffff817ca044>] ? _raw_spin_unlock_irqrestore+0x47/0x65
> [   92.256689]  [<ffffffff81086613>] ? trace_hardirqs_on_caller+0x125/0x181
> [   92.256689]  [<ffffffff8108667c>] ? trace_hardirqs_on+0xd/0xf
> [   92.256689]  [<ffffffff8109e5f8>] ? cpu_stop_signal_done+0x2c/0x2c
> [   92.256689]  [<ffffffff81055e74>] kthread+0x9a/0xa2
> [   92.256689]  [<ffffffff817d22c4>] kernel_thread_helper+0x4/0x10
> [   92.256689]  [<ffffffff817ca4b0>] ? retint_restore_args+0x13/0x13
> [   92.256689]  [<ffffffff81055dda>] ? __init_kthread_worker+0x5a/0x5a
> [   92.317029]  [<ffffffff817d22c0>] ? gs_change+0x13/0x13
> 
> Thanks,
> Fengguang
> 

