Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756798Ab1JQR2H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 13:28:07 -0400
Received: from SMTP.ANDREW.CMU.EDU ([128.2.11.95]:40282 "EHLO
	smtp.andrew.cmu.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752857Ab1JQR2G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 13:28:06 -0400
Date: Mon, 17 Oct 2011 13:27:53 -0400
From: Ben Blum <bblum@andrew.cmu.edu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>, Andrew Morton <akpm@linux-foundation.org>,
        Ben Blum <bblum@andrew.cmu.edu>,
        Frederic Weisbecker <fweisbec@redhat.com>,
        Paul Menage <paul@paulmenage.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] cgroups: don't cache common ancestor in task counter
 subsys
Message-ID: <20111017172753.GA23241@ghc17.ghc.andrew.cmu.edu>
References: <4E9BDA43.6060406@cn.fujitsu.com>
 <20111017172537.GH2829@somewhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111017172537.GH2829@somewhere>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-PMX-Version: 5.5.9.388399, Antispam-Engine: 2.7.2.376379, Antispam-Data: 2011.5.19.222118
X-SMTP-Spam-Clean: 8% (
 BODY_SIZE_4000_4999 0, BODY_SIZE_5000_LESS 0, BODY_SIZE_7000_LESS 0, __ANY_URI 0, __BOUNCE_CHALLENGE_SUBJ 0, __BOUNCE_NDR_SUBJ_EXEMPT 0, __CD 0, __CP_NAME_BODY 0, __CT 0, __CT_TEXT_PLAIN 0, __HAS_MSGID 0, __MIME_TEXT_ONLY 0, __MIME_VERSION 0, __SANE_MSGID 0, __TO_MALFORMED_2 0, __URI_NO_PATH 0, __URI_NO_WWW 0, __URI_NS , __USER_AGENT 0)
X-SMTP-Spam-Score: 8%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 17, 2011 at 07:25:41PM +0200, Frederic Weisbecker wrote:
> On Mon, Oct 17, 2011 at 03:33:23PM +0800, Li Zefan wrote:
> > To reproduce the bug:
> > 
> >   # mount -t cgroup -o tasks xxx /cgroup
> >   # mkdir /cgroup/tmp
> >   # echo PID > /cgroup/tmp/cgroups.proc (PID has child threads)
> >   # echo PID > /cgroup/tasks
> >   # ecoh PID > /cgroup/tmp/cgroups.proc
> >   (oops!)
> > 
> > the call graph is:
> > 
> > 	for_each_thread()
> > 	    can_attach_task();
> > 
> > 	for_each_thead()
> > 	    attach_task();
> > 
> > but not:
> > 
> > 	for_each_thread() {
> > 	    can_attach_task();
> > 	    attach_task();
> > 	}
> > 
> > So common_ancestor used in attach_task() is always the value calculated
> > in the last can_attach_task() call.
> 
> Ah! good catch!
> 
> Just a comment below:
> 
> > 
> > To fix it, instead of caching, we always calculate the value every time
> > we want to use it.
> > 
> > Reported-by: Ben Blum <bblum@andrew.cmu.edu>
> > Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
> > ---
> >  Documentation/cgroups/cgroups.txt |    3 ++-
> >  include/linux/cgroup.h            |    2 +-
> >  kernel/cgroup.c                   |    7 ++++---
> >  kernel/cgroup_task_counter.c      |   24 +++++++++++++++++-------
> >  4 files changed, 24 insertions(+), 12 deletions(-)
> > 
> > diff --git a/Documentation/cgroups/cgroups.txt b/Documentation/cgroups/cgroups.txt
> > index 3bc1dc9..f9e51a8 100644
> > --- a/Documentation/cgroups/cgroups.txt
> > +++ b/Documentation/cgroups/cgroups.txt
> > @@ -623,7 +623,8 @@ function, so that the subsystem can implement a rollback. If not, not necessary.
> >  This will be called only about subsystems whose can_attach() operation have
> >  succeeded.
> >  
> > -void cancel_attach_task(struct cgroup *cgrp, struct task_struct *tsk)
> > +void cancel_attach_task(struct cgroup *cgrp, struct cgroup *oldcgrp,
> > +			struct task_struct *tsk)
> >  (cgroup_mutex held by caller)
> >  
> >  As cancel_attach, but for operations that must be cancelled once per
> > diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
> > index 9c8151e..e4659c4 100644
> > --- a/include/linux/cgroup.h
> > +++ b/include/linux/cgroup.h
> > @@ -475,7 +475,7 @@ struct cgroup_subsys {
> >  			       struct task_struct *tsk);
> >  	void (*cancel_attach)(struct cgroup_subsys *ss, struct cgroup *cgrp,
> >  			      struct task_struct *tsk);
> > -	void (*cancel_attach_task)(struct cgroup *cgrp,
> > +	void (*cancel_attach_task)(struct cgroup *cgrp, struct cgroup *oldcgrp,
> >  				   struct task_struct *tsk);
> >  	void (*pre_attach)(struct cgroup *cgrp);
> >  	void (*attach_task)(struct cgroup *cgrp, struct cgroup *old_cgrp,
> > diff --git a/kernel/cgroup.c b/kernel/cgroup.c
> > index 018df9d..91abc9b 100644
> > --- a/kernel/cgroup.c
> > +++ b/kernel/cgroup.c
> > @@ -1885,7 +1885,7 @@ out:
> >  				break;
> >  
> >  			if (ss->cancel_attach_task)
> > -				ss->cancel_attach_task(cgrp, tsk);
> > +				ss->cancel_attach_task(cgrp, oldcgrp, tsk);
> >  			if (ss->cancel_attach)
> >  				ss->cancel_attach(ss, cgrp, tsk);
> >  		}
> > @@ -2151,7 +2151,7 @@ int cgroup_attach_proc(struct cgroup *cgrp, struct task_struct *leader)
> >  			}
> >  		} else if (retval == -ESRCH) {
> >  			if (ss->cancel_attach_task)
> > -				ss->cancel_attach_task(cgrp, tsk);
> > +				ss->cancel_attach_task(cgrp, oldcgrp, tsk);
> >  		} else {
> >  			BUG_ON(1);
> >  		}
> > @@ -2191,7 +2191,8 @@ out_cancel_attach:
> >  					tsk = flex_array_get_ptr(group, i);
> >  					if (tsk == failed_task)
> >  						break;
> > -					ss->cancel_attach_task(cgrp, tsk);
> > +					ss->cancel_attach_task(cgrp, oldcgrp,
> > +							       tsk);
> 
> When we rollback there, we are dealing with oldcgrp of the last thread
> we have treated. All threads in the rollback list don't necessary belonged
> to that old_cgroup.
> 
> And we can't try to retrieve these old_cgroup through task_cgroup_from_root() because
> the threads might have exited and thus could be assigned to the init cgroup.
> 
> I believe we need to cache these old cgroups in the flex array.
> 

Doing this would fulfill the "TODO" in cgroup_attach_proc for being able
to pass the oldcgrp for each task in the loop around the ss->attach
call, so if you do that, remove the corresponding comment. :)

-- Ben
