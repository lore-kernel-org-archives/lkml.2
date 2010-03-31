Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755625Ab0CaXsn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Mar 2010 19:48:43 -0400
Received: from smtp-out.google.com ([216.239.44.51]:10506 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753472Ab0CaXsm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Mar 2010 19:48:42 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=Ct/WgwTCNzXADFcAw3soUUbJXbaFYpw2L4iVmET8cw7QsMSw7P7Zyaq9/qDjgUGwa
	48nm3IoNgpJN0yO7Ct/Fw==
Date: Wed, 31 Mar 2010 16:48:31 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Oleg Nesterov <oleg@redhat.com>
cc: Andrew Morton <akpm@linux-foundation.org>, anfei <anfei.zhou@gmail.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       nishimura@mxp.nes.nec.co.jp,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Mel Gorman <mel@csn.ul.ie>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: [patch] oom: give current access to memory reserves if it has
 been killed
In-Reply-To: <20100331233058.GA6081@redhat.com>
Message-ID: <alpine.DEB.2.00.1003311641470.2150@chino.kir.corp.google.com>
References: <20100328145528.GA14622@desktop> <20100328162821.GA16765@redhat.com> <alpine.DEB.2.00.1003281341590.30570@chino.kir.corp.google.com> <20100329112111.GA16971@redhat.com> <alpine.DEB.2.00.1003291302170.14859@chino.kir.corp.google.com>
 <20100330154659.GA12416@redhat.com> <alpine.DEB.2.00.1003301320020.5234@chino.kir.corp.google.com> <20100331175836.GA11635@redhat.com> <alpine.DEB.2.00.1003311342410.25284@chino.kir.corp.google.com> <20100331224904.GA4025@redhat.com>
 <20100331233058.GA6081@redhat.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 1 Apr 2010, Oleg Nesterov wrote:

> > Why? You ignored this part:
> >
> > 	Say, right after exit_mm() we are doing acct_process(), and f_op->write()
> > 	needs a page. So, you are saying that in this case __page_cache_alloc()
> > 	can never trigger out_of_memory() ?
> >
> > why this is not possible?
> >
> > David, I am not arguing, I am asking.
> 
> In case I wasn't clear...
> 
> Yes, currently __oom_kill_task(p) is not possible if p->mm == NULL.
> 
> But your patch adds
> 
> 	if (fatal_signal_pending(current))
> 		__oom_kill_task(current);
> 
> into out_of_memory().
> 

Ok, and it's possible during the tasklist scan if current is PF_EXITING 
and that gets passed to oom_kill_process(), so we need the following 
patch.  Can I have your acked-by and then I'll propose it to Andrew with a 
follow-up that merges __oom_kill_task() into oom_kill_task() since it only 
has one caller now anyway?

 [ Both of these situations will be current since the oom killer is a 
   no-op whenever another task is found to be PF_EXITING and
   oom_kill_process() wouldn't get called with any other thread unless
   oom_kill_quick is enabled or its VM_FAULT_OOM in which cases we kill 
   current as well. ]

Thanks Oleg.
---
 mm/oom_kill.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/oom_kill.c b/mm/oom_kill.c
--- a/mm/oom_kill.c
+++ b/mm/oom_kill.c
@@ -459,7 +459,7 @@ static int oom_kill_process(struct task_struct *p, gfp_t gfp_mask, int order,
 	 * its children or threads, just set TIF_MEMDIE so it can die quickly
 	 */
 	if (p->flags & PF_EXITING) {
-		__oom_kill_task(p);
+		set_tsk_thread_flag(p, TIF_MEMDIE);
 		return 0;
 	}
 
@@ -686,7 +686,7 @@ void out_of_memory(struct zonelist *zonelist, gfp_t gfp_mask,
 	 * its memory.
 	 */
 	if (fatal_signal_pending(current)) {
-		__oom_kill_task(current);
+		set_tsk_thread_flag(current, TIF_MEMDIE);
 		return;
 	}
 
