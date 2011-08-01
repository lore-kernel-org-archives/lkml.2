Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751801Ab1HAO55 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Aug 2011 10:57:57 -0400
Received: from mail-ey0-f171.google.com ([209.85.215.171]:51131 "EHLO
	mail-ey0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750859Ab1HAO5v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Aug 2011 10:57:51 -0400
Message-ID: <4E36BEE5.9060006@gmail.com>
Date: Mon, 01 Aug 2011 16:57:41 +0200
From: Maarten Lankhorst <m.b.lankhorst@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20110707 Thunderbird/5.0
MIME-Version: 1.0
To: Robert Richter <robert.richter@amd.com>
CC: Thomas Gleixner <tglx@linutronix.de>, "x86@kernel.org" <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH v2] oprofile, x86: Move memory allocation for ppro out
 of per cpu
References: <4E35A14E.90702@gmail.com> <20110801070742.GA11795@erda.amd.com>
In-Reply-To: <20110801070742.GA11795@erda.amd.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/01/2011 09:07 AM, Robert Richter wrote:
> On 31.07.11 14:39:10, Maarten Lankhorst wrote:
>> ppro_setup_ctrs is called on all cpu's, while init is only called once.
> Can you please describe the root problem more precisely. Why can't you
> run it on -rt? What is broken?
on -rt it warns about the allocation.
>> Signed-off-by: Maarten Lankhorst <m.b.lankhorst@gmail.com>
>>
>> ---
>> Oprofile shutdown is still broken. Doing kfree in the shutdown call gave
> Do you mean it is broken and your patch fixes it, or is it still
> broken even with your path applied?
With the patch I no longer get the warning on setup_ctrs, but on rt
just starting and shutting down is enough to cause badness. The
original backtrace is below, but here's what happens with it patched.
opcontrol --start and then --shutdown:

[17318.720971] BUG: sleeping function called from invalid context at kernel/rtmutex.c:645
[17318.720972] in_atomic(): 1, irqs_disabled(): 0, pid: 18108, name: opjitconv
[17318.720974] Pid: 18108, comm: opjitconv Tainted: P        WC  3.0.0-rt6-patser+ #5
[17318.720975] Call Trace:
[17318.720979]  [<ffffffff8103fc0a>] __might_sleep+0xca/0xf0
[17318.720981]  [<ffffffff8160d424>] rt_spin_lock+0x24/0x40
[17318.720983]  [<ffffffff811453c3>] kfree+0xd3/0x370
[17318.720985]  [<ffffffffa0c20204>] free_msrs+0x44/0x130 [oprofile]
[17318.720987]  [<ffffffffa0c2037c>] nmi_shutdown+0x8c/0xc0 [oprofile]
[17318.720989]  [<ffffffffa0c1d2b6>] oprofile_shutdown+0x36/0x70 [oprofile]
[17318.720990]  [<ffffffffa0c1e8db>] event_buffer_release+0x1b/0x50 [oprofile]
[17318.720992]  [<ffffffff8115814e>] fput+0xfe/0x240
[17318.720993]  [<ffffffff811546ec>] filp_close+0x6c/0x90
[17318.720995]  [<ffffffff8105a810>] put_files_struct+0xa0/0x120
[17318.720996]  [<ffffffff8105a96c>] exit_files+0x5c/0x70
[17318.720997]  [<ffffffff8105aeaf>] do_exit+0x17f/0x900
[17318.720998]  [<ffffffff8105b9af>] do_group_exit+0x4f/0xd0
[17318.720999]  [<ffffffff8105ba47>] sys_exit_group+0x17/0x20
[17318.721001]  [<ffffffff8161456b>] system_call_fastpath+0x16/0x1b
[17318.721303] slab error in kmem_cache_destroy(): cache `dcookie_cache': Can't free all objects
[17318.721304] Pid: 18108, comm: opjitconv Tainted: P        WC  3.0.0-rt6-patser+ #5
[17318.721305] Call Trace:
[17318.721306]  [<ffffffff81145f4c>] kmem_cache_destroy+0xdc/0x120
[17318.721309]  [<ffffffff811cd4e5>] dcookie_unregister+0x175/0x180
[17318.721310]  [<ffffffffa0c1e8e7>] event_buffer_release+0x27/0x50 [oprofile]
[17318.721312]  [<ffffffff8115814e>] fput+0xfe/0x240
[17318.721313]  [<ffffffff811546ec>] filp_close+0x6c/0x90
[17318.721314]  [<ffffffff8105a810>] put_files_struct+0xa0/0x120
[17318.721315]  [<ffffffff8105a96c>] exit_files+0x5c/0x70
[17318.721316]  [<ffffffff8105aeaf>] do_exit+0x17f/0x900
[17318.721317]  [<ffffffff8105b9af>] do_group_exit+0x4f/0xd0
[17318.721318]  [<ffffffff8105ba47>] sys_exit_group+0x17/0x20
[17318.721319]  [<ffffffff8161456b>] system_call_fastpath+0x16/0x1b

After that opcontrol can no longer start.

>> me a warning of in_atomic, so I moved to exit. This also allowed me to
>> remove the null pointer checks, by zeroing reset_value on shutdown. But
>> even with shutdown being broken on -rt at least I can run oprofile now. :)
> If there is a problem I tend to fix it by using a hard coded array:
>
>  static unsigned long reset_value[OP_MAX_COUNTER];
Ah, that looks better, thanks. I wanted to use a static array,
but didn't know the max value I should use.
> See arch/x86/oprofile/op_model_amd.c.
>
> But still can't see the problem you want to fix.
It gives a warning on rt because it allocates memory in something
that runs on all cpus. I think the OP_MAX_COUNTER fix is fine, since
amd does similar.

~Maarten

Original bug:

[   46.460786] oprofile: using NMI interrupt.
[   47.492263] BUG: sleeping function called from invalid context at kernel/rtmutex.c:645
[   47.492265] in_atomic(): 1, irqs_disabled(): 1, pid: 0, name: kworker/0:1
[   47.492267] Pid: 0, comm: kworker/0:1 Tainted: G         C  3.0.0-rt3-patser+ #39
[   47.492269] Call Trace:
[   47.492270]  <IRQ>  [<ffffffff8103fc0a>] __might_sleep+0xca/0xf0
[   47.492279]  [<ffffffff8160d424>] rt_spin_lock+0x24/0x40
[   47.492282]  [<ffffffff811476c7>] __kmalloc+0xc7/0x370
[   47.492287]  [<ffffffffa0275c85>] ? ppro_setup_ctrs+0x215/0x260 [oprofile]
[   47.492291]  [<ffffffffa0273de0>] ? oprofile_cpu_notifier+0x60/0x60 [oprofile]
[   47.492295]  [<ffffffffa0275c85>] ppro_setup_ctrs+0x215/0x260 [oprofile]
[   47.492305]  [<ffffffffa0273de0>] ? oprofile_cpu_notifier+0x60/0x60 [oprofile]
[   47.492307]  [<ffffffffa0273de0>] ? oprofile_cpu_notifier+0x60/0x60 [oprofile]
[   47.492308]  [<ffffffffa0273ea4>] nmi_cpu_setup+0xc4/0x110 [oprofile]
[   47.492310]  [<ffffffff81094455>] generic_smp_call_function_interrupt+0x95/0x190
[   47.492313]  [<ffffffff8101df77>] smp_call_function_interrupt+0x27/0x40
[   47.492315]  [<ffffffff81615093>] call_function_interrupt+0x13/0x20
[   47.492316]  <EOI>  [<ffffffff8131d0c4>] ? plist_check_head+0x54/0xc0
[   47.492321]  [<ffffffff81371fe8>] ? intel_idle+0xc8/0x120
[   47.492322]  [<ffffffff81371fc7>] ? intel_idle+0xa7/0x120
[   47.492324]  [<ffffffff814a57b0>] cpuidle_idle_call+0xb0/0x230
[   47.492326]  [<ffffffff810011db>] cpu_idle+0x8b/0xe0
[   47.492328]  [<ffffffff815fc82f>] start_secondary+0x1d3/0x1d8

