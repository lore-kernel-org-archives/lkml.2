Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757629Ab1EZO5u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 10:57:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21345 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757023Ab1EZO5t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 10:57:49 -0400
Date: Thu, 26 May 2011 16:55:45 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: Pedro Alves <pedro@codesourcery.com>,
        Denys Vlasenko <vda.linux@googlemail.com>, jan.kratochvil@redhat.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, indan@nul.nu, bdonlan@gmail.com
Subject: Re: [PATCH 03/10] ptrace: implement PTRACE_SEIZE
Message-ID: <20110526145545.GC12525@redhat.com>
References: <1305569849-10448-1-git-send-email-tj@kernel.org> <201105241049.58921.pedro@codesourcery.com> <20110524120013.GD10334@htj.dyndns.org> <201105241336.04298.pedro@codesourcery.com> <20110524140215.GF10334@htj.dyndns.org> <20110525181856.GA16575@redhat.com> <20110526091041.GC9715@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110526091041.GC9715@htj.dyndns.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/26, Tejun Heo wrote:
>
> This reminded me of another issue.  Currently we have two different
> methods of reporting debug events.  One is direct ptrace event trap,
> which ends up in ptrace_stop() from the event site and thus is
> synchronous.  The other is sending SIGTRAP, literally.  Besides the
> usual problems related with implicitly sending signals, this also
> makes it difficult to determine which event is happening exactly and
> makes the whole signal delivery/injection thing much worse.
>
> I suspect that all ptrace traps probably started as actual SIGTRAPs
> and so all the events were reported via signal delivery path and so
> the signal "injection" worked; however, now we have synchronous traps
> and some SIGTRAPs, which are confusing and unreliable.  I don't see
> any reason why the events which are currently reported via SIGTRAPs
> can't be reported via ptrace traps with unique PTRACE_EVENT_*.  I
> don't think we can take synchronous traps directly but we can schedule
> them, record relevant information in preallocated area and just set
> TIF_SIGPENDING and let the signal delivery path report the trap.  This
> will make all the events reliable and easily distinguishible and we
> can fix the SIGTRAP signal problem.  What do you think?

Agreed, it would be nice to avoid SIGTRAP's. Although right now it is
not clear to me how we can do this. The problematic case is the
single-stepping, afaics. Say, int3. Even if the task is ptraced, we
can't know why do we hit this insn. It is possible that this task
auto-debugs itself and thus we should send SIGTRAP. Even the
X86_EFLAGS_TF case is not that simple although we can probably take
TIF_SINGLESTEP into account. But again, the task can set X86_EFLAGS_TF
itself.

Oleg.

