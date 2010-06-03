Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933557Ab0FCJTi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 05:19:38 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:49206 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S933264Ab0FCJTg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 05:19:36 -0400
Message-ID: <4C07743C.7030204@cn.fujitsu.com>
Date: Thu, 03 Jun 2010 17:22:04 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: Daniel J Blueman <daniel.blueman@gmail.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] RCU: don't turn off lockdep when find suspicious rcu_dereference_check()
 usage
References: <AANLkTinNygSdXsg3vAVRHttAMh6nX4tauNKn3XnfQC_x@mail.gmail.com> <20100602145653.GA2385@linux.vnet.ibm.com>
In-Reply-To: <20100602145653.GA2385@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul E. McKenney wrote:
> On Tue, Jun 01, 2010 at 02:06:13PM +0100, Daniel J Blueman wrote:
>> Hi Paul,
>>
>> With 2.6.35-rc1 and your patch in the context below, we still see
>> "include/linux/cgroup.h:534 invoked rcu_dereference_check() without
>> protection!", so need this additional patch:
>>
>> Acquire read-side RCU lock around task_group() calls, addressing
>> "include/linux/cgroup.h:534 invoked rcu_dereference_check() without
>> protection!" warning.
>>
>> Signed-off-by: Daniel J Blueman <daniel.blueman@gmail.com>
> 
> Thank you, Daniel!  I have queued this for 2.6.35.
> 
> I had to apply the patch by hand due to line wrapping.  Could you please
> check your email-agent settings?  This simple patch was no problem to
> hand apply, but for a larger patch this process would be both tedious
> and error prone.
> 
> 							Thanx, Paul
> 
>> diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
>> index 217e4a9..50ec9ea 100644
>> --- a/kernel/sched_fair.c
>> +++ b/kernel/sched_fair.c
>> @@ -1241,6 +1241,7 @@ static int wake_affine(struct sched_domain *sd,
>> struct task_struct *p, int sync)
>>  	 * effect of the currently running task from the load
>>  	 * of the current CPU:
>>  	 */
>> +	rcu_read_lock();
>>  	if (sync) {
>>  		tg = task_group(current);
>>  		weight = current->se.load.weight;
>> @@ -1250,6 +1251,7 @@ static int wake_affine(struct sched_domain *sd,
>> struct task_struct *p, int sync)
>>  	}
>>
>>  	tg = task_group(p);
>> +	rcu_read_unlock();

Hmmm.. I think it's not safe to access tg after rcu_read_unlock.

>>  	weight = p->se.load.weight;
>>
>>  	imbalance = 100 + (sd->imbalance_pct - 100) / 2;
>>
