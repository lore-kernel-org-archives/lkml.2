Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752275Ab0JHFRb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 01:17:31 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:41615 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750960Ab0JHFRa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 01:17:30 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Fri, 8 Oct 2010 14:12:01 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Minchan Kim <minchan.kim@gmail.com>, Greg Thelen <gthelen@google.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        containers@lists.osdl.org, Andrea Righi <arighi@develer.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>
Subject: Re: [PATCH v2] memcg: reduce lock time at move charge (Was Re:
 [PATCH 04/10] memcg: disable local interrupts in lock_page_cgroup()
Message-Id: <20101008141201.c1e3a4e2.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20101007215556.21412ae6.akpm@linux-foundation.org>
References: <1286175485-30643-1-git-send-email-gthelen@google.com>
	<1286175485-30643-5-git-send-email-gthelen@google.com>
	<20101005160332.GB9515@barrios-desktop>
	<xr93wrpwkypv.fsf@ninji.mtv.corp.google.com>
	<AANLkTikKXNx-Cj2UY+tJj8ifC+Je5WDbS=eR6xsKM1uU@mail.gmail.com>
	<20101007093545.429fe04a.kamezawa.hiroyu@jp.fujitsu.com>
	<20101007105456.d86d8092.nishimura@mxp.nes.nec.co.jp>
	<20101007111743.322c3993.kamezawa.hiroyu@jp.fujitsu.com>
	<20101007152111.df687a62.kamezawa.hiroyu@jp.fujitsu.com>
	<20101007162811.c3a35be9.nishimura@mxp.nes.nec.co.jp>
	<20101007164204.83b207c6.kamezawa.hiroyu@jp.fujitsu.com>
	<20101007170405.27ed964c.kamezawa.hiroyu@jp.fujitsu.com>
	<20101007161454.84570cf9.akpm@linux-foundation.org>
	<20101008133712.2a836331.kamezawa.hiroyu@jp.fujitsu.com>
	<20101007215556.21412ae6.akpm@linux-foundation.org>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 7 Oct 2010 21:55:56 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> On Fri, 8 Oct 2010 13:37:12 +0900 KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> 
> > On Thu, 7 Oct 2010 16:14:54 -0700
> > Andrew Morton <akpm@linux-foundation.org> wrote:
> > 
> > > On Thu, 7 Oct 2010 17:04:05 +0900
> > > KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> > > 
> > > > Now, at task migration among cgroup, memory cgroup scans page table and moving
> > > > account if flags are properly set.
> > > > 
> > > > The core code, mem_cgroup_move_charge_pte_range() does
> > > > 
> > > >  	pte_offset_map_lock();
> > > > 	for all ptes in a page table:
> > > > 		1. look into page table, find_and_get a page
> > > > 		2. remove it from LRU.
> > > > 		3. move charge.
> > > > 		4. putback to LRU. put_page()
> > > > 	pte_offset_map_unlock();
> > > > 
> > > > for pte entries on a 3rd level? page table.
> > > > 
> > > > This pte_offset_map_lock seems a bit long. This patch modifies a rountine as
> > > > 
> > > > 	for 32 pages: pte_offset_map_lock()
> > > > 		      find_and_get a page
> > > > 		      record it
> > > > 		      pte_offset_map_unlock()
> > > > 	for all recorded pages
> > > > 		      isolate it from LRU.
> > > > 		      move charge
> > > > 		      putback to LRU
> > > > 	for all recorded pages
> > > > 		      put_page()
> > > 
> > > The patch makes the code larger, more complex and slower!
> > > 
> > 
> > Slower ?
> 
> Sure.  It walks the same data three times, potentially causing
> thrashing in the L1 cache.

Hmm, make this 2 times, at least.

> It takes and releases locks at a higher frequency.  It increases the text size.
> 

But I don't think page_table_lock is a lock which someone can hold so long
that
	1. find_get_page
	2. spin_lock(zone->lock)
		3. remove it from LRU
	4. lock_page_cgroup()
	5. move charge (This means page 
	5. putback to LRU
for 4096/8=1024 pages long.

will try to make the routine smarter.

But I want to get rid of page_table_lock -> lock_page_cgroup().

Thanks,
-Kame


