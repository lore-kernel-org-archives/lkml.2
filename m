Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755961Ab1BCJ26 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Feb 2011 04:28:58 -0500
Received: from shutemov.name ([188.40.19.243]:49978 "EHLO shutemov.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755480Ab1BCJ24 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Feb 2011 04:28:56 -0500
Date: Thu, 3 Feb 2011 11:28:55 +0200
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Paul Menage <menage@google.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>, containers@lists.linux-foundation.org,
        jacob.jun.pan@linux.intel.com,
        Arjan van de Ven <arjan@linux.intel.com>, linux-kernel@vger.kernel.org,
        Matt Helsley <matthltc@us.ibm.com>
Subject: Re: [PATCH, v3 2/2] cgroups: introduce timer slack subsystem
Message-ID: <20110203092855.GC1083@shutemov.name>
References: <1296679656-31163-1-git-send-email-kirill@shutemov.name>
 <1296679656-31163-3-git-send-email-kirill@shutemov.name>
 <AANLkTikAbmFmQNGgYMYhTOS8L5nU39edcTjQXNpdxGy2@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTikAbmFmQNGgYMYhTOS8L5nU39edcTjQXNpdxGy2@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2010-08-04)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 02, 2011 at 03:23:15PM -0800, Paul Menage wrote:
> On Wed, Feb 2, 2011 at 12:47 PM, Kirill A. Shutsemov
> <kirill@shutemov.name> wrote:
> > From: Kirill A. Shutemov <kirill@shutemov.name>
> >
> > Provides a way of tasks grouping by timer slack value. Introduces per
> > cgroup max and min timer slack value. When a task attaches to a cgroup,
> > its timer slack value adjusts (if needed) to fit min-max range.
> >
> > It also provides a way to set timer slack value for all tasks in the
> > cgroup at once.
> >
> > This functionality is useful in mobile devices where certain background
> > apps are attached to a cgroup and minimum wakeups are desired.
> 
> If you really want to be able to make this modular,

Why not?

> I'd be inclined to
> make the check_timer_slack hook just default to NULL, rather than
> introducing dummy_timer_slack_check()

Good point.

> > +
> > +static int tslack_write_range(struct cgroup *cgroup, struct cftype *cft,
> > +               u64 val)
> > +{
> > +       struct timer_slack_cgroup *tslack_cgroup;
> > +       struct cgroup_iter it;
> > +       struct task_struct *task;
> > +
> > +       if (!val)
> > +               return -EINVAL;
> > +
> > +       tslack_cgroup = cgroup_to_tslack_cgroup(cgroup);
> > +       switch (cft->private) {
> > +       case TIMER_SLACK_MIN:
> > +               if (val > tslack_cgroup->max_slack_ns)
> > +                       return -EINVAL;
> > +               tslack_cgroup->min_slack_ns = val;
> > +               break;
> > +       case TIMER_SLACK_MAX:
> > +               if (val < tslack_cgroup->min_slack_ns)
> > +                       return -EINVAL;
> > +               tslack_cgroup->max_slack_ns = val;
> > +               break;
> > +       default:
> > +               BUG();
> > +       }
> > +
> 
> Don't we want to keep the min/max applied hierarchically as well? i.e.
> a child can't set its min/max outside the range of its parents?

Ok, I'll implement it.

> > +
> > +static int __init init_cgroup_timer_slack(void)
> > +{
> > +       BUG_ON(timer_slack_check != dummy_timer_slack_check);
> 
> Better to make this just fail the initialization if someone else has
> already claimed the hook, rather than crashing.

Ok.

Thanks, for reviewing.

-- 
 Kirill A. Shutemov
