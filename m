Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755839Ab2AQUms (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 15:42:48 -0500
Received: from merlin.infradead.org ([205.233.59.134]:34033 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755751Ab2AQUmp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 15:42:45 -0500
Message-ID: <4F15DD40.5040200@kernel.dk>
Date: Tue, 17 Jan 2012 21:42:40 +0100
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>
CC: linux kernel mailing list <linux-kernel@vger.kernel.org>,
        Tejun Heo <tj@kernel.org>
Subject: Re: Kernel crash in icq_free_icq_rcu
References: <20120117201823.GD19223@redhat.com> <4F15D7D0.2040203@kernel.dk> <20120117204053.GE19223@redhat.com>
In-Reply-To: <20120117204053.GE19223@redhat.com>
X-Enigmail-Version: 1.3.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-01-17 21:40, Vivek Goyal wrote:
> On Tue, Jan 17, 2012 at 09:19:28PM +0100, Jens Axboe wrote:
>> On 2012-01-17 21:18, Vivek Goyal wrote:
>>> Hi Tejun,
>>>
>>> With latest linus kernel, I see following crash. I was running some
>>> scripts which create cgroups and launch fio jobs in those groups. In
>>> a separate window I wrote a script to change the IO scheduler on the
>>> device in a loop while IO was happening on the device. After few
>>> seconds I see following. So far I tried it twice and reproduced it
>>> both the times in first few seconds.
>>>
>>> Thanks
>>> Vivek
>>>
>>>
>>> [   94.217015] BUG: unable to handle kernel NULL pointer dereference at 000000000000001c
>>> [   94.218004] IP: [<ffffffff81142fae>] kmem_cache_free+0x5e/0x200
>>> [   94.218004] PGD 13abda067 PUD 137d52067 PMD 0 
>>> [   94.218004] Oops: 0000 [#1] SMP DEBUG_PAGEALLOC
>>> [   94.218004] CPU 0 
>>> [   94.218004] Modules linked in: [last unloaded: scsi_wait_scan]
>>> [   94.218004] 
>>> [   94.218004] Pid: 0, comm: swapper/0 Not tainted 3.2.0+ #16 Hewlett-Packard HP xw6600 Workstation/0A9Ch
>>> [   94.218004] RIP: 0010:[<ffffffff81142fae>]  [<ffffffff81142fae>] kmem_cache_free+0x5e/0x200
>>> [   94.218004] RSP: 0018:ffff88013fc03de0  EFLAGS: 00010006
>>> [   94.218004] RAX: ffffffff81e0d020 RBX: ffff880138b3c680 RCX: 00000001801c001b
>>> [   94.218004] RDX: 00000000003aac1d RSI: ffff880138b3c680 RDI: ffffffff81142fae
>>> [   94.218004] RBP: ffff88013fc03e10 R08: ffff880137830238 R09: 0000000000000001
>>> [   94.218004] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
>>> [   94.218004] R13: ffffea0004e2cf00 R14: ffffffff812f6eb6 R15: 0000000000000246
>>> [   94.218004] FS:  0000000000000000(0000) GS:ffff88013fc00000(0000) knlGS:0000000000000000
>>> [   94.218004] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
>>> [   94.218004] CR2: 000000000000001c CR3: 00000001395ab000 CR4: 00000000000006f0
>>> [   94.218004] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>>> [   94.218004] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
>>> [   94.218004] Process swapper/0 (pid: 0, threadinfo ffffffff81e00000, task ffffffff81e0d020)
>>> [   94.218004] Stack:
>>> [   94.218004]  0000000000000102 ffff88013fc0db20 ffffffff81e22700 ffff880139500f00
>>> [   94.218004]  0000000000000001 000000000000000a ffff88013fc03e20 ffffffff812f6eb6
>>> [   94.218004]  ffff88013fc03e90 ffffffff810c8da2 ffffffff81e01fd8 ffff880137830240
>>> [   94.218004] Call Trace:
>>> [   94.218004]  <IRQ> 
>>> [   94.218004]  [<ffffffff812f6eb6>] icq_free_icq_rcu+0x16/0x20
>>> [   94.218004]  [<ffffffff810c8da2>] __rcu_process_callbacks+0x1c2/0x420
>>> [   94.218004]  [<ffffffff810c9038>] rcu_process_callbacks+0x38/0x250
>>> [   94.218004]  [<ffffffff810405ee>] __do_softirq+0xce/0x3e0
>>> [   94.218004]  [<ffffffff8108ed04>] ? clockevents_program_event+0x74/0x100
>>> [   94.218004]  [<ffffffff81090104>] ? tick_program_event+0x24/0x30
>>> [   94.218004]  [<ffffffff8183ed1c>] call_softirq+0x1c/0x30
>>> [   94.218004]  [<ffffffff8100422d>] do_softirq+0x8d/0xc0
>>> [   94.218004]  [<ffffffff81040c3e>] irq_exit+0xae/0xe0
>>> [   94.218004]  [<ffffffff8183f4be>] smp_apic_timer_interrupt+0x6e/0x99
>>> [   94.218004]  [<ffffffff8183e330>] apic_timer_interrupt+0x70/0x80
>>> [   94.218004]  <EOI> 
>>> [   94.218004]  [<ffffffff8100a806>] ? mwait_idle+0xb6/0x4c0
>>> [   94.218004]  [<ffffffff8100a7fd>] ? mwait_idle+0xad/0x4c0
>>> [   94.218004]  [<ffffffff810011e6>] cpu_idle+0x96/0xe0
>>> [   94.218004]  [<ffffffff818064df>] rest_init+0x133/0x144
>>> [   94.218004]  [<ffffffff81806425>] ? rest_init+0x79/0x144
>>> [   94.218004]  [<ffffffff81ed4b51>] start_kernel+0x35b/0x366
>>> [   94.218004]  [<ffffffff81ed4321>] x86_64_start_reservations+0x131/0x135
>>> [   94.218004]  [<ffffffff81ed4415>] x86_64_start_kernel+0xf0/0xf7
>>> [   94.218004] Code: f3 e8 97 cb ee ff 48 c1 e8 0c 48 c1 e0 06 49 01 c5 49 8b 45 00 f6 c4 80 0f 85 99 00 00 00 4c 8b 75 08 9c 41 5f fa e8 12 f8 f4 ff <49> 63 74 24 1c 48 89 df e8 e5 4b f5 ff 41 f7 c7 00 02 00 00 74 
>>> [   94.218004] RIP  [<ffffffff81142fae>] kmem_cache_free+0x5e/0x200
>>> [   94.218004]  RSP <ffff88013fc03de0>
>>> [   94.218004] CR2: 000000000000001c
>>
>> Can you try this?
> 
> Nope, this does not help either. Can reproduce the issue with below
> patch applied.
> 
>>
>>
>> diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
>> index 163263d..ee55019 100644
>> --- a/block/cfq-iosched.c
>> +++ b/block/cfq-iosched.c
>> @@ -3117,18 +3117,17 @@ cfq_should_preempt(struct cfq_data *cfqd, struct cfq_queue *new_cfqq,
>>   */
>>  static void cfq_preempt_queue(struct cfq_data *cfqd, struct cfq_queue *cfqq)
>>  {
>> -	struct cfq_queue *old_cfqq = cfqd->active_queue;
>> -
>>  	cfq_log_cfqq(cfqd, cfqq, "preempt");
>> -	cfq_slice_expired(cfqd, 1);
>>  
>>  	/*
>>  	 * workload type is changed, don't save slice, otherwise preempt
>>  	 * doesn't happen
>>  	 */
>> -	if (cfqq_type(old_cfqq) != cfqq_type(cfqq))
>> +	if (cfqq_type(cfqd->active_queue) != cfqq_type(cfqq))
>>  		cfqq->cfqg->saved_workload_slice = 0;
>>  
>> +	cfq_slice_expired(cfqd, 1);
>> +
> 
> cfq_slice_expired() will overwrite the value of
> cfqq->cfqg->saved_workload_slice. So we need to set it to zero after
> cfq_slice_expired.

Good point, lets just fix that up afterwards, the use-after-free needs
to go asap.

> I was thinking of just saving the workload type of cfqq before
> cfq_slice_expired() so that we don't access old cfqq after
> cfq_slice_expired(). But then I noticed that we don't drop a cfqq
> reference in cfq_slice_expired(). So not sure how cfq_slice_expired()
> can lead to freeing up of queue. It should happen only when process
> has exited and last request on the queue if finished. 

It does, it drops a ref to the cic which in turn drops the active async
and sync queues.

Out for tonight, will pick this up in the morning.

-- 
Jens Axboe

