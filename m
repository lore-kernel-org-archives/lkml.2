Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758898Ab0FPM0R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 08:26:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41164 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754271Ab0FPM0Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 08:26:16 -0400
Date: Wed, 16 Jun 2010 14:24:03 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Rientjes <rientjes@google.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH 6/9] oom: use same_thread_group instead comparing ->mm
Message-ID: <20100616122403.GA5304@redhat.com>
References: <20100616201948.72D7.A69D9226@jp.fujitsu.com> <20100616203319.72E6.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100616203319.72E6.A69D9226@jp.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/16, KOSAKI Motohiro wrote:
>
> Now, oom are using "child->mm != p->mm" check to distinguish subthread.

Heh. is it true??? I never undestood what oom_kill_process()->list_for_each_entry()
is supposed to do.

> But It's incorrect. vfork() child also have the same ->mm.

Yes.

> This patch change to use same_thread_group() instead.

I don't think we need same_thread_group(). Please note that any children must
be from the different thread_group.

So,

> --- a/mm/oom_kill.c
> +++ b/mm/oom_kill.c
> @@ -161,7 +161,7 @@ unsigned long oom_badness(struct task_struct *p, unsigned long uptime)
>  		list_for_each_entry(c, &t->children, sibling) {
>  			child = find_lock_task_mm(c);
>  			if (child) {
> -				if (child->mm != p->mm)
> +				if (same_thread_group(p, child))
>  					points += child->mm->total_vm/2 + 1;
>  				task_unlock(child);
>  			}
> @@ -486,7 +486,7 @@ static int oom_kill_process(struct task_struct *p, gfp_t gfp_mask, int order,
>  		list_for_each_entry(child, &t->children, sibling) {
>  			unsigned long child_points;
>
> -			if (child->mm == p->mm)
> +			if (same_thread_group(p, child))
>  				continue;

In both cases same_thread_group() must be false.

This means that the change in oom_badness() doesn't look right,
"child->mm != p->mm" is the correct check to decide whether we should
account child->mm.

The change in oom_kill_process() merely removes this "continue".
Could someone please explain what this code _should_ do?

Oleg.

