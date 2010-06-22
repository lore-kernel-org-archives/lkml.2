Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758901Ab0FVC4L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jun 2010 22:56:11 -0400
Received: from mga11.intel.com ([192.55.52.93]:18798 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753614Ab0FVC4J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jun 2010 22:56:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,457,1272870000"; 
   d="scan'208";a="810156882"
Subject: Re: [PATCH v3 2/2] tmpfs: Make tmpfs scalable with percpu_counter
 for used blocks
From: Tim Chen <tim.c.chen@linux.intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
       Hugh Dickins <hughd@google.com>, yanmin.zhang@intel.com
In-Reply-To: <20100621131802.c2f45c82.akpm@linux-foundation.org>
References: <1276818993.9661.82.camel@schen9-DESK>
	 <20100621131802.c2f45c82.akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 21 Jun 2010 19:52:11 -0700
Message-ID: <1277175131.5150.19.camel@schen9-DESK>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-06-21 at 13:18 -0700, Andrew Morton wrote:
> On Thu, 17 Jun 2010 16:56:33 -0700
> Tim Chen <tim.c.chen@linux.intel.com> wrote:
> 
> > The current implementation of tmpfs is not scalable.
> > We found that stat_lock is contended by multiple threads
> > when we need to get a new page, leading to useless spinning
> > inside this spin lock.  
> > 
> > This patch makes use of the percpu_counter library to maintain local
> > count of used blocks to speed up getting and returning
> > of pages.  So the acquisition of stat_lock is unnecessary
> > for getting and returning blocks, improving the performance 
> > of tmpfs on system with large number of cpus.  On a 4 socket
> > 32 core NHM-EX system, we saw improvement of 270%.
> 
> So it had exactly the same performance as the token-jar approach?
> 

The performance numbers are almost identical, the difference is quite
small (within 1%).

> It'd be good if the changelog were to mention the inaccuracy issues. 
> Describe their impact, if any.

You are talking about the small chance that we may overshoot the limit
a bit? There's a slight chance of race between threads when another
thread allocate the last block after we have read the block count,
thinking that the used blocks are still below limit. There's a small
chance that the same thing happen when we remount.  
> 
> Are you actually happy with this overall approach?
> 
I think qtoken approach can eliminate the small inaccuracy mentioned
above.  However, the inaccuracy will really be quite small and transient
(will go away once we return the used blocks) and will not cause any
problem to tmpfs.  So I'm fine with it.

> >
> > ...
> >
> > @@ -2258,9 +2254,8 @@ static int shmem_remount_fs(struct super_block *sb, int *flags, char *data)
> >  		return error;
> >  
> >  	spin_lock(&sbinfo->stat_lock);
> > -	blocks = sbinfo->max_blocks - sbinfo->free_blocks;
> >  	inodes = sbinfo->max_inodes - sbinfo->free_inodes;
> > -	if (config.max_blocks < blocks)
> > +	if (config.max_blocks < percpu_counter_sum(&sbinfo->used_blocks))
> 
> This could actually use percpu_counter_compare()?
> 

Yeah, using percpu_counter_compare probably is cleaner.

Tim



