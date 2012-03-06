Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031553Ab2CFWyy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 17:54:54 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:42863 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932377Ab2CFWyw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 17:54:52 -0500
Date: Tue, 6 Mar 2012 14:54:51 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Mel Gorman <mgorman@suse.de>
Cc: David Rientjes <rientjes@google.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Christoph Lameter <cl@linux.com>, Miao Xie <miaox@cn.fujitsu.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cpuset: mm: Reduce large amounts of memory barrier
 related damage v2
Message-Id: <20120306145451.8eff82a6.akpm@linux-foundation.org>
In-Reply-To: <20120306224201.GA17697@suse.de>
References: <20120306132735.GA2855@suse.de>
	<20120306122657.8e5b128d.akpm@linux-foundation.org>
	<20120306224201.GA17697@suse.de>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 6 Mar 2012 22:42:01 +0000
Mel Gorman <mgorman@suse.de> wrote:

> /*
>  * get_mems_allowed is required when making decisions involving mems_allowed
>  * such as during page allocation. mems_allowed can be updated in parallel
>  * and depending on the new value an operation can fail potentially causing
>  * process failure. A retry loop with get_mems_allowed and put_mems_allowed
>  * prevents these artificial failures.
>  */
> static inline unsigned int get_mems_allowed(void)
> {
>         return read_seqcount_begin(&current->mems_allowed_seq);
> }
> 
> /*
>  * If this returns false, the operation that took place after get_mems_allowed
>  * may have failed. It is up to the caller to retry the operation if
>  * appropriate.
>  */
> static inline bool put_mems_allowed(unsigned int seq)
> {
>         return !read_seqcount_retry(&current->mems_allowed_seq, seq);
> }
> 
> ?

lgtm ;)

> > > -static inline void put_mems_allowed(void)
> > > +/*
> > > + * If this returns false, the operation that took place after get_mems_allowed
> > > + * may have failed. It is up to the caller to retry the operation if
> > > + * appropriate
> > > + */
> > > +static inline bool put_mems_allowed(unsigned int seq)
> > >  {
> > > -	/*
> > > -	 * ensure that reading mems_allowed and mempolicy before reducing
> > > -	 * mems_allowed_change_disable.
> > > -	 *
> > > -	 * the write-side task will know that the read-side task is still
> > > -	 * reading mems_allowed or mempolicy, don't clears old bits in the
> > > -	 * nodemask.
> > > -	 */
> > > -	smp_mb();
> > > -	--ACCESS_ONCE(current->mems_allowed_change_disable);
> > > +	return !read_seqcount_retry(&current->mems_allowed_seq, seq);
> > >  }
> > >  
> > >  static inline void set_mems_allowed(nodemask_t nodemask)
> > 
> > How come set_mems_allowed() still uses task_lock()?
> >
> 
> Consistency.
> 
> The task_lock is taken by kernel/cpuset.c when updating
> mems_allowed so it is taken here. That said, it is unnecessary to take
> as the two places where set_mems_allowed is used are not going to be
> racing. In the unlikely event that set_mems_allowed() gets another user,
> there is no harm is leaving the task_lock as it is. It's not in a hot
> path of any description.

But shouldn't set_mems_allowed() bump mems_allowed_seq?
