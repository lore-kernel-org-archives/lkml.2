Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757175Ab1CBLuL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 06:50:11 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:62302 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757150Ab1CBLuE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 06:50:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=V9ox3gOduh9y2hUXjtdg5c2QNTKx/Nrl6eechkBjjPaYndHihKENpj8r5XJtIeiFCL
         9B+rbXwgvx/hiorKBNc1SPcY+Az9bGsxA6FFJ9HoMWPxKsGdA/PLtnfnQLJT3+GtPrMR
         QLc80DXUQ4IDLLNO77hAdiAIleEXGDPzvFc4E=
MIME-Version: 1.0
In-Reply-To: <20110302112756.GI3319@htj.dyndns.org>
References: <20110301152457.GE26074@htj.dyndns.org> <AANLkTi=cUM9S5M7h0unMfbQ88CzqhoDN9CUEVf_9HrdS@mail.gmail.com>
 <20110302073727.GD19669@htj.dyndns.org> <AANLkTimA8wtM4sJu1SMVuOaNXyxEtLcfaj7kJf2NovAd@mail.gmail.com>
 <20110302112756.GI3319@htj.dyndns.org>
From: Denys Vlasenko <vda.linux@googlemail.com>
Date: Wed, 2 Mar 2011 12:48:56 +0100
Message-ID: <AANLkTi=tQ0kLB_MiTArpNAWHUT0id_dbXXLu9UpPhRfN@mail.gmail.com>
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

On Wed, Mar 2, 2011 at 12:27 PM, Tejun Heo <tj@kernel.org> wrote:
> On Wed, Mar 02, 2011 at 12:21:28PM +0100, Denys Vlasenko wrote:
>> > I think WSTOPSIG should be SIGTRAP as the tracee left group stop and
>> > entered ptrace trap.
>>
>> This would be, by my count, 13th kind of SIGTRAP use by ptrace.
>> Which makes multi-level if's in debuggers even more complex
>> and more error-prone.
>
> Of course, all ptrace traps are SIGTRAPs.

Except for those SIGSTOPs in children on auto-attach
via PTRACE_O_TRACE[V]FORK / PTRACE_O_TRACECLONE options...

>> Why not SIGCONT? This event is, after all, caused by SIGCONT.
>> It would be so much nicer to be able to detect it with single if()
>> in the debugger...
>
> I disagree.  It's a ptrace trap.  It should use SIGTRAP.  We just need
> well defined siginfo output to distinguish between them.  It's not
> like we can avoid siginfo anyway.

Performance problem here. Strace is already suffering from being
rather slow, especially for multi-threaded processes.

So far strace was able to avoid querying siginfo on every stop.

In order to make job control stop work properly, it will now need
to query siginfo, but only if signo==SIGSTOP. SIGSTOPs don't
occur too often, definitely not twice per syscall as SIGTRAPs do,
so it's not a problem.

With your proposal to show resume-from-job-control-stop-via-SIGCONT
as SIGTRAP, *every* SIGTRAP stop needs to be followed
by PTRACE_GETSIGINFO.


>> > No, it's not a signal delivery notification.  It's a ptrace trap
>> > notification.  SIGCONT may not be delivered to this task.  Please
>> > remember that it's the emission of SIGCONT which ends a group stop,
>> > not delivery.
>>
>> From userspace POV it's really a kernel's implementation detail.
>
> Not really.  This is actually a visible difference.  Roland wrote in
> the previous discussion.  One visible difference is that ptrace can
> veto job control stop but it can't veto the end of job control.  Job
> control actions happen before SIGCONT hits the signal delivery path
> which is visible through ptrace.
>
>> >> (b) does PTRACE_CONT(<other_sig>)? or
>> >> (c) does PTRACE_CONT(0)?
>> >
>> > See above.
>>
>> This means that SIGCONT handler will be executed in the tracee
>> after debugger does PTRACE_CONT(<any_signo>) at this point.
>>
>> Which makes SIGCONT special: debugger can suppress execution
>> of other signal handlers in tracee, but not SIGCONT handler.
>> Another special case. Can we avoid having it?
>
> Hmmm.... I think you're confused about how SIGCONT is handled or maybe
> I am.  Either way, please elaborate.  I can't really follow.

signal(SIGCONT, my_handler) does install a handler for SIGCONT
in userspace, and this handler does run when SIGCONT is delivered:

#include <errno.h>
#include <string.h>
#include <stdio.h>
#include <signal.h>
#include <unistd.h>
static void sig(int n)
{
       char buf[128];
       int e = errno;
       sprintf(buf, "sig: %d %s\n", n, strsignal(n));
       write(1, buf, strlen(buf));
       errno = e;
}
int main()
{
       signal(SIGSTOP, sig);
       signal(SIGCONT, sig);
       signal(SIGWINCH, sig);
       signal(SIGABRT, sig);
 again:
       printf("PID: %d\n", getpid());
       fflush(NULL);
       errno = 0;
       sleep(30);
       int e = errno;
       printf("after sleep: errno=%d %s\n", e, strerror(e));
       if (e) goto again;
       return 0;
}

# ./a.out
PID: 16382
 <------ kill -STOP 16382
 <------ kill -ABRT 16382
 <------ kill -WINCH 16382
 <------ kill -CONT 16382
sig: 28 Window changed
sig: 18 Continued
sig: 6 Aborted
after sleep: errno=4 Interrupted system call
PID: 16382


Therefore we also need to think about this aspect of SIGCONT behavior
under debuggers.

Do we provide for the mechanism for debuggers to
prevent execution of *SIGCONT userspace handler*?

And, looking at the example above, I see that on resume from stop,
*SIGCONT userspace handler* actually doesn't run as *the first handler*
after SIGCONT. Other pending signal's handlers may be executed before it.

How would the above example look under ptraced process? Particularly,
this sequence:
 <------ kill -STOP 16382
 <------ kill -ABRT 16382
 <------ kill -WINCH 16382
 <------ kill -CONT 16382
sig: 28 Window changed
sig: 18 Continued
sig: 6 Aborted


-- 
vda
