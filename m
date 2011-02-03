Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756666Ab1BCRx2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Feb 2011 12:53:28 -0500
Received: from mga02.intel.com ([134.134.136.20]:23073 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756175Ab1BCRx0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Feb 2011 12:53:26 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,420,1291622400"; 
   d="scan'208";a="703729795"
Date: Thu, 3 Feb 2011 09:51:17 -0800
From: Jacob Pan <jacob.jun.pan@linux.intel.com>
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Paul Menage <menage@google.com>, Li Zefan <lizf@cn.fujitsu.com>,
        containers@lists.linux-foundation.org,
        Arjan van de Ven <arjan@linux.intel.com>, linux-kernel@vger.kernel.org,
        Matt Helsley <matthltc@us.ibm.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH, v3 2/2] cgroups: introduce timer slack subsystem
Message-ID: <20110203095117.76a568fc@putvin>
In-Reply-To: <20110203092229.GB1083@shutemov.name>
References: <1296679656-31163-1-git-send-email-kirill@shutemov.name>
	<1296679656-31163-3-git-send-email-kirill@shutemov.name>
	<20110202145605.6c9006fa@putvin>
	<20110203092229.GB1083@shutemov.name>
Organization: OTC
X-Mailer: Claws Mail 3.7.4 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 3 Feb 2011 11:22:29 +0200
"Kirill A. Shutemov" <kirill@shutemov.name> wrote:

> On Wed, Feb 02, 2011 at 02:56:05PM -0800, jacob pan wrote:
> > On Wed,  2 Feb 2011 22:47:36 +0200
> > "Kirill A. Shutsemov" <kirill@shutemov.name> wrote:
> > 
> > > From: Kirill A. Shutemov <kirill@shutemov.name>
> > > 
> > > Provides a way of tasks grouping by timer slack value. Introduces
> > > per cgroup max and min timer slack value. When a task attaches to
> > > a cgroup, its timer slack value adjusts (if needed) to fit min-max
> > > range.
> > > 
> > > It also provides a way to set timer slack value for all tasks in
> > > the cgroup at once.
> > > 
> > > This functionality is useful in mobile devices where certain
> > > background apps are attached to a cgroup and minimum wakeups are
> > > desired.
> > > 
> > > Signed-off-by: Kirill A. Shutemov <kirill@shutemov.name>
> > > Idea-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
> > > ---
> > >  include/linux/cgroup_subsys.h |    6 +
> > >  include/linux/init_task.h     |    4 +-
> > >  init/Kconfig                  |   10 ++
> > >  kernel/Makefile               |    1 +
> > >  kernel/cgroup_timer_slack.c   |  242
> > > +++++++++++++++++++++++++++++++++++++++++
> > 


> > 
> > > +
> > > +static struct cftype files[] = {
> > > +	{
> > > +		.name = "set_slack_ns",
> > > +		.write_u64 = tslack_write_set_slack_ns,
> > > +	},
> > should we also allow reading of the current slack_ns?
> 
> There is no 'current slack_ns' for a cgroup since any process free to
> change it with prctl().
> 

I think there is still a need for current slack_ns. e.g. if i created a
cgroup_1 then attach task_A and task_B to it such that their
individual timer_slack got adjusted based on the limit in the
cgroup. Now I set cgroup_1 timer_slack to be ts_1, then timer_slack
for both task_A and task_B are set to ts_1.

If i attach another task_C to cgroup_1, timer_slack for task_C will be
adjusted based on min/max setting of cgroup_1, which can be different
than ts_1. User has to manually set cgroup time_slack again to make them
identical.

I think this logic defeats the purpose of having timer_slack
subsystem in the first place. IMHO, the original intention was to have
grouping effect of tasks in the cgroup.

So my suggestion is to keep a per cgroup current timer_slack value,
which can be default to the system default at 50us. Like Arjan
suggested, we can enforce the timer_slack value in the timer code when
it is used. This way we can solve another problem where when a task is
detached from the cgroup, it would be desirable to restore its original
slack value.

