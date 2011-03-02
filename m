Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757489Ab1CBXSw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 18:18:52 -0500
Received: from mx1.redhat.com ([209.132.183.28]:53487 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754516Ab1CBXSv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 18:18:51 -0500
Date: Wed, 2 Mar 2011 18:17:27 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Greg Thelen <gthelen@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, containers@lists.osdl.org,
        Andrea Righi <arighi@develer.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Minchan Kim <minchan.kim@gmail.com>,
        Ciju Rajan K <ciju@linux.vnet.ibm.com>,
        David Rientjes <rientjes@google.com>,
        Wu Fengguang <fengguang.wu@intel.com>,
        Chad Talbott <ctalbott@google.com>,
        Justin TerAvest <teravest@google.com>
Subject: Re: [PATCH v5 9/9] memcg: check memcg dirty limits in page writeback
Message-ID: <20110302231727.GG2547@redhat.com>
References: <1298669760-26344-1-git-send-email-gthelen@google.com>
 <1298669760-26344-10-git-send-email-gthelen@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1298669760-26344-10-git-send-email-gthelen@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 25, 2011 at 01:36:00PM -0800, Greg Thelen wrote:

[..]
> @@ -500,18 +527,27 @@ static void balance_dirty_pages(struct address_space *mapping,
>  		};
>  
>  		global_dirty_info(&sys_info);
> +		if (!memcg_dirty_info(NULL, &memcg_info))
> +			memcg_info = sys_info;
>  
>  		/*
>  		 * Throttle it only when the background writeback cannot
>  		 * catch-up. This avoids (excessively) small writeouts
>  		 * when the bdi limits are ramping up.
>  		 */
> -		if (dirty_info_reclaimable(&sys_info) + sys_info.nr_writeback <=
> +		if ((dirty_info_reclaimable(&sys_info) +
> +		     sys_info.nr_writeback <=
>  				(sys_info.background_thresh +
> -				 sys_info.dirty_thresh) / 2)
> +				 sys_info.dirty_thresh) / 2) &&
> +		    (dirty_info_reclaimable(&memcg_info) +
> +		     memcg_info.nr_writeback <=
> +				(memcg_info.background_thresh +
> +				 memcg_info.dirty_thresh) / 2))
>  			break;
>  
> -		bdi_thresh = bdi_dirty_limit(bdi, sys_info.dirty_thresh);
> +		bdi_thresh = bdi_dirty_limit(bdi,
> +				min(sys_info.dirty_thresh,
> +				    memcg_info.dirty_thresh));
>  		bdi_thresh = task_dirty_limit(current, bdi_thresh);

Greg, so currently we seem to have per_bdi/per_task dirty limits and
now with this patch it will sort of become per_cgroup/per_bdi/per_task
dirty limits? I think that kind of makes sense to me.

Thanks
Vivek
