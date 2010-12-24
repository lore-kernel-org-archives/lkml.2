Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752330Ab0LXIcQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Dec 2010 03:32:16 -0500
Received: from SMTP.ANDREW.CMU.EDU ([128.2.11.96]:57235 "EHLO
	smtp.andrew.cmu.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752050Ab0LXIcP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Dec 2010 03:32:15 -0500
X-Greylist: delayed 553 seconds by postgrey-1.27 at vger.kernel.org; Fri, 24 Dec 2010 03:32:15 EST
Date: Fri, 24 Dec 2010 03:22:26 -0500
From: Ben Blum <bblum@andrew.cmu.edu>
To: Ben Blum <bblum@andrew.cmu.edu>
Cc: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
        akpm@linux-foundation.org, ebiederm@xmission.com, lizf@cn.fujitsu.com,
        matthltc@us.ibm.com, menage@google.com, oleg@redhat.com
Subject: [PATCH v6 0/3] cgroups: implement moving a threadgroup's threads
 atomically with cgroup.procs
Message-ID: <20101224082226.GA13872@ghc17.ghc.andrew.cmu.edu>
References: <20100730235649.GA22644@ghc17.ghc.andrew.cmu.edu>
 <20100811054604.GA8743@ghc17.ghc.andrew.cmu.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100811054604.GA8743@ghc17.ghc.andrew.cmu.edu>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-PMX-Version: 5.5.9.388399, Antispam-Engine: 2.7.2.376379, Antispam-Data: 2010.4.9.4220
X-SMTP-Spam-Clean: 8% (
 FROM_SAME_AS_TO 0.05, BODY_SIZE_3000_3999 0, BODY_SIZE_5000_LESS 0, BODY_SIZE_7000_LESS 0, __CD 0, __CP_URI_IN_BODY 0, __CT 0, __CT_TEXT_PLAIN 0, __FROM_SAME_AS_TO2 0, __HAS_MSGID 0, __MIME_TEXT_ONLY 0, __MIME_VERSION 0, __SANE_MSGID 0, __TO_MALFORMED_2 0, __URI_NO_MAILTO 0, __URI_NS , __USER_AGENT 0)
X-SMTP-Spam-Score: 8%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 11, 2010 at 01:46:04AM -0400, Ben Blum wrote:
> On Fri, Jul 30, 2010 at 07:56:49PM -0400, Ben Blum wrote:
> > This patch series is a revision of http://lkml.org/lkml/2010/6/25/11 .
> > 
> > This patch series implements a write function for the 'cgroup.procs'
> > per-cgroup file, which enables atomic movement of multithreaded
> > applications between cgroups. Writing the thread-ID of any thread in a
> > threadgroup to a cgroup's procs file causes all threads in the group to
> > be moved to that cgroup safely with respect to threads forking/exiting.
> > (Possible usage scenario: If running a multithreaded build system that
> > sucks up system resources, this lets you restrict it all at once into a
> > new cgroup to keep it under control.)
> > 
> > Example: Suppose pid 31337 clones new threads 31338 and 31339.
> > 
> > # cat /dev/cgroup/tasks
> > ...
> > 31337
> > 31338
> > 31339
> > # mkdir /dev/cgroup/foo
> > # echo 31337 > /dev/cgroup/foo/cgroup.procs
> > # cat /dev/cgroup/foo/tasks
> > 31337
> > 31338
> > 31339
> > 
> > A new lock, called threadgroup_fork_lock and living in signal_struct, is
> > introduced to ensure atomicity when moving threads between cgroups. It's
> > taken for writing during the operation, and taking for reading in fork()
> > around the calls to cgroup_fork() and cgroup_post_fork(). I put calls to
> > down_read/up_read directly in copy_process(), since new inline functions
> > seemed like overkill.
> > 
> > -- Ben
> > 
> > ---
> >  Documentation/cgroups/cgroups.txt |   13 -
> >  include/linux/init_task.h         |    9
> >  include/linux/sched.h             |   10
> >  kernel/cgroup.c                   |  426 +++++++++++++++++++++++++++++++++-----
> >  kernel/cgroup_freezer.c           |    4
> >  kernel/cpuset.c                   |    4
> >  kernel/fork.c                     |   16 +
> >  kernel/ns_cgroup.c                |    4
> >  kernel/sched.c                    |    4
> >  9 files changed, 440 insertions(+), 50 deletions(-)
> 
> Here's an updated patchset. I've added an extra patch to implement the 
> callback scheme Paul suggested (note how there are twice as many deleted
> lines of code as before :) ), and also moved the up_read/down_read calls
> to static inline functions in sched.h near the other threadgroup-related
> calls.

One more go at this. I've refreshed the patches for some conflicts in
cgroup_freezer.c, by adding an extra argument to the per_thread() call,
"need_rcu", which makes the function take rcu_read_lock even around the
single-task case (like freezer now requires). So no semantics have been
changed.

I also poked around at some attach() calls which also iterate over the
threadgroup (blkiocg_attach, cpuset_attach, cpu_cgroup_attach). I was
borderline about making another function, cgroup_attach_per_thread(),
but decided against.

There is a big issue in cpuset_attach, as explained in this email:
http://www.spinics.net/lists/linux-containers/msg22223.html
but the actual code/diffs for this patchset are independent of that
getting fixed, so I'm putting this up for consideration now.

-- Ben

---
 Documentation/cgroups/cgroups.txt |   13 -
 block/blk-cgroup.c                |   31 ++
 include/linux/cgroup.h            |   14 +
 include/linux/init_task.h         |    9 
 include/linux/sched.h             |   35 ++
 kernel/cgroup.c                   |  469 ++++++++++++++++++++++++++++++++++----
 kernel/cgroup_freezer.c           |   33 +-
 kernel/cpuset.c                   |   30 --
 kernel/fork.c                     |   10 
 kernel/ns_cgroup.c                |   25 --
 kernel/sched.c                    |   24 -
 11 files changed, 565 insertions(+), 128 deletions(-)
