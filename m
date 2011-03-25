Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753578Ab1CYO0h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 10:26:37 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:56796 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753507Ab1CYO0e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 10:26:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=o+LUptvxjpZHTbnp8xm1DqP3xzPK9mnXeAJRmfVdMOEw3cWf/929qnkFDMqnpUJT0J
         xgs+miKI8PdF27TN3A1z/9Tl/V3jkEkOsgQM0ZMyuVaLmlB36HJ/AigQWgMssRhWtSRO
         46uDI5OkLpZ4ivx5713a9MlnWczzu5Nhj/h1U=
Date: Fri, 25 Mar 2011 15:26:30 +0100
From: Tejun Heo <tj@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: jan.kratochvil@redhat.com, vda.linux@googlemail.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, indan@nul.nu, roland@hack.frob.com
Subject: Re: [PATCHSET] ptrace,signal: Improve ptrace and job control
 interaction
Message-ID: <20110325142630.GD1409@htj.dyndns.org>
References: <1300874766-12941-1-git-send-email-tj@kernel.org>
 <20110323183837.GA27680@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110323183837.GA27680@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Oleg.

On Wed, Mar 23, 2011 at 07:38:37PM +0100, Oleg Nesterov wrote:
> But of course we need more changes. In particular, there is still the
> small problem with the CLD_CONTINUED notification.
> 
> __ptrace_unlink() does signal_wake_up() if it adds SIGNAL_STOP_STOPPED.
> This is correct, but it should also add TIF_SIGPENDING if
> (signal->flags & SIGNAL_CLD_MASK) != 0.
> 
> Otherwise, if the stopped tracee was PTRACE_CONT'ed and then SIGCONT
> ends the group-stop, the real_parent won't be notified after detach.

Heh, that's an interesting one.  I don't think it has much to do with
__ptrace_unlink() tho.  Isn't the proper solution using something akin
to signal_wake_up() in SIGCONT generation path in prepare_signal()?

Explicit wake_up_state() without kick_process() is okay there because
if the code assumes that the tasks are guaranteed to pass through
signal delivery path whenever event worthy of notification happens
(either SIGNAL_STOP_STOPPED or group_stop_count is set).  PTRACE_CONT
breaks that as the tracee could be running in userland and thus the
solution is to add kick_process() as in signal_wake_up().

Am I making any sense?

> Unfortunately, this means that recalc_sigpending_tsk() has to check
> SIGNAL_CLD_MASK as well. Do you see another solution?

Hmmm... I think the above subtle breakage exists for !ptrace case too.
Please consider the following scenario.

* SIGSTOP is sent to a task and group stop is initiated.

* Before the task participates in group stop, SIGCONT is sent.

* Before CLD_STOPPED notification for the incomplete-stop/cont
  sequence can be made, recalc_sigpending() happens.

* CLD_STOPPED notification is pending but TIF_SIGPENDING isn't set and
  the task isn't in signal delivery path and can continue execution.

It's a pretty convoluted extremely unlikely corner case tho.  Anyways,
adding SIGNAL_CLD_MASK test to recalc_sigpending() should solve it.

> There is another case. SIGCONT can hit the stopped-but-running-task,
> but I don't think we should try to set TIF_SIGPENDING in this case,
> you are going to add the trap later.

Hmmm... As I wrote above, I think we should do it regardless of the
new trap.

Thanks.

-- 
tejun
