Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754921Ab2KBOuq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 10:50:46 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:38500 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750954Ab2KBOup (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 10:50:45 -0400
Message-ID: <5093DDBD.4000603@gmail.com>
Date: Fri, 02 Nov 2012 15:50:37 +0100
From: =?ISO-8859-15?Q?David_Nystr=F6m?= <david.c.nystrom@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Christoph Lameter <cl@linux.com>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Clark Williams <clark.williams@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Li Zefan <lizf@cn.fujitsu.com>, Ingo Molnar <mingo@kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Mike Galbraith <efault@gmx.de>
Subject: Re: [PATCH 00/32] [RFC] nohz/cpuset: Start discussions on nohz CPUs
References: <20121029202711.062749374@goodmis.org>  <0000013ac180f152-79f05c71-4d38-43b0-9b62-8a71c00dfda7-000000@email.amazonses.com> <1351867045.4004.141.camel@gandalf.local.home>
In-Reply-To: <1351867045.4004.141.camel@gandalf.local.home>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/02/2012 03:37 PM, Steven Rostedt wrote:
> On Fri, 2012-11-02 at 14:23 +0000, Christoph Lameter wrote:
>> On Mon, 29 Oct 2012, Steven Rostedt wrote:
>>
>>> A while ago Frederic posted a series of patches to get an idea on
>>> how to implement nohz cpusets. Where you can add a task to a cpuset
>>> and mark the set to be 'nohz'. When the task runs on a CPU and is
>>> the only task scheduled (nr_running == 1), the tick will stop.
>>> The idea is to give the task the least amount of kernel interference
>>> as possible. If the task doesn't do any system calls (and possibly
>>> even if it does), no timer interrupt will bother it. By using
>>> isocpus and nohz cpuset, a task would be able to achieve true cpu
>>> isolation.
>>

One other aspect that this patch probably needs to address is the cache 
localization of irq spinlocks.

At least in 3.6, with !CONFIG_SPARSE_IRQ
--
struct  irq_desc irq_desc[NR_IRQS] __cacheline_aligned_in_smp = {
	[0 ... NR_IRQS-1] = {
		.handle_irq	= handle_bad_irq,
		.depth		= 1,
		.lock		= __RAW_SPIN_LOCK_UNLOCKED(irq_desc->lock),
	}
};
--

You are likely to get a cache miss in the top half of your low latency 
CPU anytime some other CPU has taken a spinlock which lies within the 
same cache line.

Or is my understanding of the __cacheline_aligned_in_smp declaration wrong ?

Br,
David

