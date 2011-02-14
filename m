Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755569Ab1BNPNs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 10:13:48 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:60973 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754391Ab1BNPNp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 10:13:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=f0px3aQpCTu8x/3VZ32q+d8onHtgGUbDl1admqvG+dQ4L/RafHidap8JxVx5IIGwNe
         E+ZNDdHz2IQdE/A9CxWWVIG8BbPrBgI0u/5AYRjEQyDoeCfVCwlQmT0mSGO1LLVSi323
         LJEWidvVNCJaoxymQKLMfKBt8o75lbOZtlLbM=
Date: Mon, 14 Feb 2011 16:13:40 +0100
From: Tejun Heo <tj@kernel.org>
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: Oleg Nesterov <oleg@redhat.com>, Roland McGrath <roland@redhat.com>,
        jan.kratochvil@redhat.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
Subject: Re: [PATCH 1/1] ptrace: make sure do_wait() won't hang after
 PTRACE_ATTACH
Message-ID: <20110214151340.GP18742@htj.dyndns.org>
References: <20110204105343.GA12133@htj.dyndns.org>
 <20110207174821.GA1237@redhat.com>
 <20110209141803.GH3770@htj.dyndns.org>
 <201102132325.55353.vda.linux@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201102132325.55353.vda.linux@googlemail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Denys.

On Sun, Feb 13, 2011 at 11:25:55PM +0100, Denys Vlasenko wrote:
> But this "diddling behind group stop's back" is exactly the current
> problem with stop signals.

Maybe.  I don't necessarily agree but can see your point too but I
think more important part is that that's a behavior which is quite
noticeable from userland.

> Here I try to stop a ptraced process:
> 
> $ strace -tt sleep 30
> 23:02:15.619262 execve("/bin/sleep", ["sleep", "30"], [/* 30 vars */]) = 0
> ...
> 23:02:15.622112 nanosleep({30, 0}, NULL) = ? ERESTART_RESTARTBLOCK (To be restarted)
> 23:02:23.781165 --- SIGSTOP (Stopped (signal)) @ 0 (0) ---
> 23:02:23.781251 --- SIGSTOP (Stopped (signal)) @ 0 (0) ---
>     (I forgot again why we see it twice. Another quirk I guess...)
> 23:02:23.781310 restart_syscall(<... resuming interrupted call ...>) = 0
> 23:02:45.622433 close(1)                = 0
> 23:02:45.622743 close(2)                = 0
> 23:02:45.622885 exit_group(0)           = ?
> 
> Why sleep didn't stop?
> 
> Because PTRACE_SYSCALL brought the task out of group stop at once,
> even though strace did try hard to not do so:
> 
>     ptrace(PTRACE_SYSCALL, $PID, 0x1, SIGSTOP) <-- note SIGSTOP!
> 
> PTRACE_CONT in this situation would do the same.

This can be fixed by updating strace, right?  strace can look at the
wait(2) exit code and if the tracee stopped for group stop, wait for
the tracee to be continued instead of issuing PTRACE_SYSCALL.

> You are saying that it is useful that gdb restarts group-stopped task
> with mere PTRACE_CONT. Above is a counter-example where it is anti-useful:
> I would muchly prefer strace to see task sit stopped until it gets SIGCONT
> (or some fatal signal).

This is more of an issue which can be improved in strace.  Sure,
changing the kernel to enforce group stop over ptrace would make this
case behave better but at the cost of breaking gdb.

> Why gdb can't use SIGCONT instead of PTRACE_CONT, just like every
> other tool which needs to resume stopped tasks?

Because that's how PTRACE_CONT behaved the whole time.  It can but
just hasn't needed to.

Thanks.

-- 
tejun
