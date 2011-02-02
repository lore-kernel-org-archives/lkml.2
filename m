Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753330Ab1BBHXQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 02:23:16 -0500
Received: from e3.ny.us.ibm.com ([32.97.182.143]:46299 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752841Ab1BBHXP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 02:23:15 -0500
Date: Tue, 1 Feb 2011 23:23:11 -0800
From: Matt Helsley <matthltc@us.ibm.com>
To: Matt Helsley <matthltc@us.ibm.com>
Cc: jacob.jun.pan@linux.intel.com,
        container cgroup <containers@lists.linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Paul Menage <menage@google.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        "Kirill A. Shutsemov" <kirill@shutemov.name>
Subject: Re: [PATCH] cgroups: respect cgroup timer slack value in prctl
Message-ID: <20110202072311.GP16432@count0.beaverton.ibm.com>
References: <1296600103-15726-1-git-send-email-jacob.jun.pan@linux.intel.com>
 <20110202070743.GO16432@count0.beaverton.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110202070743.GO16432@count0.beaverton.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 01, 2011 at 11:07:43PM -0800, Matt Helsley wrote:
> On Tue, Feb 01, 2011 at 02:41:43PM -0800, jacob.jun.pan@linux.intel.com wrote:
> > From: Jacob Pan <jacob.jun.pan@linux.intel.com>
> > 
> > Per cgroup timer slack value is used to manage task groups
> > for more friendly power management behavior. Once a task is
> > attached to a cgroup, we should not allow user to change
> > (escape) the per cgroup restriction unless a more relaxed
> > timer slack value is given by user via prctl.
> > 
> > Signed-off-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
> 
> > ---
> >  include/linux/cgroup.h      |   13 +++++++++++++
> 
> Looks like the original two patches (one or more implementing:
> 
> >  kernel/cgroup_timer_slack.c |    4 ----
> 
> ) were not sent to containers@lists.linux-foundation.org ?

Oops, I didn't see the patches from Kirill A. Shutsemov that this
apparently applies to, sorry. Odd, my mail client doesn't show a
Cc for him on this thread... (added)

Cheers,
	-Matt

> 
> >  kernel/sys.c                |   21 ++++++++++++++++++++-
> >  3 files changed, 33 insertions(+), 5 deletions(-)
> > 
> > diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
> > index ed4ba11..4405666 100644
> > --- a/include/linux/cgroup.h
> > +++ b/include/linux/cgroup.h
> > @@ -627,6 +627,19 @@ bool css_is_ancestor(struct cgroup_subsys_state *cg,
> >  unsigned short css_id(struct cgroup_subsys_state *css);
> >  unsigned short css_depth(struct cgroup_subsys_state *css);
> > 
> > +#ifdef CONFIG_CGROUP_TIMER_SLACK
> > +struct timer_slack_cgroup {
> > +	struct cgroup_subsys_state css;
> > +	unsigned long timer_slack_ns;
> > +};
> > +
> > +static inline struct timer_slack_cgroup *task_timer_slack(struct task_struct *task)
> > +{
> > +	return container_of(task_subsys_state(task, timer_slack_subsys_id),
> > +			    struct timer_slack_cgroup, css);
> > +}
> > +#endif
> > +
> >  #else /* !CONFIG_CGROUPS */
> > 
> >  static inline int cgroup_init_early(void) { return 0; }
> > diff --git a/kernel/cgroup_timer_slack.c b/kernel/cgroup_timer_slack.c
> > index daa452d..1de122a 100644
> > --- a/kernel/cgroup_timer_slack.c
> > +++ b/kernel/cgroup_timer_slack.c
> > @@ -4,10 +4,6 @@
> >  #include <linux/slab.h>
> > 
> >  struct cgroup_subsys timer_slack_subsys;
> > -struct timer_slack_cgroup {
> > -	struct cgroup_subsys_state css;
> > -	unsigned long timer_slack_ns;
> > -};
> > 
> >  static struct timer_slack_cgroup *cgroup_to_tslack_cgroup(struct cgroup *cgroup)
> >  {
> > diff --git a/kernel/sys.c b/kernel/sys.c
> > index 7f5a0cd..433fcdb 100644
> > --- a/kernel/sys.c
> > +++ b/kernel/sys.c
> > @@ -37,6 +37,8 @@
> >  #include <linux/ptrace.h>
> >  #include <linux/fs_struct.h>
> >  #include <linux/gfp.h>
> > +#include <linux/cgroup.h>
> > +#include <linux/init_task.h>
> > 
> >  #include <linux/compat.h>
> >  #include <linux/syscalls.h>
> > @@ -1688,8 +1690,25 @@ SYSCALL_DEFINE5(prctl, int, option, unsigned long, arg2, unsigned long, arg3,
> >  			if (arg2 <= 0)
> >  				current->timer_slack_ns =
> >  					current->default_timer_slack_ns;
> > -			else
> > +			else {
> > +#ifdef CONFIG_CGROUP_TIMER_SLACK
> > +				/* only allow more relaxed slack value than
> > +				 * the attached timer slack cgroup allows.
> > +				 */
> > +				unsigned long cg_timer_slack;
> > +
> > +				rcu_read_lock();
> > +				cg_timer_slack = task_timer_slack(current)->timer_slack_ns;
> > +				rcu_read_unlock();
> > +				if (cg_timer_slack < arg2 || cg_timer_slack
> > +					== TIMER_SLACK_NS_DEFAULT)
> > +					current->timer_slack_ns = arg2;
> > +				else
> > +					return -EINVAL;
> > +#else
> 
> Looks like this could be an inline function which returns the
> minimum timer slack allowed for the task. Then the code here would be:
> 
> if (arg2 <= 0)
> 	current->timer_slack_ns = current->default_timer_slack_ns;
> else {
> 	if (arg2 < min_timer_slack_ns(tsk))
> 		return -EINVAL; /* Can't set less than the minimum */
> 	current->timer_slack_ns = arg2;
> }
> 
> and the #ifdef CONFIG_CGROUP_TIMER_SLACK bits could be in a header as
> usual.
> 
> Incidentally, shouldn't that really be -EPERM since it's not an invalid
> value -- just one that's not permitted due to restrictions imposed by
> the cgroup subsystem?
> 
> >  				current->timer_slack_ns = arg2;
> > +#endif
> > +			}
> >  			error = 0;
> >  			break;
> >  		case PR_MCE_KILL:
> > -- 
> > 1.7.0.4
> > 
> > _______________________________________________
> > Containers mailing list
> > Containers@lists.linux-foundation.org
> > https://lists.linux-foundation.org/mailman/listinfo/containers
> _______________________________________________
> Containers mailing list
> Containers@lists.linux-foundation.org
> https://lists.linux-foundation.org/mailman/listinfo/containers
