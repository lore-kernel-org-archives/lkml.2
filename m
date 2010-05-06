Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753142Ab0EFVmi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 May 2010 17:42:38 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:44130 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752325Ab0EFVmg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 May 2010 17:42:36 -0400
Date: Thu, 6 May 2010 13:31:17 -0700
From: Matt Helsley <matthltc@us.ibm.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Oren Laadan <orenl@cs.columbia.edu>,
       Andrew Morton <akpm@linux-foundation.org>,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Serge Hallyn <serue@us.ibm.com>, Matt Helsley <matthltc@us.ibm.com>,
       Pavel Emelyanov <xemul@openvz.org>, Cedric Le Goater <legoater@free.fr>,
       Paul Menage <menage@google.com>, Li Zefan <lizf@cn.fujitsu.com>,
       linux-pm@lists.linux-foundation.org
Subject: Re: [PATCH v21 015/100] cgroup freezer: Update stale locking
 comments
Message-ID: <20100506203117.GM31830@count0.beaverton.ibm.com>
References: <1272723382-19470-1-git-send-email-orenl@cs.columbia.edu>
 <1272723382-19470-16-git-send-email-orenl@cs.columbia.edu>
 <201005062140.19821.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201005062140.19821.rjw@sisk.pl>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 06, 2010 at 09:40:19PM +0200, Rafael J. Wysocki wrote:
> On Saturday 01 May 2010, Oren Laadan wrote:
> > From: Matt Helsley <matthltc@us.ibm.com>
> > 
> > Update stale comments regarding locking order and add a little more detail
> > so it's easier to follow the locking between the cgroup freezer and the
> > power management freezer code.
> 
> I guess these three patches are for me.
> 
> Do you want me to handle them?
> 
> Rafael

Hi Rafael,

	I think you can take 15 as it's an update to the comments.

16 and 17 are specific to checkpoint/restart. There are no other in-kernel
uses, that we've identified, for them. So I was under the impression that it's
inappropriate to add them without also adding the checkpoint/restart patches
that use them.

Thanks!

Cheers,
	-Matt Helsley

> 
> 
> > Signed-off-by: Matt Helsley <matthltc@us.ibm.com>
> > Cc: Oren Laadan <orenl@cs.columbia.edu>
> > Cc: Cedric Le Goater <legoater@free.fr>
> > Cc: Paul Menage <menage@google.com>
> > Cc: Li Zefan <lizf@cn.fujitsu.com>
> > Cc: Rafael J. Wysocki <rjw@sisk.pl>
> > Cc: linux-pm@lists.linux-foundation.org
> > ---
> >  kernel/cgroup_freezer.c |   21 +++++++++++++--------
> >  1 files changed, 13 insertions(+), 8 deletions(-)
> > 
> > diff --git a/kernel/cgroup_freezer.c b/kernel/cgroup_freezer.c
> > index da5e139..85f19cc 100644
> > --- a/kernel/cgroup_freezer.c
> > +++ b/kernel/cgroup_freezer.c
> > @@ -89,10 +89,10 @@ struct cgroup_subsys freezer_subsys;
> >  
> >  /* Locks taken and their ordering
> >   * ------------------------------
> > - * css_set_lock
> >   * cgroup_mutex (AKA cgroup_lock)
> > - * task->alloc_lock (AKA task_lock)
> >   * freezer->lock
> > + * css_set_lock
> > + * task->alloc_lock (AKA task_lock)
> >   * task->sighand->siglock
> >   *
> >   * cgroup code forces css_set_lock to be taken before task->alloc_lock
> > @@ -100,33 +100,38 @@ struct cgroup_subsys freezer_subsys;
> >   * freezer_create(), freezer_destroy():
> >   * cgroup_mutex [ by cgroup core ]
> >   *
> > - * can_attach():
> > - * cgroup_mutex
> > + * freezer_can_attach():
> > + * cgroup_mutex (held by caller of can_attach)
> >   *
> > - * cgroup_frozen():
> > + * cgroup_freezing_or_frozen():
> >   * task->alloc_lock (to get task's cgroup)
> >   *
> >   * freezer_fork() (preserving fork() performance means can't take cgroup_mutex):
> > - * task->alloc_lock (to get task's cgroup)
> >   * freezer->lock
> >   *  sighand->siglock (if the cgroup is freezing)
> >   *
> >   * freezer_read():
> >   * cgroup_mutex
> >   *  freezer->lock
> > + *   write_lock css_set_lock (cgroup iterator start)
> > + *    task->alloc_lock
> >   *   read_lock css_set_lock (cgroup iterator start)
> >   *
> >   * freezer_write() (freeze):
> >   * cgroup_mutex
> >   *  freezer->lock
> > + *   write_lock css_set_lock (cgroup iterator start)
> > + *    task->alloc_lock
> >   *   read_lock css_set_lock (cgroup iterator start)
> > - *    sighand->siglock
> > + *    sighand->siglock (fake signal delivery inside freeze_task())
> >   *
> >   * freezer_write() (unfreeze):
> >   * cgroup_mutex
> >   *  freezer->lock
> > + *   write_lock css_set_lock (cgroup iterator start)
> > + *    task->alloc_lock
> >   *   read_lock css_set_lock (cgroup iterator start)
> > - *    task->alloc_lock (to prevent races with freeze_task())
> > + *    task->alloc_lock (inside thaw_process(), prevents race with refrigerator())
> >   *     sighand->siglock
> >   */
> >  static struct cgroup_subsys_state *freezer_create(struct cgroup_subsys *ss,
> > 
> 
