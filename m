Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754755Ab0JGXPu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Oct 2010 19:15:50 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51688 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754602Ab0JGXPt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Oct 2010 19:15:49 -0400
Date: Thu, 7 Oct 2010 16:14:54 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Minchan Kim <minchan.kim@gmail.com>, Greg Thelen <gthelen@google.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        containers@lists.osdl.org, Andrea Righi <arighi@develer.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>
Subject: Re: [PATCH v2] memcg: reduce lock time at move charge (Was Re:
 [PATCH 04/10] memcg: disable local interrupts in lock_page_cgroup()
Message-Id: <20101007161454.84570cf9.akpm@linux-foundation.org>
In-Reply-To: <20101007170405.27ed964c.kamezawa.hiroyu@jp.fujitsu.com>
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
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 7 Oct 2010 17:04:05 +0900
KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:

> Now, at task migration among cgroup, memory cgroup scans page table and moving
> account if flags are properly set.
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
> This pte_offset_map_lock seems a bit long. This patch modifies a rountine as
> 
> 	for 32 pages: pte_offset_map_lock()
> 		      find_and_get a page
> 		      record it
> 		      pte_offset_map_unlock()
> 	for all recorded pages
> 		      isolate it from LRU.
> 		      move charge
> 		      putback to LRU
> 	for all recorded pages
> 		      put_page()

The patch makes the code larger, more complex and slower!

I do think we're owed a more complete description of its benefits than
"seems a bit long".  Have problems been observed?  Any measurements
taken?


