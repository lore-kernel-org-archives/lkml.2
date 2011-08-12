Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753698Ab1HLR6v (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Aug 2011 13:58:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16306 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752830Ab1HLR6t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Aug 2011 13:58:49 -0400
Date: Fri, 12 Aug 2011 19:55:50 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: Roland McGrath <roland@hack.frob.com>,
        Denys Vlasenko <dvlasenk@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Matt Fleming <matt.fleming@linux.intel.com>,
        linux-kernel@vger.kernel.org, Pavel Machek <pavel@ucw.cz>
Subject: [PATCH v2 0/3] make vfork killable
Message-ID: <20110812175550.GA7484@redhat.com>
References: <20110727163159.GA23785@redhat.com> <20110729192358.GB31717@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110729192358.GB31717@mtj.dyndns.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tejun,

On 07/29, Tejun Heo wrote:
>
> If the current implementation is too nasty,

OK, I agree, the patches I sent doesn't look very clear/clean.

But,

> an alternative approach
> could be handling vfork waiting as a type of job control stop.

Well, I didn't see the code, but to be honest this doesn't look
like a good idea to me. Firstly, personally I do not think this
has something to do with the job control stop.

And, to me sys_restart_syscall() looks like the very natural
approach, and simple.

> * When entering get_signal_to_deliver(), if vfork child exists, save
>   sigmask and block all blockable signals.

Oh, I'd like to avoid this. Why should we change get_signal_to_deliver()
paths to help vfork?

> * When leaving get_signal_to_deliver(), restore sigmask if saved on
>   entry.

And I _think_ we need much more complications. We still need to
communicate with the child, for example. Unless we are going to
add the "struct completion vfork_done" or something into task_struct,
personally I dislike this idea.

> Haven't really thought a lot about the details so this might end up
> uglier than the current attempt.  :)

I _hope_ it is much uglier, but I can be wrong of course ;)

OK. Can't we make the first step at least? Make it killable. I think
this will simplify the next changes anyway.

So. This seried makes vfork() killable. No restarts, just
s/wait_for_completion/wait_for_completion_killable/ + clear
child->vfork_done if killed.

The only overhead this patch adds to CLONE_VFORK

	- parent does get_task_struct() + put_task_struct()

	- child does task_lock() + task_unlock()

4/3 is off-topic, somehow I hate PF_STARTING irrationally. and it
helps to make the diffstat below better ;)

Oleg.

 fs/exec.c             |   18 +-------------
 include/linux/sched.h |    1 -
 kernel/fork.c         |   61 +++++++++++++++++++++++++++++++-----------------
 3 files changed, 41 insertions(+), 39 deletions(-)


