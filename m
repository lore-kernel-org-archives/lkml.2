Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755772Ab1BNRaY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 12:30:24 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:36202 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752726Ab1BNRaR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 12:30:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=kDLZjVMmjxzOrGym4x7MIc8B8D3ycOGZF79y/ZCI+3U+YXOpCC5l+QQs0DAD8idvYw
         IhiO7eeHQNS8mkQBmE+K3xef0MceVcwzNGrrjG2tJ/bR6j/EOWewlAZuKVA5iwhxXb9l
         2GtETM/oUArQVobcxbaimMFrEQIbUY68L0x14=
Date: Mon, 14 Feb 2011 18:30:12 +0100
From: Tejun Heo <tj@kernel.org>
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: Oleg Nesterov <oleg@redhat.com>, Roland McGrath <roland@redhat.com>,
        jan.kratochvil@redhat.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
Subject: Re: [PATCH 1/1] ptrace: make sure do_wait() won't hang after
 PTRACE_ATTACH
Message-ID: <20110214173012.GA18742@htj.dyndns.org>
References: <20110204105343.GA12133@htj.dyndns.org>
 <20110207174821.GA1237@redhat.com>
 <20110209141803.GH3770@htj.dyndns.org>
 <201102132325.55353.vda.linux@googlemail.com>
 <20110214151340.GP18742@htj.dyndns.org>
 <AANLkTi=Djwcf9YoUrGtTEOp8W_YhsefzrNhMxVhtw_Lp@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTi=Djwcf9YoUrGtTEOp8W_YhsefzrNhMxVhtw_Lp@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Mon, Feb 14, 2011 at 06:20:52PM +0100, Denys Vlasenko wrote:
> >> 23:02:15.622112 nanosleep({30, 0}, NULL) = ? ERESTART_RESTARTBLOCK (To be restarted)
> >> 23:02:23.781165 --- SIGSTOP (Stopped (signal)) @ 0 (0) ---
> >> 23:02:23.781251 --- SIGSTOP (Stopped (signal)) @ 0 (0) ---
> >>     (I forgot again why we see it twice. Another quirk I guess...)
> >> 23:02:23.781310 restart_syscall(<... resuming interrupted call ...>) = 0
> >> 23:02:45.622433 close(1)                = 0
> >> 23:02:45.622743 close(2)                = 0
> >> 23:02:45.622885 exit_group(0)           = ?
...
> > This can be fixed by updating strace, right?  strace can look at the
> > wait(2) exit code and if the tracee stopped for group stop, wait for
> > the tracee to be continued instead of issuing PTRACE_SYSCALL.
> 
> But tracee didn't stop _yet_. Signal is not delivered _yet_, debugger
> can decide at this point whether to deliver it:
> ptrace(PTRACE_SYSCALL, $PID, 0x1, SIGSTOP)
> or ignore:
> ptrace(PTRACE_SYSCALL, $PID, 0x1, 0)
> 
> strace has to deliver SIGSTOP if it wants to make program run exactly
> as it would run without strace. So it tries to do so.
> Currently, ptrace machinery doesn't react as strace, its user, expects it to.

Okay, maybe I'm missing something but so once SIGSTOP is determined to
be delivered, then the tracee enters group stop and that's the second
SIGSTOP notification you get.  At that point, strace should wait for
the tracee to be continued by SIGCONT.  That should work, right?

Thanks.

-- 
tejun
