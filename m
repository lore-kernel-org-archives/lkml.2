Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754566Ab0G1JdK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 05:33:10 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:40483 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751665Ab0G1JdF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 05:33:05 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Wed, 28 Jul 2010 18:28:13 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Ben Blum <bblum@andrew.cmu.edu>
Cc: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
        akpm@linux-foundation.org, ebiederm@xmission.com, lizf@cn.fujitsu.com,
        matthltc@us.ibm.com, menage@google.com, oleg@redhat.com
Subject: Re: [RFC] [PATCH v3 1/2] cgroups: read-write lock CLONE_THREAD
 forking per threadgroup
Message-Id: <20100728182813.7c2826ae.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20100728082953.GA15455@ghc01.ghc.andrew.cmu.edu>
References: <20100625054541.GA20610@ghc01.ghc.andrew.cmu.edu>
	<20100625054654.GB20610@ghc01.ghc.andrew.cmu.edu>
	<20100628161031.a8c71fce.kamezawa.hiroyu@jp.fujitsu.com>
	<20100628154359.GA24629@ghc01.ghc.andrew.cmu.edu>
	<20100728082953.GA15455@ghc01.ghc.andrew.cmu.edu>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 Jul 2010 04:29:53 -0400
Ben Blum <bblum@andrew.cmu.edu> wrote:

> On Mon, Jun 28, 2010 at 11:43:59AM -0400, Ben Blum wrote:
> > On Mon, Jun 28, 2010 at 04:10:31PM +0900, KAMEZAWA Hiroyuki wrote:
> > > By the way, IMHO, hiding lock in cgroup_fork() and cgroup_post_fork() doesn't
> > > seem good idea. How about a code like this ?
> > > 
> > >   read_lock_thread_clone(current);
> > >   cgroup_fork();
> > >  .....
> > >   cgroup_post_fork();
> > >   read_unlock_thrad_clone(current);
> > > 
> > > We may have chances to move these lock to better position if cgroup is
> > > an only user.
> > 
> > I didn't do that out of a desire to change fork.c as little as possible,
> > but that does look better than what I've got. Those two functions should
> > be in fork.c under #ifdef CONFIG_CGROUPS.
> 
> I'm looking at this now and am not sure where the best place to put
> these is:
> 
> 1) Don't make new functions, just put:
> 
>     #ifdef CONFIG_CGROUPS
>         if (clone_flags & CLONE_THREAD)
>             down/up_read(...);
>     #endif
> 
> directly in copy_process() in fork.c. Simplest, but uglifies the code.
> 
> 2) Make static helper functions in fork.c. Good, but not consistent with
> directly using the lock in write-side (attach_proc).
> 
> 3) Define inline functions under #ifdef CONFIG_CGROUPS in sched.h, just
> under the declaration of the lock. Most robust, but I'm hesitant to add
> unneeded stuff to such a popular header file.
> 
> Any opinions?
> 

My point was simple. Because copy_process() is very important path,
the new lock should be visible in copy_process() or kernek/fork.c.
"If the lock is visible in copy_process(), the reader can notice it".

Then, I offer you 2 options.

rename cgroup_fork() and cgroup_post_fork() as
       cgroup_fork_lock() and cgroup_post_fork_unlock() 

Now, the lock is visible and the change is minimum.

Or
       add the definition of lock/unlock to cgroup.h and include it 
       from kernel/fork.c

Thanks,
-Kame

