Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752476Ab1ARRzx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jan 2011 12:55:53 -0500
Received: from mx1.redhat.com ([209.132.183.28]:7060 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751813Ab1ARRzw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jan 2011 12:55:52 -0500
Date: Tue, 18 Jan 2011 19:55:00 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Jason Wang <jasowang@redhat.com>, kvm@vger.kernel.org,
        virtualization@lists.osdl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vhost: rcu annotation fixup
Message-ID: <20110118175500.GA6935@redhat.com>
References: <20110118110845.GA11555@redhat.com>
 <20110118174834.GF2193@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110118174834.GF2193@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 18, 2011 at 09:48:34AM -0800, Paul E. McKenney wrote:
> On Tue, Jan 18, 2011 at 01:08:45PM +0200, Michael S. Tsirkin wrote:
> > When built with rcu checks enabled, vhost triggers
> > bogus warnings as vhost features are read without
> > dev->mutex sometimes.
> > Fixing it properly is not trivial as vhost.h does not
> > know which lockdep classes it will be used under.
> > Disable the warning by stubbing out the check for now.
> > 
> > Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> > ---
> >  drivers/vhost/vhost.h |    4 +---
> >  1 files changed, 1 insertions(+), 3 deletions(-)
> > 
> > diff --git a/drivers/vhost/vhost.h b/drivers/vhost/vhost.h
> > index 2af44b7..2d03a31 100644
> > --- a/drivers/vhost/vhost.h
> > +++ b/drivers/vhost/vhost.h
> > @@ -173,9 +173,7 @@ static inline int vhost_has_feature(struct vhost_dev *dev, int bit)
> >  {
> >  	unsigned acked_features;
> > 
> > -	acked_features =
> > -		rcu_dereference_index_check(dev->acked_features,
> > -					    lockdep_is_held(&dev->mutex));
> > +	acked_features = rcu_dereference_index_check(dev->acked_features, 1);
> 
> Ouch!!!
> 
> Could you please at least add a comment?

Yes, OK.

> Alternatively, pass in the lock that is held and check for that?  Given
> that this is a static inline, the compiler should be able to optimize
> the argument away when !PROVE_RCU, correct?
> 
> 							Thanx, Paul

Hopefully, yes. We don't always have a lock: the idea was
to create a lockdep for these cases. But we can't pass
the pointer to that ...

> >  	return acked_features & (1 << bit);
> >  }
> > 
> > -- 
> > 1.7.3.2.91.g446ac
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
