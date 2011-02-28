Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753834Ab1B1N3s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 08:29:48 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:48903 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753519Ab1B1N3q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 08:29:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=XYTL5as6pNDzm2zt2gwlokJwkg3rkMmpvrpwYdcVsJficEi6LArELcVvyZCrpU0omq
         5GFlzzjUIQ93Rmz9FSugitHxxbkL7CFNvpVIhQP3h0+z4CKJYYk4CmAjkkXuF5MJ1JiN
         CK6gcih2SUGOOIXTQO7OMBLdX0e20zLcuprLQ=
Date: Mon, 28 Feb 2011 14:29:41 +0100
From: Tejun Heo <tj@kernel.org>
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: Oleg Nesterov <oleg@redhat.com>, Roland McGrath <roland@redhat.com>,
        jan.kratochvil@redhat.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
Subject: Re: [PATCH 1/1] ptrace: make sure do_wait() won't hang after
 PTRACE_ATTACH
Message-ID: <20110228132941.GB9326@htj.dyndns.org>
References: <20110214190141.GA19221@redhat.com>
 <20110224202941.GA12258@redhat.com>
 <20110225155142.GQ24828@htj.dyndns.org>
 <201102260348.03312.vda.linux@googlemail.com>
 <20110228125622.GA9326@htj.dyndns.org>
 <AANLkTik1+XVrkwTouERoxF2AWYyv-UCqie_Wq3OLjoXg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTik1+XVrkwTouERoxF2AWYyv-UCqie_Wq3OLjoXg@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 28, 2011 at 02:16:48PM +0100, Denys Vlasenko wrote:
> (gdb) print getpid()
> 
> gdb modifies IP, sets breakpoint on return address, and issues PTRACE_CONT(0).
> Kernel has to put the tracee into group-stop, right?
> Becuase if it doesn't, if it makes tracee run, then the kernel is
> still broken. For example,
> stracing a program and sending SIGSTOP on it won't work: the sequence
> of events will be
> got SIGSTOP because SIGSTOP was delivered
> PTRACE_SYSCALL(SIGSTOP) - "inject it"
> got SIGSTOP because tracee is in group-stop now
> PTRACE_SYSCALL(SIGSTOP) - equivalent to PTRACE_SYSCALL(0)
>   because we aren't in signal delivery ptrace-stop
> and tracee continues.
> 
> That's why I think gdb's "print getpid()" today depends on the bug.
> If we simply fix the bug (by making PTRACE_CONT/SYSCALL(0)
> re-enter group-stop), then "print getpid()" will stop working
> for stopped tracees.

There's no reason to make the tracee re-enter group stop after pulling
it out to execute 'print getpid()'.  The only thing necessary is a way
for the debugger to find out that group stop has been lifted.  The
debugger then can resume the tracee if it wishes so.  ie. group stop
becomes a trap point + a state which the debugger can monitor.  If the
debugger wants the tracee to follow the jctl behavior, it can do so by
resuming the tracee as it sees fit.

Thanks.

-- 
tejun
