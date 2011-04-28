Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754301Ab1D1HHM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Apr 2011 03:07:12 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:44982 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753467Ab1D1HHK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Apr 2011 03:07:10 -0400
Date: Thu, 28 Apr 2011 09:06:36 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Will Drewry <wad@chromium.org>
Cc: linux-kernel@vger.kernel.org, kees.cook@canonical.com, eparis@redhat.com,
        agl@chromium.org, jmorris@namei.org, rostedt@goodmis.org,
        Randy Dunlap <rdunlap@xenotime.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tom Zanussi <tzanussi@gmail.com>,
        =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 5/7] seccomp_filter: Document what seccomp_filter is and
 how it works.
Message-ID: <20110428070636.GC952@elte.hu>
References: <1303960136-14298-1-git-send-email-wad@chromium.org>
 <1303960136-14298-4-git-send-email-wad@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1303960136-14298-4-git-send-email-wad@chromium.org>
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

> +A collection of filters may be supplied via prctl, and the current set of
> +filters is exposed in /proc/<pid>/seccomp_filter.
> +
> +For instance,
> +  const char filters[] =
> +    "sys_read: (fd == 1) || (fd == 2)\n"
> +    "sys_write: (fd == 0)\n"
> +    "sys_exit: 1\n"
> +    "sys_exit_group: 1\n"
> +    "on_next_syscall: 1";
> +  prctl(PR_SET_SECCOMP, 2, filters);
> +
> +This will setup system call filters for read, write, and exit where reading can
> +be done only from fds 1 and 2 and writing to fd 0.  The "on_next_syscall" directive tells
> +seccomp to not enforce the ruleset until after the next system call is run.  This allows
> +for launchers to apply system call filters to a binary before executing it.
> +
> +Once enabled, the access may only be reduced.  For example, a set of filters may be:
> +
> +  sys_read: 1
> +  sys_write: 1
> +  sys_mmap: 1
> +  sys_prctl: 1
> +
> +Then it may call the following to drop mmap access:
> +  prctl(PR_SET_SECCOMP, 2, "sys_mmap: 0");

Ok, color me thoroughly impressed - AFAICS you implemented my suggestions in:

  http://lwn.net/Articles/332974/

and you made it work in practice!

We could split out the ftrace filter engine some more and make it more 
independent of ftrace. It's basically an in-kernel interpreter able to run off 
tracepoints.

I've Cc:-ed Linus and Andrew: are you guys opposed to such flexible, dynamic 
filters conceptually? I think we should really think hard about the actual ABI 
as this could easily spread to more applications than Chrome/Chromium.

Btw., i also think that such an approach is actually the sane(r) design to 
implement security modules: using such filters is far more flexible than the 
typical LSM approach of privileged user-space uploading various nasty objects 
into kernel space and implementing silly (and limited and intrusive) hooks 
there, like SElinux and the other security modules do.

This approach also has the ability to become recursive (gets inherited by child 
tasks, which could add their own filters) and unprivileged - unlike LSMs.

I like this *a lot* more than any security sandboxing approach i've seen 
before.

Thanks,

	Ingo
