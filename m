Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754765Ab1CBHhd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 02:37:33 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:35505 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751138Ab1CBHhc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 02:37:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Uavb6i4H1E95e5+rHeDOfYX41hGcfQOb7jXgAtM3mU0mUbbCmrOv4graRhtlVY2SGM
         Ov+lDcKR/amFykryaUukxo3zWXWA7ex+Buu2m4osvzscq5TNZwiY72FwaqpdAY+M1/vL
         KXoONjalqV6VQDKOnvPihcIgcQRcpLWYjOc7U=
Date: Wed, 2 Mar 2011 08:37:27 +0100
From: Tejun Heo <tj@kernel.org>
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: Oleg Nesterov <oleg@redhat.com>, Roland McGrath <roland@redhat.com>,
        jan.kratochvil@redhat.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
Subject: Re: [RFC] Proposal for ptrace improvements
Message-ID: <20110302073727.GD19669@htj.dyndns.org>
References: <20110301152457.GE26074@htj.dyndns.org>
 <AANLkTi=cUM9S5M7h0unMfbQ88CzqhoDN9CUEVf_9HrdS@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTi=cUM9S5M7h0unMfbQ88CzqhoDN9CUEVf_9HrdS@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 02, 2011 at 12:16:23AM +0100, Denys Vlasenko wrote:
> Let's spell this out in detail. Please correct me if
> I misunderstood your proposal:
> 
> We have a stopped task under ptrace.
> (More precisely: debugger got a WSTOPPED notification via waitpid.
> Debugger decided to emulate the job control stop, therefore it
> keeps tracee stopped, therefore it just waits on waitpid
> without doing any PTRACE_CONTs).
> 
> Another task sends SIGCONT to the tracee.
> 
> Debugger gets waitpid notification of the
> WSTOPPED, WSTOPSIG == SIGCONT form.

I think WSTOPSIG should be SIGTRAP as the tracee left group stop and
entered ptrace trap.

> Debugger can check PTRACE_GETSIGINFO, which succeeds.
> Debugger now knows it's a signal delivery notification.

No, it's not a signal delivery notification.  It's a ptrace trap
notification.  SIGCONT may not be delivered to this task.  Please
remember that it's the emission of SIGCONT which ends a group stop,
not delivery.

> (This step looks optional, since currently
> WSTOPPED, WSTOPSIG == SIGCONT combination is only possible
> on signal delivery, unlike, for example,
> WSTOPPED, WSTOPSIG == SIGSTOP, which is ambiguous).
> 
> Debugger performs PTRACE_CONT(SIGCONT) - it injects the signal.
> [Question: what if debugger doesn't? IOW: is it possible
> for debugger to suppress SIGCONTs, or not?

SIGCONT shouldn't be used here and wouldn't make any difference.
We're not in signal delivery path.

> IOW2: what should happen if debugger
> (a) does not do any PTRACE_CONT at all? or

The tracee stays stopped.

> (b) does PTRACE_CONT(<other_sig>)? or
> (c) does PTRACE_CONT(0)?

See above.

> Debugger gets WCONTINUED waitpid notification.
> [question: do we need this?]

I don't think we need this.  The tracer needs all the stopped
notifications but it doesn't need the continued notification because a
tracee is never continued without the tracer saying so.

Thanks.

-- 
tejun
