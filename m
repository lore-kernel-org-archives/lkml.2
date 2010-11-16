Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759320Ab0KPEDD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 23:03:03 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:40449 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756437Ab0KPEDB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 23:03:01 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Tue, 16 Nov 2010 12:57:26 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Greg Thelen <gthelen@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Wu Fengguang <fengguang.wu@intel.com>,
        Minchan Kim <minchan.kim@gmail.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/6] memcg: make throttle_vm_writeout() memcg aware
Message-Id: <20101116125726.db42723c.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <xr93wroixomw.fsf@ninji.mtv.corp.google.com>
References: <1289294671-6865-1-git-send-email-gthelen@google.com>
	<1289294671-6865-4-git-send-email-gthelen@google.com>
	<20101112081754.GE9131@cmpxchg.org>
	<xr93wroixomw.fsf@ninji.mtv.corp.google.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 12 Nov 2010 12:39:35 -0800
Greg Thelen <gthelen@google.com> wrote:

> > Odd branch ordering, but I may be OCDing again.
> >
> > 	if (mem_cgroup && memcg_dirty_info())
> > 		do_mem_cgroup_stuff()
> > 	else
> > 		do_global_stuff()
> >
> > would be more natural, IMO.
> 
> I agree.  I will resubmit this series with your improved branch ordering.
> 

Hmm. I think this patch is troublesome.

This patch will make memcg's pageout routine _not_ throttoled even when the whole
system vmscan's pageout is throttoled.

So, one idea is....

Make this change 
==
+++ b/mm/vmscan.c
@@ -1844,7 +1844,7 @@ static void shrink_zone(int priority, struct zone *zone,
 	if (inactive_anon_is_low(zone, sc))
 		shrink_active_list(SWAP_CLUSTER_MAX, zone, sc, priority, 0);
 
-	throttle_vm_writeout(sc->gfp_mask);
+	throttle_vm_writeout(sc->gfp_mask, sc->mem_cgroup);
 }
==
as

==
	
if (!sc->mem_cgroup || throttle_vm_writeout(sc->gfp_mask, sc->mem_cgroup) == not throttled)
	throttole_vm_writeout(sc->gfp_mask, NULL);

Then, both of memcg and global dirty thresh will be checked.


-Kame

