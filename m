Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754918Ab0F1HPS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jun 2010 03:15:18 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:50285 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753773Ab0F1HPP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jun 2010 03:15:15 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Mon, 28 Jun 2010 16:10:31 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Ben Blum <bblum@andrew.cmu.edu>
Cc: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
       akpm@linux-foundation.org, ebiederm@xmission.com, lizf@cn.fujitsu.com,
       matthltc@us.ibm.com, menage@google.com, oleg@redhat.com
Subject: Re: [RFC] [PATCH v3 1/2] cgroups: read-write lock CLONE_THREAD
 forking per threadgroup
Message-Id: <20100628161031.a8c71fce.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20100625054654.GB20610@ghc01.ghc.andrew.cmu.edu>
References: <20100625054541.GA20610@ghc01.ghc.andrew.cmu.edu>
	<20100625054654.GB20610@ghc01.ghc.andrew.cmu.edu>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 25 Jun 2010 01:46:54 -0400
Ben Blum <bblum@andrew.cmu.edu> wrote:

> Adds functionality to read/write lock CLONE_THREAD fork()ing per-threadgroup
> 
> From: Ben Blum <bblum@andrew.cmu.edu>
> 
> This patch adds an rwsem that lives in a threadgroup's signal_struct that's
> taken for reading in the fork path, under CONFIG_CGROUPS. If another part of
> the kernel later wants to use such a locking mechanism, the CONFIG_CGROUPS
> ifdefs should be changed to a higher-up flag that CGROUPS and the other system
> would both depend on.
> 
> This is a pre-patch for cgroups-procs-write.patch.
> 

Hmm, at adding a new lock, please describe its semantics.
Following is my understanding, right ?

Lock range:
This rwsem is read-locked from cgroup_fork() to cgroup_post_fork(). 
Most of works for fork() are between cgroup_fork() and cgroup_post_for().
This means if sig->threadgroup_fork_lock is held, no new do_work() can
make progress in this process groups. This rwsem is held only when
CLONE_THREAD is in clone_flags. IOW, this rwsem is taken only at creating
new thread.

What we can do with this:
By locking sig->threadgroup_fork_lock, a code can visit _all_ threads
in a process group witout any races. So, if you want to implement an
atomic operation against a process, taking this lock is an idea.

For what:
To implement an atomic process move in cgroup, we need this lock.

Why this implemantation:
Considering cgroup, threads in a cgroup can be under several different
cgroup. So, we can't implement lock in cgroup-internal, we use signal
struct.


By the way, IMHO, hiding lock in cgroup_fork() and cgroup_post_fork() doesn't
seem good idea. How about a code like this ?

  read_lock_thread_clone(current);
  cgroup_fork();
 .....
  cgroup_post_fork();
  read_unlock_thrad_clone(current);

We may have chances to move these lock to better position if cgroup is
an only user.

Thanks,
-Kame

