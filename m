Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751871Ab2KGIDR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 03:03:17 -0500
Received: from mail-ia0-f174.google.com ([209.85.210.174]:61813 "EHLO
	mail-ia0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751367Ab2KGIDP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 03:03:15 -0500
MIME-Version: 1.0
In-Reply-To: <20121106161742.GJ9966@phenom.dumpdata.com>
References: <1352189295-7111-1-git-send-email-qiumojiong@gmail.com>
	<20121106161742.GJ9966@phenom.dumpdata.com>
Date: Wed, 7 Nov 2012 16:03:15 +0800
Message-ID: <CA+jHL8DfzCpw7mXwrhO6W9KJEj9TVXgRi2NnmQbPMcbBFKzpeA@mail.gmail.com>
Subject: Re: [PATCH] xen/events: xen/events: fix RCU warning
From: =?UTF-8?B?6YKx5qih54Kv?= <qiumojiong@gmail.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: linux-kernel@vger.kernel.org, Mojiong Qiu <mjqiu@tencent.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>, xen-devel@lists.xensource.com,
        virtualization@lists.linux-foundation.org,
        "at least to 3.0.y" <stable@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks Konrad.  You are right, commit 98ad1cc14 missed the xen case.
And before merging, please modify the title a bit. one redundant
"xen/events" there.
"xen/events: xen/events: fix RCU warning"  -> "xen/events: fix RCU warning"

>> Cc: stable@kernel.org (at least to 3.0.y)
>              ^^^- vger.kernel.org
>
> You mean 3.3.x

This is my mistake. 3.0.y is OK. please ignore it.


On Wed, Nov 7, 2012 at 12:17 AM, Konrad Rzeszutek Wilk
<konrad.wilk@oracle.com> wrote:
> On Tue, Nov 06, 2012 at 04:08:15PM +0800, Mojiong Qiu wrote:
>> exit_idle() should be called after irq_enter(), otherwise it throws:
>
> That seems odd - wouldn't "smp_x86_platform_ipi"
> also need the same treatment [edit: I was looking at 3.0 kernel code] ?
>
> Ah, this is caused by
>
> commit 98ad1cc14a5c4fd658f9d72c6ba5c86dfd3ce0d5
> Author: Frederic Weisbecker <fweisbec@gmail.com>
> Date:   Fri Oct 7 18:22:09 2011 +0200
>
>     x86: Call idle notifier after irq_enter()
>
>
> and it missed the xen-case
>
> which means that any kernel v3.3 and newer need this, but earlier do
> not.
>
> Thx. Will put in 3.7 tree.
>
>>
>> [    2.513020] [ INFO: suspicious RCU usage. ]
>> [    2.513076] 3.6.5 #1 Not tainted
>> [    2.513128] -------------------------------
>> [    2.513183] include/linux/rcupdate.h:725 rcu_read_lock() used illegally while idle!
>> [    2.513271]
>> [    2.513271] other info that might help us debug this:
>> [    2.513271]
>> [    2.513388]
>> [    2.513388] RCU used illegally from idle CPU!
>> [    2.513388] rcu_scheduler_active = 1, debug_locks = 1
>> [    2.513511] RCU used illegally from extended quiescent state!
>> [    2.513572] 1 lock held by swapper/0/0:
>> [    2.513626]  #0:  (rcu_read_lock){......}, at: [<ffffffff810e9fe0>] __atomic_notifier_call_chain+0x0/0x140
>> [    2.513815]
>> [    2.513815] stack backtrace:
>> [    2.513897] Pid: 0, comm: swapper/0 Not tainted 3.6.5 #1
>> [    2.513954] Call Trace:
>> [    2.514005]  <IRQ>  [<ffffffff811259a2>] lockdep_rcu_suspicious+0xe2/0x130
>> [    2.514107]  [<ffffffff810ea10c>] __atomic_notifier_call_chain+0x12c/0x140
>> [    2.514169]  [<ffffffff810e9fe0>] ? atomic_notifier_chain_unregister+0x90/0x90
>> [    2.514258]  [<ffffffff811216cd>] ? trace_hardirqs_off+0xd/0x10
>> [    2.514318]  [<ffffffff810ea136>] atomic_notifier_call_chain+0x16/0x20
>> [    2.514381]  [<ffffffff810777c3>] exit_idle+0x43/0x50
>> [    2.514441]  [<ffffffff81568865>] xen_evtchn_do_upcall+0x25/0x50
>> [    2.514503]  [<ffffffff81aa690e>] xen_do_hypervisor_callback+0x1e/0x30
>> [    2.514562]  <EOI>  [<ffffffff810013aa>] ? hypercall_page+0x3aa/0x1000
>> [    2.514662]  [<ffffffff810013aa>] ? hypercall_page+0x3aa/0x1000
>> [    2.514722]  [<ffffffff81061540>] ? xen_safe_halt+0x10/0x20
>> [    2.514782]  [<ffffffff81075cfa>] ? default_idle+0xba/0x570
>> [    2.514841]  [<ffffffff810778af>] ? cpu_idle+0xdf/0x140
>> [    2.514900]  [<ffffffff81a4d881>] ? rest_init+0x135/0x144
>> [    2.514960]  [<ffffffff81a4d74c>] ? csum_partial_copy_generic+0x16c/0x16c
>> [    2.515022]  [<ffffffff82520c45>] ? start_kernel+0x3db/0x3e8
>> [    2.515081]  [<ffffffff8252066a>] ? repair_env_string+0x5a/0x5a
>> [    2.515141]  [<ffffffff82520356>] ? x86_64_start_reservations+0x131/0x135
>> [    2.515202]  [<ffffffff82524aca>] ? xen_start_kernel+0x465/0x46
>>
>> Signed-off-by: Mojiong Qiu <mjqiu@tencent.com>
>> Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
>> Cc: Jeremy Fitzhardinge <jeremy@goop.org>
>> Cc: xen-devel@lists.xensource.com
>> Cc: virtualization@lists.linux-foundation.org
>> Cc: linux-kernel@vger.kernel.org
>> Cc: stable@kernel.org (at least to 3.0.y)
>              ^^^- vger.kernel.org
>
> You mean 3.3.x
>
>> ---
>>  drivers/xen/events.c |    2 +-
>>  1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/drivers/xen/events.c b/drivers/xen/events.c
>> index 912ac81..0be4df3 100644
>> --- a/drivers/xen/events.c
>> +++ b/drivers/xen/events.c
>> @@ -1395,10 +1395,10 @@ void xen_evtchn_do_upcall(struct pt_regs *regs)
>>  {
>>       struct pt_regs *old_regs = set_irq_regs(regs);
>>
>> +     irq_enter();
>>  #ifdef CONFIG_X86
>>       exit_idle();
>>  #endif
>> -     irq_enter();
>>
>>       __xen_evtchn_do_upcall();
>>
>> --
>> 1.6.3.2
