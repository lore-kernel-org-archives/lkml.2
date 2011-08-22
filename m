Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752743Ab1HVNiq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 09:38:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44791 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752457Ab1HVNip (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 09:38:45 -0400
Date: Mon, 22 Aug 2011 15:35:40 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Matt Fleming <matt.fleming@intel.com>
Cc: Tejun Heo <tj@kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>,
        Roland McGrath <roland@hack.frob.com>,
        Denys Vlasenko <dvlasenk@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org, Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCH 2/3] vfork: make it killable
Message-ID: <20110822133540.GA28724@redhat.com>
References: <20110727163159.GA23785@redhat.com> <20110729192358.GB31717@mtj.dyndns.org> <20110812175550.GA7484@redhat.com> <20110812175629.GC7484@redhat.com> <1313786038.19751.2.camel@mfleming-mobl1.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1313786038.19751.2.camel@mfleming-mobl1.ger.corp.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/19, Matt Fleming wrote:
>
> On Fri, 2011-08-12 at 19:56 +0200, Oleg Nesterov wrote:
> > Make vfork() killable.
> >
> > Change do_fork(CLONE_VFORK) to do wait_for_completion_killable().
> > If it fails we do not return to the user-mode and never touch ->mm
> > shared with our child.
> >
> > However, in this case we should clear child->vfork_done before
> > return, we use task_lock() in do_fork()->wait_for_vfork_done()
> > and complete_vfork_done() to serialize with each other.
>
> It's probably worth updating the comment above task_lock() in
> include/linux/sched.h, to say that it is now used to protect
> ->vfork_done.

OK, added

	@@ -2335,7 +2335,7 @@ static inline int thread_group_empty(struct task_struct *p)
	  * Protects ->fs, ->files, ->mm, ->group_info, ->comm, keyring
	  * subscriptions and synchronises with wait4().  Also used in procfs.  Also
	  * pins the final release of task.io_context.  Also protects ->cpuset and
	- * ->cgroup.subsys[].
	+ * ->cgroup.subsys[]. And ->vfork_done.
	  *
	  * Nests both inside and outside of read_lock(&tasklist_lock).
	  * It must not be nested with write_lock_irq(&tasklist_lock),

to this patch, and pushed 1-4 into ptrace branch.

Oleg.

