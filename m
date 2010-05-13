Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757835Ab0EMD7D (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 23:59:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23482 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754909Ab0EMD7A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 23:59:00 -0400
Date: Thu, 13 May 2010 06:53:45 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
       dipankar@in.ibm.com, akpm@linux-foundation.org,
       mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, dvhltc@us.ibm.com,
       niv@us.ibm.com, tglx@linutronix.de, peterz@infradead.org,
       rostedt@goodmis.org, Valdis.Kletnieks@vt.edu, dhowells@redhat.com,
       eric.dumazet@gmail.com, Arnd Bergmann <arnd@relay.de.ibm.com>,
       Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH RFC tip/core/rcu 23/23] vhost: add __rcu annotations
Message-ID: <20100513035345.GB7413@redhat.com>
References: <20100512213317.GA15085@linux.vnet.ibm.com> <1273700022-16523-23-git-send-email-paulmck@linux.vnet.ibm.com> <20100512214847.GD22930@redhat.com> <20100512230057.GH2303@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100512230057.GH2303@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 12, 2010 at 04:00:57PM -0700, Paul E. McKenney wrote:
> On Thu, May 13, 2010 at 12:48:47AM +0300, Michael S. Tsirkin wrote:
> > On Wed, May 12, 2010 at 02:33:42PM -0700, Paul E. McKenney wrote:
> > > From: Arnd Bergmann <arnd@relay.de.ibm.com>
> > > 
> > > Also add rcu_dreference_protected() for code paths where locks are held.
> > > 
> > > Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> > > Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > > Cc: "Michael S. Tsirkin" <mst@redhat.com>
> > 
> > Maybe long lines can be fixed? Otherwise looks ok.
> 
> Done.  I introduced locals to make it fit.
> 
> One other thing...  We need some API that says "we are running in the
> context of a work queue."  Otherwise, we will get false positives when
> called in a work queue without locks held.
> 
> Any thoughts?  One approach would be to create a separate lockdep class
> for vhost workqueue state, similar to the approach used in instrument
> rcu_read_lock() and friends.
> 
> 							Thanx, Paul

And we would want some way to tag the flushes ... not easy.
Let's start with switching to raw to avoid the errors.

> > > ---
> > >  drivers/vhost/net.c   |   11 ++++++++---
> > >  drivers/vhost/vhost.c |   14 ++++++++------
> > >  drivers/vhost/vhost.h |    4 ++--
> > >  3 files changed, 18 insertions(+), 11 deletions(-)
> > > 
> > > diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
> > > index 9777583..945c5cb 100644
> > > --- a/drivers/vhost/net.c
> > > +++ b/drivers/vhost/net.c
> > > @@ -364,7 +364,10 @@ static void vhost_net_disable_vq(struct vhost_net *n,
> > >  static void vhost_net_enable_vq(struct vhost_net *n,
> > >  				struct vhost_virtqueue *vq)
> > >  {
> > > -	struct socket *sock = vq->private_data;
> > > +	struct socket *sock;
> > > +
> > > +	sock = rcu_dereference_protected(vq->private_data,
> > > +					 lockdep_is_held(&vq->mutex));
> > >  	if (!sock)
> > >  		return;
> > >  	if (vq == n->vqs + VHOST_NET_VQ_TX) {
> > > @@ -380,7 +383,8 @@ static struct socket *vhost_net_stop_vq(struct vhost_net *n,
> > >  	struct socket *sock;
> > >  
> > >  	mutex_lock(&vq->mutex);
> > > -	sock = vq->private_data;
> > > +	sock = rcu_dereference_protected(vq->private_data,
> > > +					 lockdep_is_held(&vq->mutex));
> > >  	vhost_net_disable_vq(n, vq);
> > >  	rcu_assign_pointer(vq->private_data, NULL);
> > >  	mutex_unlock(&vq->mutex);
> > > @@ -518,7 +522,8 @@ static long vhost_net_set_backend(struct vhost_net *n, unsigned index, int fd)
> > >  	}
> > >  
> > >  	/* start polling new socket */
> > > -	oldsock = vq->private_data;
> > > +	oldsock = rcu_dereference_protected(vq->private_data,
> > > +					    lockdep_is_held(&vq->mutex));
> > >  	if (sock == oldsock)
> > >  		goto done;
> > >  
> > > diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
> > > index e69d238..fc0c077 100644
> > > --- a/drivers/vhost/vhost.c
> > > +++ b/drivers/vhost/vhost.c
> > > @@ -180,7 +180,7 @@ long vhost_dev_reset_owner(struct vhost_dev *dev)
> > >  	vhost_dev_cleanup(dev);
> > >  
> > >  	memory->nregions = 0;
> > > -	dev->memory = memory;
> > > +	RCU_INIT_POINTER(dev->memory, memory);
> > >  	return 0;
> > >  }
> > >  
> > > @@ -212,8 +212,9 @@ void vhost_dev_cleanup(struct vhost_dev *dev)
> > >  		fput(dev->log_file);
> > >  	dev->log_file = NULL;
> > >  	/* No one will access memory at this point */
> > > -	kfree(dev->memory);
> > > -	dev->memory = NULL;
> > > +	kfree(rcu_dereference_protected(dev->memory,
> > > +					lockdep_is_held(&dev->mutex)));
> > > +	RCU_INIT_POINTER(dev->memory, NULL);
> > >  	if (dev->mm)
> > >  		mmput(dev->mm);
> > >  	dev->mm = NULL;
> > > @@ -294,14 +295,14 @@ static int vq_access_ok(unsigned int num,
> > >  /* Caller should have device mutex but not vq mutex */
> > >  int vhost_log_access_ok(struct vhost_dev *dev)
> > >  {
> > > -	return memory_access_ok(dev, dev->memory, 1);
> > > +	return memory_access_ok(dev, rcu_dereference_protected(dev->memory, lockdep_is_held(&dev->mutex)), 1);
> > >  }
> > >  
> > >  /* Verify access for write logging. */
> > >  /* Caller should have vq mutex and device mutex */
> > >  static int vq_log_access_ok(struct vhost_virtqueue *vq, void __user *log_base)
> > >  {
> > > -	return vq_memory_access_ok(log_base, vq->dev->memory,
> > > +	return vq_memory_access_ok(log_base, rcu_dereference_protected(vq->dev->memory, lockdep_is_held(&dev->mutex)),
> > >  			    vhost_has_feature(vq->dev, VHOST_F_LOG_ALL)) &&
> > >  		(!vq->log_used || log_access_ok(log_base, vq->log_addr,
> > >  					sizeof *vq->used +
> > > @@ -342,7 +343,8 @@ static long vhost_set_memory(struct vhost_dev *d, struct vhost_memory __user *m)
> > >  
> > >  	if (!memory_access_ok(d, newmem, vhost_has_feature(d, VHOST_F_LOG_ALL)))
> > >  		return -EFAULT;
> > > -	oldmem = d->memory;
> > > +	oldmem = rcu_dereference_protected(d->memory,
> > > +					   lockdep_is_held(&d->mutex));
> > >  	rcu_assign_pointer(d->memory, newmem);
> > >  	synchronize_rcu();
> > >  	kfree(oldmem);
> > > diff --git a/drivers/vhost/vhost.h b/drivers/vhost/vhost.h
> > > index 44591ba..240396c 100644
> > > --- a/drivers/vhost/vhost.h
> > > +++ b/drivers/vhost/vhost.h
> > > @@ -92,7 +92,7 @@ struct vhost_virtqueue {
> > >  	 * work item execution acts instead of rcu_read_lock() and the end of
> > >  	 * work item execution acts instead of rcu_read_lock().
> > >  	 * Writers use virtqueue mutex. */
> > > -	void *private_data;
> > > +	void __rcu *private_data;
> > >  	/* Log write descriptors */
> > >  	void __user *log_base;
> > >  	struct vhost_log log[VHOST_NET_MAX_SG];
> > > @@ -102,7 +102,7 @@ struct vhost_dev {
> > >  	/* Readers use RCU to access memory table pointer
> > >  	 * log base pointer and features.
> > >  	 * Writers use mutex below.*/
> > > -	struct vhost_memory *memory;
> > > +	struct vhost_memory __rcu *memory;
> > >  	struct mm_struct *mm;
> > >  	struct mutex mutex;
> > >  	unsigned acked_features;
> > > -- 
> > > 1.7.0.6
