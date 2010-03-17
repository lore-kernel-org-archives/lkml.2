Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751962Ab0CQBmK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 21:42:10 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:59913 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751333Ab0CQBmJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 21:42:09 -0400
Message-ID: <4BA03363.8040604@cn.fujitsu.com>
Date: Wed, 17 Mar 2010 09:41:55 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -tip] rcu: local_irq_disable() also delimits RCU_SCHED
 read-site critical sections
References: <4B9F66E1.2060309@cn.fujitsu.com> <20100316132156.GC6709@linux.vnet.ibm.com>
In-Reply-To: <20100316132156.GC6709@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul E. McKenney wrote:
> On Tue, Mar 16, 2010 at 07:09:21PM +0800, Lai Jiangshan wrote:
>> It is documented that local_irq_disable() also delimits
>> RCU_SCHED read-site critical sections.
>> See the document of synchronize_sched() or
>> Documentation/RCU/whatisRCU.txt.
>>
>> So we have to test irqs_disabled() in rcu_read_lock_sched_held().
>> Otherwise rcu-lockdep brings incorrect complaint.
> 
> Interesting -- I was under the impression that preempt_count() covered
> this as well, due to the following in include/linux/hardirq.h:
> 
> 	#define PREEMPT_MASK    (__IRQ_MASK(PREEMPT_BITS) << PREEMPT_SHIFT)
> 	#define SOFTIRQ_MASK    (__IRQ_MASK(SOFTIRQ_BITS) << SOFTIRQ_SHIFT)
> 	#define HARDIRQ_MASK    (__IRQ_MASK(HARDIRQ_BITS) << HARDIRQ_SHIFT)
> 	#define NMI_MASK        (__IRQ_MASK(NMI_BITS)     << NMI_SHIFT)
> 
> But irqs_disabled() does look to sample the actual interrupt hardware.
> 
> So, if there are cases where RCU is used where the interrupt hardware
> is disabled, but preempt_count() has not been updated, this patch is
> the right thing to do.
> 
> 							Thanx, Paul
> 

local_irq_disable() does not touch preempt_count, it touchs
a register of current CPU.

The following quick test module is a case where RCU_SCHED is used where
the interrupt hardware is disabled, but preempt_count() has
not been updated, and it raises rcu-lockdep complaint.

#include <linux/module.h>
#include <linux/hardirq.h>
#include <linux/rcupdate.h>

void *test = &test;

int test_init(void)
{
	local_irq_disable();
	printk(KERN_INFO "%p\n", rcu_dereference_sched(test));
	local_irq_enable();

	return 0;
}

void test_exit(void) {}

module_init(test_init);
module_exit(test_exit);
MODULE_LICENSE("GPL");
