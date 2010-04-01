Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932071Ab0DATD6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 15:03:58 -0400
Received: from smtp-out.google.com ([216.239.44.51]:10866 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758053Ab0DATD4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 15:03:56 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=iP/GDYBrymF3ig2Och2NY02DKZjdxldxZeSTLrnypcb9Ln7Ylb8t9K7tzD2PwJrDp
	R7YfcffGayUmPXFG6se9w==
Date: Thu, 1 Apr 2010 12:03:39 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Oleg Nesterov <oleg@redhat.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       anfei <anfei.zhou@gmail.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       nishimura@mxp.nes.nec.co.jp,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Mel Gorman <mel@csn.ul.ie>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, stable@kernel.org
Subject: Re: [PATCH 1/1] oom: fix the unsafe usage of badness() in
 proc_oom_score()
In-Reply-To: <20100401131357.GB11291@redhat.com>
Message-ID: <alpine.DEB.2.00.1004011200330.30661@chino.kir.corp.google.com>
References: <20100328162821.GA16765@redhat.com> <alpine.DEB.2.00.1003281341590.30570@chino.kir.corp.google.com> <20100329112111.GA16971@redhat.com> <alpine.DEB.2.00.1003291302170.14859@chino.kir.corp.google.com> <20100330163909.GA16884@redhat.com>
 <alpine.DEB.2.00.1003301331110.5234@chino.kir.corp.google.com> <20100331091628.GA11438@redhat.com> <20100331201746.GC11635@redhat.com> <alpine.DEB.2.00.1004010029260.6285@chino.kir.corp.google.com> <20100401131321.GA11291@redhat.com>
 <20100401131357.GB11291@redhat.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 1 Apr 2010, Oleg Nesterov wrote:

> proc_oom_score(task) have a reference to task_struct, but that is all.
> If this task was already released before we take tasklist_lock
> 
> 	- we can't use task->group_leader, it points to nowhere
> 
> 	- it is not safe to call badness() even if this task is
> 	  ->group_leader, has_intersects_mems_allowed() assumes
> 	  it is safe to iterate over ->thread_group list.
> 
> 	- even worse, badness() can hit ->signal == NULL
> 
> Add the pid_alive() check to ensure __unhash_process() was not called.
> 
> Also, use "task" instead of task->group_leader. badness() should return
> the same result for any sub-thread. Currently this is not true, but
> this should be changed anyway.
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>

Acked-by: David Rientjes <rientjes@google.com>

Andrew, this is 2.6.34 material and should be backported to stable.  It's 
not introduced by the recent oom killer rewrite pending in -mm, but it 
will require a trivial merge resolution on that work.
