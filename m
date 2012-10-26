Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965631Ab2JZRxH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 13:53:07 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:57229 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965593Ab2JZRxE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 13:53:04 -0400
Date: Fri, 26 Oct 2012 10:52:58 -0700
From: Tejun Heo <tj@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: rjw@sisk.pl, linux-kernel@vger.kernel.org, lizefan@huawei.com,
        containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH v2 1/1] freezer: change ptrace_stop/do_signal_stop to use
 freezable_schedule()
Message-ID: <20121026175258.GV11442@htj.dyndns.org>
References: <20121022211317.GD5951@atj.dyndns.org>
 <20121023153919.GA16201@redhat.com>
 <20121024185710.GA12182@atj.dyndns.org>
 <20121025163941.GA3801@redhat.com>
 <20121025163959.GB3801@redhat.com>
 <20121025171812.GE11442@htj.dyndns.org>
 <20121025173433.GA7650@redhat.com>
 <20121025173632.GI11442@htj.dyndns.org>
 <20121026174545.GA21639@redhat.com>
 <20121026174606.GB21639@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121026174606.GB21639@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 26, 2012 at 07:46:06PM +0200, Oleg Nesterov wrote:
> try_to_freeze_tasks() and cgroup_freezer rely on scheduler locks
> to ensure that a task doing STOPPED/TRACED -> RUNNING transition
> can't escape freezing. This mostly works, but ptrace_stop() does
> not necessarily call schedule(), it can change task->state back to
> RUNNING and check freezing() without any lock/barrier in between.
> 
> We could add the necessary barrier, but this patch changes
> ptrace_stop() and do_signal_stop() to use freezable_schedule().
> This fixes the race, freezer_count() and freezer_should_skip()
> carefully avoid the race.
> 
> And this simplifies the code, try_to_freeze_tasks/update_if_frozen
> no longer need to use task_is_stopped_or_traced() checks with the
> non trivial assumptions. We can rely on the mechanism which was
> specially designed to mark the sleeping task as "frozen enough".
> 
> v2: As Tejun pointed out, we can also change get_signal_to_deliver()
> and move try_to_freeze() up before 'relock' label.
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>

Looks good to me. :)

 Acked-by: Tejun Heo <tj@kernel.org>

Rafael, sorry that this one doesn't have pm cc'd but can you please
pick up this one too?

Thanks a lot.

-- 
tejun
