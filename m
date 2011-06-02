Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751920Ab1FBO3g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jun 2011 10:29:36 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:40805 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751829Ab1FBO3e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jun 2011 10:29:34 -0400
Date: Thu, 2 Jun 2011 16:29:16 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Will Drewry <wad@chromium.org>
Cc: linux-kernel@vger.kernel.org, kees.cook@canonical.com,
        torvalds@linux-foundation.org, tglx@linutronix.de, rostedt@goodmis.org,
        jmorris@namei.org, Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH v3 02/13] tracing: split out syscall_trace_enter
 construction
Message-ID: <20110602142916.GA18325@elte.hu>
References: <BANLkTimNcag-ZmVTXjUoTyiuJm6jtW0DgA@mail.gmail.com>
 <1306897845-9393-2-git-send-email-wad@chromium.org>
 <20110601070023.GB27671@elte.hu>
 <BANLkTimWvddKkVQA1qOc6KhxPUj8j2dWQg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTimWvddKkVQA1qOc6KhxPUj8j2dWQg@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Will Drewry <wad@chromium.org> wrote:

> > If you agree with my observation that filters allow the clean 
> > user-space implementation of LSM equivalent security solutions 
> > (of which sandboxes are just a *narrow special case*) then please 
> > use the main highlevel abstraction we have defined around them: 
> > event filters.
> 
> I agree that LSM-equivalent security solutions can be moved over to 
> an ftrace based infrastructure.  However, LSMs and seccomp have 
> different semantics.  Reducing the kernel attack surface in a 
> "sandboxing"-sort-of-way requires a default-deny interface that is 
> resilient to kernel changes (like new system calls) without 
> immediately degrading robustness. [...]

Correct. Because seccomp is the user of those syscall-surface events 
it can use them in such a way - i see no problem there: unknown or 
not permitted syscalls get denied for seccomp-mode-2 tasks.

> [...] LSMs provide a fail-open mechanism for taking an active role 
> in kernel-defined pinch points.  It is possible to implement a 
> default-deny LSM, but it requires a "hook" for every security event 
> and the addition of a security event results in a hole in the 
> not-so-default-deny infrastructure.  ftrace + event filters are the 
> same.

Well, i only suggested that it's LSM-equivalent security 
functionality, i did not suggest that you should implement an LSM in 
security/. I do not think the LSM modularization is particularly well 
fit for seccomp.

> Based on my observations while exploring the code, it appears that 
> the LSM security_* calls could easily become active trace events 
> and the LSM infrastructure moved over to use those as tracepoints 
> or via event_filters.  There will be a need for new predicates for 
> the various new types (inode *, etc), and so on.  However, the 
> trace_sys_enter/__secure_computing model will still be a special 
> case.

Yes, and that special event will not go away!

I did not suggest to *replace* those events with the security events. 
I suggested to *combine* them - or at least have a model that 
smoothly extends to those events as well and does not limit itself to 
the syscall surface alone.

We'll want to have both.

But by hardcoding to only those events, and creating a 
syscall-numbering special ABI, a wall will be risen between this 
implementation and any future enhancement to cover other events. My 
suggestion would be to use the event filter approach - that way 
there's not a wall but an open door towards future extensions ;-)

Thanks,

	Ingo
