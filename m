Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752982Ab1HAIMP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Aug 2011 04:12:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42073 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752595Ab1HAIMI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Aug 2011 04:12:08 -0400
Date: Mon, 1 Aug 2011 11:12:37 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Liu Yuan <namei.unix@gmail.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, Avi Kivity <avi@redhat.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] vhost-blk: An in-kernel accelerator for virtio-blk
Message-ID: <20110801081237.GC5439@redhat.com>
References: <1311863346-4338-1-git-send-email-namei.unix@gmail.com>
 <1311863346-4338-2-git-send-email-namei.unix@gmail.com>
 <20110728152244.GA31888@redhat.com>
 <4E3646E0.9050400@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E3646E0.9050400@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 01, 2011 at 02:25:36PM +0800, Liu Yuan wrote:
> On 07/28/2011 11:22 PM, Michael S. Tsirkin wrote:
> >
> >It would be nicer to reuse the worker infrastructure
> >from vhost.c. In particular this one ignores cgroups that
> >the owner belongs to if any.
> >Does this one do anything that vhost.c doesn't?
> >
> 
> The main idea I use a separated thread to handling completion is to
> decouple the  request handling
> and the request completion signalling. This might allow better
> scalability in a IO intensive scenario,

The code seems to have the vq mutex though, isn't that right?
If so, it can't execute in parallel so it's a bit
hard to see how this would help scalability.

> since I noted that virtio driver would allow sumbit as much as 128
> requests in one go.
> 
> Hmm, I have tried to make signalling thread into a function that is
> called as a vhost-worker's work.
> I didn't see regression in my laptop with iodepth equalling 1,2,3.
> But requests handling and completion signalling may produce race in
> a high requests submitting rate. Anyway, I'll adopt it to work as a
> vhost
> worker function in v2.
> 
> >
> >>+	switch (ioctl) {
> >>+		case VHOST_NET_SET_BACKEND:
> >>+			if(copy_from_user(&backend, (void __user *)arg, sizeof backend))
> >>+				break;
> >>+			ret = blk_set_backend(blk,&backend);
> >>+			break;
> >Please create your own ioctl for this one.
> >
> 
> How about change VHOST_NET_SET_BACKEND into VHOST_SET_BACKEND?

I had a feeling other devices might want some other structure
(not an fd) as a backend. Maybe that was wrong ...
If so, pls do that, and #define VHOST_NET_SET_BACKEND VHOST_SET_BACKEND
for compatibility.

> >>
> >>  static int io_submit_one(struct kioctx *ctx, struct iocb __user *user_iocb,
> >>  			 struct iocb *iocb, bool compat)
> >>diff --git a/fs/eventfd.c b/fs/eventfd.c
> >>index d9a5917..6343bc9 100644
> >>--- a/fs/eventfd.c
> >>+++ b/fs/eventfd.c
> >>@@ -406,6 +406,7 @@ struct file *eventfd_file_create(unsigned int count, int flags)
> >>
> >>  	return file;
> >>  }
> >>+EXPORT_SYMBOL_GPL(eventfd_file_create);
> >You can avoid the need for this export if you pass
> >the eventfd in from userspace.
> >
> 
> Since eventfd used by completion code is internal and hiding it from
> hw/vhost_blk.c would simplify
> the configuration, I think this exporting is necessary and can get
> rid of unnecessary FD management
> in vhost-blk.c.

Well this is a new kernel interface duplicating the functionality of the
old one.  You'll have a hard time selling this idea upstream, I suspect.
And I doubt it simplifies the code significantly.
Further, you have a single vq for block, but net has two and
we do want the flexibility of using a single eventfd for both,
I think.

> >>
> >>  SYSCALL_DEFINE2(eventfd2, unsigned int, count, int, flags)
> >>  {
> >>diff --git a/include/linux/aio.h b/include/linux/aio.h
> >>index 7a8db41..d63bc04 100644
> >>--- a/include/linux/aio.h
> >>+++ b/include/linux/aio.h
> >>@@ -214,6 +214,37 @@ struct mm_struct;
> >>  extern void exit_aio(struct mm_struct *mm);
> >>  extern long do_io_submit(aio_context_t ctx_id, long nr,
> >>  			 struct iocb __user *__user *iocbpp, bool compat);
> >>+extern void __put_ioctx(struct kioctx *ctx);
> >>+extern struct kioctx *ioctx_alloc(unsigned nr_events);
> >>+extern struct kiocb *aio_get_req(struct kioctx *ctx);
> >>+extern ssize_t aio_run_iocb(struct kiocb *iocb);
> >>+extern int __aio_run_iocbs(struct kioctx *ctx);
> >>+extern int read_events(struct kioctx *ctx,
> >>+                        long min_nr, long nr,
> >>+                        struct io_event __user *event,
> >>+                        struct timespec __user *timeout);
> >>+extern void io_destroy(struct kioctx *ioctx);
> >>+extern ssize_t aio_setup_iocb(struct kiocb *kiocb, bool compat);
> >>+extern void __put_ioctx(struct kioctx *ctx);
> >>+
> >>+static inline void get_ioctx(struct kioctx *kioctx)
> >>+{
> >>+        BUG_ON(atomic_read(&kioctx->users)<= 0);
> >>+        atomic_inc(&kioctx->users);
> >>+}
> >>+
> >>+static inline int try_get_ioctx(struct kioctx *kioctx)
> >>+{
> >>+        return atomic_inc_not_zero(&kioctx->users);
> >>+}
> >>+
> >>+static inline void put_ioctx(struct kioctx *kioctx)
> >>+{
> >>+        BUG_ON(atomic_read(&kioctx->users)<= 0);
> >>+        if (unlikely(atomic_dec_and_test(&kioctx->users)))
> >>+                __put_ioctx(kioctx);
> >>+}
> >>+
> >>  #else
> >>  static inline ssize_t wait_on_sync_kiocb(struct kiocb *iocb) { return 0; }
> >>  static inline int aio_put_req(struct kiocb *iocb) { return 0; }
> >>-- 
> >>1.7.5.1
> 
> Other comments will be addressed in V2. Thanks
> 
> Yuan
