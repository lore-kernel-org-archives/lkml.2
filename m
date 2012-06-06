Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754557Ab2FFHVl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 03:21:41 -0400
Received: from mga01.intel.com ([192.55.52.88]:50703 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751410Ab2FFHVj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 03:21:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="161589482"
Message-ID: <4FCF0500.9050704@linux.intel.com>
Date: Wed, 06 Jun 2012 15:21:36 +0800
From: Chen Gong <gong.chen@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: LKML <linux-kernel@vger.kernel.org>, tony.luck@intel.com, bp@amd64.org,
        x86@kernel.org, Peter Zijlstra <peterz@infradead.org>
Subject: Re: [patch 2/2] x86: mce: Implement cmci poll mode for intel machines
References: <20120524174943.989990966@linutronix.de> <20120524175056.478167482@linutronix.de> <4FCC1F7C.5000008@linux.intel.com> <alpine.LFD.2.02.1206042158200.3086@ionos> <4FCDF1C8.9020007@linux.intel.com> <alpine.LFD.2.02.1206051503560.3086@ionos>
In-Reply-To: <alpine.LFD.2.02.1206051503560.3086@ionos>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2012/6/5 21:35, Thomas Gleixner 写道:
> On Tue, 5 Jun 2012, Chen Gong wrote:
>> 于 2012/6/5 4:01, Thomas Gleixner 写道:
>>> On Mon, 4 Jun 2012, Chen Gong wrote:
>>>  static void mce_timer_fn(unsigned long data)
>>>  {
>>> ...
>>> +	/* Might have become 0 after CMCI storm subsided */
>>> +	if (iv) {
>>> +		t->expires = jiffies + iv;
>>> +		add_timer_on(t, smp_processor_id());
>>> +	}
>>> +}
>> I've found under some conditions, *t* is pending on the timer tree, so
>> add_timer_on will crash the whole system. Furthermore, if this timer
> How should that happen? This is the timer callback function, which is
> called from the timer code when the timer expired. It CANNOT be
> pending at that point. The add_timer_on() in mce_timer_kick() might
> cause that BUG to trigger, but definitely not the one here in the
> timer callback.
>
>> function triggers "WARN_ON(smp_processor_id() != data);", this timer
> What causes the timer to be added on the wrong CPU in the first place?
> The WARN_ON meriliy detects it after the fact.

Yes, I've checked CPU status when these timers are registered. The CPU these
timers adhere and *data* they saved are equal. But the fact is the issu does
happen.  I have no idea of it:-(.

e.g.

------------[ cut here ]------------
kernel BUG at kernel/timer.c:919!
invalid opcode: 0000 [#1] SMP
CPU 0
Modules linked in: autofs4 sunrpc cpufreq_ondemand acpi_cpufreq
freq_table mperf ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 xt_state
nf_conntrack ip6table_filter ip6_tables ipv6 dm_mirror dm_region_hash
dm_log dm_mod coretemp kvm crc32c_intel ghash_clmulni_intel microcode
pcspkr sb_edac edac_core sg wmi lpc_ich mfd_core igb ioatdma dca
i2c_i801 i2c_core ext4 mbcache jbd2 sd_mod crc_t10dif sr_mod cdrom
aesni_intel cryptd aes_x86_64 aes_generic ahci libahci isci libsas
scsi_transport_sas [last unloaded: scsi_wait_scan]

Pid: 0, comm: swapper/0 Not tainted 3.5.0-rc1storm-thomas+ #39 Intel
Corporation S2600CP/S2600CP
RIP: 0010:[<ffffffff8105fbad>]  [<ffffffff8105fbad>] add_timer_on+0xcd/0x120
RSP: 0018:ffff88013ee03da0  EFLAGS: 00010286
RAX: 000000000000e208 RBX: ffff88013ee0d940 RCX: 0000000000001857
RDX: ffff88013ef40000 RSI: 0000000000000000 RDI: ffff88013ee0d940
RBP: ffff88013ee03de0 R08: 0000000000000000 R09: ffffffff8163ad80
R10: 0000000000000060 R11: 0000000000000001 R12: ffff880139700000
R13: 000000000000000a R14: 0000000100016638 R15: 000000000000000a
FS:  0000000000000000(0000) GS:ffff88013ee00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 00000030eda73000 CR3: 0000000001a0b000 CR4: 00000000000407f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process swapper/0 (pid: 0, threadinfo ffffffff81a00000, task
ffffffff81a13420)
Stack:
 ffff88013ee03db0 ffffffff8106b6aa 0000000000000000 ffff88013ee0d940
 000000000000000a 0000000000000000 0000000100016638 000000000000000a
 ffff88013ee03e10 ffffffff8102c2d4 0000000000000100 ffffffff8102c200
Call Trace:
 <IRQ>
 [<ffffffff8106b6aa>] ? __queue_work+0x10a/0x430
 [<ffffffff8102c2d4>] mce_timer_fn+0xd4/0x190
 [<ffffffff8102c200>] ? machine_check_poll+0x180/0x180
 [<ffffffff8105f9f9>] call_timer_fn+0x49/0x130
 [<ffffffff8102c200>] ? machine_check_poll+0x180/0x180
 [<ffffffff8105fe03>] run_timer_softirq+0x143/0x280
 [<ffffffff8109f148>] ? ktime_get+0x68/0xf0
 [<ffffffff81058017>] __do_softirq+0xb7/0x210
 [<ffffffff81077b72>] ? hrtimer_interrupt+0x152/0x240
 [<ffffffff8151ea5c>] call_softirq+0x1c/0x30
 [<ffffffff81015335>] do_softirq+0x65/0xa0
 [<ffffffff81057e1d>] irq_exit+0xbd/0xe0
 [<ffffffff8151f39e>] smp_apic_timer_interrupt+0x6e/0x99
 [<ffffffff8151e10a>] apic_timer_interrupt+0x6a/0x70
 <EOI>
 [<ffffffff812b2f9d>] ? intel_idle+0xdd/0x150
 [<ffffffff812b2f83>] ? intel_idle+0xc3/0x150
 [<ffffffff8140c939>] cpuidle_enter+0x19/0x20
 [<ffffffff8140d174>] cpuidle_idle_call+0xd4/0x1d0
 [<ffffffff8101bd7f>] cpu_idle+0xcf/0x120
 [<ffffffff814fa475>] rest_init+0x75/0x80
 [<ffffffff81b00f52>] start_kernel+0x3e2/0x3ef
 [<ffffffff81b0098e>] ? kernel_init+0x27b/0x27b
 [<ffffffff81b00356>] x86_64_start_reservations+0x131/0x136
 [<ffffffff81b0045e>] x86_64_start_kernel+0x103/0x112
Code: 4c 89 e7 e8 76 54 4b 00 48 8b 5d d8 4c 8b 65 e0 4c 8b 6d e8 4c 8b
75 f0 4c 8b 7d f8 c9 c3 f6 43 18 01 75 c5 4d 89 7c 24 18 eb be <0f> 0b
90 eb fd 48 8b 75 08 e8 b5 fc ff ff e9 6b ff ff ff 4c 8b
RIP  [<ffffffff8105fbad>] add_timer_on+0xcd/0x120
 RSP <ffff88013ee03da0>


I add some print in timer callback, it shows:

smp_processor_id() = 0, mce_timer_fn data(CPU id) = 10
timer->function = ffffffff8102c200, timer pending = 1, CPU = 0
(add_timer_on, BUG!!!)

In fact, CPU0 and CPU10 on different socket, and the error happens on
the socket including
CPU10. I'm afraid it is still related to CMCI broadcast, but CMCI
doesn't spread out
of the socket, so I have no idea about it :-(

>
>> will be added on the other CPU, which means it loses the chance to
>> decrement *cmci_storm_on_cpus* to zero to reenable the CMCI. Maybe
>> this situation happens seldomly, but once it happens, CMCI will never
>> be actived again after it is disabled.
>>
>>> +void mce_timer_kick(unsigned long interval)
>>> +{
>>> +	struct timer_list *t = &__get_cpu_var(mce_timer);
>>> +	unsigned long when = jiffies + interval;
>>> +	unsigned long iv = __this_cpu_read(mce_next_interval);
>>> +
>>> +	if (time_before(when, t->expires) && timer_pending(t)) {
>>> +		mod_timer(t, when);
>>> +	} else if (!mce_next_interval) {
>>> +		t->expires = round_jiffies(jiffies + iv);
>>> +		add_timer_on(t, smp_processor_id());
>> I've changed "else if (!mce_next_interval)" to "else if (iv)", but
>   else if (!iv) perhaps ?

If so, iv = 0, which means this timer will be executed right now after
add_timer_on.

>
>> I still think it is not right. Imaging *when* is after t->expires and
>> this timer is pending on the timer tree, so it will hit *else if*
>> if iv is not zero(common situations), again, add_timer_on will trigger
>> BUG_ON because this timer is pending.
> See above. Aside of that I rewrote the code to be more clear. See
> delta patch below.
>  
>>>  static void intel_threshold_interrupt(void)
>>>  {
>>> +	if (cmci_storm_detect())
>>> +		return;
>>>  	machine_check_poll(MCP_TIMESTAMP, &__get_cpu_var(mce_banks_owned));
>>>  	mce_notify_irq();
>>>  }
>> I think cmci_storm_detect should be placed in the machine_check_poll,
>> not out of it. Because machine_check_poll it the core execution logic
>> for CMCI handling, in the meanwhile, poll timer and mce-inject module
>> call machine_check_poll at any time. If poll timer or mce-inject run
>> too quickly, the CMCI handler has trouble. Whereas, if
>> cmci_storm_detect is in the machine_check_poll, this kind of possibility
>> can be avoid.
> No, it's wrong to put it into machine_check_poll(). 
>
> machine_check_poll() is a generic functionality which has nothing to
> do with CMCI storms. That CMCI storm/poll stuff is intel specific and
> therefor the detection logic is in the intel specific interrupt
> handler and nowhere else.

Gotta it, I'm just afraid something else, please see my another mail replied
for Boris.

>
> Thanks,
>
> 	tglx
> ---
>  arch/x86/kernel/cpu/mcheck/mce.c |   11 ++++++-----
>  1 file changed, 6 insertions(+), 5 deletions(-)
>
> Index: linux-2.6/arch/x86/kernel/cpu/mcheck/mce.c
> ===================================================================
> --- linux-2.6.orig/arch/x86/kernel/cpu/mcheck/mce.c
> +++ linux-2.6/arch/x86/kernel/cpu/mcheck/mce.c
> @@ -1305,13 +1305,14 @@ void mce_timer_kick(unsigned long interv
>  	unsigned long when = jiffies + interval;
>  	unsigned long iv = __this_cpu_read(mce_next_interval);
>  
> -	if (time_before(when, t->expires) && timer_pending(t)) {
> -		mod_timer(t, when);
> -	} else if (!mce_next_interval) {
> -		t->expires = round_jiffies(jiffies + iv);
> +	if (timer_pending(t)) {
> +		if (time_before(when, t->expires))
> +			mod_timer(t, when);
> +	} else {
> +		t->expires = round_jiffies(jiffies + when);

should be "t->expires = round_jiffies(when);"
>  		add_timer_on(t, smp_processor_id());
>  	}
> -	if (interval < iv)
> +	if (interval > iv)
>  		__this_cpu_write(mce_next_interval, iv);
>  }
>  
Strange, anyway, mce_next_interval should be updated in proper way, but
if using above logic, mce_next_interval doesn't make change. I prefer
if (interval < iv)
    __this_cpu_write(mce_next_interval, interval);

In fact, during my test, I wrote the similar codes to do the test, but
it can't fix the bug. The logic here is not the key, no matter how you set
timer, you can get a poll timer. The issue happens in the timer function
itself. Once timer callback is entered, the issue happens every time.
