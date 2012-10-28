Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752750Ab2J1Non (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2012 09:44:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9098 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752464Ab2J1Nol (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2012 09:44:41 -0400
Date: Sun, 28 Oct 2012 14:45:33 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: Tejun Heo <tj@kernel.org>, rjw@sisk.pl, linux-kernel@vger.kernel.org,
        lizefan@huawei.com, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v2 1/1] freezer: change ptrace_stop/do_signal_stop to
	use freezable_schedule()
Message-ID: <20121028134533.GA30847@redhat.com>
References: <20121023153919.GA16201@redhat.com> <20121024185710.GA12182@atj.dyndns.org> <20121025163941.GA3801@redhat.com> <20121025163959.GB3801@redhat.com> <20121025171812.GE11442@htj.dyndns.org> <20121025173433.GA7650@redhat.com> <20121025173632.GI11442@htj.dyndns.org> <20121026174545.GA21639@redhat.com> <20121026174606.GB21639@redhat.com> <1351376558.21585.1.camel@deadeye.wl.decadent.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1351376558.21585.1.camel@deadeye.wl.decadent.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/27, Ben Hutchings wrote:
>
> On Fri, 2012-10-26 at 19:46 +0200, Oleg Nesterov wrote:
> > try_to_freeze_tasks() and cgroup_freezer rely on scheduler locks
> > to ensure that a task doing STOPPED/TRACED -> RUNNING transition
> > can't escape freezing. This mostly works, but ptrace_stop() does
> > not necessarily call schedule(), it can change task->state back to
> > RUNNING and check freezing() without any lock/barrier in between.
> >
> > We could add the necessary barrier, but this patch changes
> > ptrace_stop() and do_signal_stop() to use freezable_schedule().
> > This fixes the race, freezer_count() and freezer_should_skip()
> > carefully avoid the race.
> >
> > And this simplifies the code, try_to_freeze_tasks/update_if_frozen
> > no longer need to use task_is_stopped_or_traced() checks with the
> > non trivial assumptions. We can rely on the mechanism which was
> > specially designed to mark the sleeping task as "frozen enough".
> >
> > v2: As Tejun pointed out, we can also change get_signal_to_deliver()
> > and move try_to_freeze() up before 'relock' label.
> >
> > Signed-off-by: Oleg Nesterov <oleg@redhat.com>
> [...]
>
> This is not the correct way to submit a change to stable.  Please see
> Documentation/stable_kernel_rules.txt

Sorry for confusion, it is not for stable@, it was cc'ed by mistake.

Oleg.

