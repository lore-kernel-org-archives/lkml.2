Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751394Ab1EKSKs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 14:10:48 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:53653 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750775Ab1EKSKr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 14:10:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=Imkptgx8BjE3ARO05WvVw6TuId2FrskQbPuRlGK+SZ+VPbLj13OrfB9+eG4g83st11
         6/oI7CRaLOY3hdJ6TI5wCK3SKLREJGv+UGOmhQwjGz3xdDb9jBBklli9jTqi1+B7NIb1
         ta1DYg1bg9Dt1RYkepgqlbau2kgmryaG74dG8=
MIME-Version: 1.0
In-Reply-To: <20110511091955.GD1661@htj.dyndns.org>
References: <1304869745-1073-1-git-send-email-tj@kernel.org>
 <20110510095022.GR1661@htj.dyndns.org> <20110510140620.GB21834@redhat.com>
 <201105102359.58900.vda.linux@googlemail.com> <20110511091955.GD1661@htj.dyndns.org>
From: Denys Vlasenko <vda.linux@googlemail.com>
Date: Wed, 11 May 2011 14:23:44 +0200
Message-ID: <BANLkTikQm1PVCW3164g0bfgU9fs4MMTfNA@mail.gmail.com>
Subject: Re: [PATCH 04/11] ptrace: implement PTRACE_INTERRUPT
To: Tejun Heo <tj@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>, jan.kratochvil@redhat.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, indan@nul.nu
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tejun,

On Wed, May 11, 2011 at 11:19 AM, Tejun Heo <tj@kernel.org> wrote:
> On Tue, May 10, 2011 at 11:59:58PM +0200, Denys Vlasenko wrote:
>> Tejun, why exactly do you want userspace to always see INTERRUPT stop?
>>
>> If tracer did ptrace(PTRACE_INTERRUPT), it wants tracee to stop.
>> It then goes to waitpid, and whatever stop it sees, it handles.
>> I don't see any problem if it instead happens to see, say, a signal delivery
>> stop, and no INTERRUPT stop after that, ever. No information is lost.
>>
>> Therefore, we can merge SEIZE and INTERRUPT bits into one
>> (or drop SEIZE bit altogether, if we decide that SEIZE doesn't stop).
>
> First of all, I think it's cleaner that way - if you ask for
> INTERRUPT, you get an INTERRUPT.  Secondly, because INTERRUPT trap is
> special regarding retrapping notifications and there will be cases
> where debugger wants to put a tracee into INTERRUPT trap and it will
> be pretty annoying to do that safely if INTERRUPT disappears on each
> trap and/or INTERRUPT doesn't work if tracee is already trapped.
>
>> Then, NOTIFY bit.
>> Tejun, let us know why did you design group stop notification
>> in a "sticky" way. Is it because of some races with SIGSTOP/SIGCONT?
>> From userspace POV, it's not obvious why we can't just have
>> *one* INTERRUPT stop (that is, non-sticky one) every time there
>> is a group stop state change. Tracer can retrieve status via
>> GETSIGINFO just like as provided by your patch, but it doesn't
>> absolutely has to: it can simply CONT the tracee.
>
> Design like that is fragile like hell.  Going back to the debugging
> stopped tracee case I talked about in another reply, let's say
> debugger issues PTRACE_CONT at the same time SIGCONT is generated.

If tracer issues PTRACE_CONT, it means that tracee was in some
sort of ptrace stop anyway at that point.
Therefore "cont" notification, just like any other ptrace notification
(say, signal notification) which was generated while tracee
was ptrace-stopped, should be reported *at the next waitpid*.

If, as you say in this example, SIGCONT was generated while tracee
was ptrace-stopped, then next waitpid will return "cont" notification
to tracer. Tracer will know that it is a "cont" notification
by looking at GETSIGINFO result.

Why do you need stickiness of "cont" notification?
I don't see this need from userspace POV.

> Tracee will continue execution and debugger would believe that the
> trap was continued by it

Yes...

> and be oblivious about the SIGCONT which
> raced with PTRACE_CONT.

...yes, until tracer gets the next waitpid result, which
will inform tracer that "cont" has happened.

(After which, tracer will likely PTRACE_CONT,
get SIGCONT signal delivery notification, inject it via
PTRACE_CONT(SIGCONT) so that tracee can run the handler,
and so forth...)


>> (
>> No, a bit different. Not
>> "every time there is a group stop state change"
>> but
>> "every time there is a SIGCONT which releases tracee from group stop"
>> - because group stop notification is _already_ delivered
>> to the tracer, even by the current kernel's code,
>> and it is already detectable (by observing that GETSIGINFO
>> fails on it) and we can avoid changing this.
>> )
>> Therefore, NOTIFY bit is also not needed. Only INTERRUPT bit is.
>> Unless I miss something...
>
> As I replied in another message, group stop may also be initiated
> while a tracee is INTERRUPT trapped.
>
> Those different TRAP bits are invisible to userland.

Sure, I'm not arguing about details of kernel-side machinery.
If you need three bits (or 33) in task struct to make it work, so be it.
Oleg is your guy to discuss that.

> The only changes
> visible from userland are new ptrace requests - PTRACE_SEIZE and
> PTRACE_INTERRUPT, and a new trap condition - PTRACE_EVENT_INTERRUPT.
>
> PTRACE_EVENT_INTERRUPT traps are mostly side-effect-less and I'm
> planning on documenting specifically that it may seem spurious and the
> debugger should only rely on the information obtained from GETSIGINFO.

I understand this. I am trying to understand what feature are you trying
to provide to userland, or what problematic race scenario you are trying
to make resolve-able *in userland* by making "stop" and "cont"
notifications sticky wrt GETSIGINFO. I just don't see this scenario.

-- 
vda
