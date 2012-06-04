Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760912Ab2FDQRE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 12:17:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5570 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752716Ab2FDQRB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 12:17:01 -0400
Date: Mon, 4 Jun 2012 18:15:16 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Filipe Brandenburger <filbranden@gmail.com>
Cc: Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] prctl: pdeath_signal sent when parent thread
	(instead of parent process) dies
Message-ID: <20120604161516.GA11243@redhat.com>
References: <1338332348-3469-1-git-send-email-filbranden@gmail.com> <20120601190230.GA405@redhat.com> <CABe66sWwvCq=vWq5=ojbgHZeG764BGvts0cMJExTVrTeHRS+KA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABe66sWwvCq=vWq5=ojbgHZeG764BGvts0cMJExTVrTeHRS+KA@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Filipe,

On 06/01, Filipe Brandenburger wrote:
>
> On Fri, Jun 1, 2012 at 3:02 PM, Oleg Nesterov <oleg@redhat.com> wrote:
> > Filipe, you can't even imagine how much do I like this change
> > personally ;) Although I think that pdeath_signal code should
> > be moved into reparent_leader(). I suggested this many times.
>
> Yes, that would really make sense!

Forgot to mention, and we should make ->pdeath_signal per-process.

> > But I was told there are users which depend on current behaviour,
> > they really want to know when the parent _thread_ exits.
>
> Hmmm... but is it the parent thread inside the same process or the
> thread of the parent process that forked it?

It is the parent thread inside the same process which forked the
child initially. Assuming you are asking about the exiting "father"
thread.

> doesn't really make any
> sense to me...

Same here ;) that is why I tried to change this logic too.

Parent/child relationship is process-wide. task->parent points to
the thread, but this is just the technical detail and it is only
needed because we have __WNOTHREAD (see do_wait).

IOW. I think we should move ->pdeath_signal from task_struct to
signal_struct, and then do

	--- x/kernel/exit.c
	+++ x/kernel/exit.c
	@@ -770,6 +770,9 @@ static void reparent_leader(struct task_
		if (same_thread_group(p->real_parent, father))
			return;
	 
	+	if (p->signal->pdeath_signal)
	+		group_send_sig_info(p->signal->pdeath_signal, SEND_SIG_NOINFO, p);
	+
		/* We don't want people slaying init.  */
		p->exit_signal = SIGCHLD;
	 
	@@ -806,9 +809,6 @@ static void forget_original_parent(struc
					BUG_ON(t->ptrace);
					t->parent = t->real_parent;
				}
	-			if (t->pdeath_signal)
	-				group_send_sig_info(t->pdeath_signal,
	-						    SEND_SIG_NOINFO, t);
			} while_each_thread(p, t);
			reparent_leader(father, p, &dead_children);
		}

Oleg.

