Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933004Ab1EMJNS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 May 2011 05:13:18 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:39495 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932419Ab1EMJNP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 May 2011 05:13:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=DkOj5N/FbHzhuUDaWckkesxWp/s5Eok9Re8sdGQqDmuYeY6BKDAIjrLunoEOifnqRR
         CxXpLaQ+1eI1Yck/8MvGQjhd/tk7t4j7GqhEKGlQHmCkPqDPpWIjlFk0cp/O85gy+hm9
         are8/m6JzzMvbZu1KQrKHd6MifmufOVhLX07s=
Date: Fri, 13 May 2011 11:13:11 +0200
From: Tejun Heo <tj@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: jan.kratochvil@redhat.com, vda.linux@googlemail.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, indan@nul.nu
Subject: Re: [PATCH 10/11] ptrace: move JOBCTL_TRAPPING wait to wait(2) and
 ptrace_check_attach()
Message-ID: <20110513091311.GC6500@htj.dyndns.org>
References: <1304869745-1073-1-git-send-email-tj@kernel.org>
 <1304869745-1073-11-git-send-email-tj@kernel.org>
 <20110511164947.GA26383@redhat.com>
 <20110511195333.GE24245@mtj.dyndns.org>
 <20110512155910.GD18599@redhat.com>
 <20110512160709.GL1030@htj.dyndns.org>
 <20110512182006.GA25850@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110512182006.GA25850@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thu, May 12, 2011 at 08:20:06PM +0200, Oleg Nesterov wrote:
> Now about GROUP_STOP_TRAPPING. To simplify the discussion, lets
> forget about this series, please recall the previous
> "ptrace: use GROUP_STOP_TRAPPING for PTRACE_DETACH too" change.
> 
> http://marc.info/?l=linux-kernel&m=130486589601593
> 
> In short, it changes __ptrace_unlink() to set _TRAPPING if needed,
> and ptrace_attach() waits for !TRAPPING unconditionally.
> 
> Problem: TRAPPING can be set outside of do_signal_stop() paths, and
> I think we should avoid this as much as possible.

For PTRACE_DETACH, this was true but it isn't true for notification
re-traps.  Notification re-traps happen iff JOBCTL_TRAPPED (now
renamed to JOBCTL_ALLOW_NOTIFY) is set and tracee sets it only while
it's inside signal delivery path - more specifically, when
ptrace_stop() is called from do_signal_stop() or for INTERRUPT trap,
both of which are always inside get_signal_to_deliver().

> (I am ignoring the problem this patch addresses temporary, I think
>  we can fix it a bit differently).

Just leaving it alone also is an option.  We can just mandate
ptrace(2) users to always perform sleeping wait(2) after PTRACE_SEIZE.
If it can be fixed easily, sure.  If not, let's leave it alone.

> Say, the thread group was stopped, the tracer PTRACE_CONT's T1, it calls
> sys_execve() and reports the trap from syscall_trace_enter().
> 
> The tracer does ptrace(T1, DETACH) + ptrace(T1, SEIZE) and hangs forever.
> 
> Once again, this is only one example. coredump, vfork, probably something
> else. In short: I think that TRAPPING-outside-of-do_signal_stop is the
> can of worms.

Yeap, fully agreed.  We need something different for detach case;
however, for re-trap, tracee is known to be in signal delivery path
and should be okay, I think.  Right?

Thanks.

-- 
tejun
