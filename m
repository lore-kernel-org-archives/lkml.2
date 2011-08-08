Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753763Ab1HHHb5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Aug 2011 03:31:57 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:48265 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753176Ab1HHHb4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Aug 2011 03:31:56 -0400
Message-ID: <4E3F90E3.9080600@gmail.com>
Date: Mon, 08 Aug 2011 15:31:47 +0800
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
References: <1311863346-4338-1-git-send-email-namei.unix@gmail.com> <CAJSP0QUKz7LFuARF_n2LcBi_uuSzfmkjrWsHAWrXXkEaQJKkEA@mail.gmail.com> <4E325F98.5090308@gmail.com> <4E32F7F2.4080607@us.ibm.com> <4E363DB9.70801@gmail.com> <1312495132.9603.4.camel@badari-desktop> <4E3BCE4D.7090809@gmail.com> <4E3C302A.3040500@us.ibm.com> <4E3F3D4E.70104@gmail.com> <4E3F6E72.1000907@us.ibm.com>
In-Reply-To: <4E3F6E72.1000907@us.ibm.com>
Content-Type: multipart/mixed;
 boundary="------------040907030002040109090908"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------040907030002040109090908
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

On 08/08/2011 01:04 PM, Badari Pulavarty wrote:
> On 8/7/2011 6:35 PM, Liu Yuan wrote:
>> On 08/06/2011 02:02 AM, Badari Pulavarty wrote:
>>> On 8/5/2011 4:04 AM, Liu Yuan wrote:
>>>> On 08/05/2011 05:58 AM, Badari Pulavarty wrote:
>>>>> Hi Liu Yuan,
>>>>>
>>>>> I started testing your patches. I applied your kernel patch to 3.0
>>>>> and applied QEMU to latest git.
>>>>>
>>>>> I passed 6 blockdevices from the host to guest (4 vcpu, 4GB RAM).
>>>>> I ran simple "dd" read tests from the guest on all block devices
>>>>> (with various blocksizes, iflag=direct).
>>>>>
>>>>> Unfortunately, system doesn't stay up. I immediately get into
>>>>> panic on the host. I didn't get time to debug the problem. Wondering
>>>>> if you have seen this issue before and/or you have new patchset
>>>>> to try ?
>>>>>
>>>>> Let me know.
>>>>>
>>>>> Thanks,
>>>>> Badari
>>>>>
>>>>
>>>> Okay, it is actually a bug pointed out by MST on the other thread, 
>>>> that it needs a mutex for completion thread.
>>>>
>>>> Now would you please this attachment?This patch only applies to 
>>>> kernel part, on top of v1 kernel patch.
>>>>
>>>> This patch mainly moves completion thread into vhost thread as a 
>>>> function. As a result, both requests submitting and completion 
>>>> signalling is in the same thread.
>>>>
>>>> Yuan
>>>
>>> Unfortunately, "dd" tests (4 out of 6) in the guest hung. I see 
>>> following messages
>>>
>>> virtio_blk virtio2: requests: id 0 is not a head !
>>> virtio_blk virtio3: requests: id 1 is not a head !
>>> virtio_blk virtio5: requests: id 1 is not a head !
>>> virtio_blk virtio1: requests: id 1 is not a head !
>>>
>>> I still see host panics. I will collect the host panic and see if 
>>> its still same or not.
>>>
>>> Thanks,
>>> Badari
>>>
>>>
>> Would you please show me how to reproduce it step by step? I tried dd 
>> with two block device attached, but didn't get hung nor panic.
>>
>> Yuan
>
> I did 6 "dd"s on 6 block devices..
>
> dd if=/dev/vdb of=/dev/null bs=1M iflag=direct &
> dd if=/dev/vdc of=/dev/null bs=1M iflag=direct &
> dd if=/dev/vdd of=/dev/null bs=1M iflag=direct &
> dd if=/dev/vde of=/dev/null bs=1M iflag=direct &
> dd if=/dev/vdf of=/dev/null bs=1M iflag=direct &
> dd if=/dev/vdg of=/dev/null bs=1M iflag=direct &
>
> I can reproduce the problem with in 3 minutes :(
>
> Thanks,
> Badari
>
>
Ah...I made an embarrassing mistake that I tried to 'free()' an 
kmem_cache object.

Would you please revert the vblk-for-kernel-2 patch and apply the new 
one attached in this letter?

Yuan,
Thanks

--------------040907030002040109090908
Content-Type: text/x-patch;
 name="vblk-for-kernel-2.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="vblk-for-kernel-2.patch"

diff --git a/drivers/vhost/blk.c b/drivers/vhost/blk.c
index ecaf6fe..7a24aba 100644
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
@@ -361,8 +363,8 @@ static long vhost_blk_ioctl(struct file *f, unsigned int ioctl,
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
@@ -480,10 +482,50 @@ static void handle_guest_kick(struct vhost_work *work)
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
+		kmem_cache_free(used_info_cachep, u);
+	}
+
+	vhost_signal(&blk->dev, &blk->vq);
+}
+
 static void eventfd_setup(struct vhost_blk *blk)
 {
 	blk->efile = eventfd_file_create(0, 0);
 	blk->ectx = eventfd_ctx_fileget(blk->efile);
+	vhost_poll_init(&blk->poll, handle_completetion, POLLIN, &blk->dev);
+	vhost_poll_start(&blk->poll, blk->efile);
 }
 
 static int vhost_blk_open(struct inode *inode, struct file *f)
@@ -528,7 +570,7 @@ static int vhost_blk_release(struct inode *inode, struct file *f)
 	vhost_dev_cleanup(&blk->dev);
 	/* Yet another flush? See comments in vhost_net_release() */
 	blk_flush(blk);
-	completion_thread_destory(blk);
+//	completion_thread_destory(blk);
 	eventfd_destroy(blk);
 	kfree(blk);
 

--------------040907030002040109090908--
