Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752578Ab0GAIAx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 04:00:53 -0400
Received: from cantor2.suse.de ([195.135.220.15]:42414 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752383Ab0GAIAv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 04:00:51 -0400
Date: Thu, 1 Jul 2010 18:00:43 +1000
From: Nick Piggin <npiggin@suse.de>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       John Stultz <johnstul@us.ibm.com>, Frank Mayhar <fmayhar@google.com>
Subject: Re: [patch 44/52] fs: icache per-CPU sb inode lists and locks
Message-ID: <20100701080043.GE22976@laptop>
References: <20100624030212.676457061@suse.de>
 <20100624030732.702284052@suse.de>
 <20100630092641.GI24712@dastard>
 <20100630120850.GE21358@laptop>
 <20100701031200.GS24712@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100701031200.GS24712@dastard>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 01, 2010 at 01:12:00PM +1000, Dave Chinner wrote:
> On Wed, Jun 30, 2010 at 10:08:50PM +1000, Nick Piggin wrote:
> > > I can't say that I'm a great fan of hiding loop context in defines
> > > like this. It reminds far too much of how parts of Irix slowly
> > > ossified because they ended up mess of complex, fragile macros that
> > > nobody fully understood...
> > 
> > It's not perfect. I think it is a lot better than open coding
> > (which I tried before) because that really muddies up the intention
> > of the loop body.
> 
> Something like this doesn't seem particularly bad:
> 
> static inline struct list_head *
> inode_get_sb_list(struct super_block *sb, int *i)
> {
> 	int cpu;
> 
> 	cpu = cpumask_next(i, cpu_possible_mask);
> 	if (cpu >= nr_cpu_ids)
> 		return NULL;
> 	*i = cpu;
> #ifdef CONFIG_SMP
> 	return per_cpu_ptr(sb->s_inodes, cpu);
> #else
> 	return &sb->s_inodes;
> #endif
> }
> 
> and:
> 
> 	struct list_head *list;
> 	int i;
> ....
> 	i = -1;
> 	while ((list = inode_get_sb_list(sb, &i))) {
> 		list_for_each_entry_rcu(inode, tmp, list, i_sb_list) {
> 			.....
> 		}
> 	}
> 
> I'd much prefer this to hiding the outer loop in macros...

I don't see it as an improvement. A macro called
inode_sb_list_for_each_entry is rather obvious and idiomatic as to what
it does. You don't need to look at the implementation if you just need
to walk the inode sb list.

