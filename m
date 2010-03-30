Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756385Ab0CaBZH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 21:25:07 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59939 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756049Ab0CaBZF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 21:25:05 -0400
Date: Tue, 30 Mar 2010 18:22:58 -0400
From: Andrew Morton <akpm@linux-foundation.org>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>, cl@linux-foundation.org,
       lee.schermerhorn@hp.com, rientjes@google.com,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Rik van Riel <riel@redhat.com>, Minchan Kim <minchan.kim@gmail.com>,
       Andrea Arcangeli <aarcange@redhat.com>,
       "David S. Miller" <davem@davemloft.net>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, Troels Liebe Bentsen <tlb@rapanden.dk>,
       linux-bluetooth@vger.kernel.org
Subject: Re: [PATCH] exit: fix oops in sync_mm_rss
Message-Id: <20100330182258.59813fe6.akpm@linux-foundation.org>
In-Reply-To: <20100331094124.43c49290.kamezawa.hiroyu@jp.fujitsu.com>
References: <20100316170808.GA29400@redhat.com>
	<20100330135634.09e6b045.akpm@linux-foundation.org>
	<20100331092815.c8b9d89c.kamezawa.hiroyu@jp.fujitsu.com>
	<20100330173721.cbd442cb.akpm@linux-foundation.org>
	<20100331094124.43c49290.kamezawa.hiroyu@jp.fujitsu.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 31 Mar 2010 09:41:24 +0900 KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:

> > With this fixed, the test for non-zero tsk->mm is't really needed in
> > do_exit(), is it?  I guess it makes sense though - sync_mm_rss() only
> > really works for kernel threads by luck..
> 
> At first, I considered so, too. But I changed my mind to show
> "we know tsk->mm can be NULL here!" by code. 
> Because __sync_mm_rss_stat() has BUG_ON(!mm), the code reader will think
> tsk->mm shouldn't be NULL always.
> 
> Doesn't make sense ?

uh, not really ;)


I think we should do this too:

--- a/mm/memory.c~exit-fix-oops-in-sync_mm_rss-fix
+++ a/mm/memory.c
@@ -131,7 +131,6 @@ static void __sync_task_rss_stat(struct 
 
 	for (i = 0; i < NR_MM_COUNTERS; i++) {
 		if (task->rss_stat.count[i]) {
-			BUG_ON(!mm);
 			add_mm_counter(mm, i, task->rss_stat.count[i]);
 			task->rss_stat.count[i] = 0;
 		}
_

Because we just made sure it can't happen, and if it _does_ happen, the
oops will tell us the samme thing that the BUG_ON() would have.
