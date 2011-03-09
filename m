Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756911Ab1CIBbG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Mar 2011 20:31:06 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:34164 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932068Ab1CIBbD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Mar 2011 20:31:03 -0500
Date: Wed, 9 Mar 2011 01:30:17 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Stephen Wilson <wilsons@start.ca>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Roland McGrath <roland@redhat.com>, Matt Mackall <mpm@selenic.com>,
        David Rientjes <rientjes@google.com>, Nick Piggin <npiggin@kernel.dk>,
        Andrea Arcangeli <aarcange@redhat.com>, Mel Gorman <mel@csn.ul.ie>,
        Ingo Molnar <mingo@elte.hu>, Michel Lespinasse <walken@google.com>,
        Hugh Dickins <hughd@google.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/6] enable writing to /proc/pid/mem
Message-ID: <20110309013017.GY22723@ZenIV.linux.org.uk>
References: <1299631343-4499-1-git-send-email-wilsons@start.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1299631343-4499-1-git-send-email-wilsons@start.ca>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 08, 2011 at 07:42:17PM -0500, Stephen Wilson wrote:
> For a long time /proc/pid/mem has provided a read-only interface, at least
> since 2.4.0.  However, a write capability has existed "forever" in tree via the
> function mem_write(), disabled with an #ifdef along with the comment "this is a
> security hazard".  Currently, the main problem with mem_write() is that between
> the time permissions are checked and the actual write the target task could
> exec a setuid-root binary.
> 
> This patch series enables safe writes to /proc/pid/mem.  The principle strategy
> is to get a reference to the target task's mm before the permission check, and
> to hold that reference until after the write completes.

One note: I'd rather prefer approach similar to mm_for_maps().  IOW, instead
of "check, then get mm, then check _again_ to decide if we are allowed to
use it", just turn check_mm_permissions() into a function that returns
you a safe mm or gives you NULL (or, better yet, ERR_PTR(...)).  With all
checks done within that sucker.

Then mem_read() and mem_write() wouldn't need to recheck anything again
and the same helper would be usable for other things as well.  I mean
something like this: (*WARNING* - completely untested)

        err = mutex_lock_killable(&tsk->signal->cred_guard_mutex);
	if (err)
                return ERR_PTR(err);

        mm = get_tsk_mm(tsk);
	if (!mm) {
		mm = ERR_PTR(-EPERM);	/* maybe EINVAL here? */
	} else if (mm != current->mm) {
		int match;
	        /*
		 * If current is actively ptrace'ing, and would also be
		 * permitted to freshly attach with ptrace now, permit it.
		 */
		if (!tsk_is_stopped_or_traced(tsk))
			goto Eperm;
		rcu_read_lock();
		match = (tracehook_tracer_tsk(tsk) == current);
		rcu_read_unlock();
		if (!match)
			goto Eperm;
		if (!ptrace_may_access(tsk, PTRACE_MODE_ATTACH))
			goto Eperm;
        }
        mutex_unlock(&tsk->signal->cred_guard_mutex);
	return mm;
Eperm:
        mutex_unlock(&tsk->signal->cred_guard_mutex);
	mmput(mm);
	return ERR_PTR(-EPERM);
