Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423151Ab2LGA4t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 19:56:49 -0500
Received: from mail-vb0-f52.google.com ([209.85.212.52]:49640 "EHLO
	mail-vb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423077Ab2LGA4q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 19:56:46 -0500
MIME-Version: 1.0
In-Reply-To: <1354542848-29638-3-git-send-email-alex.shi@intel.com>
References: <1354542848-29638-1-git-send-email-alex.shi@intel.com>
	<1354542848-29638-3-git-send-email-alex.shi@intel.com>
Date: Fri, 7 Dec 2012 01:56:46 +0100
Message-ID: <CAFTL4hz=PQZuSsF_6--i5BmiJGVxXngdQjDRD4gx4-SwDk36zw@mail.gmail.com>
Subject: Re: [PATCH 02/10] sched: fix find_idlest_group mess logical
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Alex Shi <alex.shi@intel.com>
Cc: npiggin@kernel.dk, mingo@redhat.com, peterz@infradead.org,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        Mike Galbraith <efault@gmx.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/12/3 Alex Shi <alex.shi@intel.com>:
> There is 4 situations in the function:
> 1, no task allowed group;
>         so min_load = ULONG_MAX, this_load = 0, idlest = NULL
> 2, only local group task allowed;
>         so min_load = ULONG_MAX, this_load assigned, idlest = NULL
> 3, only non-local task group allowed;
>         so min_load assigned, this_load = 0, idlest != NULL
> 4, local group + another group are task allowed.
>         so min_load assigned, this_load assigned, idlest != NULL
>
> Current logical will return NULL in first 3 kinds of scenarios.
> And still return NULL, if idlest group is heavier then the
> local group in the 4th situation.
>
> Actually, I thought groups in situation 2,3 are also eligible to host
> the task. And in 4th situation, agree to bias toward local group.
> So, has this patch.

The way I understand the loop that use this in select_task_rq_fair() is:

a) start from the highest domain level we are allowed to run to
migrate the task in
b) from that top level domain, find the idlest group. If the idlest
group contains current CPU, zoom in the child domain and repeat b). If
the idlest group doesn't contain the current CPU, pick the idlest CPU
from that group.
c) In the end if we found no idler target than current CPU, then take it.

So if you also return a group that contains current CPU from
find_idlest_group(), you don't recursively zoom in the child domain
anymore. find_idlest_cpu() will fix that for you but it may come with
some cost because now it iterates through every CPUs, or may be half
of them.

The advantage of a recursive zooming through find_idlest_group() is to
scale better with the number of CPUs. It's probably like O(log n)
instead of O(n).

But it's possible I misunderstood something.
