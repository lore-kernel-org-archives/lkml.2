Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755492Ab0LDSDc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Dec 2010 13:03:32 -0500
Received: from e4.ny.us.ibm.com ([32.97.182.144]:51356 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751467Ab0LDSDa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Dec 2010 13:03:30 -0500
Date: Sat, 4 Dec 2010 10:03:25 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        rusty@rustcorp.com.au, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] vhost test module
Message-ID: <20101204180325.GA26334@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20101129170431.GA4027@redhat.com>
 <20101129170901.GB4027@redhat.com>
 <20101202190037.GH2085@linux.vnet.ibm.com>
 <20101202191130.GA8092@redhat.com>
 <20101202192616.GL2085@linux.vnet.ibm.com>
 <20101202194709.GA9081@redhat.com>
 <20101202231303.GS2085@linux.vnet.ibm.com>
 <20101202231818.GA12362@redhat.com>
 <20101202235656.GT2085@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101202235656.GT2085@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 02, 2010 at 03:56:56PM -0800, Paul E. McKenney wrote:
> On Fri, Dec 03, 2010 at 01:18:18AM +0200, Michael S. Tsirkin wrote:
> > On Thu, Dec 02, 2010 at 03:13:03PM -0800, Paul E. McKenney wrote:
> > > On Thu, Dec 02, 2010 at 09:47:09PM +0200, Michael S. Tsirkin wrote:
> > > > On Thu, Dec 02, 2010 at 11:26:16AM -0800, Paul E. McKenney wrote:
> > > > > On Thu, Dec 02, 2010 at 09:11:30PM +0200, Michael S. Tsirkin wrote:
> > > > > > On Thu, Dec 02, 2010 at 11:00:37AM -0800, Paul E. McKenney wrote:
> > > > > > > On Mon, Nov 29, 2010 at 07:09:01PM +0200, Michael S. Tsirkin wrote:
> > > > > > > > This adds a test module for vhost infrastructure.
> > > > > > > > Intentionally not tied to kbuild to prevent people
> > > > > > > > from installing and loading it accidentally.
> > > > > > > > 
> > > > > > > > Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> > > > > > > 
> > > > > > > On question below.
> > > > > > > 
> > > > > > > > ---
> > > > > > > > 
> > > > > > > > diff --git a/drivers/vhost/test.c b/drivers/vhost/test.c
> > > > > > > > new file mode 100644
> > > > > > > > index 0000000..099f302
> > > > > > > > --- /dev/null
> > > > > > > > +++ b/drivers/vhost/test.c
> > > > > > > > @@ -0,0 +1,320 @@
> > > > > > > > +/* Copyright (C) 2009 Red Hat, Inc.
> > > > > > > > + * Author: Michael S. Tsirkin <mst@redhat.com>
> > > > > > > > + *
> > > > > > > > + * This work is licensed under the terms of the GNU GPL, version 2.
> > > > > > > > + *
> > > > > > > > + * test virtio server in host kernel.
> > > > > > > > + */
> > > > > > > > +
> > > > > > > > +#include <linux/compat.h>
> > > > > > > > +#include <linux/eventfd.h>
> > > > > > > > +#include <linux/vhost.h>
> > > > > > > > +#include <linux/miscdevice.h>
> > > > > > > > +#include <linux/module.h>
> > > > > > > > +#include <linux/mutex.h>
> > > > > > > > +#include <linux/workqueue.h>
> > > > > > > > +#include <linux/rcupdate.h>
> > > > > > > > +#include <linux/file.h>
> > > > > > > > +#include <linux/slab.h>
> > > > > > > > +
> > > > > > > > +#include "test.h"
> > > > > > > > +#include "vhost.c"
> > > > > > > > +
> > > > > > > > +/* Max number of bytes transferred before requeueing the job.
> > > > > > > > + * Using this limit prevents one virtqueue from starving others. */
> > > > > > > > +#define VHOST_TEST_WEIGHT 0x80000
> > > > > > > > +
> > > > > > > > +enum {
> > > > > > > > +	VHOST_TEST_VQ = 0,
> > > > > > > > +	VHOST_TEST_VQ_MAX = 1,
> > > > > > > > +};
> > > > > > > > +
> > > > > > > > +struct vhost_test {
> > > > > > > > +	struct vhost_dev dev;
> > > > > > > > +	struct vhost_virtqueue vqs[VHOST_TEST_VQ_MAX];
> > > > > > > > +};
> > > > > > > > +
> > > > > > > > +/* Expects to be always run from workqueue - which acts as
> > > > > > > > + * read-size critical section for our kind of RCU. */
> > > > > > > > +static void handle_vq(struct vhost_test *n)
> > > > > > > > +{
> > > > > > > > +	struct vhost_virtqueue *vq = &n->dev.vqs[VHOST_TEST_VQ];
> > > > > > > > +	unsigned out, in;
> > > > > > > > +	int head;
> > > > > > > > +	size_t len, total_len = 0;
> > > > > > > > +	void *private;
> > > > > > > > +
> > > > > > > > +	private = rcu_dereference_check(vq->private_data, 1);
> > > > > > > 
> > > > > > > Any chance of a check for running in a workqueue?  If I remember correctly,
> > > > > > > the ->lockdep_map field in the work_struct structure allows you to create
> > > > > > > the required lockdep expression.
> > > > > > 
> > > > > > We moved away from using the workqueue to a custom kernel thread
> > > > > > implementation though.
> > > > > 
> > > > > OK, then could you please add a check for "current == custom_kernel_thread"
> > > > > or some such?
> > > > > 
> > > > > 							Thanx, Paul
> > > > 
> > > > It's a bit tricky. The way we flush out things is by an analog of
> > > > flush_work. So just checking that we run from workqueue isn't
> > > > right need to check that we are running from one of the specific work
> > > > structures that we are careful to flush.
> > > > 
> > > > I can do this by passing the work structure pointer on to relevant
> > > > functions but I think this will add (very minor) overhead even when rcu
> > > > checks are disabled. Does it matter? Thoughts?
> > > 
> > > Would it be possible to set up separate lockdep maps, in effect passing
> > > the needed information via lockdep rather than via the function arguments?
> > 
> > Possibly, I don't know enough about this but will check.
> > Any examples to look at?
> 
> I would suggest the workqueue example in include/linux/workqueue.h and
> kernel/workqueue.c.  You will need a struct lockdep_map for each of the
> specific work structures, sort of like the one in struct workqueue_struct.
> 
> You can then use lock_map_acquire() and lock_map_release() to flag the
> fact that your kernel thread is running and not, and then you can pass
> lock_is_held() to rcu_dereference_check().  Each of lock_map_acquire(),
> lock_map_release(), and lock_is_held() takes a struct lockdep_map as
> sole argument.  The rcu_lock_map definition shows an example of a global
> lockdep_map variable.  If you need to do runtime initialization of your
> lockdep_map structure, you can use lockdep_init_map().
> 
> Seem reasonable?

PS to previous...

Suppose that there are many work structures, and several of them use
this same function, but the function has no indication of which one it
is working on.  Then one reasonable approach is to share a lockdep_map
structure among them.  Although this does not allow you to validate
one-to-one from structure to function invocation, it -does- allow the
code to defend itself against an incorrect direct call into the from
some inappropriate context.

							Thanx, Paul
