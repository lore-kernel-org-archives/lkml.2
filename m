Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751682Ab0DZNjn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Apr 2010 09:39:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44722 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750790Ab0DZNjm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Apr 2010 09:39:42 -0400
Date: Mon, 26 Apr 2010 09:39:20 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>,
       linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>,
       Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Subject: Re: [PATCH] blk-cgroup: Fix RCU correctness warning in
	cfq_init_queue()
Message-ID: <20100426133920.GA1559@redhat.com>
References: <20100422155452.GD3228@redhat.com> <20100422231556.GW2524@linux.vnet.ibm.com> <20100422235555.GA12004@redhat.com> <20100423001751.GX2524@linux.vnet.ibm.com> <20100423144138.GA5026@redhat.com> <20100423194649.GF2589@linux.vnet.ibm.com> <4BD4ED7A.5020205@cn.fujitsu.com> <20100426020631.GU2440@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100426020631.GU2440@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 25, 2010 at 07:06:31PM -0700, Paul E. McKenney wrote:
> On Mon, Apr 26, 2010 at 09:33:46AM +0800, Li Zefan wrote:
> > >>>>>> With RCU correctness on, We see following warning. This patch fixes it.
> > >>>>> This is in initialization code, so that there cannot be any concurrent
> > >>>>> updates, correct?  If so, looks good.
> > >>>>>
> > >>>> I think theoritically two instances of cfq_init_queue() can be running
> > >>>> in parallel (for two different devices), and they both can call
> > >>>> blkiocg_add_blkio_group(). But then we use a spin lock to protect
> > >>>> blkio_cgroup.
> > >>>>
> > >>>> spin_lock_irqsave(&blkcg->lock, flags);
> > >>>>
> > >>>> So I guess two parallel updates should be fine.
> > >>> OK, in that case, would it be possible add this spinlock to the condition
> > >>> checked by css_id()'s rcu_dereference_check()?
> > >> Hi Paul,
> > >>
> > >> I think adding these spinlock to condition checked might become little
> > >> messy. And the reason being that this lock is subsystem (controller)
> > >> specific and maintained by controller. Now if any controller implements
> > >> a lock and we add that lock in css_id() rcu_dereference_check(), it will
> > >> look ugly.
> > >>
> > >> So probably a better way is to make sure that css_id() is always called
> > >> under rcu read lock so that we don't hit this warning?
> > > 
> > > As long as holding rcu_read_lock() prevents css_id() from the usual
> > > problems such as access memory that was concurrently freed, yes.
> > 
> > blkiocg_add_blkio_group() also calls cgroup_path(), which also needs to
> > be called within rcu_read_lock, so I think Vivek's patch is better than
> > the one you posted in another mail thread.
> 
> My apologies, Vivek!  I lost track of your patch.  I have now replaced
> my patch with yours.

Thanks Paul.

I sent this patch to Jens also, thinking he will apply to his tree. Looks
like he has not applied it yet though.

Jens, is it ok if this patch gets merged through paul's tree or should it
go through blk tree?

Thanks
Vivek
