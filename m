Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755555Ab1BCJWc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Feb 2011 04:22:32 -0500
Received: from shutemov.name ([188.40.19.243]:52620 "EHLO shutemov.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755432Ab1BCJWa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Feb 2011 04:22:30 -0500
Date: Thu, 3 Feb 2011 11:22:29 +0200
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: jacob pan <jacob.jun.pan@linux.intel.com>
Cc: Paul Menage <menage@google.com>, Li Zefan <lizf@cn.fujitsu.com>,
        containers@lists.linux-foundation.org,
        Arjan van de Ven <arjan@linux.intel.com>, linux-kernel@vger.kernel.org,
        Matt Helsley <matthltc@us.ibm.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH, v3 2/2] cgroups: introduce timer slack subsystem
Message-ID: <20110203092229.GB1083@shutemov.name>
References: <1296679656-31163-1-git-send-email-kirill@shutemov.name>
 <1296679656-31163-3-git-send-email-kirill@shutemov.name>
 <20110202145605.6c9006fa@putvin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110202145605.6c9006fa@putvin>
User-Agent: Mutt/1.5.20 (2010-08-04)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 02, 2011 at 02:56:05PM -0800, jacob pan wrote:
> On Wed,  2 Feb 2011 22:47:36 +0200
> "Kirill A. Shutsemov" <kirill@shutemov.name> wrote:
> 
> > From: Kirill A. Shutemov <kirill@shutemov.name>
> > 
> > Provides a way of tasks grouping by timer slack value. Introduces per
> > cgroup max and min timer slack value. When a task attaches to a
> > cgroup, its timer slack value adjusts (if needed) to fit min-max
> > range.
> > 
> > It also provides a way to set timer slack value for all tasks in the
> > cgroup at once.
> > 
> > This functionality is useful in mobile devices where certain
> > background apps are attached to a cgroup and minimum wakeups are
> > desired.
> > 
> > Signed-off-by: Kirill A. Shutemov <kirill@shutemov.name>
> > Idea-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
> > ---
> >  include/linux/cgroup_subsys.h |    6 +
> >  include/linux/init_task.h     |    4 +-
> >  init/Kconfig                  |   10 ++
> >  kernel/Makefile               |    1 +
> >  kernel/cgroup_timer_slack.c   |  242
> > +++++++++++++++++++++++++++++++++++++++++
> 
> > +
> > +static int cgroup_timer_slack_check(struct task_struct *task,
> > +		unsigned long slack_ns)
> > +{
> > +	struct cgroup_subsys_state *css;
> > +	struct timer_slack_cgroup *tslack_cgroup;
> > +
> 
> use rcu_read_lock()/unlock?
> lockdep complains unprotected rcu dereference check.

Hmm.. I'm not sure, but it looks like lockdep false positive similar to
cgroup_freezer's (see commit 8b46f88084).
Paul, am I right?

> > +	css = task_subsys_state(task, timer_slack_subsys.subsys_id);
> > +	tslack_cgroup = container_of(css, struct timer_slack_cgroup,
> > css); +
> > +	if (slack_ns < tslack_cgroup->min_slack_ns)
> > +		return -EPERM;
> > +	if (slack_ns > tslack_cgroup->max_slack_ns)
> > +		return -EPERM;
> > +	return 0;
> > +}
> > +
> 
> > +
> > +static struct cftype files[] = {
> > +	{
> > +		.name = "set_slack_ns",
> > +		.write_u64 = tslack_write_set_slack_ns,
> > +	},
> should we also allow reading of the current slack_ns?

There is no 'current slack_ns' for a cgroup since any process free to
change it with prctl().

> > +	{
> > +		.name = "min_slack_ns",
> > +		.private = TIMER_SLACK_MIN,
> > +		.read_u64 = tslack_read_range,
> > +		.write_u64 = tslack_write_range,
> > +	},
> > +	{
> > +		.name = "max_slack_ns",
> > +		.private = TIMER_SLACK_MAX,
> > +		.read_u64 = tslack_read_range,
> > +		.write_u64 = tslack_write_range,
> > +	},
> > +};
> > +

-- 
 Kirill A. Shutemov
