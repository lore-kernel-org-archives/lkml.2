Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755757Ab0D1AQe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 20:16:34 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:34748 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755640Ab0D1AQd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 20:16:33 -0400
Date: Tue, 27 Apr 2010 17:16:28 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>,
       linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>,
       Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Subject: Re: [PATCH] blk-cgroup: Fix RCU correctness warning in
 cfq_init_queue()
Message-ID: <20100428001628.GA19734@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20100423001751.GX2524@linux.vnet.ibm.com>
 <20100423144138.GA5026@redhat.com>
 <20100423194649.GF2589@linux.vnet.ibm.com>
 <4BD4ED7A.5020205@cn.fujitsu.com>
 <20100426020631.GU2440@linux.vnet.ibm.com>
 <20100426133920.GA1559@redhat.com>
 <20100426144542.GA2529@linux.vnet.ibm.com>
 <20100426204208.GF3372@redhat.com>
 <20100426204704.GJ2529@linux.vnet.ibm.com>
 <20100426205244.GG3372@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100426205244.GG3372@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 26, 2010 at 04:52:44PM -0400, Vivek Goyal wrote:
> On Mon, Apr 26, 2010 at 01:47:04PM -0700, Paul E. McKenney wrote:
> > On Mon, Apr 26, 2010 at 04:42:08PM -0400, Vivek Goyal wrote:
> > > On Mon, Apr 26, 2010 at 07:45:42AM -0700, Paul E. McKenney wrote:
> > > > On Mon, Apr 26, 2010 at 09:39:20AM -0400, Vivek Goyal wrote:
> > > > > On Sun, Apr 25, 2010 at 07:06:31PM -0700, Paul E. McKenney wrote:
> > > > > > On Mon, Apr 26, 2010 at 09:33:46AM +0800, Li Zefan wrote:
> > > > > > > >>>>>> With RCU correctness on, We see following warning. This patch fixes it.
> > > > > > > >>>>> This is in initialization code, so that there cannot be any concurrent
> > > > > > > >>>>> updates, correct?  If so, looks good.
> > > > > > > >>>>>
> > > > > > > >>>> I think theoritically two instances of cfq_init_queue() can be running
> > > > > > > >>>> in parallel (for two different devices), and they both can call
> > > > > > > >>>> blkiocg_add_blkio_group(). But then we use a spin lock to protect
> > > > > > > >>>> blkio_cgroup.
> > > > > > > >>>>
> > > > > > > >>>> spin_lock_irqsave(&blkcg->lock, flags);
> > > > > > > >>>>
> > > > > > > >>>> So I guess two parallel updates should be fine.
> > > > > > > >>> OK, in that case, would it be possible add this spinlock to the condition
> > > > > > > >>> checked by css_id()'s rcu_dereference_check()?
> > > > > > > >> Hi Paul,
> > > > > > > >>
> > > > > > > >> I think adding these spinlock to condition checked might become little
> > > > > > > >> messy. And the reason being that this lock is subsystem (controller)
> > > > > > > >> specific and maintained by controller. Now if any controller implements
> > > > > > > >> a lock and we add that lock in css_id() rcu_dereference_check(), it will
> > > > > > > >> look ugly.
> > > > > > > >>
> > > > > > > >> So probably a better way is to make sure that css_id() is always called
> > > > > > > >> under rcu read lock so that we don't hit this warning?
> > > > > > > > 
> > > > > > > > As long as holding rcu_read_lock() prevents css_id() from the usual
> > > > > > > > problems such as access memory that was concurrently freed, yes.
> > > > > > > 
> > > > > > > blkiocg_add_blkio_group() also calls cgroup_path(), which also needs to
> > > > > > > be called within rcu_read_lock, so I think Vivek's patch is better than
> > > > > > > the one you posted in another mail thread.
> > > > > > 
> > > > > > My apologies, Vivek!  I lost track of your patch.  I have now replaced
> > > > > > my patch with yours.
> > > > > 
> > > > > Thanks Paul.
> > > > > 
> > > > > I sent this patch to Jens also, thinking he will apply to his tree. Looks
> > > > > like he has not applied it yet though.
> > > > > 
> > > > > Jens, is it ok if this patch gets merged through paul's tree or should it
> > > > > go through blk tree?
> > > > 
> > > > I am happy for it to go either way, so just let me know!
> > > 
> > > I am also happy to go either way. I guess you can go ahead with pulling it in.
> > 
> > I have it queued for 2.6.34.
> 
> Thanks Paul. Where can I get your tree to clone from? I can test the
> changes. I can't find it on kernel.org.

I have a early-alpha version of an RCU git tree at:

master.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-2.6-rcutest.git

This is my first attempt to create such a tree, so please let me know if
you run into problems trying to use it.  The branch "urgent.2010.40.27a",
complete with a dyslexic month of April, contains the RCU lockdep
fixes that are not known to me to be in other trees.  The branch
"rcutest.2010.04.27a" contains stuff intended for 2.6.35.

I expect that I will learn how one -really- sets up a tree over the next
little while, at which point I will delete the above and create a real
one.  A more real one, anyway...

							Thanx, Paul
