Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755847Ab1CBLVu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 06:21:50 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:40047 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753312Ab1CBLVt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 06:21:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=jFqFpR6EDynHOoP0pQ24HggvjUdnAihTmsJwsPfFdJTpbBCGLiN5oK6r/OWl08YOgk
         F2HvHD+P3vkl0PFOtj0JcFdZgZkiGGIamOQcD+oEDtHnY3dAbnHsMWrKMrN9MtJAkLNM
         G9uL3BoBkETPvoWWnMo0SUL+eItfKM9DHICwM=
MIME-Version: 1.0
In-Reply-To: <20110302073727.GD19669@htj.dyndns.org>
References: <20110301152457.GE26074@htj.dyndns.org> <AANLkTi=cUM9S5M7h0unMfbQ88CzqhoDN9CUEVf_9HrdS@mail.gmail.com>
 <20110302073727.GD19669@htj.dyndns.org>
From: Denys Vlasenko <vda.linux@googlemail.com>
Date: Wed, 2 Mar 2011 12:21:28 +0100
Message-ID: <AANLkTimA8wtM4sJu1SMVuOaNXyxEtLcfaj7kJf2NovAd@mail.gmail.com>
Subject: Re: [RFC] Proposal for ptrace improvements
To: Tejun Heo <tj@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>, Roland McGrath <roland@redhat.com>,
        jan.kratochvil@redhat.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 2, 2011 at 8:37 AM, Tejun Heo <tj@kernel.org> wrote:
> On Wed, Mar 02, 2011 at 12:16:23AM +0100, Denys Vlasenko wrote:
>> Let's spell this out in detail. Please correct me if
>> I misunderstood your proposal:
>>
>> We have a stopped task under ptrace.
>> (More precisely: debugger got a WSTOPPED notification via waitpid.
>> Debugger decided to emulate the job control stop, therefore it
>> keeps tracee stopped, therefore it just waits on waitpid
>> without doing any PTRACE_CONTs).
>>
>> Another task sends SIGCONT to the tracee.
>>
>> Debugger gets waitpid notification of the
>> WSTOPPED, WSTOPSIG == SIGCONT form.
>
> I think WSTOPSIG should be SIGTRAP as the tracee left group stop and
> entered ptrace trap.

This would be, by my count, 13th kind of SIGTRAP use by ptrace.
Which makes multi-level if's in debuggers even more complex
and more error-prone.

Why not SIGCONT? This event is, after all, caused by SIGCONT.
It would be so much nicer to be able to detect it with single if()
in the debugger...


>> Debugger can check PTRACE_GETSIGINFO, which succeeds.
>> Debugger now knows it's a signal delivery notification.
>
> No, it's not a signal delivery notification.  It's a ptrace trap
> notification.  SIGCONT may not be delivered to this task.  Please
> remember that it's the emission of SIGCONT which ends a group stop,
> not delivery.

>From userspace POV it's really a kernel's implementation detail.


>> Debugger performs PTRACE_CONT(SIGCONT) - it injects the signal.
>> [Question: what if debugger doesn't? IOW: is it possible
>> for debugger to suppress SIGCONTs, or not?
>
> SIGCONT shouldn't be used here and wouldn't make any difference.
> We're not in signal delivery path.
>
>> IOW2: what should happen if debugger
>> (a) does not do any PTRACE_CONT at all? or
>
> The tracee stays stopped.
>
>> (b) does PTRACE_CONT(<other_sig>)? or
>> (c) does PTRACE_CONT(0)?
>
> See above.

This means that SIGCONT handler will be executed in the tracee
after debugger does PTRACE_CONT(<any_signo>) at this point.

Which makes SIGCONT special: debugger can suppress execution
of other signal handlers in tracee, but not SIGCONT handler.
Another special case. Can we avoid having it?


>> Debugger gets WCONTINUED waitpid notification.
>> [question: do we need this?]
>
> I don't think we need this.  The tracer needs all the stopped
> notifications but it doesn't need the continued notification because a
> tracee is never continued without the tracer saying so.

Yes, I think it's ok.

-- 
vda
