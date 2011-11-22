Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754526Ab1KVMsT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 07:48:19 -0500
Received: from cantor2.suse.de ([195.135.220.15]:60938 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751318Ab1KVMsR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 07:48:17 -0500
Date: Tue, 22 Nov 2011 13:48:11 +0100
From: Jan Kara <jack@suse.cz>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Jan Kara <jack@suse.cz>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Christoph Hellwig <hch@lst.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/5] writeback: fix dirtied pages accounting on
 sub-page writes
Message-ID: <20111122124811.GD8058@quack.suse.cz>
References: <20111121130342.211953629@intel.com>
 <20111121131215.905222115@intel.com>
 <20111122001127.GG4017@quack.suse.cz>
 <20111122092110.GB12864@localhost>
 <20111122122157.GB8058@quack.suse.cz>
 <20111122123001.GA16054@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111122123001.GA16054@localhost>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 22-11-11 20:30:01, Wu Fengguang wrote:
> > > @@ -1743,6 +1738,8 @@ void account_page_dirtied(struct page *p
> > >  		__inc_bdi_stat(mapping->backing_dev_info, BDI_DIRTIED);
> > >  		task_dirty_inc(current);
> > >  		task_io_account_write(PAGE_CACHE_SIZE);
> > > +		current->nr_dirtied++;
> > > +		__get_cpu_var(bdp_ratelimits)++;
> >   I think you need preempt_disable() and preempt_enable() pair around
> > __get_cpu_var(). Otherwise a process could get rescheduled in the middle of
> > read-modify-write cycle...
> 
> Hmm, I'm not worried about it at all, because bdp_ratelimits don't
> need to be accurate. In normal cases it won't even trigger one single
> call to balance_dirty_pages().
  I agree regarding the accuracy. But the CPU can change when the process
is scheduled again. So you could modify counter of a CPU you are not
running on. And that can cause bad things...

> btw, account_page_dirtied() is called inside spinlock, will it be
> sufficient?
  Currently it is not enough in real-time kernels and when sleeping
spinlocks work gets merged it won't be enough even in standard kernels...
And in kernels where spinlock means preemption is disabled
preempt_enable/disable will be almost for free...

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
