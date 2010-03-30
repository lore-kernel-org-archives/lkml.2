Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755833Ab0C3Ucf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 16:32:35 -0400
Received: from smtp-out.google.com ([216.239.44.51]:29456 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755585Ab0C3Uc2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 16:32:28 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=lLjskqCZK03twy9iaikmX84Xk2V6lppdqoI9posxNiK2imyIebyGDOV1m4QGba6Cp
	mB6YEdCVOJ7CYyxYCuZjg==
Date: Tue, 30 Mar 2010 13:32:21 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Oleg Nesterov <oleg@redhat.com>
cc: Andrew Morton <akpm@linux-foundation.org>, anfei <anfei.zhou@gmail.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       nishimura@mxp.nes.nec.co.jp,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Mel Gorman <mel@csn.ul.ie>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] oom: fix the unsafe proc_oom_score()->badness() call
In-Reply-To: <20100330163909.GA16884@redhat.com>
Message-ID: <alpine.DEB.2.00.1003301331110.5234@chino.kir.corp.google.com>
References: <1269447905-5939-1-git-send-email-anfei.zhou@gmail.com> <20100326150805.f5853d1c.akpm@linux-foundation.org> <20100326223356.GA20833@redhat.com> <20100328145528.GA14622@desktop> <20100328162821.GA16765@redhat.com>
 <alpine.DEB.2.00.1003281341590.30570@chino.kir.corp.google.com> <20100329112111.GA16971@redhat.com> <alpine.DEB.2.00.1003291302170.14859@chino.kir.corp.google.com> <20100330163909.GA16884@redhat.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Mar 2010, Oleg Nesterov wrote:

> proc_oom_score(task) have a reference to task_struct, but that is all.
> If this task was already released before we take tasklist_lock
> 
> 	- we can't use task->group_leader, it points to nowhere
> 
> 	- it is not safe to call badness() even if this task is
> 	  ->group_leader, has_intersects_mems_allowed() assumes
> 	  it is safe to iterate over ->thread_group list.
> 
> Add the pid_alive() check to ensure __unhash_process() was not called.
> 
> Note: I think we shouldn't use ->group_leader, badness() should return
> the same result for any sub-thread. However this is not true currently,
> and I think that ->mm check and list_for_each_entry(p->children) in
> badness are not right.
> 

I think it would be better to just use task and not task->group_leader.
