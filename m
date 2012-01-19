Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757367Ab2ASEFQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 23:05:16 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:57962 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757253Ab2ASEFO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 23:05:14 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Thu, 19 Jan 2012 13:03:53 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Hugh Dickins <hughd@google.com>
Cc: Sasha Levin <levinsasha928@gmail.com>, hannes <hannes@cmpxchg.org>,
        mhocko@suse.cz, bsingharora@gmail.com, Dave Jones <davej@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>, cgroups@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [BUG] kernel BUG at mm/memcontrol.c:1074!
Message-Id: <20120119130353.0ca97435.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <alpine.LSU.2.00.1201181932040.2287@eggly.anvils>
References: <1326949826.5016.5.camel@lappy>
	<20120119122354.66eb9820.kamezawa.hiroyu@jp.fujitsu.com>
	<alpine.LSU.2.00.1201181932040.2287@eggly.anvils>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 Jan 2012 19:41:44 -0800 (PST)
Hugh Dickins <hughd@google.com> wrote:

> On Thu, 19 Jan 2012, KAMEZAWA Hiroyuki wrote:
> > On Thu, 19 Jan 2012 07:10:26 +0200
> > Sasha Levin <levinsasha928@gmail.com> wrote:
> > 
> > > Hi all,
> > > 
> > > During testing, I have triggered the OOM killer by mmap()ing a large block of memory. The OOM kicked in and tried to kill the process:
> > > 
> > 
> > two questions.
> > 
> > 1. What is the kernel version  ?
> 
> It says 3.2.0-next-20120119-sasha #128
> 
> > 2. are you using memcg moutned ?
> 
> I notice that, unlike Linus's git, this linux-next still has
> mm-isolate-pages-for-immediate-reclaim-on-their-own-lru.patch in.
> 
> I think that was well capable of oopsing in mem_cgroup_lru_del_list(),
> since it didn't always know which lru a page belongs to.
> 
> I'm going to be optimistic and assume that was the cause.
> 
Hmm, because the log hits !memcg at lru "del", the page should be added
to LRU somewhere and the lru must be determined by pc->mem_cgroup.

Once set, pc->mem_cgroup is not cleared, just overwritten. AFAIK, there is
only one chance to set pc->mem_cgroup as NULL... initalization.
I wonder why it hits lru_del() rather than lru_add()...
................

Ahhhh, ok, it seems you are right. the patch has following kinds of codes
==
+static void pagevec_putback_immediate_fn(struct page *page, void *arg)
+{
+       struct zone *zone = page_zone(page);
+
+       if (PageLRU(page)) {
+               enum lru_list lru = page_lru(page);
+               list_move(&page->lru, &zone->lru[lru].list);
+       }
+}
==
..this will bypass mem_cgroup_lru_add(), and we can see bug in lru_del()
rather than lru_add()..

Another question is who pushes pages to LRU before setting pc->mem_cgroup..
Anyway, I think we need to fix memcg to be LRU_IMMEDIATE aware.

Thanks,
-Kmae




