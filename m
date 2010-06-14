Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755156Ab0FNA4V (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jun 2010 20:56:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23729 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755140Ab0FNA4U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jun 2010 20:56:20 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
X-Fcc: ~/Mail/linus
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       David Rientjes <rientjes@google.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Nick Piggin <npiggin@suse.de>
Subject: Re: uninterruptible CLONE_VFORK (Was: oom: Make coredump interruptible)
In-Reply-To: Oleg Nesterov's message of  Sunday, 13 June 2010 19:13:37 +0200 <20100613171337.GA12159@redhat.com>
References: <20100604112721.GA12582@redhat.com>
	<20100609195309.GA6899@redhat.com>
	<20100613175547.616F.A69D9226@jp.fujitsu.com>
	<20100613155354.GA8428@redhat.com>
	<20100613171337.GA12159@redhat.com>
X-Antipastobozoticataclysm: Bariumenemanilow
Message-Id: <20100614005608.0D006408C1@magilla.sf.frob.com>
Date: Sun, 13 Jun 2010 17:56:07 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Oh. And another problem, vfork() is not interruptible too. This means
> that the user can hide the memory hog from oom-killer. 

I'm not sure there is really any danger like that, because of the
oom_kill_process "Try to kill a child first" logic.  Eventually the vfork
child will be chosen and killed, and when it finally exits that will
release the vfork wait.  So if the vfork parent is really the culprit,
it will then be subject to oom_kill_process sooner or later.

> But let's forget about oom.

Sure, but it reminds me to mention that vfork mm sharing is another reason
that having oom_kill set some persistent state in the mm seems wrong.  If a
vfork child is chosen for oom_kill and killed, then it's possible that will
relieve the need (e.g. much memory was held indirectly via its fd table or
whatnot else that is not shared with the parent via mm).  So once the child
is dead, there should not be any lingering bits in the parent's mm.

> Roland, any reason it should be uninterruptible? This doesn't look good
> in any case. Perhaps the pseudo-patch below makes sense?

I've long thought that we should make a vfork parent SIGKILL-able.  (Of
course the vfork wait can't be made interruptible by other signals, since
it must never do anything userish like signal handler setup until the child
has died or exec'd.)  I don't know off hand of any problem with your
straightforward change.  But I don't have much confidence that there isn't
any strange gotcha waiting there due to some other kind of implicit
assumption about vfork parent blocks that we are overlooking at the moment.
So I wouldn't change this without more thorough auditing and thinking about
everything related to vfork.

Personally, what I've really been interested in is changing the vfork wait
to use some different kind of blocking entirely.  My real motivation for
that is to let a vfork wait be morphed into and out of TASK_TRACED, so a
debugger can examine its registers and so forth.  That would entail letting
the vfork/clone syscall return fully back to the asm level so it could stop
in a proper state some place like the syscall-exit or notify-resume points.
However, that has other wrinkles on machines like sparc and ia64, where
user_regset access can involve user memory access.  Since we can't allow
those while the user memory is still shared with the child, it might not
really be practical at all.


Thanks,
Roland
