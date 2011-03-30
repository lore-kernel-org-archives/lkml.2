Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965363Ab1C3VnO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 17:43:14 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54420 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964901Ab1C3VnJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 17:43:09 -0400
Date: Wed, 30 Mar 2011 14:36:17 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Minchan Kim <minchan.kim@gmail.com>
Cc: linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Andrey Vagin <avagin@openvz.org>
Subject: Re: [PATCH] Accelerate OOM killing
Message-Id: <20110330143617.3d57aad2.akpm@linux-foundation.org>
In-Reply-To: <1300960353-2596-1-git-send-email-minchan.kim@gmail.com>
References: <1300960353-2596-1-git-send-email-minchan.kim@gmail.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 Mar 2011 18:52:33 +0900
Minchan Kim <minchan.kim@gmail.com> wrote:

> When I test Andrey's problem, I saw the livelock and sysrq-t says
> there are many tasks in cond_resched after try_to_free_pages.

__alloc_pages_direct_reclaim() has two cond_resched()s, in
straight-line code.  So I think you're concluding that the first
cond_resched() is a no-op, but the second one frequently schedules
away.

For this to be true, the try_to_free_pages() call must be doing
something to cause it, such as taking a large amount of time, or
delivering wakeups, etc.  Do we know?

The patch is really a bit worrisome and ugly.  If the CPU scheduler has
decided that this task should be preempted then *that* is the problem,
and we need to work out why it is happening and see if there is anything
we should fix.  Instead the patch simply ignores the scheduler's
directive, which is known as "papering over a bug".

IOW, we should work out why need_resched is getting set so frequently
rather than just ignoring it (and potentially worsening kernel
scheduling latency).

> If did_some_progress is false, cond_resched could delay oom killing so
> It might be killing another task.
> 
> This patch accelerates oom killing without unnecessary giving CPU
> to another task. It could help avoding unnecessary another task killing
> and livelock situation a litte bit.

Well...  _does_ it help?  What were the results of your testing of this
patch?

