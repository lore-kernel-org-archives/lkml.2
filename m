Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754840Ab1KVMaJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 07:30:09 -0500
Received: from mga14.intel.com ([143.182.124.37]:26959 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750851Ab1KVMaI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 07:30:08 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,552,1315206000"; 
   d="scan'208";a="77935006"
Date: Tue, 22 Nov 2011 20:30:01 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Jan Kara <jack@suse.cz>
Cc: "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Christoph Hellwig <hch@lst.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/5] writeback: fix dirtied pages accounting on
 sub-page writes
Message-ID: <20111122123001.GA16054@localhost>
References: <20111121130342.211953629@intel.com>
 <20111121131215.905222115@intel.com>
 <20111122001127.GG4017@quack.suse.cz>
 <20111122092110.GB12864@localhost>
 <20111122122157.GB8058@quack.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111122122157.GB8058@quack.suse.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > @@ -1743,6 +1738,8 @@ void account_page_dirtied(struct page *p
> >  		__inc_bdi_stat(mapping->backing_dev_info, BDI_DIRTIED);
> >  		task_dirty_inc(current);
> >  		task_io_account_write(PAGE_CACHE_SIZE);
> > +		current->nr_dirtied++;
> > +		__get_cpu_var(bdp_ratelimits)++;
>   I think you need preempt_disable() and preempt_enable() pair around
> __get_cpu_var(). Otherwise a process could get rescheduled in the middle of
> read-modify-write cycle...

Hmm, I'm not worried about it at all, because bdp_ratelimits don't
need to be accurate. In normal cases it won't even trigger one single
call to balance_dirty_pages().

btw, account_page_dirtied() is called inside spinlock, will it be
sufficient?

Thanks,
Fengguang
