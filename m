Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751504Ab0DLMbH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Apr 2010 08:31:07 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:60909 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750776Ab0DLMbD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Apr 2010 08:31:03 -0400
Message-ID: <4BC31265.4090503@cn.fujitsu.com>
Date: Mon, 12 Apr 2010 20:30:29 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Oleg Nesterov <oleg@redhat.com>, Gautham R Shenoy <ego@in.ibm.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>, Ingo Molnar <mingo@elte.hu>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Nathan Fontenot <nfont@austin.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, Sachin Sant <sachinp@in.ibm.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Shane Wang <shane.wang@intel.com>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] cpuhotplug: make get_online_cpus() scalability by
 using percpu counter
References: <4BB9BD8A.9040209@cn.fujitsu.com>	 <20100405162901.GA3567@redhat.com> <20100406120039.GC5680@redhat.com>	 <4BBC8A11.3040501@cn.fujitsu.com> <20100407135456.GA12029@redhat.com>	 <20100409121235.GA5784@redhat.com>  <4BC2E6CE.7060401@cn.fujitsu.com> <1271064539.4222.27.camel@twins>
In-Reply-To: <1271064539.4222.27.camel@twins>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:
> On Mon, 2010-04-12 at 17:24 +0800, Lai Jiangshan wrote:
>> Oleg Nesterov wrote:
>>> On 04/07, Oleg Nesterov wrote:
>>>> On 04/07, Lai Jiangshan wrote:
>>>>> Old get_online_cpus() is read-preference, I think the goal of this ability
>>>>> is allow get_online_cpus()/put_online_cpus() to be called nested.
>>>> Sure, I understand why you added task_struct->get_online_cpus_nest.
>>>>
>>>>> and use per-task counter for allowing get_online_cpus()/put_online_cpus()
>>>>> to be called nested, I think this deal is absolutely worth.
>>>> As I said, I am not going to argue. I can't justify this tradeoff.
>>> But, I must admit, I'd like to avoid adding the new member to task_struct.
>>>
>>> What do you think about the code below?
>>>
>>> I didn't even try to compile it, just to explain what I mean.
>>>
>>> In short: we have the per-cpu fast counters, plus the slow counter
>>> which is only used when cpu_hotplug_begin() is in progress.
>>>
>>> Oleg.
>>>
>> get_online_cpus() in your code is still read-preference.
>> I wish we quit this ability of get_online_cpus().
> 
> Why?

Because read-preference RWL will cause write site starvation.

A user run the following code will cause cpuhotplug starvation.
(100 processes run sched_setaffinity().)

Lai

#define _GNU_SOURCE
#include <sched.h>
#include <sys/types.h>
#include <unistd.h>
#include <stdlib.h>

#define NCPU 4
#define NPROCESS 100

cpu_set_t set;
pid_t target;

void stress_test(void)
{
	int cpu;

	srand((int)target);
	for (;;) {
		cpu = rand() % NCPU;
		CPU_SET(cpu, &set);
		sched_setaffinity(target, sizeof(set), &set);
		CPU_CLR(cpu, &set);
	}
}

int main(int argc, char *argv[])
{
	pid_t ret;
	int i;

	target = getpid();
	for (i = 1; i < NPROCESS; i++) {
		ret = fork();
		if (ret < 0)
			break;
		else if (ret)
			target = ret;
		else
			stress_test();
	}

	stress_test();
}



