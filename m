Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933142Ab1IBCxA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Sep 2011 22:53:00 -0400
Received: from mga14.intel.com ([143.182.124.37]:25874 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933071Ab1IBCw6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Sep 2011 22:52:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,316,1312182000"; 
   d="scan'208";a="44916797"
Date: Fri, 2 Sep 2011 10:52:55 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Jan Kara <jack@suse.cz>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Dave Chinner <david@fromorbit.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] writeback: fix BDI_WRITTEN accounting disturbing
 bdi->completions
Message-ID: <20110902025255.GA28584@localhost>
References: <20110901144041.GA5681@localhost>
 <20110901162950.GD2070@quack.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110901162950.GD2070@quack.suse.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 02, 2011 at 12:29:50AM +0800, Jan Kara wrote:
> On Thu 01-09-11 22:40:41, Wu Fengguang wrote:
> > Peter,
> > 
> > This is an amazing bug. I'm not sure how the accounting goes wrong in
> > some tricky way. But you can compare the exact bdi proportions pattern
> > before/after patch. The gray "bdi setpoint" lines are vastly different.
> > 
> > ---
> > When increasing BDI_WRITTEN together with bdi->completions inside the
> > same local irq disabling block, bdi_thresh is found to go wild in the
> > 1 disk + 1 usb stick writeback test case. Fix it by moving BDI_WRITTEN
> > accounting out.
>   I don't understand this - the patch is just NOP. The change in
> test_clear_page_writeback() does absolutely nothing and the change in
> bdi_writeout_inc() just changes:
>   	local_irq_save(flags);
>   	__inc_bdi_stat(bdi);
>   	__prop_inc_percpu_max(&vm_completions, &bdi->completions,
>   			      bdi->max_prop_frac);
>   	local_irq_restore(flags);
> 
> to:
>   	local_irq_save(flags);
>   	__inc_bdi_stat(bdi);
>   	local_irq_restore(flags);
>   	local_irq_save(flags);
>   	__prop_inc_percpu_max(&vm_completions, &bdi->completions,
>   			      bdi->max_prop_frac);
>   	local_irq_restore(flags);
> 
> So the difference must be in something else...

Yes you are right -- this patch is basically a NOP. I retried without
this patch and it's now working fine again. Something mysterious to
catch..

Thanks,
Fengguang
