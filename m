Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753966Ab1EIOHV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 10:07:21 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:40683 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753942Ab1EIOHT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 10:07:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:reply-to:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=gwF+1oA/q5mnReEMkAZob0WWEf/9aR8B1IDloyUgDSVtbsIZl6jd1L3expsfnvJqMA
         0kHHTlYlsJD5oow0PIeWdCrO3W7BR3TsATImIIkSIU7v6cn8c4mrpIrBQlsva0ih24YS
         gipQ/YcNF6AWYZ2UJw3LsU7wh0gP0ph0uuJfE=
Date: Mon, 9 May 2011 22:07:05 +0800
From: Yong Zhang <yong.zhang0@gmail.com>
To: Hillf Danton <dhillf@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>, Mike Galbraith <efault@gmx.de>
Subject: Re: [PATCH] sched: shorten setting the allowed cpu mask of task
Message-ID: <20110509140705.GA2219@zhy>
Reply-To: Yong Zhang <yong.zhang0@gmail.com>
References: <BANLkTi=tPbwNP3xDYZVHHqQ2zZujCBT6jw@mail.gmail.com>
 <BANLkTimjkK-q63x5DrEj+9=pF8zbW7mJ2g@mail.gmail.com>
 <BANLkTimrHnX5BcK5Q6eJgCAzP+j7azAqow@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <BANLkTimrHnX5BcK5Q6eJgCAzP+j7azAqow@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 09, 2011 at 08:52:53PM +0800, Hillf Danton wrote:
> On Mon, May 9, 2011 at 12:39 PM, Yong Zhang <yong.zhang0@gmail.com> wrote:
> > On Fri, May 6, 2011 at 8:52 PM, Hillf Danton <dhillf@gmail.com> wrote:
> >> When setting the allowed cpu mask for a given task, if the task is
> >> already bound to certain cpu, after checking the validity of the new
> >
> > Maybe we don't need to restrict it only on task bound to certain cpu.
> >
> Hi Yong
> 
> The original code guards, I guess, casual change in the mask of
> allowed CPUs, if bounded,
> for tasks such as the workers of work queue. So the restriction looks necessary.

Yeah, that is true; but I don't think we need to go ahead for
unbounded task if cpu_allowed will not be changed.

My thought is like below:

---
Subject: [PATCH] sched: avoid going ahead if cpu_allowed will not be changed

If cpumask_equal(&p->cpus_allowed, new_mask) is true, seems
there is no reason to prevent set_cpus_allowed_ptr() return
directly.

Signed-off-by: Yong Zhang <yong.zhang0@gmail.com>
---
 kernel/sched.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index da93381..56bc1fa 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -5946,13 +5946,15 @@ int set_cpus_allowed_ptr(struct task_struct *p, const struct cpumask *new_mask)
 
 	rq = task_rq_lock(p, &flags);
 
+	if (cpumask_equal(&p->cpus_allowed, new_mask))
+		goto out;
+
 	if (!cpumask_intersects(new_mask, cpu_active_mask)) {
 		ret = -EINVAL;
 		goto out;
 	}
 
-	if (unlikely((p->flags & PF_THREAD_BOUND) && p != current &&
-		     !cpumask_equal(&p->cpus_allowed, new_mask))) {
+	if (unlikely((p->flags & PF_THREAD_BOUND) && p != current)) {
 		ret = -EINVAL;
 		goto out;
 	}
-- 
1.7.1

