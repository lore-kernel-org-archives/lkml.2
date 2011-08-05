Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756066Ab1HELEz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Aug 2011 07:04:55 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:43922 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751707Ab1HELEx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Aug 2011 07:04:53 -0400
Message-ID: <4E3BCE4D.7090809@gmail.com>
Date: Fri, 05 Aug 2011 19:04:45 +0800
From: Liu Yuan <namei.unix@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.18) Gecko/20110617 Thunderbird/3.1.11
MIME-Version: 1.0
To: Badari Pulavarty <pbadari@us.ibm.com>
CC: Stefan Hajnoczi <stefanha@gmail.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Rusty Russell <rusty@rustcorp.com.au>, Avi Kivity <avi@redhat.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Khoa Huynh <khoa@us.ibm.com>
Subject: Re: [RFC PATCH]vhost-blk: In-kernel accelerator for virtio block
 device
References: <1311863346-4338-1-git-send-email-namei.unix@gmail.com>	 <CAJSP0QUKz7LFuARF_n2LcBi_uuSzfmkjrWsHAWrXXkEaQJKkEA@mail.gmail.com>	 <4E325F98.5090308@gmail.com> <4E32F7F2.4080607@us.ibm.com>	 <4E363DB9.70801@gmail.com> <1312495132.9603.4.camel@badari-desktop>
In-Reply-To: <1312495132.9603.4.camel@badari-desktop>
Content-Type: multipart/mixed;
 boundary="------------000900080900090904050305"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------000900080900090904050305
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

On 08/05/2011 05:58 AM, Badari Pulavarty wrote:
> Hi Liu Yuan,
>
> I started testing your patches. I applied your kernel patch to 3.0
> and applied QEMU to latest git.
>
> I passed 6 blockdevices from the host to guest (4 vcpu, 4GB RAM).
> I ran simple "dd" read tests from the guest on all block devices
> (with various blocksizes, iflag=direct).
>
> Unfortunately, system doesn't stay up. I immediately get into
> panic on the host. I didn't get time to debug the problem. Wondering
> if you have seen this issue before and/or you have new patchset
> to try ?
>
> Let me know.
>
> Thanks,
> Badari
>

Okay, it is actually a bug pointed out by MST on the other thread, that 
it needs a mutex for completion thread.

Now would you please this attachment?This patch only applies to kernel 
part, on top of v1 kernel patch.

This patch mainly moves completion thread into vhost thread as a 
function. As a result, both requests submitting and completion 
signalling is in the same thread.

Yuan

--------------000900080900090904050305
Content-Type: text/x-patch;
 name="vblk-for-kernel-2.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="vblk-for-kernel-2.patch"

diff --git a/drivers/vhost/blk.c b/drivers/vhost/blk.c
index ecaf6fe..5cba543 100644
--- a/drivers/vhost/blk.c
+++ b/drivers/vhost/blk.c
@@ -47,6 +47,7 @@ struct vhost_blk {
 	struct eventfd_ctx *ectx;
 	struct file *efile;
 	struct task_struct *worker;
+	struct vhost_poll poll;
 };
 
 struct used_info {
@@ -62,6 +63,7 @@ static struct kmem_cache *used_info_cachep;
 static void blk_flush(struct vhost_blk *blk)
 {
        vhost_poll_flush(&blk->vq.poll);
+       vhost_poll_flush(&blk->poll);
 }
 
 static long blk_set_features(struct vhost_blk *blk, u64 features)
@@ -146,11 +148,11 @@ static long blk_reset_owner(struct vhost_blk *b)
         blk_stop(b);
         blk_flush(b);
         ret = vhost_dev_reset_owner(&b->dev);
-	if (b->worker) {
-		b->should_stop = 1;
-		smp_mb();
-		eventfd_signal(b->ectx, 1);
-	}
+//	if (b->worker) {
+//		b->should_stop = 1;
+//		smp_mb();
+//		eventfd_signal(b->ectx, 1);
+//	}
 err:
         mutex_unlock(&b->dev.mutex);
         return ret;
@@ -323,6 +325,7 @@ static void completion_thread_destory(struct vhost_blk *blk)
 
 static long blk_set_owner(struct vhost_blk *blk)
 {
+	eventfd_signal(blk->ectx, 1);
 	return completion_thread_setup(blk);
 }
 
@@ -361,8 +364,8 @@ static long vhost_blk_ioctl(struct file *f, unsigned int ioctl,
 		default:
 			mutex_lock(&blk->dev.mutex);
 			ret = vhost_dev_ioctl(&blk->dev, ioctl, arg);
-			if (!ret && ioctl == VHOST_SET_OWNER)
-				ret = blk_set_owner(blk);
+//			if (!ret && ioctl == VHOST_SET_OWNER)
+//				ret = blk_set_owner(blk);
 			blk_flush(blk);
 			mutex_unlock(&blk->dev.mutex);
 			break;
@@ -480,10 +483,51 @@ static void handle_guest_kick(struct vhost_work *work)
 	handle_kick(blk);
 }
 
+static void handle_completetion(struct vhost_work* work)
+{
+	struct vhost_blk *blk = container_of(work, struct vhost_blk, poll.work);
+	struct timespec ts = { 0 };
+	int ret, i, nr;
+	u64 count;
+
+	do {
+		ret = eventfd_ctx_read(blk->ectx, 1, &count);
+	} while (unlikely(ret == -ERESTARTSYS));
+
+	do {
+		nr = kernel_read_events(blk->ioctx, count, MAX_EVENTS, events, &ts);
+	} while (unlikely(nr == -EINTR));
+	dprintk("%s, count %llu, nr %d\n", __func__, count, nr);
+
+	if (unlikely(nr <= 0))
+		return;
+
+	for (i = 0; i < nr; i++) {
+		struct used_info *u = (struct used_info *)events[i].obj;
+		int len, status;
+
+		dprintk("%s, head %d complete in %d\n", __func__, u->head, i);
+		len = io_event_ret(&events[i]);
+		//status = u->len == len ? VIRTIO_BLK_S_OK : VIRTIO_BLK_S_IOERR;
+		status = len > 0 ? VIRTIO_BLK_S_OK : VIRTIO_BLK_S_IOERR;
+		if (copy_to_user(u->status, &status, sizeof status)) {
+			vq_err(&blk->vq, "%s failed to write status\n", __func__);
+			BUG(); /* FIXME: maybe a bit radical? */
+		}
+		vhost_add_used(&blk->vq, u->head, u->len);
+		kfree(u);
+	}
+
+	vhost_signal(&blk->dev, &blk->vq);
+}
+
 static void eventfd_setup(struct vhost_blk *blk)
 {
+	//struct vhost_virtqueue *vq = &blk->vq;
 	blk->efile = eventfd_file_create(0, 0);
 	blk->ectx = eventfd_ctx_fileget(blk->efile);
+	vhost_poll_init(&blk->poll, handle_completetion, POLLIN, &blk->dev);
+	vhost_poll_start(&blk->poll, blk->efile);
 }
 
 static int vhost_blk_open(struct inode *inode, struct file *f)
@@ -528,7 +572,7 @@ static int vhost_blk_release(struct inode *inode, struct file *f)
 	vhost_dev_cleanup(&blk->dev);
 	/* Yet another flush? See comments in vhost_net_release() */
 	blk_flush(blk);
-	completion_thread_destory(blk);
+//	completion_thread_destory(blk);
 	eventfd_destroy(blk);
 	kfree(blk);
 

--------------000900080900090904050305--
