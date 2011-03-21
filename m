Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753961Ab1CURMr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 13:12:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40934 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751541Ab1CURMp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 13:12:45 -0400
Date: Mon, 21 Mar 2011 17:39:50 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: roland@redhat.com, jan.kratochvil@redhat.com, vda.linux@googlemail.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, indan@nul.nu
Subject: Re: [PATCH 4/8] job control: Allow access to job control events
	through ptracees
Message-ID: <20110321163950.GA27409@redhat.com>
References: <1299614199-25142-1-git-send-email-tj@kernel.org> <1299614199-25142-5-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1299614199-25142-5-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/08, Tejun Heo wrote:
>
> Currently a real parent can't access job control stopped/continued
> events through a ptraced child.  This utterly breaks job control when
> the children are ptraced.

Yes. This is what we need.

Oh. I'll try to recheck this all once again later, there are too many
combinations we should worry about. But looks correct.

Minor problem:

> One situation to be careful about is when the real parent is ptracing.
> The parent is the recipient of both ptrace and job control stop events
> and one stop can be reported as both job control and ptrace stops.  As
> this can break the current ptrace users, suppress job control stopped
> events for these cases.

Yes, but

> @@ -1580,15 +1582,37 @@ static int wait_consider_task(struct wait_opts *wo, int ptrace,
>  			wo->notask_error = 0;
>  	} else {
>  		/*
> +		 * If %current is ptracing @p, hide group stop/continued
> +		 * state when looking at @p as the real parent; otherwise,
> +		 * a single stop can be reported twice as group and ptrace
> +		 * stops.
> +		 *
> +		 * If a ptracer wants to distinguish the two events for its
> +		 * own children, it should create a separate task which
> +		 * takes the role of real parent.
> +		 */
> +		if (likely(!ptrace) && task_ptrace(p) && p->parent == current)
> +			return 0;

This doesn't look exactly right. Ignoring __WNOTHREAD, do_wait() should work
the same way for every thread in parent/debugger's thread group. IOW, we
should probably check same_thread_group(p->parent, p->real_parent) instead
of "== current".



OTOH, this is minor, perhaps we do not care. And  we have more oddities
like this. In fact I think we should just change ptrace_reparented() to
use same_thread_group(), this makes wait_task_zombie() more consistent.
But, again, this needs another discussion and off-topic right now.

Oleg.

