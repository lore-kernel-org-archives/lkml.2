Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759480Ab1CDOAJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 09:00:09 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:37854 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753267Ab1CDOAH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 09:00:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=MPMhCSwBpAuMlRsFEWcbsLi/wBGRMB1OqrYpnsa/IzUC0wZVGNjXDlKiM1PXYvLk9u
         wF/OvZn0GY0s/aioqP9J8NKTB00YR4i1S75r6nNuluh7M1sk88QzkU0z2Pf2ZCTv7RDn
         SxIHLfPaM0u0Jy/aaCmRLx/lPmf+D/+GO70iY=
MIME-Version: 1.0
In-Reply-To: <20110304134126.GL20499@htj.dyndns.org>
References: <20110301152457.GE26074@htj.dyndns.org> <20110303173422.GA27960@redhat.com>
 <20110303202246.GB32152@redhat.com> <AANLkTikeCzr-OGkmaaortS7_rR+JCM9B6aJV0c52EMbE@mail.gmail.com>
 <20110304134126.GL20499@htj.dyndns.org>
From: Denys Vlasenko <vda.linux@googlemail.com>
Date: Fri, 4 Mar 2011 14:59:32 +0100
Message-ID: <AANLkTikLd2Kg9Pz+5eLd_irdxoKdrR9qPj8yixeTfvaM@mail.gmail.com>
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

On Fri, Mar 4, 2011 at 2:41 PM, Tejun Heo <tj@kernel.org> wrote:
>> And again, I would like to ask you kernel guys to give
>> userspace a way to distinguish this stop from other possible stops.
>>
>> IOW: debugger PTRACE_SYSCALL(0)'ed a job control stopped task.
>> Debugger gets WIFSTOPPED, WSTOPSIG = SIGTRAP.
>> Debugger wants to know: is it a "syscall entry/exit" stop
>> or an "end of job control stop" stop?
>> Preferably without the need to query PTRACE_GETSIGINFO
>> on every SIGTRAP - that'd slow strace down a lot.
>
> There's no question that it should be distinguishible.  I was still
> mostly thinking about siginfo tho.  Is PTRACE_GETSIGINFO such big
> deal?  It's a very simple syscall.  It enters kernel, copyout the
> structure and returns.  Are you interested in adding GET_SIGINFO call
> to the current ptrace and see how much things actually slow down?

I would rather speed strace up than slow it down further, even if slightly.


>> I imagine one way to do it is to #define a PTRACE_EVENT_foo
>> for "end of job control stop" stop and return it in high byte
>> of waitpid status, just like other PTRACE_EVENTs are returned today.
>
> Maybe but I'm not fully sure yet because I think for debuggers the
> group stop status needs to be available for other ptrace traps too, so

By all means, do make this information accessible
with PTRACE_GETSIGINFO too. I have nothing against that.


> it might really not fit there.  I'd like to avoid twisting debugging
> API

It is *already* twisted that way. Other ptrace stops *already*
return extra information in waitpid status: run "man ptrace"
and read PTRACE_SETOPTIONS section. For example:

      "PTRACE_O_TRACEEXEC (since Linux 2.5.46)
             Stop  the  child  at  the next execve(2) call with
             SIGTRAP | PTRACE_EVENT_EXEC << 8."

I don't see why adding another PTRACE_EVENT_foo
is a big deal.

-- 
vda
