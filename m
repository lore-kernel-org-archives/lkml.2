Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754531Ab1B1O0Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 09:26:16 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:50192 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754118Ab1B1O0P convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 09:26:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=EKNqZ4F/3pnlS0QFCgvD39ed/VfCPLsMDZ6IZtrmK0cRo/4gj5Ud28uSFdBINo8qY0
         kgW8ity7K27MAGab+jw4LoOJFNOHsvxbi+cz61t2dhw7WkwAg2rqJpjj4j6Dn6B+GYib
         oE8iDjc70acLlkWg/Gov0pLsmGR0O6wZ9Vvcw=
MIME-Version: 1.0
In-Reply-To: <20110228135312.GC9326@htj.dyndns.org>
References: <20110214190141.GA19221@redhat.com> <20110224202941.GA12258@redhat.com>
 <20110225155142.GQ24828@htj.dyndns.org> <201102260348.03312.vda.linux@googlemail.com>
 <20110228125622.GA9326@htj.dyndns.org> <AANLkTik1+XVrkwTouERoxF2AWYyv-UCqie_Wq3OLjoXg@mail.gmail.com>
 <20110228132941.GB9326@htj.dyndns.org> <AANLkTin9HW5R5Wihw+yceKkW=Pj+eB8-id0E1Gud2y-G@mail.gmail.com>
 <20110228135312.GC9326@htj.dyndns.org>
From: Denys Vlasenko <vda.linux@googlemail.com>
Date: Mon, 28 Feb 2011 15:25:53 +0100
Message-ID: <AANLkTimQV0j2MuPdwQBgpdCN6nA9KTbVwrSM1Ut0i_=q@mail.gmail.com>
Subject: Re: [PATCH 1/1] ptrace: make sure do_wait() won't hang after PTRACE_ATTACH
To: Tejun Heo <tj@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>, Roland McGrath <roland@redhat.com>,
        jan.kratochvil@redhat.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 28, 2011 at 2:53 PM, Tejun Heo <tj@kernel.org> wrote:
> Hello,
>
> On Mon, Feb 28, 2011 at 02:41:29PM +0100, Denys Vlasenko wrote:
>> > There's no reason to make the tracee re-enter group stop after pulling
>> > it out to execute 'print getpid()'.
>>
>> If we want to execute 'print getpid()', you are right, we don't want
>> to enter group stop. That's use case #1. But there is use case #2:
>> "strace sleep" + ^Z. if we want to continue stracing sleep
>> without continuing, our PTRACE_SYSCALL(0) *must* make sleep
>> enter group stop. Otherwise, sleep won't be stopped. It will
>> continue sleeping and will exit, which is not what we want. Right?
>
> I don't really follow the distinction you're trying to make.  It
> doesn't matter what you're trying to do.  All that's necessary is for
> the debugger to find out whether group stop is in effect or not and a
> way to control the tracee's execution.  Nothing else is necessary.
> The debugger already knows when the tracee enters group stop.  We just
> need a way for the debugger to find out when group stop stops.

If I understand you right, you are proposing to handle strace+^Z
scenario this way (simplified pseudo-C):

for(;;) {
  waitpid(-1, ...);
  tracee_is_stopped = 0;
  if (waitpid reported *stopping* signal) {
    PTRACE_GETSIGINFO();
    if (PTRACE_GETSIGINFO failed)
      tracee_is_stopped = 1;
  }
  if (!tracee_is_stopped)
    PTRACE_SYSCALL(signal);
}

This requires API change to make waitpid in debugger
see waking SIGCONTs even if we did not restart the tracee
(at least in the case when tracee was in group stop).

This sounds like viable plan from userspace POV.

>> Can you describe this in more details? Do you propose that
>> debugger can detect that we are in group stop (it is already sort-of
>> possible with PTRACE_GETSIGINFO) and if it doesn't want to
>> restart tracee, it simply doesn't do any PTRACE_SYSCALL/CONT?
>> I tried that. This makes tracee sit in *ptrace* stop, not group stop.
>> Meaning: debugger is never be able to see waking SIGCONT:
>> waitpid doesn't report it to the debugger.
>
> A tracee should _always_ enter ptrace trap whenever stopping while
> ptraced.  The stop here or stop there depending on the type of stop
> behavior is hardly useful and very fragile (I think it's inherently
> fragile that way).  Again, the only missing thing is a way for the
> debugger to find out when task stop stops.

PTRACE_GETSIGINFO tells you that. It's a bit of a hack
(PTRACE_GETSIGINFO was meant to be used for a different purpose)
but it seems to be working well.

The problematic case is when we attach to *already stopped* task.
gdb today goes through insane gyrations to detect that condition
(I believe it looks into /proc/TID/state).

If we are going to add PTRACE_ATTACH_NOSTOP or something like it,
perhaps we need to take care to make tracee state detectable
at attach time more easily. Maybe by delivering "I have stopped with SIGfoo"
notification to the debugger if tracee was in group stop?

> BTW, I'm not talking about
> the current behavior.  There's no way to make jctl work properly as it
> is.  We need to improve the kernel one way or another.

I'm happy to hear that :)
Thanks!
-- 
vda
