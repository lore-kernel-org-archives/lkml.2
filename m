Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755806Ab0JLDjX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Oct 2010 23:39:23 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:33707 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754337Ab0JLDjW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Oct 2010 23:39:22 -0400
Date: Tue, 12 Oct 2010 09:09:15 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Minchan Kim <minchan.kim@gmail.com>, Greg Thelen <gthelen@google.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        containers@lists.osdl.org, Andrea Righi <arighi@develer.com>
Subject: Re: [PATCH v2] memcg: reduce lock time at move charge (Was Re:
 [PATCH 04/10] memcg: disable local interrupts in lock_page_cgroup()
Message-ID: <20101012033915.GA25875@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <20101007111743.322c3993.kamezawa.hiroyu@jp.fujitsu.com>
 <20101007152111.df687a62.kamezawa.hiroyu@jp.fujitsu.com>
 <20101007162811.c3a35be9.nishimura@mxp.nes.nec.co.jp>
 <20101007164204.83b207c6.kamezawa.hiroyu@jp.fujitsu.com>
 <20101007170405.27ed964c.kamezawa.hiroyu@jp.fujitsu.com>
 <20101007161454.84570cf9.akpm@linux-foundation.org>
 <20101008133712.2a836331.kamezawa.hiroyu@jp.fujitsu.com>
 <20101007215556.21412ae6.akpm@linux-foundation.org>
 <20101008141201.c1e3a4e2.kamezawa.hiroyu@jp.fujitsu.com>
 <20101008194131.20b44a9d.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20101008194131.20b44a9d.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> [2010-10-08 19:41:31]:

> On Fri, 8 Oct 2010 14:12:01 +0900
> KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> > > Sure.  It walks the same data three times, potentially causing
> > > thrashing in the L1 cache.
> > 
> > Hmm, make this 2 times, at least.
> > 
> How about this ?
> ==
> From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> 
> Presently, at task migration among cgroups, memory cgroup scans page tables and
> moves accounting if flags are properly set.
> 
> 
> The core code, mem_cgroup_move_charge_pte_range() does
> 
>  	pte_offset_map_lock();
> 	for all ptes in a page table:
> 		1. look into page table, find_and_get a page
> 		2. remove it from LRU.
> 		3. move charge.
> 		4. putback to LRU. put_page()
> 	pte_offset_map_unlock();
> 
> for pte entries on a 3rd level? page table.
> 
> As a planned updates, we'll support dirty-page accounting. Because move_charge()
> is highly race, we need to add more check in move_charge.
> For example, lock_page();-> wait_on_page_writeback();-> unlock_page();
> is an candidate for new check.
>


Is this a change to help dirty limits or is it a generic bug fix.
 
-- 
	Three Cheers,
	Balbir
