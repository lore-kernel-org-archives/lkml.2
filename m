Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754247Ab0DZC5t (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Apr 2010 22:57:49 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:51758 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750798Ab0DZC5r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Apr 2010 22:57:47 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Mon, 26 Apr 2010 11:53:47 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Mel Gorman <mel@csn.ul.ie>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "minchan.kim@gmail.com" <minchan.kim@gmail.com>,
       Christoph Lameter <cl@linux.com>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [BUGFIX][mm][PATCH] fix migration race in rmap_walk
Message-Id: <20100426115347.2ee2a917.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20100426084901.15c09a29.kamezawa.hiroyu@jp.fujitsu.com>
References: <20100423120148.9ffa5881.kamezawa.hiroyu@jp.fujitsu.com>
	<20100423095922.GJ30306@csn.ul.ie>
	<20100423155801.GA14351@csn.ul.ie>
	<20100424110200.b491ec5f.kamezawa.hiroyu@jp.fujitsu.com>
	<20100424104324.GD14351@csn.ul.ie>
	<20100426084901.15c09a29.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 Apr 2010 08:49:01 +0900
KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:

> On Sat, 24 Apr 2010 11:43:24 +0100
> Mel Gorman <mel@csn.ul.ie> wrote:

> > It looks nice but it still broke after 28 hours of running. The
> > seq-counter is still insufficient to catch all changes that are made to
> > the list. I'm beginning to wonder if a) this really can be fully safely
> > locked with the anon_vma changes and b) if it has to be a spinlock to
> > catch the majority of cases but still a lazy cleanup if there happens to
> > be a race. It's unsatisfactory and I'm expecting I'll either have some
> > insight to the new anon_vma changes that allow it to be locked or Rik
> > knows how to restore the original behaviour which as Andrea pointed out
> > was safe.
> > 
> Ouch. Hmm, how about the race in fork() I pointed out ?
> 
Forget this. Sorry for noise.

==
This is a memo for myself.

*) at fork, when copying a vma for file, vma_prio_tree_add() is called
   before copying page tables.
   There are several patterns.

Assume tasks named as t1,t2,t3,t4,t5 and their own vmas v1,v2,v3,v4,v5 which map
a range in address spaces.

(a) t1 forks t2.
   v1 is in prio_tree, v2 for t2 will be pointed by ->head pointer.

   \
    v1  --(head)---> v2 
   /  \
  ?    ?

  vma_prio_tree_foreach() order : v1->v2.


(b) after (a), t2 forks t3. (list_add() is used.)
 
    \
     v1 --(head)--> v2 ->(list.next)->v3
    /  \
   ?    ?

   vma_prio_tree_foreach() order : v1->v2->v3

(c) after (b), t1 forks t4.

    \
     v1 --(head)--> v2 ->(list.next)->v3->v4
    /  \              
   ?    ?

    vma_prio_tree_foreach() order : v1->v2->v3->v4

(d) after (c), t4 forks t5.

    \
     v1 --(head)--> v2 ->(list.next)->v3->v4->v5
    /  \               
   ?    ?
    vma_prio_tree_foreach() order : v1->v2->v3->v4->v5

(e) after (c), t3 forks t5.
    \
     v1 --(head)--> v2 ->(list.next)->v3->v5->v4-
    /  \               
   ?    ?
    vma_prio_tree_foreach() order : v1->v2->v3->v5->v4

.....in any case, it seems vma_prio_tree_foreach() finds
the parent's vma 1st.

Thx,
-Kame















