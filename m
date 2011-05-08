Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755587Ab1EHW1q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 May 2011 18:27:46 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:63473 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754879Ab1EHW1p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 May 2011 18:27:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=GaSt4vaIXO3Xxrflu3Zar/3yRaID46xwce6GNVy/dtUGfa6NrEkJ3aJGcdvRMlj/2y
         CPbkPQTaBESfN6UaXEDIQv8sxuqH4T16COlSfA4CCv/W5cWqR88KQby327zcCbV1RHGp
         GGo2mClkxmJ2qmVrWZHOl4E4MBR7nKiOy+pUQ=
From: Denys Vlasenko <vda.linux@googlemail.com>
To: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCHSET ptrace] ptrace: implement PTRACE_SEIZE/INTERRUPT and group stop notification
Date: Mon, 9 May 2011 00:27:41 +0200
User-Agent: KMail/1.8.2
Cc: oleg@redhat.com, jan.kratochvil@redhat.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org, indan@nul.nu
References: <1304869745-1073-1-git-send-email-tj@kernel.org>
In-Reply-To: <1304869745-1073-1-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201105090027.41534.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 08 May 2011 17:48, Tejun Heo wrote:
> Hello,
> 
> This patchset implements new ptrace requests SEIZE and INTERRUPT and
> also add group stop notification mechanism for ptracer.  Combined,
> this implements "P4. PTRACE_SEIZE" and "P5. ^Z and fg for tracees" of
> the ptrace job control improvements proposal[1].
> 
> Please note that there are some deviations from the proposal.

No battle plan survives contact with the enemy :)

> * As suggested by Oleg, PTRACE_SEIZE only serves as ATTACH without
>   signal/job control side-effects.  After attached, PTRACE_INTERRUPT
>   should be used to trap tracee without side effect.

Hmm, in "[PATCH 02/11] ptrace: implement PTRACE_SEIZE" you are saying:

> After PTRACE_SEIZE, tracee will trap.

So which is it? Does PTRACE_SEIZE trap or not?


> * Group stop notification is implemented as sticky INTERRUPT trap
>   which gets cleared on PTRACE_GETSIGINFO and notifies both start and
>   end of group stops.
> ...
> * The trap condition is sticky until GETSIGINFO.  This is necessary
>   because generation of the event may race with CONT and ptracer may
>   miss the trap.

As a userspace guy, I find this explanation unclear.

What is "sticky" exactly? siginfo.si_pt_flags contents?

What exactly "sticky" means? If PTRACE_GETSIGINFO is not queried
by userspace after it observed ptrace stop, what will happen?

Your example code in
"[PATCH 11/11] ptrace: implement group stop notification for ptracer"
does this:

                  waitid(P_PID, tracee, NULL, WSTOPPED);

                  if (!ptrace(PTRACE_GETSIGINFO, tracee, NULL, &si)) {
                          if (!si.si_code) {
                                  printf("tracer: SIG %d\n", si.si_signo);
                                  ptrace(PTRACE_CONT, tracee, NULL,
                                         (void *)(unsigned long)si.si_signo);
                                  goto repeat;
                          }
                          stopped = !!si.si_status;
                  } else
                          stopped = 1;

                  if (stopped != last_stopped)
                          printf("tracer: stopped=%d\n", stopped);
                  last_stopped = stopped;

                  if (!stopped)
                          ptrace(PTRACE_CONT, tracee, NULL, NULL);

That is, it always queries PTRACE_GETSIGINFO, which means this example
doesn't demonstrate "stickiness".


Real world users of ptrace, such as strace, will likely avoid
PTRACE_GETSIGINFO'ing on every stop - they will examine wait status,
and query PTRACE_GETSIGINFO only if they know they have to -
such as when they see a job stop signal (SIGSTOP/SIGTSTP/etc),
not SIGTRAP.

Is it still possible, or PTRACE_GETSIGINFO will be a mandatory call
after each ptrace stop for any userspace usage which wants to track
job stop status of the tracee?


> Each patch implementing new feature includes test program showing its
> functionality.  Notification would probably need a bit more polishing
> but all the needed functionalities are there.

This is great! Thanks!

I don't know the status of ptrace test suite
after I stopped working on strace (did the suite bit rot, or is it
maintained and still relevant?). If it is still in use,
I can adapt these tests and add them to it.

-- 
vda
