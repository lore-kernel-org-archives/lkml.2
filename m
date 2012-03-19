Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161311Ab2CSQKv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 12:10:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13223 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757053Ab2CSQKu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 12:10:50 -0400
Date: Mon, 19 Mar 2012 17:02:49 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Al Viro <viro@zeniv.linux.org.uk>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        James Morris <james.l.morris@oracle.com>,
        Greg KH <gregkh@linuxfoundation.org>, Ingo Molnar <mingo@elte.hu>,
        Roland McGrath <roland@hack.frob.com>,
        Solar Designer <solar@openwall.com>,
        Djalal Harouni <tixxdz@opendz.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] exec_id/exit_signal fixes
Message-ID: <20120319160249.GA4910@redhat.com>
References: <1331421919-15499-1-git-send-email-tixxdz@opendz.org> <1331421919-15499-2-git-send-email-tixxdz@opendz.org> <20120311172512.GA2729@redhat.com> <20120311174953.GB2729@redhat.com> <CA+55aFx43nZmhRg5Qv5x-4BdgcM-y80ECrgC8mCWc0RqU+_8rQ@mail.gmail.com> <20120314185510.GA14172@redhat.com> <20120314190939.GC14172@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120314190939.GC14172@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew, these changes are orthogonal to
"CLONE_PARENT shouldn't allow to set ->exit_signal" in -mm.

Please review/comment. The patches are really simple I hope,
but with or without them I do not understand eligible_child().

	/* Wait for all children (clone and not) if __WALL is set;
	 * otherwise, wait for clone children *only* if __WCLONE is
	 * set; otherwise, wait for non-clone children *only*.  (Note:
	 * A "clone" child here is one that reports to its parent
	 * using a signal other than SIGCHLD.) */
	if (((p->exit_signal != SIGCHLD) ^ !!(wo->wo_flags & __WCLONE))
	    && !(wo->wo_flags & __WALL))
		return 0;

OK, but exec/exit can change ->exit_signal "in between".

For example. The parent clones the !SIGCHLD child and does
do_wait(__WCLONE). The child execs. The parent still sleeps until
child exits but do_wait() returns ECHILD. And more, this also
depends on who does exec in mt case.

Or the parent execs. In this case eligible_child() depends on when
the child exits, before or after exec.

Anyway, the current check in exit_notify() is wrong, 2/2 tries to
fix this. But both patches add the (hopefully minor) user-visible
changes wrt eligible_child().

Really, I think de_thread() should set ->exit_signal = SIGCHLD for
each child. This looks simple and understandable, and with the
CLONE_PARENT change above we can kill self_exec_id/parent_exec_id.


May be de_thread() should also do __wake_up_parent() if it changes
->exit_signal. Or perhaps we should change eligible_child() to check
p->cloned_with_not_SIGCHLD. I dunno. I hope this doesn't matter
and nobody cares.

OTOH, I never understood why we should reset ->exit_signal if the
child execs but the parent is still the same.


3/3 is offtopic minor cleanup. Imho setmax_mm_hiwater_rss() in
de_thread() looks strange.

Oleg.

