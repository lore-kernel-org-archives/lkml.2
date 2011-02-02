Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755521Ab1BBXXm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 18:23:42 -0500
Received: from smtp-out.google.com ([216.239.44.51]:61075 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755180Ab1BBXXk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 18:23:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=X1zZej52wwHx6MO1VgWLKAjHWHLeP8WTBdG/eieRnXa8lETA9R/7wi/mmF6pqbrka6
         STIqnvW2lmAR/sYQr4Uw==
MIME-Version: 1.0
In-Reply-To: <1296679656-31163-3-git-send-email-kirill@shutemov.name>
References: <1296679656-31163-1-git-send-email-kirill@shutemov.name> <1296679656-31163-3-git-send-email-kirill@shutemov.name>
From: Paul Menage <menage@google.com>
Date: Wed, 2 Feb 2011 15:23:15 -0800
Message-ID: <AANLkTikAbmFmQNGgYMYhTOS8L5nU39edcTjQXNpdxGy2@mail.gmail.com>
Subject: Re: [PATCH, v3 2/2] cgroups: introduce timer slack subsystem
To: "Kirill A. Shutsemov" <kirill@shutemov.name>
Cc: Li Zefan <lizf@cn.fujitsu.com>, containers@lists.linux-foundation.org,
        jacob.jun.pan@linux.intel.com,
        Arjan van de Ven <arjan@linux.intel.com>, linux-kernel@vger.kernel.org,
        Matt Helsley <matthltc@us.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 2, 2011 at 12:47 PM, Kirill A. Shutsemov
<kirill@shutemov.name> wrote:
> From: Kirill A. Shutemov <kirill@shutemov.name>
>
> Provides a way of tasks grouping by timer slack value. Introduces per
> cgroup max and min timer slack value. When a task attaches to a cgroup,
> its timer slack value adjusts (if needed) to fit min-max range.
>
> It also provides a way to set timer slack value for all tasks in the
> cgroup at once.
>
> This functionality is useful in mobile devices where certain background
> apps are attached to a cgroup and minimum wakeups are desired.

If you really want to be able to make this modular, I'd be inclined to
make the check_timer_slack hook just default to NULL, rather than
introducing dummy_timer_slack_check()


> +
> +static int tslack_write_range(struct cgroup *cgroup, struct cftype *cft,
> +               u64 val)
> +{
> +       struct timer_slack_cgroup *tslack_cgroup;
> +       struct cgroup_iter it;
> +       struct task_struct *task;
> +
> +       if (!val)
> +               return -EINVAL;
> +
> +       tslack_cgroup = cgroup_to_tslack_cgroup(cgroup);
> +       switch (cft->private) {
> +       case TIMER_SLACK_MIN:
> +               if (val > tslack_cgroup->max_slack_ns)
> +                       return -EINVAL;
> +               tslack_cgroup->min_slack_ns = val;
> +               break;
> +       case TIMER_SLACK_MAX:
> +               if (val < tslack_cgroup->min_slack_ns)
> +                       return -EINVAL;
> +               tslack_cgroup->max_slack_ns = val;
> +               break;
> +       default:
> +               BUG();
> +       }
> +

Don't we want to keep the min/max applied hierarchically as well? i.e.
a child can't set its min/max outside the range of its parents?

> +
> +static int __init init_cgroup_timer_slack(void)
> +{
> +       BUG_ON(timer_slack_check != dummy_timer_slack_check);

Better to make this just fail the initialization if someone else has
already claimed the hook, rather than crashing.

Paul
