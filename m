Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751496Ab1ENFtN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 May 2011 01:49:13 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:54872 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751278Ab1ENFtJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 May 2011 01:49:09 -0400
Message-ID: <4DCE17AB.4090002@linux.vnet.ibm.com>
Date: Sat, 14 May 2011 13:48:27 +0800
From: Cheng Xu <chengxu@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.2.17) Gecko/20110414 Thunderbird/3.1.10
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Ingo Molnar <mingo@elte.hu>, Paul Mckenney <paulmck@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] sched: rt_rq runtime leakage bug fix
References: <4DCA3C0C.3080901@linux.vnet.ibm.com> <1305105711.2914.205.camel@laptop>  <4DCAC79A.7050505@linux.vnet.ibm.com> <1305195150.2914.268.camel@laptop>
In-Reply-To: <1305195150.2914.268.camel@laptop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-5-12 18:12, Peter Zijlstra wrote:
> 
> it would be nice to know why the , operator version
> doesn't work though, since that looks to be the more conventional way to
> write it.
> 

I did some investigation, it looks that, 

1 #define for_each_rt_rq(rt_rq, iter, rq)                                   \
2	for (iter = list_entry_rcu(task_groups.next, typeof(*iter), list),  \
3	     rt_rq = iter->rt_rq[cpu_of(rq)]; &iter->list != &task_groups;  \
4	     iter = list_entry_rcu(iter->list.next, typeof(*iter), list),   \
5	     rt_rq = iter->rt_rq[cpu_of(rq)])

in for loop, when task_groups (as sentinel node of the doubly linked circular list) is reached after the final iteration, a fake iter (of struct task_group *) is calculated at line 4 via container_of(&task_groups, struct task_group, list). By "fake", as we know, it is just an address, with &iter->list == &task_groups, but not pointing to a true struct task_group object. Accessing other members of fake iter might be the cause of page fault. 

In my JS22 blade, cpu_of(rq)=1 and fake iter->rt_rq happens to be 0x100000000, value of another global variable near task_groups. Kernel tries to take it plus 8 as address, to retrieve iter->rt_rq[1]. and then page fault happens at address 0x100000008. 
