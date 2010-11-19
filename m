Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753410Ab0KSLRO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 06:17:14 -0500
Received: from zene.cmpxchg.org ([85.214.230.12]:60164 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752854Ab0KSLRN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 06:17:13 -0500
Date: Fri, 19 Nov 2010 12:16:52 +0100
From: Johannes Weiner <hannes@cmpxchg.org>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Greg Thelen <gthelen@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Wu Fengguang <fengguang.wu@intel.com>,
        Minchan Kim <minchan.kim@gmail.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/6] memcg: make throttle_vm_writeout() memcg aware
Message-ID: <20101119111652.GB24635@cmpxchg.org>
References: <1289294671-6865-1-git-send-email-gthelen@google.com>
 <1289294671-6865-4-git-send-email-gthelen@google.com>
 <20101112081754.GE9131@cmpxchg.org>
 <xr93wroixomw.fsf@ninji.mtv.corp.google.com>
 <20101116125726.db42723c.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101116125726.db42723c.kamezawa.hiroyu@jp.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Tue, Nov 16, 2010 at 12:57:26PM +0900, KAMEZAWA Hiroyuki wrote:
> Hmm. I think this patch is troublesome.
> 
> This patch will make memcg's pageout routine _not_ throttoled even when the whole
> system vmscan's pageout is throttoled.
> 
> So, one idea is....
> 
> Make this change 
> ==
> +++ b/mm/vmscan.c
> @@ -1844,7 +1844,7 @@ static void shrink_zone(int priority, struct zone *zone,
>  	if (inactive_anon_is_low(zone, sc))
>  		shrink_active_list(SWAP_CLUSTER_MAX, zone, sc, priority, 0);
>  
> -	throttle_vm_writeout(sc->gfp_mask);
> +	throttle_vm_writeout(sc->gfp_mask, sc->mem_cgroup);
>  }
> ==
> as
> 
> ==
> 	
> if (!sc->mem_cgroup || throttle_vm_writeout(sc->gfp_mask, sc->mem_cgroup) == not throttled)
> 	throttole_vm_writeout(sc->gfp_mask, NULL);
> 
> Then, both of memcg and global dirty thresh will be checked.

Good point, both limits should apply.

I'd prefer to stuff it all into throttle_vm_writeout() and not encode
memcg-specific behaviour into the caller, though.
