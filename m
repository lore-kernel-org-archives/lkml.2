Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753624Ab0F1Poo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jun 2010 11:44:44 -0400
Received: from SMTP.ANDREW.CMU.EDU ([128.2.11.61]:44373 "EHLO
	smtp.andrew.cmu.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751210Ab0F1Pom (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jun 2010 11:44:42 -0400
Date: Mon, 28 Jun 2010 11:43:59 -0400
From: Ben Blum <bblum@andrew.cmu.edu>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Ben Blum <bblum@andrew.cmu.edu>, linux-kernel@vger.kernel.org,
       containers@lists.linux-foundation.org, akpm@linux-foundation.org,
       ebiederm@xmission.com, lizf@cn.fujitsu.com, matthltc@us.ibm.com,
       menage@google.com, oleg@redhat.com
Subject: Re: [RFC] [PATCH v3 1/2] cgroups: read-write lock CLONE_THREAD
 forking per threadgroup
Message-ID: <20100628154359.GA24629@ghc01.ghc.andrew.cmu.edu>
References: <20100625054541.GA20610@ghc01.ghc.andrew.cmu.edu>
 <20100625054654.GB20610@ghc01.ghc.andrew.cmu.edu>
 <20100628161031.a8c71fce.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100628161031.a8c71fce.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-PMX-Version: 5.5.9.388399, Antispam-Engine: 2.7.2.376379, Antispam-Data: 2010.6.28.153314
X-SMTP-Spam-Clean: 8% (
 BODYTEXTP_SIZE_3000_LESS 0, BODY_SIZE_2000_2999 0, BODY_SIZE_5000_LESS 0, BODY_SIZE_7000_LESS 0, __BOUNCE_CHALLENGE_SUBJ 0, __BOUNCE_NDR_SUBJ_EXEMPT 0, __CD 0, __CT 0, __CT_TEXT_PLAIN 0, __HAS_MSGID 0, __MIME_TEXT_ONLY 0, __MIME_VERSION 0, __SANE_MSGID 0, __TO_MALFORMED_2 0, __URI_NO_PATH 0, __URI_NO_WWW 0, __USER_AGENT 0)
X-SMTP-Spam-Score: 8%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 28, 2010 at 04:10:31PM +0900, KAMEZAWA Hiroyuki wrote:
> On Fri, 25 Jun 2010 01:46:54 -0400
> Ben Blum <bblum@andrew.cmu.edu> wrote:
> 
> > Adds functionality to read/write lock CLONE_THREAD fork()ing per-threadgroup
> > 
> > From: Ben Blum <bblum@andrew.cmu.edu>
> > 
> > This patch adds an rwsem that lives in a threadgroup's signal_struct that's
> > taken for reading in the fork path, under CONFIG_CGROUPS. If another part of
> > the kernel later wants to use such a locking mechanism, the CONFIG_CGROUPS
> > ifdefs should be changed to a higher-up flag that CGROUPS and the other system
> > would both depend on.
> > 
> > This is a pre-patch for cgroups-procs-write.patch.
> > 
> 
> Hmm, at adding a new lock, please describe its semantics.
> Following is my understanding, right ?
> 
> Lock range:
> This rwsem is read-locked from cgroup_fork() to cgroup_post_fork(). 
> Most of works for fork() are between cgroup_fork() and cgroup_post_for().
> This means if sig->threadgroup_fork_lock is held, no new do_work() can
> make progress in this process groups. This rwsem is held only when
> CLONE_THREAD is in clone_flags. IOW, this rwsem is taken only at creating
> new thread.
> 
> What we can do with this:
> By locking sig->threadgroup_fork_lock, a code can visit _all_ threads
> in a process group witout any races. So, if you want to implement an
> atomic operation against a process, taking this lock is an idea.
> 
> For what:
> To implement an atomic process move in cgroup, we need this lock.

All good. Should a description like this go in Documentation/ somewhere,
or above the declaration of the lock?

> Why this implemantation:
> Considering cgroup, threads in a cgroup can be under several different
> cgroup. So, we can't implement lock in cgroup-internal, we use signal
> struct.

Not entirely, though that's an additional restriction... The reason it's
in signal_struct: signal_struct is per-threadgroup and has exactly the
lifetime rules we want. Putting the lock in task_struct and taking
current->group_leader->signal... seems like it would also work, but
introduces cacheline conflicts that weren't there before, since fork
doesn't look at group_leader (but it does bump signal's count).

> By the way, IMHO, hiding lock in cgroup_fork() and cgroup_post_fork() doesn't
> seem good idea. How about a code like this ?
> 
>   read_lock_thread_clone(current);
>   cgroup_fork();
>  .....
>   cgroup_post_fork();
>   read_unlock_thrad_clone(current);
> 
> We may have chances to move these lock to better position if cgroup is
> an only user.

I didn't do that out of a desire to change fork.c as little as possible,
but that does look better than what I've got. Those two functions should
be in fork.c under #ifdef CONFIG_CGROUPS.

> 
> Thanks,
> -Kame

Thanks,
-- Ben
