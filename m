Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932379Ab1FGTkB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 15:40:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37687 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758425Ab1FGTj6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 15:39:58 -0400
Date: Tue, 7 Jun 2011 15:38:35 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Greg Thelen <gthelen@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, containers@lists.osdl.org,
        linux-fsdevel@vger.kernel.org, Andrea Righi <arighi@develer.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Minchan Kim <minchan.kim@gmail.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Ciju Rajan K <ciju@linux.vnet.ibm.com>,
        David Rientjes <rientjes@google.com>,
        Wu Fengguang <fengguang.wu@intel.com>,
        Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v8 11/12] writeback: make background writeback cgroup
 aware
Message-ID: <20110607193835.GD26965@redhat.com>
References: <1307117538-14317-1-git-send-email-gthelen@google.com>
 <1307117538-14317-12-git-send-email-gthelen@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1307117538-14317-12-git-send-email-gthelen@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 03, 2011 at 09:12:17AM -0700, Greg Thelen wrote:
> When the system is under background dirty memory threshold but a cgroup
> is over its background dirty memory threshold, then only writeback
> inodes associated with the over-limit cgroup(s).
> 

[..]
> -static inline bool over_bground_thresh(void)
> +static inline bool over_bground_thresh(struct bdi_writeback *wb,
> +				       struct writeback_control *wbc)
>  {
>  	unsigned long background_thresh, dirty_thresh;
>  
>  	global_dirty_limits(&background_thresh, &dirty_thresh);
>  
> -	return (global_page_state(NR_FILE_DIRTY) +
> -		global_page_state(NR_UNSTABLE_NFS) > background_thresh);
> +	if (global_page_state(NR_FILE_DIRTY) +
> +	    global_page_state(NR_UNSTABLE_NFS) > background_thresh) {
> +		wbc->for_cgroup = 0;
> +		return true;
> +	}
> +
> +	wbc->for_cgroup = 1;
> +	wbc->shared_inodes = 1;
> +	return mem_cgroups_over_bground_dirty_thresh();
>  }

Hi Greg,

So all the logic of writeout from mem cgroup works only if system is
below background limit. The moment we cross background limit, looks
like we will fall back to existing way of writting inodes?

This kind of cgroup writeback I think will atleast not solve the problem
for CFQ IO controller, as we fall back to old ways of writting back inodes
the moment we cross dirty ratio.

Also have you done any benchmarking regarding what's the overhead of
going through say thousands of inodes to find the inode which is eligible
for writeback from a cgroup? I think Dave Chinner had raised this concern
in the past.

Thanks
Vivek
