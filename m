Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755660Ab1K0V0I (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Nov 2011 16:26:08 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:52088 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751288Ab1K0V0G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Nov 2011 16:26:06 -0500
Date: Sun, 27 Nov 2011 13:25:58 -0800
From: Tejun Heo <tj@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: paul@paulmenage.org, rjw@sisk.pl, lizf@cn.fujitsu.com,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        containers@lists.linux-foundation.org, fweisbec@gmail.com,
        matthltc@us.ibm.com, akpm@linux-foundation.org, oleg@redhat.com,
        kamezawa.hiroyu@jp.fujitsu.com
Subject: Re: [PATCH UPDATED 03/10] threadgroup: extend threadgroup_lock()
 to cover exit and exec
Message-ID: <20111127212558.GE4266@google.com>
References: <1320191193-8110-1-git-send-email-tj@kernel.org>
 <1320191193-8110-4-git-send-email-tj@kernel.org>
 <20111124225054.GA14828@google.com>
 <CA+55aFxq1wztMzYhKaY5RHazLBDz4pSXUgiGzTj2wA6EJcDbAw@mail.gmail.com>
 <20111127192155.GB4266@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111127192155.GB4266@google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Linus.

On Sun, Nov 27, 2011 at 11:21:55AM -0800, Tejun Heo wrote:
> On Thu, Nov 24, 2011 at 08:02:18PM -0800, Linus Torvalds wrote:
> >  - do you even *need* two separate locks at all? If you extend the
> > threadgroup_fork_lock to cover exec/exit too (and rename it), then why
> > does that separate cred_guard_mutex make sense at all?
> 
> That was mostly choosing the path of least resistance as both locks
> already existed and exec exclusion was added later on, but yeah there
> isn't much to lose by merging those two locks (do_exit nesting inside
> exec will need some care tho).  I'll try to unify the two locks.

Hmmm... I tried this but it seems more difficult than originally
expected.  The biggest obstacle is that we don't have _interruptible
and _killable rwsem ops.

As proposed, what we have is,

* fork and exit paths are read-protected by group_rwsem.  ie. forks
  and exits don't block each other.

* exec path is protected by cred_guard_mutex.  cred_guard_mutex also
  synchronizes parallel exec attempts.  (It's probably better to
  rename it to exec_mutex)

* thread_group_lock() makes the thread group stable by write-locking
  group_rwsem and grabbing cred_guard_mutex.  The former excludes
  forks and exits and the latter exec.

group_rwsem and cred_guard_mutex can be merged by,

* fork and exit paths read-lock group_rwsem as it currently does.

* exec path write-locks group_rwsem.  Note that it'll need to unlock
  in de_thread() while waiting for other threads to exit as exit path
  can't proceed while group_rwsem is write-locked.
  prepare_bprm_creds() should be updated to check signal_pending()
  after acquiring group_rwsem.

  This introduces synchronization between exec and fork/exit paths,
  but I don't think this is something we need to worry about as both
  fork-exec and exit-exec scalabilities don't matter.

* thread_group_lock() write-locks group_rwsem.

The problem is that cred_guard_mutex uses _interruptible/_killable
operations and rwsem doesn't have them, so cred_guard_mutex can't be
easily replaced with write-locking group_rwsem.

If the two locks can't be merged, under the proposed scheme, while not
exactly pretty, both fork/exit and exec paths go through single
locking and only the ones which want stable threadgroup need to grab
both locks, so IMHO it is at least reasonable.

Any better ideas?

Thanks.

-- 
tejun
