Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754742Ab1G0QfJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 12:35:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26943 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754345Ab1G0QfG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 12:35:06 -0400
Date: Wed, 27 Jul 2011 18:31:59 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Roland McGrath <roland@hack.frob.com>, Tejun Heo <tj@kernel.org>
Cc: Denys Vlasenko <dvlasenk@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Matt Fleming <matt.fleming@linux.intel.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/8] make vfork killable/restartable/traceable
Message-ID: <20110727163159.GA23785@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

CLONE_VFORK sleeps in TASK_INTERRUPTIBLE until the child exits/execs.
This is obviously not good, it is sooo simple to create the task which
doesn't react to SIGKILL/SIGSTOP.

Questions:

	- do we really need this?

	  I think we do. This really "looks like a bug" in any case,
	  even if nobody ever complained afaik.

	- may be 1-3 is enough?

	  may be... but personally I think SIGSTOP/ptrace should work
	  too.

	- is it safe to exit/stop on !x86 machine???

	  I do not know. May be this needs some #ifdef's around
	  wait_for_completion_interruptible(). I am not sure that,
	  say, arch_ptrace_stop() can't abuse the ->mm shared with
	  the child.

	  OTOH. This can happen anyway, do_fork() does ptrace_event()
	  before wait_for_completion().

	- and of course, while I think this is bugfix, this is user
	  visible change.

Please comment.

9/8 is off-topic.

Oleg.

 fs/exec.c                   |   11 ----
 include/linux/sched.h       |    2 +-
 include/linux/thread_info.h |    4 ++
 kernel/fork.c               |  121 ++++++++++++++++++++++++++++++++++---------
 kernel/pid.c                |   13 +++++
 5 files changed, 114 insertions(+), 37 deletions(-)

