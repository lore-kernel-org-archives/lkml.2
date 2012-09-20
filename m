Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754041Ab2ITHom (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 03:44:42 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:62873 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753832Ab2ITHoj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 03:44:39 -0400
Message-ID: <505AC979.7000008@gmail.com>
Date: Thu, 20 Sep 2012 09:44:57 +0200
From: Sasha Levin <levinsasha928@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120913 Thunderbird/15.0.1
MIME-Version: 1.0
To: Michael Wang <wangyun@linux.vnet.ibm.com>
CC: paulmck@linux.vnet.ibm.com, Dave Jones <davej@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: RCU idle CPU detection is broken in linux-next
References: <5050CCE0.4090403@gmail.com> <20120919153934.GB2455@linux.vnet.ibm.com> <5059F458.3000407@gmail.com> <20120919170648.GF2455@linux.vnet.ibm.com> <505AC6C8.9060706@linux.vnet.ibm.com>
In-Reply-To: <505AC6C8.9060706@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/20/2012 09:33 AM, Michael Wang wrote:
> On 09/20/2012 01:06 AM, Paul E. McKenney wrote:
>> On Wed, Sep 19, 2012 at 06:35:36PM +0200, Sasha Levin wrote:
>>> On 09/19/2012 05:39 PM, Paul E. McKenney wrote:
>>>> On Wed, Sep 12, 2012 at 07:56:48PM +0200, Sasha Levin wrote:
>>>>>> Hi Paul,
>>>>>>
>>>>>> While fuzzing using trinity inside a KVM tools guest, I've managed to trigger
>>>>>> "RCU used illegally from idle CPU!" warnings several times.
>>>>>>
>>>>>> There are a bunch of traces which seem to pop exactly at the same time and from
>>>>>> different places around the kernel. Here are several of them:
>>>> Hello, Sasha,
>>>>
>>>> OK, interesting.  Could you please try reproducing with the diagnostic
>>>> patch shown below?
>>>
>>> Sure - here are the results (btw, it reproduces very easily):
>>>
>>> [ 13.525119] ================================================
>>> [ 13.527165] [ BUG: lock held when returning to user space! ]
>>> [ 13.528752] 3.6.0-rc6-next-20120918-sasha-00002-g190c311-dirty #362 Tainted: GW
>>> [ 13.531314] ------------------------------------------------
>>> [ 13.532918] init/1 is leaving the kernel with locks still held!
>>> [ 13.534574] 1 lock held by init/1:
>>> [ 13.535533] #0: (rcu_idle){.+.+..}, at: [<ffffffff811c36d0>]
>>> rcu_eqs_enter_common+0x1a0/0x9a0
>>>
>>> I'm basically seeing lots of the above, so I can't even get to the point where I
>>> get the previous lockdep warnings.
>>
>> OK, that diagnostic patch was unhelpful.  Back to the drawing board...
> 
> May be we could first make sure the cpu_idle() behave properly?
> 
> Since according to the log, rcu think cpu is idle while current pid
> is not 0, that could happen if things broken in cpu_idle() which
> is very dependent on platform.
> 
> So check it when idle thread was switched out may could be the first
> step? some thing like below.
> 
> Regards,
> Michael Wang
> 
> diff --git a/kernel/sched/idle_task.c b/kernel/sched/idle_task.c
> index b6baf37..f8c7354 100644
> --- a/kernel/sched/idle_task.c
> +++ b/kernel/sched/idle_task.c
> @@ -43,6 +43,7 @@ dequeue_task_idle(struct rq *rq, struct task_struct *p, int flags)
>  
>  static void put_prev_task_idle(struct rq *rq, struct task_struct *prev)
>  {
> +       WARN_ON(rcu_is_cpu_idle());
>  }
>  
>  static void task_tick_idle(struct rq *rq, struct task_struct *curr, int queued)

Looks like you're on to something, with the small patch above applied:

[   23.514223] ------------[ cut here ]------------
[   23.515496] WARNING: at kernel/sched/idle_task.c:46
put_prev_task_idle+0x1e/0x30()
[   23.517498] Pid: 0, comm: swapper/0 Tainted: G        W
3.6.0-rc6-next-20120919-sasha-00001-gb54aafe-dirty #366
[   23.520393] Call Trace:
[   23.521882]  [<ffffffff8115167e>] ? put_prev_task_idle+0x1e/0x30
[   23.524220]  [<ffffffff81106736>] warn_slowpath_common+0x86/0xb0
[   23.524220]  [<ffffffff81106825>] warn_slowpath_null+0x15/0x20
[   23.524220]  [<ffffffff8115167e>] put_prev_task_idle+0x1e/0x30
[   23.524220]  [<ffffffff839ea61e>] __schedule+0x25e/0x8f0
[   23.524220]  [<ffffffff81175ebd>] ? tick_nohz_idle_exit+0x18d/0x1c0
[   23.524220]  [<ffffffff839ead05>] schedule+0x55/0x60
[   23.524220]  [<ffffffff81078540>] cpu_idle+0x90/0x160
[   23.524220]  [<ffffffff8383043c>] rest_init+0x130/0x144
[   23.524220]  [<ffffffff8383030c>] ? csum_partial_copy_generic+0x16c/0x16c
[   23.524220]  [<ffffffff858acc18>] start_kernel+0x38d/0x39a
[   23.524220]  [<ffffffff858ac5fe>] ? repair_env_string+0x5e/0x5e
[   23.524220]  [<ffffffff858ac326>] x86_64_start_reservations+0x101/0x105
[   23.524220]  [<ffffffff858ac472>] x86_64_start_kernel+0x148/0x157
[   23.524220] ---[ end trace 2c3061ab727afec2 ]---

