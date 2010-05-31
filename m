Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756805Ab0EaJtV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 05:49:21 -0400
Received: from hera.kernel.org ([140.211.167.34]:49470 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756682Ab0EaJtU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 05:49:20 -0400
Message-ID: <4C0385D8.2090107@kernel.org>
Date: Mon, 31 May 2010 11:48:08 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] sched: consult online mask instead of active in select_fallback_rq()
References: <1273747705-7829-1-git-send-email-tj@kernel.org>	 <1273747705-7829-2-git-send-email-tj@kernel.org> <1275292864.27810.21440.camel@twins>
In-Reply-To: <1275292864.27810.21440.camel@twins>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 31 May 2010 09:48:10 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 05/31/2010 10:01 AM, Peter Zijlstra wrote:
> On Thu, 2010-05-13 at 12:48 +0200, Tejun Heo wrote:
>> If called after sched_class chooses a CPU which isn't in a task's
>> cpus_allowed mask, select_fallback_rq() can end up migrating a task
>> which is bound to an !active but online cpu to an active cpu.  This is
>> dangerous because active is cleared before CPU_DOWN_PREPARE is called
>> and subsystems expect affinities of kthreads and other tasks to be
>> maintained till their CPU_DOWN_PREPARE callbacks are complete.
> 
> So 6ad4c188 (sched: Fix balance vs hotplug race) moved it that early
> because it was done too late.
> 
> Could we not instead do it explicitly after CPU_DOWN_PREPARE? It would
> of course mean removing the partition_sched_domain() and
> generate_sched_domains() calls from these callbacks and doing it
> explicitly.
> 
> So we need to do it before we take the CPU down, but I think we can do
> it after DOWN_PREPARE.

Hmm.... yeah, I suppose that would be cleaner.  Maybe doing it from
the lowest priority DOWN_PREPARE notifier would do the trick.  I'll
give it a shot.

>> Consult cpu_online_mask instead.
>>
>> This problem is triggered by cmwq.  During CPU_DOWN_PREPARE, hotplug
>> callback creates the trustee kthread and kthread_bind()s it to the
>> target cpu, and the trustee is expected to run on that cpu.
> 
> It doesn't explain wth a trustee kthread is, which pretty much renders
> the whole paragraph useless.

Come on.  The paragraph makes perfect sense even if you remove the
words "trustee" completely.  It's saying that it's creating a kthread
CPU_DOWN_PREPARE and binds it to the cpu and expects it to stay there.
If you're not completely comfortable with the use of "trustee" without
proper introduction, I'll be happy to remove it, but limited amount of
forward reference is helpful when searching the history backwards.

Thanks.

-- 
tejun
