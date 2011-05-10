Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753110Ab1EJWAG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 18:00:06 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:47534 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751361Ab1EJWAD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 18:00:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=saSJEURR16jrcnCBVn4ryt8Q7pcWntiwQ4ZpDuqeFNTmUrO3YyQsEiL/ymfevfARHG
         JAIMK3YXZ9J05cJhltfrSCN2Dw3zBCw6xYWyMy2DNsUFg2FPWwEUqXITba0AczNcgPUg
         4caze1A5Z3DabS5BwUm8FtxuV/Cgy1B0KSWOc=
From: Denys Vlasenko <vda.linux@googlemail.com>
To: Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH 04/11] ptrace: implement PTRACE_INTERRUPT
Date: Tue, 10 May 2011 23:59:58 +0200
User-Agent: KMail/1.8.2
Cc: Tejun Heo <tj@kernel.org>, jan.kratochvil@redhat.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, indan@nul.nu
References: <1304869745-1073-1-git-send-email-tj@kernel.org> <20110510095022.GR1661@htj.dyndns.org> <20110510140620.GB21834@redhat.com>
In-Reply-To: <20110510140620.GB21834@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Content-Disposition: inline
Message-Id: <201105102359.58900.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 10 May 2011 16:06, Oleg Nesterov wrote:
> On 05/10, Tejun Heo wrote:
> > On Mon, May 09, 2011 at 06:58:57PM +0200, Oleg Nesterov wrote:
> > > Right now I am a bit puzzled why do we have 2 bits, JOBCTL_TRAP_INTERRUPT
> > > and JOBCTL_TRAP_SEIZE... But I didn't read this + other patches yet.
> >
> > It eventually ends up with three trap flags - SEIZE, INTERRUPT and
> > NOTIFY.  They all use PTRACE_EVENT_INTERRUPT trap but are different as
> > for when they're cleared.  SEIZE is cleared after any trap.  INTERRUPT
> > is cleared after an INTERRUPT trap
> 
> Yes, I see, but still can't understand. OK, please ignore, let me read
> other patches first.
> 
> Well, in fact I seem to understand why do we have 2 bits. Unless I misread
> the code, PTRACE_INTERRUPT is sticky. It can't be lost even if the tracee
> can report another event before. Contrary, SEIZE is cleared if the tracee
> reports something else right after attach, but they both report the same
> PTRACE_EVENT_INTERRUPT. So, if the user does
> 
> 	ptrace(PTRACE_SEIZE);
> 	ptrace(PTRACE_INTERRUPT);
> 
> we need 2 bits to ensure PTRACE_EVENT_INTERRUPT will be reported in any
> case.
> 
> And, you know, I am not sure this is very clear. What if we change the
> rules so that PTRACE_SEIZE always reports PTRACE_EVENT_INTERRUPT like
> PTRACE_INTERRUPT? This looks more symmetrical and simple to me. IOW,
> ptrace(PTRACE_SEIZE) simply implies the implicit PTRACE_INTERRUPT.
> 
> Oh. And this reminds me the previous discussion. Should PTRACE_SEIZE
> stop the tracee? Perhaps it should only attach or do PTRACE_INTERRUPT
> depending on flags? Personally I think it should stop...

Off the top of my head, I don't see the use case for non-stopping
SEIZE right not, but arguably some people might want that.

Regarding three SEIZE/INTERRUPT/NOTIFY bits. Let's see whether
we really need them.

Tejun, why exactly do you want userspace to always see INTERRUPT stop?

If tracer did ptrace(PTRACE_INTERRUPT), it wants tracee to stop.
It then goes to waitpid, and whatever stop it sees, it handles.
I don't see any problem if it instead happens to see, say, a signal delivery
stop, and no INTERRUPT stop after that, ever. No information is lost.

Therefore, we can merge SEIZE and INTERRUPT bits into one
(or drop SEIZE bit altogether, if we decide that SEIZE doesn't stop).

Then, NOTIFY bit.
Tejun, let us know why did you design group stop notification
in a "sticky" way. Is it because of some races with SIGSTOP/SIGCONT?
>From userspace POV, it's not obvious why we can't just have
*one* INTERRUPT stop (that is, non-sticky one) every time there
is a group stop state change. Tracer can retrieve status via
GETSIGINFO just like as provided by your patch, but it doesn't
absolutely has to: it can simply CONT the tracee.

(
No, a bit different. Not
"every time there is a group stop state change"
but
"every time there is a SIGCONT which releases tracee from group stop"
- because group stop notification is _already_ delivered
to the tracer, even by the current kernel's code,
and it is already detectable (by observing that GETSIGINFO
fails on it) and we can avoid changing this.
)

Therefore, NOTIFY bit is also not needed. Only INTERRUPT bit is.
Unless I miss something...

Another note: even though PTRACE_INTERRUPT solves the problem that
PTRACE_DETACH of a running tracee was butt-ugly thing to do correctly,
the "new" way is still a bit ugly: tracer needs PTRACE_INTERRUPT,
waitpid, and only then PTRACE_DETACH. Why not go all the way
and make PTRACE_DETACH work on running tracee too?

-- 
vda
