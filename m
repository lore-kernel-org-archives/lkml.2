Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754839Ab0JVHbH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 03:31:07 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:63393 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754126Ab0JVHbF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 03:31:05 -0400
Message-ID: <4CC13EB1.6020800@cn.fujitsu.com>
Date: Fri, 22 Oct 2010 15:35:13 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.9) Gecko/20100423 Thunderbird/3.0.4
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2 v2] rcu,cleanup: simplify the code when cpu is dying
References: <4CBE8872.1010905@cn.fujitsu.com> <20101020192503.GH2386@linux.vnet.ibm.com>
In-Reply-To: <20101020192503.GH2386@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/21/2010 03:25 AM, Paul E. McKenney wrote:
> On Wed, Oct 20, 2010 at 02:13:06PM +0800, Lai Jiangshan wrote:
>> When we handle cpu notify DYING, the whole system is stopped except
>> current CPU, so we can touch any data, and we remove the orphan_cbs_tail
>> and send the callbacks to the dest CPU directly.
> 
> Queued along with the documentation/comment patch below, thank you!!!
> (Of course, please let me know if you see problems with my patch.)

Your patch is good for me, please queue it, thanks.

> 
> One remaining question...  You use cpumask_any() to select the destination
> CPU, which sounds good until you look at its definition.  The problem
> is that cpumask_any() always chooses the lowest-numbered online CPU.
> So imagine a (say) 64-CPU system and suppose that CPU 0 remains online.
> Suppose further that the other 63 CPUs each execute some workload that
> generates lots of RCU callbacks (perhaps creating then removing a large
> source tree), and periodically go offline and come back online.
> 
> All of the RCU callbacks from CPUs 1-63 could easily end up getting
> dumped onto CPU 0's callback lists.  It is easy to imagine that CPU 0
> might not be able to invoke these callbacks as fast as the other CPUs
> could generate them.
> 
> Or am I missing something?


It happens in the worst case. It may also happen before this patch.

Before this patch, the callback move to the receive-CPU who handles the CPU_DEAD
event, and this CPU may be always cpu#0 in the worst case, the problem happens.

And it's not help if I introduce a choose_receive_cpu_very_smart(),
Suppose further that the other 63 CPUs each execute some workload that
generates lots of RCU callbacks (perhaps creating then removing a large
source tree), and periodically go offline and come back online. In worse
case, in some period, there is only cpu#0 online, So all of the RCU callbacks
from CPUs 1-63 could easily end up getting dumped onto CPU 0's callback lists. 
It is easy to imagine that CPU 0 might not be able to invoke these callbacks
as fast as the other CPUs could generate them.

Another bad case(it may happens without this patch/with this patch
/with choose_receive_cpu_very_smart()):
	Live-Lock, suppose cpu#A and cpu#B periodically go offline and come
	back online, the callback may be moved from A to B and from B to A
	periodically, no callback is handled.

To fix these problems(it does really very hardly happen), we must force
all adopted callbacks are called before next cpu-offline. so we can use
work_on_cpu() or rcu_barrier() to do this. To make the code simpler, I will
use rcu_barrier().

Thanks.
Lai
