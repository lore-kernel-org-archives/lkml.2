Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754795Ab2EBMGl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2012 08:06:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7309 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753467Ab2EBMGk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2012 08:06:40 -0400
Message-ID: <4FA12344.4090608@redhat.com>
Date: Wed, 02 May 2012 13:06:28 +0100
From: Pedro Alves <palves@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120424 Thunderbird/12.0
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>,
        pacman@kosh.dhis.org, linux-man <linux-man@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Denys Vlasenko <dvlasenk@redhat.com>, Tejun Heo <tj@kernel.org>,
        Jan Kratochvil <jan.kratochvil@redhat.com>
Subject: Re: ptrace.2: PTRACE_KILL needs a stopped process too
References: <20091216004533.22261.qmail@kosh.dhis.org> <CAKgNAkhtu8d0NKcTwWyCA8qWgz8Lag+GcpEE1=YMVe_Nh8XJ9Q@mail.gmail.com> <20120422200459.GA7519@redhat.com>
In-Reply-To: <20120422200459.GA7519@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/22/2012 09:04 PM, Oleg Nesterov wrote:

> On 04/23, Michael Kerrisk (man-pages) wrote:
>>
>> [widening CC]
> 
> add more CC's
> 
>> The man page says "For requests other than PTRACE_KILL,
> 
> Argh, PTRACE_KILL again.
> 
> You know, I simply do not know what it was supposed to do. I can only
> see what the code actually does.
> 
>> the child process
>> must be stopped."
> 
> Yes and no.
> 
> Yes, ptrace(PTRACE_KILL) "succeeds" even if the tracee is not stopped.
> 
> No, it has no effect if the tracee is not stopped.
> 
> All I can say is: PTRACE_KILL should never exist. If you want to kill
> the tracee, you can do kill(SIGKILL).
> 
> Roughly, ptrace(PTRACE_KILL) is equal to ptrace(PTRACE_CONT, SIGKILL)
> except it always returns 0.
> 
>> If the man page is describing actual intended kernel behavior, then it's a
>> fairly long-standing kernel bug.
> 
> Perhaps. May be it should simply do kill(SIGKILL), but then it is not
> clear why do we have PTRACE_KILL. And once again, I was never able to
> understand the supposed behaviour.
> 
> Personally, I think we should fix the documentation. And imho the only
> possible fix is to add this note: do not ever use PTRACE_KILL.


Yeah.  Here's what gdb's gdbserver does nowadays (gdb does the exact same,
though only gdbserver's version has this comment):

static void
linux_kill_one_lwp (struct lwp_info *lwp)
{
  int pid = lwpid_of (lwp);

  /* PTRACE_KILL is unreliable.  After stepping into a signal handler,
     there is no signal context, and ptrace(PTRACE_KILL) (or
     ptrace(PTRACE_CONT, SIGKILL), pretty much the same) acts like
     ptrace(CONT, pid, 0,0) and just resumes the tracee.  A better
     alternative is to kill with SIGKILL.  We only need one SIGKILL
     per process, not one for each thread.  But since we still support
     linuxthreads, and we also support debugging programs using raw
     clone without CLONE_THREAD, we send one for each thread.  For
     years, we used PTRACE_KILL only, so we're being a bit paranoid
     about some old kernels where PTRACE_KILL might work better
     (dubious if there are any such, but that's why it's paranoia), so
     we try SIGKILL first, PTRACE_KILL second, and so we're fine
     everywhere.  */

  errno = 0;
  kill (pid, SIGKILL);
  if (debug_threads)
    fprintf (stderr,
	     "LKL:  kill (SIGKILL) %s, 0, 0 (%s)\n",
	     target_pid_to_str (ptid_of (lwp)),
	     errno ? strerror (errno) : "OK");

  errno = 0;
  ptrace (PTRACE_KILL, pid, 0, 0);
  if (debug_threads)
    fprintf (stderr,
	     "LKL:  PTRACE_KILL %s, 0, 0 (%s)\n",
	     target_pid_to_str (ptid_of (lwp)),
	     errno ? strerror (errno) : "OK");
}

-- 
Pedro Alves
