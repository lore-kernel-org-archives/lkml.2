Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754170Ab1B1Nxh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 08:53:37 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:58162 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752677Ab1B1Nxg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 08:53:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=AIpsxO1KcEqwESQvZZEscVIUyyCj5ClvPofvsHi9CL8LsnQUEQLt7J5uPBd/d4PDus
         8YNMFnKiFT7FybNu0wYCLu5jsToYodlwG+P4K4WqCnGLbVugeePiUoIl6y8K2xwJ2Stl
         TWHDIsJrFyczy8+IdcSKL3e44yz192vLqJWZw=
Date: Mon, 28 Feb 2011 14:53:12 +0100
From: Tejun Heo <tj@kernel.org>
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: Oleg Nesterov <oleg@redhat.com>, Roland McGrath <roland@redhat.com>,
        jan.kratochvil@redhat.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
Subject: Re: [PATCH 1/1] ptrace: make sure do_wait() won't hang after
 PTRACE_ATTACH
Message-ID: <20110228135312.GC9326@htj.dyndns.org>
References: <20110214190141.GA19221@redhat.com>
 <20110224202941.GA12258@redhat.com>
 <20110225155142.GQ24828@htj.dyndns.org>
 <201102260348.03312.vda.linux@googlemail.com>
 <20110228125622.GA9326@htj.dyndns.org>
 <AANLkTik1+XVrkwTouERoxF2AWYyv-UCqie_Wq3OLjoXg@mail.gmail.com>
 <20110228132941.GB9326@htj.dyndns.org>
 <AANLkTin9HW5R5Wihw+yceKkW=Pj+eB8-id0E1Gud2y-G@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTin9HW5R5Wihw+yceKkW=Pj+eB8-id0E1Gud2y-G@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Mon, Feb 28, 2011 at 02:41:29PM +0100, Denys Vlasenko wrote:
> > There's no reason to make the tracee re-enter group stop after pulling
> > it out to execute 'print getpid()'.
> 
> If we want to execute 'print getpid()', you are right, we don't want
> to enter group stop. That's use case #1. But there is use case #2:
> "strace sleep" + ^Z. if we want to continue stracing sleep
> without continuing, our PTRACE_SYSCALL(0) *must* make sleep
> enter group stop. Otherwise, sleep won't be stopped. It will
> continue sleeping and will exit, which is not what we want. Right?

I don't really follow the distinction you're trying to make.  It
doesn't matter what you're trying to do.  All that's necessary is for
the debugger to find out whether group stop is in effect or not and a
way to control the tracee's execution.  Nothing else is necessary.
The debugger already knows when the tracee enters group stop.  We just
need a way for the debugger to find out when group stop stops.

> >  The only thing necessary is a way
> > for the debugger to find out that group stop has been lifted.
> 
> What do you mean by "has been *lifted*"?

Somebody sent SIGCONT.

> > The debugger then can resume the tracee if it wishes so.  ie. group stop
> > becomes a trap point + a state which the debugger can monitor.  If the
> > debugger wants the tracee to follow the jctl behavior, it can do so by
> > resuming the tracee as it sees fit.
> 
> Can you describe this in more details? Do you propose that
> debugger can detect that we are in group stop (it is already sort-of
> possible with PTRACE_GETSIGINFO) and if it doesn't want to
> restart tracee, it simply doesn't do any PTRACE_SYSCALL/CONT?
> I tried that. This makes tracee sit in *ptrace* stop, not group stop.
> Meaning: debugger is never be able to see waking SIGCONT:
> waitpid doesn't report it to the debugger.

A tracee should _always_ enter ptrace trap whenever stopping while
ptraced.  The stop here or stop there depending on the type of stop
behavior is hardly useful and very fragile (I think it's inherently
fragile that way).  Again, the only missing thing is a way for the
debugger to find out when task stop stops.  BTW, I'm not talking about
the current behavior.  There's no way to make jctl work properly as it
is.  We need to improve the kernel one way or another.

Thanks.

-- 
tejun
