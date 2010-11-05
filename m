Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753367Ab0KEQHA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Nov 2010 12:07:00 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:55259 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752753Ab0KEQG4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Nov 2010 12:06:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=pbIhNFqUMudE/tN4e3DNJ0fwu5U5y/64IYP/KOG0vHceg/Hep6mEaZvT3OCrD/Qyjg
         Acni4GmIfvW3Kj5Bp/ehUvwEbgWuxVBglKwCdZ4eaDsy9pYKfxaHB1vZYdEkL0XcIU4C
         dvxAS48qny76ZSAHRqRBn7+6glgphDePfs6eI=
MIME-Version: 1.0
In-Reply-To: <20101101155110.GC5985@lenovo>
References: <4CCEB51C.7010901@web.de>
	<20101101154536.GT4823@redhat.com>
	<20101101155110.GC5985@lenovo>
Date: Fri, 5 Nov 2010 17:06:55 +0100
Message-ID: <AANLkTikVSpw-R6Jt-ZfK6sJXoRv7wJ7-vPHQGcNYkVDK@mail.gmail.com>
Subject: Re: BUG: using smp_processor_id() in preemptible arch_trigger_all_cpu_backtrace_handler
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Don Zickus <dzickus@redhat.com>, Jan Kiszka <jan.kiszka@web.de>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Eric Paris <eparis@redhat.com>, Randy Dunlap <randy.dunlap@oracle.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/11/1 Cyrill Gorcunov <gorcunov@gmail.com>:
> On Mon, Nov 01, 2010 at 11:45:36AM -0400, Don Zickus wrote:
> ...
>> Heh.  Yeah when I migrated the code, I completely forgot the notifier
>> chain could be called from a preemptible context (ie not NMI).
>>
>> This patch should fix it and I think it is the correct fix.  Let me know
>> how it works out.
>>
>> Cheers,
>> Don
>>
>> diff --git a/arch/x86/kernel/apic/hw_nmi.c b/arch/x86/kernel/apic/hw_nmi.c
>> index c7c9ae4..1bdd0b5 100644
>> --- a/arch/x86/kernel/apic/hw_nmi.c
>> +++ b/arch/x86/kernel/apic/hw_nmi.c
>> @@ -63,7 +63,7 @@ arch_trigger_all_cpu_backtrace_handler(struct notifier_block *self,
>>  {
>>       struct die_args *args = __args;
>>       struct pt_regs *regs;
>> -     int cpu = smp_processor_id();
>> +     int cpu;
>>
>>       switch (cmd) {
>>       case DIE_NMI:
>> @@ -74,6 +74,7 @@ arch_trigger_all_cpu_backtrace_handler(struct notifier_block *self,
>>       }
>>
>>       regs = args->regs;
>> +     cpu = smp_processor_id();
>>
>>       if (cpumask_test_cpu(cpu, to_cpumask(backtrace_mask))) {
>>               static arch_spinlock_t lock = __ARCH_SPIN_LOCK_UNLOCKED;
>>
>
>  yup, this will do the trick for a while. In general I believe we might have
> kind of NMI exclusive chain so we wouldn't need the 'case:'s.


Yeah.  And seperating NMIs from the rest of the DIE notifiers would
probably improve
performance of things like PMI handling.

And I've always been confused with this "die" notifier semantic. We
are not dying when
we handle a counter overflow interrupt.
The same applies to DIE_INT3, DIE_TRAP, DIE_DEBUG, ....

But until then, as having a seperate notifier is quite a refactoring,
we should enqueue Don's fix.
Don, can you resend it with usual SOB and changelog?

Thanks.
