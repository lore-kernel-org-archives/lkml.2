Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760224Ab0EDX6A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 19:58:00 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:35583 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751504Ab0EDX57 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 19:57:59 -0400
Date: Tue, 4 May 2010 16:57:50 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
       dipankar@in.ibm.com, akpm@linux-foundation.org,
       mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, dvhltc@us.ibm.com,
       niv@us.ibm.com, tglx@linutronix.de, peterz@infradead.org,
       rostedt@goodmis.org, Valdis.Kletnieks@vt.edu, dhowells@redhat.com,
       eric.dumazet@gmail.com, Arnd Bergmann <arnd@relay.de.ibm.com>,
       Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH tip/core/rcu 43/48] vhost: add __rcu annotations
Message-ID: <20100504235750.GH2639@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20100504201934.GA19234@linux.vnet.ibm.com>
 <1273004398-19760-43-git-send-email-paulmck@linux.vnet.ibm.com>
 <20100504213936.GB3568@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100504213936.GB3568@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 05, 2010 at 12:39:36AM +0300, Michael S. Tsirkin wrote:
> On Tue, May 04, 2010 at 01:19:53PM -0700, Paul E. McKenney wrote:
> > From: Arnd Bergmann <arnd@relay.de.ibm.com>
> > 
> > Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> > Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > Cc: "Michael S. Tsirkin" <mst@redhat.com>
> > ---
> >  drivers/vhost/net.c   |    6 +++---
> >  drivers/vhost/vhost.c |   12 ++++++------
> >  drivers/vhost/vhost.h |    4 ++--
> >  3 files changed, 11 insertions(+), 11 deletions(-)
> > 
> > diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
> > index 9777583..36e8dec 100644
> > --- a/drivers/vhost/net.c
> > +++ b/drivers/vhost/net.c
> > @@ -364,7 +364,7 @@ static void vhost_net_disable_vq(struct vhost_net *n,
> >  static void vhost_net_enable_vq(struct vhost_net *n,
> >  				struct vhost_virtqueue *vq)
> >  {
> > -	struct socket *sock = vq->private_data;
> > +	struct socket *sock = rcu_dereference(vq->private_data);
> 
> This should be rcu_dereference_const as well: it is called
> with vq mutex held.

How about the following?

	struct socket *sock;
	
	sock = rcu_dereference_protected(vq->private_data,
					 lockdep_is_held(&vq->mutex));

This could be used for some (though not all) of these situations.

And just so you know...  The fact that this is here in the first
place is actually my mistake -- my intention was to include the __rcu
annotations and nothing else, then follow up with bug fixes.  In fact,
the alert reader will have noted that there is in fact no such thing
as rcu_dereference_const().  And have concluded that none of my test
machines use vhost.  :-/

But as long as we are here, might as well complete the annotation...

So I have inserted guesses for the lockdep_is_held() expressions below
for your amusement.  Please let me know what I should be using instead.

> >  	if (!sock)
> >  		return;
> >  	if (vq == n->vqs + VHOST_NET_VQ_TX) {
> > @@ -380,7 +380,7 @@ static struct socket *vhost_net_stop_vq(struct vhost_net *n,
> >  	struct socket *sock;
> >  
> >  	mutex_lock(&vq->mutex);
> > -	sock = vq->private_data;
> > +	sock = rcu_dereference_const(vq->private_data);

	sock = rcu_dereference_protected(vq->private_data,
					 lockdep_is_held(&vq->mutex));

> >  	vhost_net_disable_vq(n, vq);
> >  	rcu_assign_pointer(vq->private_data, NULL);
> >  	mutex_unlock(&vq->mutex);
> > @@ -518,7 +518,7 @@ static long vhost_net_set_backend(struct vhost_net *n, unsigned index, int fd)
> >  	}
> >  
> >  	/* start polling new socket */
> > -	oldsock = vq->private_data;
> > +	oldsock = rcu_dereference_const(vq->private_data);

	oldsock = rcu_dereference_protected(vq->private_data,
					    lockdep_is_held(&vq->mutex));

Though I can't say I see where this lock is actually acquired in this
case...

> >  	if (sock == oldsock)
> >  		goto done;
> >  
> > diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
> > index e69d238..fc9bde2 100644
> > --- a/drivers/vhost/vhost.c
> > +++ b/drivers/vhost/vhost.c
> > @@ -180,7 +180,7 @@ long vhost_dev_reset_owner(struct vhost_dev *dev)
> >  	vhost_dev_cleanup(dev);
> >  
> >  	memory->nregions = 0;
> > -	dev->memory = memory;
> > +	rcu_assign_pointer(dev->memory, memory);
> 
> This is called when there can be no active readers, so the smp_wmb
> inside rcu_assign_pointer isn't really needed.
> Use RCU_INIT_POINTER or something like this instead?

Good point!  Fixed.

> >  	return 0;
> >  }
> >  
> > @@ -212,8 +212,8 @@ void vhost_dev_cleanup(struct vhost_dev *dev)
> >  		fput(dev->log_file);
> >  	dev->log_file = NULL;
> >  	/* No one will access memory at this point */
> > -	kfree(dev->memory);
> > -	dev->memory = NULL;
> > +	kfree(rcu_dereference_const(dev->memory));

	kfree(rcu_dereference_protected(dev->memory,
					lockdep_is_held(&dev->mutex));

> > +	rcu_assign_pointer(dev->memory, NULL);
> 
> Same here.

Fixed -- any in any case, we can always use RCU_INIT_POINTER() when
assigning NULL.

> >  	if (dev->mm)
> >  		mmput(dev->mm);
> >  	dev->mm = NULL;
> > @@ -294,14 +294,14 @@ static int vq_access_ok(unsigned int num,
> >  /* Caller should have device mutex but not vq mutex */
> >  int vhost_log_access_ok(struct vhost_dev *dev)
> >  {
> > -	return memory_access_ok(dev, dev->memory, 1);
> > +	return memory_access_ok(dev, rcu_dereference_const(dev->memory), 1);

	return memory_access_ok(dev, rcu_dereference_protected(dev->memory, lockdep_is_held(&dev->mutex)), 1);

And yes, we do need an rcu_dereference_vqdev() wrapper function, but just
want to identify the mutexes for the moment.

Maybe a separate rcu_dereference_vq() as well -- but you tell me!

> >  }
> >  
> >  /* Verify access for write logging. */
> >  /* Caller should have vq mutex and device mutex */
> >  static int vq_log_access_ok(struct vhost_virtqueue *vq, void __user *log_base)
> >  {
> > -	return vq_memory_access_ok(log_base, vq->dev->memory,
> > +	return vq_memory_access_ok(log_base, rcu_dereference(vq->dev->memory),
> 
> rcu_dereference_const. This is called under vq mutex and the comment
> above it says as much.

	return memory_access_ok(dev, rcu_dereference_protected(dev->memory, lockdep_is_held(&dev->mutex)),

> >  			    vhost_has_feature(vq->dev, VHOST_F_LOG_ALL)) &&
> >  		(!vq->log_used || log_access_ok(log_base, vq->log_addr,
> >  					sizeof *vq->used +
> > @@ -342,7 +342,7 @@ static long vhost_set_memory(struct vhost_dev *d, struct vhost_memory __user *m)
> >  
> >  	if (!memory_access_ok(d, newmem, vhost_has_feature(d, VHOST_F_LOG_ALL)))
> >  		return -EFAULT;
> > -	oldmem = d->memory;
> > +	oldmem = rcu_dereference_const(d->memory);

	oldmem = rcu_dereference_protected(d->memory,
					   lockdep_is_held(&d->mutex));

> >  	rcu_assign_pointer(d->memory, newmem);
> >  	synchronize_rcu();
> >  	kfree(oldmem);
> > diff --git a/drivers/vhost/vhost.h b/drivers/vhost/vhost.h
> > index 44591ba..240396c 100644
> > --- a/drivers/vhost/vhost.h
> > +++ b/drivers/vhost/vhost.h
> > @@ -92,7 +92,7 @@ struct vhost_virtqueue {
> >  	 * work item execution acts instead of rcu_read_lock() and the end of
> >  	 * work item execution acts instead of rcu_read_lock().
> >  	 * Writers use virtqueue mutex. */
> > -	void *private_data;
> > +	void __rcu *private_data;
> >  	/* Log write descriptors */
> >  	void __user *log_base;
> >  	struct vhost_log log[VHOST_NET_MAX_SG];
> > @@ -102,7 +102,7 @@ struct vhost_dev {
> >  	/* Readers use RCU to access memory table pointer
> >  	 * log base pointer and features.
> >  	 * Writers use mutex below.*/
> > -	struct vhost_memory *memory;
> > +	struct vhost_memory __rcu *memory;
> >  	struct mm_struct *mm;
> >  	struct mutex mutex;
> >  	unsigned acked_features;
> > -- 
> > 1.7.0
