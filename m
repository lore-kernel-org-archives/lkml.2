Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934394Ab2JYH5B (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 03:57:01 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:43744 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932796Ab2JYH47 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 03:56:59 -0400
MIME-Version: 1.0
In-Reply-To: <5088EF85.4080002@de.ibm.com>
References: <1351126313-17804-1-git-send-email-fweisbec@gmail.com>
	<1351126313-17804-4-git-send-email-fweisbec@gmail.com>
	<5088EF85.4080002@de.ibm.com>
Date: Thu, 25 Oct 2012 09:56:58 +0200
Message-ID: <CAFTL4hyFiE-G4VvmO+J2MMrJBFtH07ZcYp0GEnqoQ846_eivEQ@mail.gmail.com>
Subject: Re: [PATCH 3/5] kvm: Directly account vtime to system on guest switch
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Tony Luck <tony.luck@intel.com>,
        Fenghua Yu <fenghua.yu@intel.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        Joerg Roedel <joerg.roedel@amd.com>, Alexander Graf <agraf@suse.de>,
        Xiantao Zhang <xiantao.zhang@intel.com>,
        Cornelia Huck <cornelia.huck@de.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/10/25 Christian Borntraeger <borntraeger@de.ibm.com>:
> On 25/10/12 02:51, Frederic Weisbecker wrote:
>> Switching to or from guest context is done on ioctl context.
>> So by the time we call kvm_guest_enter() or kvm_guest_exit()
>> we know we are not running the idle task.
>>
>> As a result, we can directly account the cputime using
>> vtime_account_system_irqsafe().
>>
>> There are two good reasons to do this:
>>
>> * We avoid some useless checks on guest switch. It optimizes
>> a bit this fast path.
>>
>> * In the case of CONFIG_IRQ_TIME_ACCOUNTING, calling vtime_account()
>> checks for irq time to account. This is pointless since we know
>> we are not in an irq on guest switch. This is wasting cpu cycles
>> for no good reason. vtime_account_system() OTOH is a no-op in
>> this config option.
>>
>> * s390 doesn't disable irqs in its implementation of vtime_account().
>> If vtime_account() in kvm races with an irq, the pending time might
>> be accounted twice. With vtime_account_system_irqsafe() we are protected.
>
> We disable irqs before we call kvm_guest_enter/exit, see kvm-s390.c:
>
>
> [...]
>         if (!kvm_is_ucontrol(vcpu->kvm))
>                 kvm_s390_deliver_pending_interrupts(vcpu);
>         vcpu->arch.sie_block->icptcode = 0;
>         local_irq_disable();
>         kvm_guest_enter();
>         local_irq_enable();
> [...]
>

Ah ok. Hmm I still need to keep it irqsafe for the other archs though,
as it is currently with vtime_account(). So perhaps I can remove your
local_irq_disable there and use vtime_account_system_irqsafe()
instead?

thanks.
