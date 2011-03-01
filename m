Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756943Ab1CAQ7l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 11:59:41 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:56731 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754095Ab1CAQ7b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 11:59:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=WoOSC7BiWfOM3V0mhtuMhM2nJ4Fl1Srdumqtz0D69/XZlXaHcT0EuRYYnZGN1swxUJ
         l0vUrrPYLTXklxZiTmpSbKs5vEk/EFy/zUzCh7UbsgSHvYXlAph1BTaGSAyuAr4LFWov
         E7lIyrCxUCp4PDBDC+QJUfEjlLH4hPRagipUo=
From: Denys Vlasenko <vda.linux@googlemail.com>
To: Tejun Heo <tj@kernel.org>
Subject: Re: [RFC] Proposal for ptrace improvements
Date: Tue, 1 Mar 2011 17:57:48 +0100
User-Agent: KMail/1.8.2
Cc: Oleg Nesterov <oleg@redhat.com>, Roland McGrath <roland@redhat.com>,
        jan.kratochvil@redhat.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
References: <20110301152457.GE26074@htj.dyndns.org>
In-Reply-To: <20110301152457.GE26074@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201103011757.48593.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 01 March 2011 16:24, Tejun Heo wrote:
> PROPOSAL
> --------
> ...
> P3. Keep ptrace resume separate from and beneath jctl stop
> 
> As written above, I think the current ptrace behavior, despite a lot
> of rough edges, is in the right direction in that ptrace operates
> beneath jctl.  Therefore, keep the basic operation principles but
> clearly define how jctl and ptrace interacts, or rather, how they
> don't.  The following two rules clearly separate jctl and ptrace.
> 
> * jctl stop initiates when one of the stop signals is received and
>   completes when all the member tasks participate in the group stop,
>   where participation preciesly means that a member task stops in
>   do_signal_stop().  Any member task can only participate once in any
>   given group stop.  ptrace does NOT make any difference in this
>   regard.

This proposal adds a new rule for handling of stop notification
by debuggers. Let's spell it out, because currently strace
doesn't act according to this new rule:


"When waitpid indicates stop on a *stop* signal, then it may be either:
* a signal delivery (strace will inject this signal with PTRACE_SYSCALL(sig));
* or it may be a stop notification, in which case strace *must not*
  try to inject this signal (this would be a bug, it'd make task running).
  Instead, strace should just go back to waiting in waitpid().

These two possibilities can be distinquished by querying
PTRACE_GETSIGINFO. On stop notifications, PTRACE_GETSIGINFO
errors out - stop notification is not a signal delivery
and therefore it has no siginfo."


This is easy to implement (in strace at least).

> * However, PTRACE_DETACH should maintain the integrity of group stop.
>   After a tracee is detached, it should be in a state which is
>   conformant to the current jctl state.  If jctl stop is in effect,
>   the task should be put into TASK_STOPPED; otherwise, TASK_RUNNING.

This means that without changes to gdb, this:

# gdb -p pid_of_application_currently_in_jctl_stop
(gdb) print getpid()
(gdb) print show_me_your_internal_debug_dump()
(gdb) continue

will make application run, whereas this:

# gdb -p pid_of_application_currently_in_jctl_stop
(gdb) print getpid()
(gdb) print show_me_your_internal_debug_dump()
(gdb) quit

will leave application stopped. This looks a bit inconsistent to me.

Do you propose gdb to be chaged so that "continue" command
issues PTRACE_CONT only if gdb knows that application is not
in jctl stop?

-- 
vda
