Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754848Ab1EJKx1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 06:53:27 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:57109 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752381Ab1EJKxZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 06:53:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=mXkF2q0/Vv+l/X9C51drNBon/RPfsH5TQIdBCPcCsD6t57QMz92ZqTJwyBe7l5PBIj
         0YuPiwsUf5/GZ8NHo2VgR5e1bo++60L6pnieIRamEvhgT+tDe8dghpC4SpXaDLBCJhg7
         tHaaSt0uCBdk7uCKstNFHlRwwZEKGTx/rx+Z0=
MIME-Version: 1.0
In-Reply-To: <20110510073551.GH11595@elte.hu>
References: <1304908814-23369-1-git-send-email-daniel.blueman@gmail.com>
	<20110510073551.GH11595@elte.hu>
Date: Tue, 10 May 2011 18:53:24 +0800
Message-ID: <BANLkTik0GTwV0Z21+UO69JX0cqjxwqu7jw@mail.gmail.com>
Subject: Re: [PATCH] ioapic: fix potential resume deadlock
From: Daniel J Blueman <daniel.blueman@gmail.com>
To: Suresh Siddha <suresh.b.siddha@intel.com>, Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        H Peter Anvin <hpa@zytor.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10 May 2011 15:35, Ingo Molnar <mingo@elte.hu> wrote:
> * Daniel J Blueman <daniel.blueman@gmail.com> wrote:
>
>> Fix a potential deadlock when resuming; here the calling function
>> has disabled interrupts, so we cannot sleep.
>>
>> Signed-off-by: Daniel J Blueman <daniel.blueman@gmail.com>
>>
>> ---
>>  arch/x86/kernel/apic/io_apic.c |    4 ++--
>>  1 files changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
>> index 45fd33d..df63620 100644
>> --- a/arch/x86/kernel/apic/io_apic.c
>> +++ b/arch/x86/kernel/apic/io_apic.c
>> @@ -621,14 +621,14 @@ struct IO_APIC_route_entry **alloc_ioapic_entries(void)
>>       struct IO_APIC_route_entry **ioapic_entries;
>>
>>       ioapic_entries = kzalloc(sizeof(*ioapic_entries) * nr_ioapics,
>> -                             GFP_KERNEL);
>> +                             GFP_ATOMIC);
>>       if (!ioapic_entries)
>>               return 0;
>>
>>       for (apic = 0; apic < nr_ioapics; apic++) {
>>               ioapic_entries[apic] =
>>                       kzalloc(sizeof(struct IO_APIC_route_entry) *
>> -                             nr_ioapic_registers[apic], GFP_KERNEL);
>> +                             nr_ioapic_registers[apic], GFP_ATOMIC);
>>               if (!ioapic_entries[apic])
>>                       goto nomem;
>>       }
>
> Hm, there must be some other bug here.
>
> ioapic entries should be allocated on system bootup and should never really be
> deallocated.
>
> The bug might be in the idea to call to enable_IR_x2apic() on resume - why are
> ioapic entries reallocated there? That call in default_setup_apic_routing() was
> introduced some time ago in:
>
>  fa47f7e52874: x86, x2apic: Simplify apic init in SMP and UP builds
>
> and that it results in reallocation in the suspend patch is distinctly wrong.
>
> I suspect the reason why this has not triggered for others is the relative
> rarity of affected systems?
>
> Suresh?

For reference, this is the warning I get on resume with debugging enabled:

BUG: sleeping function called from invalid context at mm/slub.c:824
in_atomic(): 0, irqs_disabled(): 1, pid: 1842, name: pm-suspend
INFO: lockdep is turned off.
irq event stamp: 0
hardirqs last  enabled at (0): [<          (null)>]           (null)
hardirqs last disabled at (0): [<ffffffff8105eca2>] copy_process+
0x4e2/0x1040
softirqs last  enabled at (0): [<ffffffff8105eca2>] copy_process+0x4e2/0x1040
softirqs last disabled at (0): [<          (null)>]           (null)
Pid: 1842, comm: pm-suspend Tainted: G   M        2.6.39-rc6-330cd+ #3
Call Trace:
 [<ffffffff81098290>] ? print_irqtrace_events+0xd0/0xe0
 [<ffffffff8104a11d>] __might_sleep+0xed/0x120
 [<ffffffff8112f7c3>] __kmalloc+0xd3/0x140
 [<ffffffff81025566>] alloc_ioapic_entries+0x66/0xb0
 [<ffffffff81022bc5>] lapic_resume+0x265/0x350
 [<ffffffff814059d5>] syscore_resume+0x35/0xd0
 [<ffffffff810a8ace>] suspend_enter+0xde/0x120
 [<ffffffff810a8b7a>] suspend_devices_and_enter+0x6a/0xb0
 [<ffffffff810a8c91>] enter_state+0xd1/0x100
 [<ffffffff810a81c6>] state_store+0xc6/0x100
 [<ffffffff81329c37>] kobj_attr_store+0x17/0x20
 [<ffffffff811a78d1>] sysfs_write_file+0xe1/0x160
 [<ffffffff811400c6>] vfs_write+0xc6/0x180
 [<ffffffff811403dc>] sys_write+0x4c/0x90
 [<ffffffff8170927b>] system_call_fastpath+0x16/0x1b
-- 
Daniel J Blueman
