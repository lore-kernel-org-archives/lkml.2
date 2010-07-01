Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753074Ab0GADN3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 23:13:29 -0400
Received: from bld-mail19.adl2.internode.on.net ([150.101.137.104]:56823 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751651Ab0GADN1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 23:13:27 -0400
Date: Thu, 1 Jul 2010 13:12:00 +1000
From: Dave Chinner <david@fromorbit.com>
To: Nick Piggin <npiggin@suse.de>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       John Stultz <johnstul@us.ibm.com>, Frank Mayhar <fmayhar@google.com>
Subject: Re: [patch 44/52] fs: icache per-CPU sb inode lists and locks
Message-ID: <20100701031200.GS24712@dastard>
References: <20100624030212.676457061@suse.de>
 <20100624030732.702284052@suse.de>
 <20100630092641.GI24712@dastard>
 <20100630120850.GE21358@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100630120850.GE21358@laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 30, 2010 at 10:08:50PM +1000, Nick Piggin wrote:
> On Wed, Jun 30, 2010 at 07:26:41PM +1000, Dave Chinner wrote:
> > On Thu, Jun 24, 2010 at 01:02:56PM +1000, npiggin@suse.de wrote:
> > > Signed-off-by: Nick Piggin <npiggin@suse.de>
> > .....
> > > @@ -2194,6 +2198,58 @@ static inline void insert_inode_hash(str
> > >  
> > >  extern void file_sb_list_add(struct file *f, struct super_block *sb);
> > >  extern void file_sb_list_del(struct file *f);
> > > +#ifdef CONFIG_SMP
> > > +
> > > +/*
> > > + * These macros iterate all inodes on all CPUs for a given superblock.
> > > + * rcu_read_lock must be held.
> > > + */
> > > +#define do_inode_list_for_each_entry_rcu(__sb, __inode)		\
> > > +{								\
> > > +	int i;							\
> > > +	for_each_possible_cpu(i) {				\
> > > +		struct list_head *list;				\
> > > +		list = per_cpu_ptr((__sb)->s_inodes, i);	\
> > > +		list_for_each_entry_rcu((__inode), list, i_sb_list)
> > > +
> > > +#define while_inode_list_for_each_entry_rcu			\
> > > +	}							\
> > > +}
> > > +
> > > +#define do_inode_list_for_each_entry_safe(__sb, __inode, __tmp)	\
> > > +{								\
> > > +	int i;							\
> > > +	for_each_possible_cpu(i) {				\
> > > +		struct list_head *list;				\
> > > +		list = per_cpu_ptr((__sb)->s_inodes, i);	\
> > > +		list_for_each_entry_safe((__inode), (__tmp), list, i_sb_list)
> > > +
> > > +#define while_inode_list_for_each_entry_safe			\
> > > +	}							\
> > > +}
> > > +
> > > +#else
> > > +
> > > +#define do_inode_list_for_each_entry_rcu(__sb, __inode)		\
> > > +{								\
> > > +	struct list_head *list;					\
> > > +	list = &(sb)->s_inodes;					\
> > > +	list_for_each_entry_rcu((__inode), list, i_sb_list)
> > > +
> > > +#define while_inode_list_for_each_entry_rcu			\
> > > +}
> > > +
> > > +#define do_inode_list_for_each_entry_safe(__sb, __inode, __tmp)	\
> > > +{								\
> > > +	struct list_head *list;					\
> > > +	list = &(sb)->s_inodes;					\
> > > +	list_for_each_entry_rcu((__inode), (__tmp), list, i_sb_list)
> > > +
> > > +#define while_inode_list_for_each_entry_safe			\
> > > +}
> > 
> > I can't say that I'm a great fan of hiding loop context in defines
> > like this. It reminds far too much of how parts of Irix slowly
> > ossified because they ended up mess of complex, fragile macros that
> > nobody fully understood...
> 
> It's not perfect. I think it is a lot better than open coding
> (which I tried before) because that really muddies up the intention
> of the loop body.

Something like this doesn't seem particularly bad:

static inline struct list_head *
inode_get_sb_list(struct super_block *sb, int *i)
{
	int cpu;

	cpu = cpumask_next(i, cpu_possible_mask);
	if (cpu >= nr_cpu_ids)
		return NULL;
	*i = cpu;
#ifdef CONFIG_SMP
	return per_cpu_ptr(sb->s_inodes, cpu);
#else
	return &sb->s_inodes;
#endif
}

and:

	struct list_head *list;
	int i;
....
	i = -1;
	while ((list = inode_get_sb_list(sb, &i))) {
		list_for_each_entry_rcu(inode, tmp, list, i_sb_list) {
			.....
		}
	}

I'd much prefer this to hiding the outer loop in macros...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
