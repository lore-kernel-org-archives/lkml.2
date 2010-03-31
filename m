Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756694Ab0CaBbv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 21:31:51 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:54105 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755324Ab0CaBbt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 21:31:49 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Wed, 31 Mar 2010 10:27:55 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Michael S. Tsirkin" <mst@redhat.com>, cl@linux-foundation.org,
       lee.schermerhorn@hp.com, rientjes@google.com,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Rik van Riel <riel@redhat.com>, Minchan Kim <minchan.kim@gmail.com>,
       Andrea Arcangeli <aarcange@redhat.com>,
       "David S. Miller" <davem@davemloft.net>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, Troels Liebe Bentsen <tlb@rapanden.dk>,
       linux-bluetooth@vger.kernel.org
Subject: Re: [PATCH] exit: fix oops in sync_mm_rss
Message-Id: <20100331102755.92a89ca5.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20100330182258.59813fe6.akpm@linux-foundation.org>
References: <20100316170808.GA29400@redhat.com>
	<20100330135634.09e6b045.akpm@linux-foundation.org>
	<20100331092815.c8b9d89c.kamezawa.hiroyu@jp.fujitsu.com>
	<20100330173721.cbd442cb.akpm@linux-foundation.org>
	<20100331094124.43c49290.kamezawa.hiroyu@jp.fujitsu.com>
	<20100330182258.59813fe6.akpm@linux-foundation.org>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Mar 2010 18:22:58 -0400
Andrew Morton <akpm@linux-foundation.org> wrote:

> On Wed, 31 Mar 2010 09:41:24 +0900 KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> 
> > > With this fixed, the test for non-zero tsk->mm is't really needed in
> > > do_exit(), is it?  I guess it makes sense though - sync_mm_rss() only
> > > really works for kernel threads by luck..
> > 
> > At first, I considered so, too. But I changed my mind to show
> > "we know tsk->mm can be NULL here!" by code. 
> > Because __sync_mm_rss_stat() has BUG_ON(!mm), the code reader will think
> > tsk->mm shouldn't be NULL always.
> > 
> > Doesn't make sense ?
> 
> uh, not really ;)
> 
> 
> I think we should do this too:
> 
> --- a/mm/memory.c~exit-fix-oops-in-sync_mm_rss-fix
> +++ a/mm/memory.c
> @@ -131,7 +131,6 @@ static void __sync_task_rss_stat(struct 
>  
>  	for (i = 0; i < NR_MM_COUNTERS; i++) {
>  		if (task->rss_stat.count[i]) {
> -			BUG_ON(!mm);
>  			add_mm_counter(mm, i, task->rss_stat.count[i]);
>  			task->rss_stat.count[i] = 0;
>  		}
> _
> 
> Because we just made sure it can't happen, and if it _does_ happen, the
> oops will tell us the samme thing that the BUG_ON() would have.
> 

Hmm, then, finaly..
==

task->rss_stat wasn't initialized to 0 at copy_process().
And __sync_task_rss_stat() should be static.
removed BUG_ON(!mm) in __sync_task_rss_stat() for avoiding to show
wrong information to code readers. Anyway, if !mm && task->rss_stat
has some value, panic will happen.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
 kernel/fork.c |    3 +++
 mm/memory.c   |    3 +--
 2 files changed, 4 insertions(+), 2 deletions(-)

Index: mmotm-2.6.34-Mar24/mm/memory.c
===================================================================
--- mmotm-2.6.34-Mar24.orig/mm/memory.c
+++ mmotm-2.6.34-Mar24/mm/memory.c
@@ -124,13 +124,12 @@ core_initcall(init_zero_pfn);
 
 #if defined(SPLIT_RSS_COUNTING)
 
-void __sync_task_rss_stat(struct task_struct *task, struct mm_struct *mm)
+static void __sync_task_rss_stat(struct task_struct *task, struct mm_struct *mm)
 {
 	int i;
 
 	for (i = 0; i < NR_MM_COUNTERS; i++) {
 		if (task->rss_stat.count[i]) {
-			BUG_ON(!mm);
 			add_mm_counter(mm, i, task->rss_stat.count[i]);
 			task->rss_stat.count[i] = 0;
 		}
Index: mmotm-2.6.34-Mar24/kernel/fork.c
===================================================================
--- mmotm-2.6.34-Mar24.orig/kernel/fork.c
+++ mmotm-2.6.34-Mar24/kernel/fork.c
@@ -1060,6 +1060,9 @@ static struct task_struct *copy_process(
 	p->prev_utime = cputime_zero;
 	p->prev_stime = cputime_zero;
 #endif
+#if defined(SPLIT_RSS_COUNTING)
+	memset(&p->rss_stat, 0, sizeof(p->rss_stat));
+#endif
 
 	p->default_timer_slack_ns = current->timer_slack_ns;
 







