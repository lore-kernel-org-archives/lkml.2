Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756680Ab1CBKaN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 05:30:13 -0500
Received: from casper.infradead.org ([85.118.1.10]:58262 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756079Ab1CBKaM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 05:30:12 -0500
Subject: Re: [PATCH] sched: next buddy hint on sleep and preempt path
From: Peter Zijlstra <peterz@infradead.org>
To: Venkatesh Pallipadi <venki@google.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        Paul Turner <pjt@google.com>, Mike Galbraith <efault@gmx.de>,
        Rik van Riel <riel@redhat.com>
In-Reply-To: <1299022433-17233-1-git-send-email-venki@google.com>
References: <1299022433-17233-1-git-send-email-venki@google.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 02 Mar 2011 11:31:43 +0100
Message-ID: <1299061903.1310.1.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-03-01 at 15:33 -0800, Venkatesh Pallipadi wrote:
> When a task in a taskgroup sleeps, pick_next_task starts all the way back at
> the root and picks the task/taskgroup with the min vruntime across all
> runnable tasks. But, when there are many frequently sleeping tasks
> across different taskgroups, it makes better sense to stay with same taskgroup
> for its slice period (or until all tasks in the taskgroup sleeps) instead of
> switching cross taskgroup on each sleep after a short runtime.
> This helps specifically where taskgroups corresponds to a process with
> multiple threads. The change reduces the number of CR3 switches in this case.

I wasn't expecting this approach to this problem, and was dreading a
pick_next_task() rewrite, but aside from all the mentioned problems it
does look quite nice :-)

It doesn't avoid iterating the whole hierarchy every schedule, but like
you say, it should avoid the expensive cr3 switches.

