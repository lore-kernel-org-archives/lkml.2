Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756830Ab0EaJzz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 05:55:55 -0400
Received: from hera.kernel.org ([140.211.167.34]:39867 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755985Ab0EaJzy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 05:55:54 -0400
Message-ID: <4C03879A.8030505@kernel.org>
Date: Mon, 31 May 2010 11:55:38 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: mingo@elte.hu, linux-kernel@vger.kernel.org,
       Rusty Russell <rusty@rustcorp.com.au>, Mike Galbraith <efault@gmx.de>
Subject: Re: [PATCH 2/4] sched: implement __set_cpus_allowed()
References: <1273747705-7829-1-git-send-email-tj@kernel.org>	 <1273747705-7829-3-git-send-email-tj@kernel.org> <1275292866.27810.21441.camel@twins>
In-Reply-To: <1275292866.27810.21441.camel@twins>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 31 May 2010 09:55:40 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 05/31/2010 10:01 AM, Peter Zijlstra wrote:
> On Thu, 2010-05-13 at 12:48 +0200, Tejun Heo wrote:
>> Concurrency managed workqueue needs to be able to migrate tasks to a
>> cpu which is online but !active for the following two purposes.
>>
>> p1. To guarantee forward progress during cpu down sequence.  Each
>>     workqueue which could be depended upon during memory allocation
>>     has an emergency worker task which is summoned when a pending work
>>     on such workqueue can't be serviced immediately.  cpu hotplug
>>     callbacks expect workqueues to work during cpu down sequence
>>     (usually so that they can flush them), so, to guarantee forward
>>     progress, it should be possible to summon emergency workers to
>>     !active but online cpus.
> 
> If we do the thing suggested in the previous patch, that is move
> clearing active and rebuilding the sched domains until right after
> DOWN_PREPARE, this goes away, right?

Hmmm... yeah, if the usual set_cpus_allowed_ptr() keeps working
throughout CPU_DOWN_PREPARE, this probably goes away.  I'll give it a
shot.

>> p2. To migrate back unbound workers when a cpu comes back online.
>>     When a cpu goes down, existing workers are unbound from the cpu
>>     and allowed to run on other cpus if there still are pending or
>>     running works.  If the cpu comes back online while those workers
>>     are still around, those workers are migrated back and re-bound to
>>     the cpu.  This isn't strictly required for correctness as long as
>>     those unbound workers don't execute works which are newly
>>     scheduled after the cpu comes back online; however, migrating back
>>     the workers has the advantage of making the behavior more
>>     consistent thus avoiding surprises which are difficult to expect
>>     and reproduce, and being actually cleaner and easier to implement.
> 
> I still don't like this much, if you mark these tasks to simply die when
> the queue is exhausted, and flush the queue explicitly on
> CPU_UP_PREPARE, you should never need to do this.

I don't think flushing from CPU_UP_PREPARE would be a good idea.
There is no guarantee that those works will finish in short (human
scale) time, but we can update cpu_active mask before other
CPU_UP_PREPARE notifiers are executed so that it's symmetrical to cpu
down path and then this problem goes away the exact same way, right?

Thanks.

-- 
tejun
