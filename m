Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754562Ab1B1OpG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 09:45:06 -0500
Received: from mx1.redhat.com ([209.132.183.28]:57328 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754521Ab1B1OpD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 09:45:03 -0500
Date: Mon, 28 Feb 2011 15:36:34 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: Tejun Heo <tj@kernel.org>, Roland McGrath <roland@redhat.com>,
        jan.kratochvil@redhat.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
Subject: Re: [PATCH 1/1] ptrace: make sure do_wait() won't hang after
	PTRACE_ATTACH
Message-ID: <20110228143634.GB31850@redhat.com>
References: <20110214190141.GA19221@redhat.com> <20110224202941.GA12258@redhat.com> <20110225155142.GQ24828@htj.dyndns.org> <201102260348.03312.vda.linux@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201102260348.03312.vda.linux@googlemail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/26, Denys Vlasenko wrote:
>
> * HOWEVER, this behavior _is_ indeed used by gdb to run small fragments
>   of tracee even if it's stopped. Jan's example:
>     # gdb -p applicationpid
>     (gdb) print getpid()
>     (gdb) print show_me_your_internal_debug_dump()
>     (gdb) continue
>   gdb people want to preserve this feature.

Yes. Jan is looking at this, and probably he will nack this change.

> How we can accomodate this gdb need while fixing this bug?
>
>
> Oleg's POV is that gdb should SIGCONT the tracee (at least if it is
> currently in group-stop). This has the advantage of using standard Unix
> tool. The disadvantage is that SIGCONT will wake up *all* threads,

Not necessarily. That is why, btw, I started to like Tejun's suggestion,
the traced task should always stop in TASK_TRACED state. This means
SIGCONT can only wakeup the tracee after PTRACE_CONT from debugger.

Even without enforcing TASK_TRACED from the kernel side, gdb should
do at least one ptrace() call after attach, this makes it TASK_TRACED
anyway.

> gdb people
> do want here a "secret" backdoor-ish way to make a *thread*
> (not the whole process) running even when the process is in group-stop.

And this is what I disagree with. This was my main motivation to start
this hopeless^W lengthy discussion ;) I simply can't accept the current
behaviour: the task runs while the kernel and parent think the whole
process is stopped.

That is why I also considered another (and imho worse) option. OK, let's
resume the tracee even if it is stopped. But in this case, let's clear
SIGNAL_STOP_STOPPED and notify its parent.

> how to open a backdoor in ptrace API for gdb:

Probably I am wrong, but in the context of this discussion I do not
care much about the new possible requests/improvements in gdb/kernel.

Of course we can do something to make gdb happy, but the problem is
the current/old code. The main objection (and I have to respect it)
is: this change is not compatible.

Oleg.

