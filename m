Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758289Ab1FWNXY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 09:23:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46820 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758138Ab1FWNXX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 09:23:23 -0400
Date: Thu, 23 Jun 2011 15:21:26 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        hch@infradead.org
Subject: Re: [PATCH 2/8] kill tracehook_notify_death()
Message-ID: <20110623132126.GA10410@redhat.com>
References: <1308322240-8247-1-git-send-email-tj@kernel.org> <1308322240-8247-7-git-send-email-tj@kernel.org> <20110622210757.GA20549@redhat.com> <20110622210834.GC20549@redhat.com> <20110623122253.GM30101@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110623122253.GM30101@htj.dyndns.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tejun,

On 06/23, Tejun Heo wrote:
>
> Hello, Oleg.
>
> On Wed, Jun 22, 2011 at 11:08:34PM +0200, Oleg Nesterov wrote:
> > Kill tracehook_notify_death(), reimplement the logic in its caller,
> > exit_notify().
> >
> > This also fixes a minor bug, if the exiting task is the group_leader
> > and it is traced by its real_parent, tracehook_notify_death() returns
> > task->exit_signal or SIGCHLD depending on thread_group_empty(), this
> > looks strange.
>
> Maybe we should do the above in a separate patch?

Do you think this makes sense? OK, I can do this...

>
> > -	if (tsk->exit_signal != SIGCHLD && !task_detached(tsk) &&
> > +	if (thread_group_leader(tsk) && tsk->exit_signal != SIGCHLD &&
>
> Hmmm... it probably depends on POV but wouldn't (exit_signal != -1 &&
> exit_signal != SIGCHLD) be easier?

I disagree.

> The logic here is about demoting
> specials sigs to SIGCHLD under certain circumstances

Yes. And what is ->exit_signal? It is in fact per-process, lives in the
group_leader's task_struct. We could move it to signal_struct.

> and the check is
> there to prevent promoting -1 to SIGCHLD.

Yes, because we should never change ->exit_signal for sub-threads.

And it doesn't make sense to check exec ids (this is again per-process,
should be cleanuped) unless the task is the group leader.

> thread_group_leader() seems
> unnecessarily indirect.

This is what I disagree with. Contrary, I think thread_group_leader() exactly
explains what do we want to check. (but once again, exec_id logic should be
cleanuped, not only in this function).

Oleg.

