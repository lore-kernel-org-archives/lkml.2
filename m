Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932943Ab1CWNbX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 09:31:23 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:58588 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932922Ab1CWNbV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 09:31:21 -0400
Date: Wed, 23 Mar 2011 06:30:48 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Matthew Wilcox <matthew@wil.cx>
Cc: Robert Love <robert.w.love@intel.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>, Ingo Molnar <mingo@elte.hu>,
        Jens Axboe <axboe@kernel.dk>,
        "James E.J. Bottomley" <James.Bottomley@suse.de>,
        Neil Horman <nhorman@tuxdriver.com>,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        "Pekka Savola (ipv6)" <pekkas@netcore.fi>,
        James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Patrick McHardy <kaber@trash.net>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Stephen Hemminger <shemminger@vyatta.com>, Tejun Heo <tj@kernel.org>,
        Jarek Poplawski <jarkao2@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@open-fcoe.org" <devel@open-fcoe.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH 02/36] scsi,rcu: convert call_rcu(fc_rport_free_rcu) to
 kfree_rcu()
Message-ID: <20110323133048.GX2322@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <4D82D071.5020703@cn.fujitsu.com>
 <4D82D3FF.2080303@cn.fujitsu.com>
 <4D82D45A.30102@cn.fujitsu.com>
 <1300814913.19083.427.camel@fritz>
 <20110323065014.GU2322@linux.vnet.ibm.com>
 <20110323112257.GD13806@parisc-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110323112257.GD13806@parisc-linux.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 23, 2011 at 05:22:57AM -0600, Matthew Wilcox wrote:
> On Tue, Mar 22, 2011 at 11:50:14PM -0700, Paul E. McKenney wrote:
> > On Tue, Mar 22, 2011 at 10:28:33AM -0700, Robert Love wrote:
> > > On Thu, 2011-03-17 at 20:41 -0700, Lai Jiangshan wrote:
> > > > -	call_rcu(&rdata->rcu, fc_rport_free_rcu);
> > > > +	kfree_rcu(rdata, rcu);
> > > 
> > > I think this last line should be:
> > > 
> > > kfree_rcu(rdata, &rdata->rcu);
> > 
> > Hello, Robert,
> > 
> > I believe that it is correct as is.  The kfree_rcu() definition is as
> > follows:
> > 
> > #define kfree_rcu(ptr, rcu_head)					\
> > 	__kfree_rcu(&((ptr)->rcu_head), offsetof(typeof(*(ptr)), rcu_head))
> > 
> > Then __kfree_rcu() encodes the offset into the rcu_head so that it can
> > be handled properly at the end of the grace period.
> 
> To be fair to Robert, I had the same thought, but decided to check the
> definition of kfree_rcu before I made the same comment.  Unfortunately,
> the definition of kfree_rcu is still not in Linus' tree (and there's no
> indication in the patch series about where to find the definition).  It
> would have been better if kfree_rcu were patch 1/n in the series, then
> we'd've been able to review it more effectively.

Good point!  That said, it is a bit ugly no matter how we handle it
because any of the patches that have not received acked-bys will need
to go up through their respective maintainer trees.  Last time I had a
situation like this, it ended up stalling my commit stream for several
months, so was trying to separate them in order to avoid the stall.

But perhaps this is one of those situations where there is simply no
good way to handle the full series.  :-(

> Any idea when kfree_rcu will be submitted to Linus?

I have it queued, and it passes mild testing.  I therefore expect to
push it for the next merge window.

So, do you guys want to carry the patches for your subsystems, or are
you willing to ack this one so that I can push it via -tip?

							Thanx, Paul
