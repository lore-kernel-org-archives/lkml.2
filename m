Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753427Ab2DTItf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 04:49:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38099 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752614Ab2DTItR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 04:49:17 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20120419231455.GA15828@redhat.com>
References: <20120419231455.GA15828@redhat.com> <20120419231431.GA15820@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: dhowells@redhat.com, Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Alexander Gordeev <agordeev@redhat.com>,
        Chris Zankel <chris@zankel.net>, David Smith <dsmith@redhat.com>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Larry Woodman <lwoodman@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Richard Kuo <rkuo@codeaurora.org>, Tejun Heo <tj@kernel.org>,
        linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6 1/6] task_work_add: generic process-context callbacks
Date: Fri, 20 Apr 2012 09:48:58 +0100
Message-ID: <10341.1334911738@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov <oleg@redhat.com> wrote:

> Provide a simple mechanism that allows running code in the
> (nonatomic) context of the arbitrary task.
> 
> The caller does task_work_add(task, task_work) and this task
> executes task_work->func() either from do_notify_resume() or
> from do_exit(). The callback can rely on PF_EXITING to detect
> the latter case.
> 
> "struct task_work" can be embedded in another struct, still it
> has "void *data" to handle the most common/simple case.
> 
> This allows us to kill the ->replacement_session_keyring hack,
> and potentially this can have more users.
> 
> Performance-wise, this adds 2 "unlikely(!hlist_empty())" checks
> into tracehook_notify_resume() and do_exit(). But at the same
> time we can remove the "replacement_session_keyring != NULL"
> checks from arch/*/signal.c and exit_creds().
> 
> Note: task_work_add/task_work_run abuses ->pi_lock. This is
> only because this lock is already used by lookup_pi_state() to
> synchronize with do_exit() setting PF_EXITING. Fortunately the
> scope of this lock in task_work.c is really tiny, and the code
> is unlikely anyway.
> 
> v2:
> 	- implement task_work_cancel(func), it removes the first
> 	  task_work with the same callback.
> v3:
> 	- task_work_add() gets the new arg, "bool notify" to
> 	  conditionalize set_notify_resume(), this makes it useable
> 	  for kthreads and task_work_add(notify => false) can
> 	  work without TIF_NOTIFY_RESUME.
> 
> 	- don't add the dummy "ifndef TIF_NOTIFY_RESUME" inlines,
> 	  just add the simple check in task_work_add().
> v4:
> 	- s/task_work_queue/task_work_add/
> v5:
> 	- task_work_run() uses current explicitely
> 
> Todo:
> 	- move clear_thread_flag(TIF_NOTIFY_RESUME) from arch/
> 	  to tracehook_notify_resume()
> 
> 	- rename tracehook_notify_resume() and move it into
> 	  linux/task_work.h
> 
> 	- m68k and xtensa don't have TIF_NOTIFY_RESUME and thus
> 	  task_work_add(notify => true) fails with -ENOTSUPP.
> 
> 	  However, ->replacement_session_keyring equally needs
> 	  this flag, task_work_add() is not worse.
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>

Acked-by: David Howells <dhowells@redhat.com>
