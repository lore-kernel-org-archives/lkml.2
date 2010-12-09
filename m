Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932196Ab0LICiE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 21:38:04 -0500
Received: from mx1.redhat.com ([209.132.183.28]:3054 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756293Ab0LICiB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 21:38:01 -0500
Date: Wed, 8 Dec 2010 21:37:58 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Oleg Nesterov <oleg@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: blk-throttle: Correct the placement of smp_rmb()
Message-ID: <20101209023758.GA6423@redhat.com>
References: <20101208184507.GA30071@redhat.com>
 <20101208190918.GI31703@redhat.com>
 <20101208191600.GA32753@redhat.com>
 <20101208193031.GJ31703@redhat.com>
 <20101208193308.GA1044@redhat.com>
 <20101208200750.GA2202@redhat.com>
 <20101208204624.GK31703@redhat.com>
 <20101208213331.GA4895@redhat.com>
 <20101208220640.GB4895@redhat.com>
 <20101209014519.GO2094@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101209014519.GO2094@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 08, 2010 at 05:45:19PM -0800, Paul E. McKenney wrote:
> On Wed, Dec 08, 2010 at 11:06:40PM +0100, Oleg Nesterov wrote:
> > On 12/08, Oleg Nesterov wrote:
> > >
> > > Unfortunately, I can't prove this. You can ask
> > > Paul McKenney if you want the authoritative answer.
> > 
> > Well. I think we should ask ;) This is interesting.
> > 
> > Paul could you please shed a light?
> > 
> > Suppose we have 2 variables, A = 0 and B = 0.
> > 
> > 	CPU0 does:
> > 
> > 		A = 1;
> > 		wmb();
> > 		B = 1;
> > 
> > 	CPU1 does:
> > 
> > 		B = 0;
> > 		mb();
> > 		if (A)
> > 			A = 2;
> > 
> > My understanding is: after that we can safely assume that
> > 
> > 	B == 1 || A == 2
> > 
> > IOW. Either CPU1 notices that A was changed, or CPU0 "wins"
> > and sets B = 1 "after" CPU1. But, it is not possible that
> > CPU1 clears B "after" it was set by CPU0 _and_ sees A == 0.
> > 
> > Is it true? I think it should be true, but can't prove.
> 
> I was afraid that a question like this might be coming...  ;-)
> 
> The question is whether you can rely on the modification order of the
> stores to B to deduce anything useful about the order in which the
> accesses to A occurred.  The answer currently is I believe you can
> for a simple example such as the one above, but I am checking with
> the hardware guys.  In addition, please note that I am not sure if
> all possible generalizations do what you want.  For example, imagine a
> 1024-CPU system in which the first 1023 CPUs do:
> 
> 	A[smp_processor_id()] = 1;
> 	wmb();
> 	B = smp_processor_id();
> 
> where the elements of A are cache-line aligned and padded.  Suppose
> that the remaining CPU does:
> 
> 	i = random() % 1023;
> 	B = -1;
> 	mb();
> 	if (A[i])
> 		A[i] = 2;
> 
> Are we guaranteed that B!=-1||A[i]==2?
> 
> In this case, it could take all of the CPUs quite some time to come to
> agreement on the order of all 1024 assignments to B.  I am bugging some
> hardware guys about this.  It has been awhile, so they forgot to run
> away when they saw me coming.  ;-)
> 
> >                                                         This
> > reminds me the old (and long) discussion about STORE-MB-LOAD.
> > Iirc, finally it was decided that
> > 
> > 	CPU0:				CPU1:
> > 
> > 	A = 1;				B = 1;
> > 	mb();				mb();
> > 	if (B)				if (A)
> > 		printf("Yes");			printf("Yes");
> > 
> > should print "Yes" at least once. This looks very similar to
> > the the previous example.
> 
> >From a hardware point of view, this example is very different than the
> earlier one.  You are not using the order of independent CPUs' stores to a
> single variable here and in addition are using mb() everywhere instead of
> a combination of mb() and wmb().  So, yes, this one is guaranteed to work.
> 
> But what the heck are you guys really trying to do, anyway?  ;-)

Hi Paul,

I pulled oleg into reviewing some block/blk-throttle.c code which I was
not very sure about and that discussion led to above situation. Anyway,
following is my requirement.

There is a hash list on which many throtl_groups (tg) are linked. Each
throtl group has some read/write limits which can be updated with the
help of cgroup files. If limit of any of the groups is updated, we
need to detect and process the change. Looking at current code, oleg
suggested that there is a simpler way to do that. Some thing like
following. 

limit change side (throtl_update_blkio_group_read_bps())
-----------------
tg->bps[READ] = X;
smp_wmb();

tg->limits_changed = true;
smp_wmb();

td->limits_changed = true;
throtl_schedule_delayed_work();

process limit change (throtl_process_limit_change())
----------------------------------------------------

if (!td->limits_changed)
	return;

td->limits_changed = false;
smp_mb();

hlist_for_each_entry_safe() {
	if (!tg->limits_changed)
		return;
	tg->limits_changed = false
	smp_mb();
	process_group_limit_change();
}

And we were wondering if above is correct.

Thanks
Vivek
