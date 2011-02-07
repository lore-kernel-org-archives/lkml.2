Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753621Ab1BGLGG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Feb 2011 06:06:06 -0500
Received: from shutemov.name ([188.40.19.243]:36114 "EHLO shutemov.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753392Ab1BGLGE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Feb 2011 06:06:04 -0500
Date: Mon, 7 Feb 2011 13:06:03 +0200
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Jacob Pan <jacob.jun.pan@linux.intel.com>
Cc: Paul Menage <menage@google.com>, Li Zefan <lizf@cn.fujitsu.com>,
        containers@lists.linux-foundation.org,
        Arjan van de Ven <arjan@linux.intel.com>, linux-kernel@vger.kernel.org,
        Matt Helsley <matthltc@us.ibm.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH, v3 2/2] cgroups: introduce timer slack subsystem
Message-ID: <20110207110603.GB11712@shutemov.name>
References: <1296679656-31163-1-git-send-email-kirill@shutemov.name>
 <1296679656-31163-3-git-send-email-kirill@shutemov.name>
 <20110202145605.6c9006fa@putvin>
 <20110203092229.GB1083@shutemov.name>
 <20110203095117.76a568fc@putvin>
 <AANLkTikvkUT8+U=bX6X2n7kMbnAt6evxTy1BqiX+TWpH@mail.gmail.com>
 <20110203115743.1ef9a4c2@putvin>
 <20110204133439.GA7181@shutemov.name>
 <20110204092755.0bbfaa7a@putvin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110204092755.0bbfaa7a@putvin>
User-Agent: Mutt/1.5.20 (2010-08-04)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 04, 2011 at 09:27:55AM -0800, Jacob Pan wrote:
> On Fri, 4 Feb 2011 15:34:39 +0200
> "Kirill A. Shutemov" <kirill@shutemov.name> wrote:
> > What's mean "original timer slack" if you are free to move a task
> > between a lot of cgroups and process itself free to change it anytime?
> > 
> 
> I need to manage tasks by a management software instead of letting the
> task change timer_slack by itself. The goal is to make management
> transparent and no modifications to the existing apps. Therefore, it is
> desirable to automatically enforce timer_slack when the apps are in the
> cgroup while automatically restore it when it is no longer under cgroup
> management.

Tasks are always under cgroup management. Root cgroup is still cgroup.

> So the "original timer slack" can be the default 50us or whatever value
> chosen by the task itself. But the app itself should not care or even be
> aware of which cgroup it is in.
> 
> So here are two optoins i can think of
> 1. add a new variable called cg_timer_slack_ns to struct task_struct{}
> cg_timer_slack_ns will be set by cgroup timer_slack subsystem, then we
> can retain the original per task value in timer_slack_ns.
> timer code will pick max(cg_timer_slack_ns, timer_slack_ns) if
> cg_timer_slack_ns is set.
> 
> 2. leave task_struct unchanged, add a current_timer_slack to the
> cgroup. timer_slack cgroup does not modify per task timer_slack_ns.
> similar to option #1, let timer code pick the timer_slack to use based
> on whether the task is in timer_slack cgroup.
> 
> Any thoughts?

I think it's over-engineering.

What about configuration like this:

 root_cgroup
 |--timer_slack.min_slack_ns = 0
 |--timer_slack.max_slack_ns = ULONG_MAX
 |--50us
 |  |--timer_slack.min_slack_ns = 50000
 |  |--timer_slack.max_slack_ns = 50000
 |--500us
    |--timer_slack.min_slack_ns = 500000
    |--timer_slack_max_slack_ns = ULONG_MAX

If you want a task allow to drive its timer_slack, just leave it in
root_cgroup.

It you want to drive timer_slack of a task, move it between 50us and 500um
based on your policy.
 
-- 
 Kirill A. Shutemov
