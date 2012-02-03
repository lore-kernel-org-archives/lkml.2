Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756530Ab2BCNsd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Feb 2012 08:48:33 -0500
Received: from mga14.intel.com ([143.182.124.37]:47210 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756486Ab2BCNsc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Feb 2012 08:48:32 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="102884088"
Date: Fri, 3 Feb 2012 21:38:23 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Amit Sahrawat <amit.sahrawat83@gmail.com>
Cc: Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Johannes Weiner <jweiner@redhat.com>,
        Amit Sahrawat <a.sahrawat@samsung.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] mm: make do_writepages() use plugging
Message-ID: <20120203133823.GB17571@localhost>
References: <1328275626-5322-1-git-send-email-amit.sahrawat83@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1328275626-5322-1-git-send-email-amit.sahrawat83@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 03, 2012 at 06:57:06PM +0530, Amit Sahrawat wrote:
> This will cover all the invocations for writepages to be called with
> plugging support.
 
Thanks.  I'll test it on the major filesystems. But would you
name a few filesystems that are expected to benefit from it?
It's not obvious because some FS ->writepages eventually calls
generic_writepages() which already does plugging.

Thanks,
Fengguang

> Signed-off-by: Amit Sahrawat <a.sahrawat@samsung.com>
> ---
>  mm/page-writeback.c |    4 ++++
>  1 files changed, 4 insertions(+), 0 deletions(-)
> 
> diff --git a/mm/page-writeback.c b/mm/page-writeback.c
> index 363ba70..2bea32c 100644
> --- a/mm/page-writeback.c
> +++ b/mm/page-writeback.c
> @@ -1866,14 +1866,18 @@ EXPORT_SYMBOL(generic_writepages);
>  
>  int do_writepages(struct address_space *mapping, struct writeback_control *wbc)
>  {
> +	struct blk_plug plug;
>  	int ret;
>  
>  	if (wbc->nr_to_write <= 0)
>  		return 0;
> +
> +	blk_start_plug(&plug);
>  	if (mapping->a_ops->writepages)
>  		ret = mapping->a_ops->writepages(mapping, wbc);
>  	else
>  		ret = generic_writepages(mapping, wbc);
> +	blk_finish_plug(&plug);
>  	return ret;
>  }
>  
> -- 
> 1.7.2.3
