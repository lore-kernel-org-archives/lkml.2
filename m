Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932930Ab1JZMjD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Oct 2011 08:39:03 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:60143 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932751Ab1JZMjB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Oct 2011 08:39:01 -0400
MIME-Version: 1.0
In-Reply-To: <20111025161426.GC17067@redhat.com>
References: <20111025141812.GA21225@linux.vnet.ibm.com> <20111025161426.GC17067@redhat.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 26 Oct 2011 14:38:39 +0200
X-Google-Sender-Auth: cytDCVQrH3pgmJ_9AIFBEvWVSOY
Message-ID: <CA+55aFx4g-3yGOgdS-UOGGincbAOgdxwfHCHpd-yVU6-dKwv0w@mail.gmail.com>
Subject: Re: [RESEND] [RFC][PATCH X86_32 1/2]: Call do_notify_resume() with
 interrupts enabled
To: Oleg Nesterov <oleg@redhat.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Steven Rostedt <rostedt@goodmis.org>,
        Christoph Hellwig <hch@infradead.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>, Andi Kleen <andi@firstfloor.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Roland McGrath <roland@hack.frob.com>, Shuah Khan <shuah.khan@hp.com>,
        Ingo Molnar <mingo@elte.hu>,
        Alexander van Heukelum <heukelum@fastmail.fm>,
        Russell King <rmk@arm.linux.org.uk>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo, Thomas, I think this is your call, but it seems valid,

                 Linus

On Tue, Oct 25, 2011 at 6:14 PM, Oleg Nesterov <oleg@redhat.com> wrote:
> On 10/25, Srikar Dronamraju wrote:
>>
>> do_notify_resume() gets called with interrupts disabled on x86_32. This
>> is different from the x86_64 behavior, where interrupts are enabled at
>> the time.
>
> And note that do_notify_resume() paths assume that irqs are enabled.
> key_replace_session_keyring/get_signal_to_deliver start with _lock_irq.
>
> IOW, I vote for this change even if I can't ack it (although it looks
> "obviously correct" to me). In fact refrigerator() looks buggy without
> this change. Yes, it enables irqs but only "by accident", via unlock_irq().
> And we are going to remove this recalc_sigpending() from freezer.
>
>
>> Queries on lkml on this issue hasn't yielded any clear answer. Lets make
>> x86_32 behave the same as x86_64, unless there is a real reason to
>> maintain status quo.
>>
>> Please refer https://lkml.org/lkml/2011/9/27/130 for more details
>>
>> A similar change was suggested in arm
>>       https://lkml.org/lkml/2011/8/25/231
>>
>> My 32-bit machine works fine (tm) with the patch below
>>
>> Signed-off-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
>> ---
>>  arch/x86/kernel/entry_32.S |    4 ++++
>>  1 files changed, 4 insertions(+)
>>
>> diff --git a/arch/x86/kernel/entry_32.S b/arch/x86/kernel/entry_32.S
>> index f3f6f53..22d0e21 100644
>> --- a/arch/x86/kernel/entry_32.S
>> +++ b/arch/x86/kernel/entry_32.S
>> @@ -625,6 +625,8 @@ work_notifysig:                           # deal with pending signals and
>>       movl %esp, %eax
>>       jne work_notifysig_v86          # returning to kernel-space or
>>                                       # vm86-space
>> +     TRACE_IRQS_ON
>> +     ENABLE_INTERRUPTS(CLBR_NONE)
>>       xorl %edx, %edx
>>       call do_notify_resume
>>       jmp resume_userspace_sig
>> @@ -638,6 +640,8 @@ work_notifysig:                           # deal with pending signals and
>>  #else
>>       movl %esp, %eax
>>  #endif
>> +     TRACE_IRQS_ON
>> +     ENABLE_INTERRUPTS(CLBR_NONE)
>>       xorl %edx, %edx
>>       call do_notify_resume
>>       jmp resume_userspace_sig
>>
>
>
