Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753954Ab1BJBgk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Feb 2011 20:36:40 -0500
Received: from SMTP.ANDREW.CMU.EDU ([128.2.11.96]:60896 "EHLO
	smtp.andrew.cmu.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752197Ab1BJBgj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Feb 2011 20:36:39 -0500
Date: Wed, 9 Feb 2011 20:36:06 -0500
From: Ben Blum <bblum@andrew.cmu.edu>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ben Blum <bblum@andrew.cmu.edu>,
        containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        oleg@redhat.com, Miao Xie <miaox@cn.fujitsu.com>,
        David Rientjes <rientjes@google.com>, menage@google.com,
        ebiederm@xmission.com
Subject: Re: [PATCH v8 0/3] cgroups: implement moving a threadgroup's
 threads atomically with cgroup.procs
Message-ID: <20110210013606.GA26677@ghc17.ghc.andrew.cmu.edu>
References: <20101226120919.GA28529@ghc17.ghc.andrew.cmu.edu>
 <20110208013542.GC31569@ghc17.ghc.andrew.cmu.edu>
 <20110209151046.89e03dcd.akpm@linux-foundation.org>
 <20110210100210.adf09c49.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110210100210.adf09c49.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-PMX-Version: 5.5.9.388399, Antispam-Engine: 2.7.2.376379, Antispam-Data: 2010.4.9.4220
X-SMTP-Spam-Clean: 8% (
 BODY_SIZE_3000_3999 0, BODY_SIZE_5000_LESS 0, BODY_SIZE_7000_LESS 0, __BOUNCE_CHALLENGE_SUBJ 0, __BOUNCE_NDR_SUBJ_EXEMPT 0, __CD 0, __CP_URI_IN_BODY 0, __CT 0, __CT_TEXT_PLAIN 0, __HAS_MSGID 0, __MIME_TEXT_ONLY 0, __MIME_VERSION 0, __SANE_MSGID 0, __TO_MALFORMED_2 0, __URI_NO_WWW 0, __USER_AGENT 0)
X-SMTP-Spam-Score: 8%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 10, 2011 at 10:02:10AM +0900, KAMEZAWA Hiroyuki wrote:
> On Wed, 9 Feb 2011 15:10:46 -0800
> Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > On Mon, 7 Feb 2011 20:35:42 -0500
> > Ben Blum <bblum@andrew.cmu.edu> wrote:
> > 
> > > On Sun, Dec 26, 2010 at 07:09:19AM -0500, Ben Blum wrote:
> > > > On Fri, Dec 24, 2010 at 03:22:26AM -0500, Ben Blum wrote:
> > > > > On Wed, Aug 11, 2010 at 01:46:04AM -0400, Ben Blum wrote:
> > > > > > On Fri, Jul 30, 2010 at 07:56:49PM -0400, Ben Blum wrote:
> > > > > > > This patch series is a revision of http://lkml.org/lkml/2010/6/25/11 .
> > > > > > > 
> > > > > > > This patch series implements a write function for the 'cgroup.procs'
> > > > > > > per-cgroup file, which enables atomic movement of multithreaded
> > > > > > > applications between cgroups. Writing the thread-ID of any thread in a
> > > > > > > threadgroup to a cgroup's procs file causes all threads in the group to
> > > > > > > be moved to that cgroup safely with respect to threads forking/exiting.
> > > > > > > (Possible usage scenario: If running a multithreaded build system that
> > > > > > > sucks up system resources, this lets you restrict it all at once into a
> > > > > > > new cgroup to keep it under control.)
> > > > > > > 
> > > > > > > Example: Suppose pid 31337 clones new threads 31338 and 31339.
> > > > > > > 
> > > > > > > # cat /dev/cgroup/tasks
> > > > > > > ...
> > > > > > > 31337
> > > > > > > 31338
> > > > > > > 31339
> > > > > > > # mkdir /dev/cgroup/foo
> > > > > > > # echo 31337 > /dev/cgroup/foo/cgroup.procs
> > > > > > > # cat /dev/cgroup/foo/tasks
> > > > > > > 31337
> > > > > > > 31338
> > > > > > > 31339
> > > > > > > 
> > > > > > > A new lock, called threadgroup_fork_lock and living in signal_struct, is
> > > > > > > introduced to ensure atomicity when moving threads between cgroups. It's
> > > > > > > taken for writing during the operation, and taking for reading in fork()
> > > > > > > around the calls to cgroup_fork() and cgroup_post_fork().
> > 
> > The above six month old text is the best (and almost the only)
> > explanation of the rationale for the entire patch series.  Is
> > it still correct and complete?

Yep, it's still fresh. (That's why I kept it around!)

> > 
> > 
> > Assuming "yes", then...  how do we determine whether the feature is
> > sufficiently useful to justify merging and maintaining it?  Will people
> > actually use it?
> > 
> > Was there some particular operational situation which led you to think
> > that the kernel should have this capability?  If so, please help us out here
> > and lavishly describe it.
> > 
> 
> In these months, I saw following questions as 
> ==
> Q. I think I put qemu to xxxx cgroup but it never works!
> A. You need to put all threads in qemu to cgroup.
> ==
> 
> 'tasks' file is not useful interface for users, I think.
> (Even if users tend to use put-task-before-exec scheme.)
> 
> 
> IMHO, from user's side of view, 'tasks' file is a mystery.
> 
> TID(thread-ID) is one of secrets in Linux + pthread library. For example,
> on RHEL6, to use gettid(), users has to use syscall() directly. And end-user
> may not know about thread-ID which is hidden under pthreads. 

I think glibc in general is to blame for the fact that you need to
syscall(__NR_gettid)? Regardless - yes, exposing an interface dealing
with task_structs can be less than perfect for a world that deals in
userland applications.

> IIRC, there are no interface other than /proc/<pid>/tasks which shows all
> thread IDs of a process. But it's not atomic.

I tend to use pgrep, which is a bit of a hassle.

Also, like in the six-month-old-text, many resource-sucking programs
nowadays (web browsers) are multithreaded.

> So, I think it's ok to have 'procs' interface for cgroup if
> overhead/impact of patch is not heavy.
> 
> Thanks,
> -Kame

Thanks for the reasoning. ;)

-- Ben
