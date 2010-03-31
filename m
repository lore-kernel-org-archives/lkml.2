Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933040Ab0CaJSp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Mar 2010 05:18:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26238 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932980Ab0CaJSk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Mar 2010 05:18:40 -0400
Date: Wed, 31 Mar 2010 11:16:28 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: David Rientjes <rientjes@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, anfei <anfei.zhou@gmail.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       nishimura@mxp.nes.nec.co.jp,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Mel Gorman <mel@csn.ul.ie>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] oom: fix the unsafe proc_oom_score()->badness() call
Message-ID: <20100331091628.GA11438@redhat.com>
References: <1269447905-5939-1-git-send-email-anfei.zhou@gmail.com> <20100326150805.f5853d1c.akpm@linux-foundation.org> <20100326223356.GA20833@redhat.com> <20100328145528.GA14622@desktop> <20100328162821.GA16765@redhat.com> <alpine.DEB.2.00.1003281341590.30570@chino.kir.corp.google.com> <20100329112111.GA16971@redhat.com> <alpine.DEB.2.00.1003291302170.14859@chino.kir.corp.google.com> <20100330163909.GA16884@redhat.com> <alpine.DEB.2.00.1003301331110.5234@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1003301331110.5234@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/30, David Rientjes wrote:
>
> On Tue, 30 Mar 2010, Oleg Nesterov wrote:
>
> > proc_oom_score(task) have a reference to task_struct, but that is all.
> > If this task was already released before we take tasklist_lock
> >
> > 	- we can't use task->group_leader, it points to nowhere
> >
> > 	- it is not safe to call badness() even if this task is
> > 	  ->group_leader, has_intersects_mems_allowed() assumes
> > 	  it is safe to iterate over ->thread_group list.
> >
> > Add the pid_alive() check to ensure __unhash_process() was not called.
> >
> > Note: I think we shouldn't use ->group_leader, badness() should return
> > the same result for any sub-thread. However this is not true currently,
> > and I think that ->mm check and list_for_each_entry(p->children) in
> > badness are not right.
> >
>
> I think it would be better to just use task and not task->group_leader.

Sure, agreed. I preserved ->group_leader just because I didn't understand
why the current code doesn't use task. But note that pid_alive() is still
needed.

I'll check the code in -mm and resend.

Oleg.

