Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756545Ab1CWSrw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 14:47:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11959 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755164Ab1CWSrv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 14:47:51 -0400
Date: Wed, 23 Mar 2011 19:38:37 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: jan.kratochvil@redhat.com, vda.linux@googlemail.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, indan@nul.nu, roland@hack.frob.com
Subject: Re: [PATCHSET] ptrace,signal: Improve ptrace and job control
	interaction
Message-ID: <20110323183837.GA27680@redhat.com>
References: <1300874766-12941-1-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1300874766-12941-1-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/23, Tejun Heo wrote:
>
> All patches have been reviewed and acked by Oleg and this will be the
> last repost of these patches.  They're being committed to a stable git
> tree (will eventually be managed by Oleg) and will be pulled into
> linux-next once -rc1 is released.

Thanks Tejun. The whole series is fine imho.




But of course we need more changes. In particular, there is still the
small problem with the CLD_CONTINUED notification.

__ptrace_unlink() does signal_wake_up() if it adds SIGNAL_STOP_STOPPED.
This is correct, but it should also add TIF_SIGPENDING if
(signal->flags & SIGNAL_CLD_MASK) != 0.

Otherwise, if the stopped tracee was PTRACE_CONT'ed and then SIGCONT
ends the group-stop, the real_parent won't be notified after detach.

Unfortunately, this means that recalc_sigpending_tsk() has to check
SIGNAL_CLD_MASK as well. Do you see another solution?



There is another case. SIGCONT can hit the stopped-but-running-task,
but I don't think we should try to set TIF_SIGPENDING in this case,
you are going to add the trap later.
There is another case. SIGCONT can hit the stopped-but-running-task,
but I don't think we should try to set TIF_SIGPENDING in this case,
you are going to add the trap later.

Oleg.

