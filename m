Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932603Ab0FQBzw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 21:55:52 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:47622 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758981Ab0FQBvk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 21:51:40 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH 6/9] oom: use same_thread_group instead comparing ->mm
Cc: kosaki.motohiro@jp.fujitsu.com, LKML <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Rientjes <rientjes@google.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20100616122403.GA5304@redhat.com>
References: <20100616203319.72E6.A69D9226@jp.fujitsu.com> <20100616122403.GA5304@redhat.com>
Message-Id: <20100617101809.FB54.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Thu, 17 Jun 2010 10:51:37 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On 06/16, KOSAKI Motohiro wrote:
> >
> > Now, oom are using "child->mm != p->mm" check to distinguish subthread.
> 
> Heh. is it true??? I never undestood what oom_kill_process()->list_for_each_entry()
> is supposed to do.

I guessed. true history was gone long time ago ;)
ok, I'll remove dubious guess.

> > But It's incorrect. vfork() child also have the same ->mm.
> 
> Yes.
> 
> > This patch change to use same_thread_group() instead.
> 
> I don't think we need same_thread_group(). Please note that any children must
> be from the different thread_group.

Agghh. I see.
ok, probably, I've got correct original author intention now.
To be honest, andrea's ancient patch is very hard to understand for me ;)

> 
> So,
> 
> > --- a/mm/oom_kill.c
> > +++ b/mm/oom_kill.c
> > @@ -161,7 +161,7 @@ unsigned long oom_badness(struct task_struct *p, unsigned long uptime)
> >  		list_for_each_entry(c, &t->children, sibling) {
> >  			child = find_lock_task_mm(c);
> >  			if (child) {
> > -				if (child->mm != p->mm)
> > +				if (same_thread_group(p, child))
> >  					points += child->mm->total_vm/2 + 1;
> >  				task_unlock(child);
> >  			}
> > @@ -486,7 +486,7 @@ static int oom_kill_process(struct task_struct *p, gfp_t gfp_mask, int order,
> >  		list_for_each_entry(child, &t->children, sibling) {
> >  			unsigned long child_points;
> >
> > -			if (child->mm == p->mm)
> > +			if (same_thread_group(p, child))
> >  				continue;
> 
> In both cases same_thread_group() must be false.
> 
> This means that the change in oom_badness() doesn't look right,
> "child->mm != p->mm" is the correct check to decide whether we should
> account child->mm.
> 
> The change in oom_kill_process() merely removes this "continue".
> Could someone please explain what this code _should_ do?

I think you are right.


