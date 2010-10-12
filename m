Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756155Ab0JLDsU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Oct 2010 23:48:20 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:32871 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755091Ab0JLDsT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Oct 2010 23:48:19 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Tue, 12 Oct 2010 12:42:53 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: balbir@linux.vnet.ibm.com
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Minchan Kim <minchan.kim@gmail.com>, Greg Thelen <gthelen@google.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        containers@lists.osdl.org, Andrea Righi <arighi@develer.com>
Subject: Re: [PATCH v2] memcg: reduce lock time at move charge (Was Re:
 [PATCH 04/10] memcg: disable local interrupts in lock_page_cgroup()
Message-Id: <20101012124253.3ccf13fb.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20101012033915.GA25875@balbir.in.ibm.com>
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
	<20101012033915.GA25875@balbir.in.ibm.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 12 Oct 2010 09:09:15 +0530
Balbir Singh <balbir@linux.vnet.ibm.com> wrote:

> * KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> [2010-10-08 19:41:31]:
> 
> > On Fri, 8 Oct 2010 14:12:01 +0900
> > KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> > > > Sure.  It walks the same data three times, potentially causing
> > > > thrashing in the L1 cache.
> > > 
> > > Hmm, make this 2 times, at least.
> > > 
> > How about this ?
> > ==
> > From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> > 
> > Presently, at task migration among cgroups, memory cgroup scans page tables and
> > moves accounting if flags are properly set.
> > 
> > 
> > The core code, mem_cgroup_move_charge_pte_range() does
> > 
> >  	pte_offset_map_lock();
> > 	for all ptes in a page table:
> > 		1. look into page table, find_and_get a page
> > 		2. remove it from LRU.
> > 		3. move charge.
> > 		4. putback to LRU. put_page()
> > 	pte_offset_map_unlock();
> > 
> > for pte entries on a 3rd level? page table.
> > 
> > As a planned updates, we'll support dirty-page accounting. Because move_charge()
> > is highly race, we need to add more check in move_charge.
> > For example, lock_page();-> wait_on_page_writeback();-> unlock_page();
> > is an candidate for new check.
> >
> 
> 
> Is this a change to help dirty limits or is it a generic bug fix.
>  
Not a bug fix. This for adding lock_page() to moge_charge(). It helps us
to remove "irq disable" in update_stat().


Thanks,
-Kame


