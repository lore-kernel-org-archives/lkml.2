Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755613Ab1E3N5y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 May 2011 09:57:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39062 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753330Ab1E3N5x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 May 2011 09:57:53 -0400
Date: Mon, 30 May 2011 15:56:23 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: Denys Vlasenko <vda.linux@googlemail.com>, jan.kratochvil@redhat.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, indan@nul.nu
Subject: Re: execve-under-ptrace API bug (was Re: Ptrace documentation,
	draft #3)
Message-ID: <20110530135623.GC4739@redhat.com>
References: <BANLkTikH4k0MfTwNzNJN-P85ER4-hKdifw@mail.gmail.com> <20110525143250.GJ10146@htj.dyndns.org> <201105300528.17384.vda.linux@googlemail.com> <20110530084906.GA11773@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110530084906.GA11773@htj.dyndns.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/30, Tejun Heo wrote:
>
> A problem is that by the time de-threading is in progress, it's
> already too deep and there's no way back and the exec'ing thread has
> to wait for completion in uninterruptible sleeps - ie. it expects
> de-threading to finish in finite amount of time and to achieve that it
> basically sends SIGKILL to all other threads.  If we introduce a trap
> in de-threading itself, we can easily end up with an unkillable
> task.

"unkillable" is not the problem, afaics. But the new trap is problematic,
we do not want the TASK_TRACED task holding the mutexes taken by the
callers of de_thread.

> 1. Don't allow more than one thread in the same group enter exec(2)
>    path at all.

This is already done, see do_execve()->prepare_bprm_creds().
cred_guard_mutex serializes exec. Btw, probably this allows us to do
more cleanups/simplifications in do_execve() paths.

> 2. Add another trap point right before de-threading commences.

See above.

Oleg.

