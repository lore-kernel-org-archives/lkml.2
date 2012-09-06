Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759446Ab2IFDBP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 23:01:15 -0400
Received: from ozlabs.org ([203.10.76.45]:53136 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755189Ab2IFDA4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 23:00:56 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Sasha Levin <levinsasha928@gmail.com>,
        "Michael S. Tsirkin" <mst@redhat.com>
Cc: virtualization@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        avi@redhat.com, kvm@vger.kernel.org
Subject: Re: [PATCH v2 2/2] virtio-ring: Allocate indirect buffers from cache when possible
In-Reply-To: <503CC904.3050207@gmail.com>
References: <1346159043-16446-1-git-send-email-levinsasha928@gmail.com> <1346159043-16446-2-git-send-email-levinsasha928@gmail.com> <20120828132032.GB2039@redhat.com> <503CC904.3050207@gmail.com>
User-Agent: Notmuch/0.13.2 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Thu, 06 Sep 2012 09:32:14 +0930
Message-ID: <874nncj9x5.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sasha Levin <levinsasha928@gmail.com> writes:

> On 08/28/2012 03:20 PM, Michael S. Tsirkin wrote:
>> On Tue, Aug 28, 2012 at 03:04:03PM +0200, Sasha Levin wrote:
>>> Currently if VIRTIO_RING_F_INDIRECT_DESC is enabled we will
>>> use indirect descriptors and allocate them using a simple
>>> kmalloc().
>>>
>>> This patch adds a cache which will allow indirect buffers under
>>> a configurable size to be allocated from that cache instead.
>>>
>>> Signed-off-by: Sasha Levin <levinsasha928@gmail.com>
>> 
>> I imagine this helps performance? Any numbers?
>
> I ran benchmarks on the original RFC, I've re-tested it now and got similar
> numbers to the original ones (virtio-net using vhost-net, thresh=16):
>
> Before:
> 	Recv   Send    Send
> 	Socket Socket  Message  Elapsed
> 	Size   Size    Size     Time     Throughput
> 	bytes  bytes   bytes    secs.    10^6bits/sec
>
> 	 87380  16384  16384    10.00    4512.12
>
> After:
> 	Recv   Send    Send
> 	Socket Socket  Message  Elapsed
> 	Size   Size    Size     Time     Throughput
> 	bytes  bytes   bytes    secs.    10^6bits/sec
>
> 	 87380  16384  16384    10.00    5399.18

I have an older patch which adjusts the threshold dynamically, can you
compare?  User-adjustable thresholds are statistically never adjusted :(

virtio: use indirect buffers based on demand (heuristic)

virtio_ring uses a ring buffer of descriptors: indirect support allows
a single descriptor to refer to a table of descriptors.  This saves
space in the ring, but requires a kmalloc/kfree.

Rather than try to figure out what the right threshold at which to use
indirect buffers, we drop the threshold dynamically when the ring is
under stress.

Note: to stress this, I reduced the ring size to 32 in lguest, and a
1G send reduced the threshold to 9.

Note2: I moved the BUG_ON()s above the indirect test, where they belong
(indirect falls thru on OOM, so the constraints still apply).

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 drivers/virtio/virtio_ring.c |   61 ++++++++++++++++++++++++++++++++++++-------
 1 file changed, 52 insertions(+), 9 deletions(-)

diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
--- a/drivers/virtio/virtio_ring.c
+++ b/drivers/virtio/virtio_ring.c
@@ -89,6 +89,8 @@ struct vring_virtqueue
 
 	/* Host supports indirect buffers */
 	bool indirect;
+	/* Threshold before we go indirect. */
+	unsigned int indirect_threshold;
 
 	/* Host publishes avail event idx */
 	bool event;
@@ -174,6 +176,34 @@ static int vring_add_indirect(struct vri
 	return head;
 }
 
+static void adjust_threshold(struct vring_virtqueue *vq,
+			     unsigned int out, unsigned int in)
+{
+	/* There are really two species of virtqueue, and it matters here.
+	 * If there are no output parts, it's a "normally full" receive queue,
+	 * otherwise it's a "normally empty" send queue. */
+	if (out) {
+		/* Leave threshold unless we're full. */
+		if (out + in < vq->num_free)
+			return;
+	} else {
+		/* Leave threshold unless we're empty. */
+		if (vq->num_free != vq->vring.num)
+			return;
+	}
+
+	/* Never drop threshold below 1 */
+	vq->indirect_threshold /= 2;
+	vq->indirect_threshold |= 1;
+
+#if 0
+	printk("%s %s: indirect threshold %u (%u+%u vs %u)\n",
+	       dev_name(&vq->vq.vdev->dev),
+	       vq->vq.name, vq->indirect_threshold,
+	       out, in, vq->num_free);
+#endif
+}
+
 int virtqueue_get_queue_index(struct virtqueue *_vq)
 {
 	struct vring_virtqueue *vq = to_vvq(_vq);
@@ -226,17 +256,32 @@ int virtqueue_add_buf(struct virtqueue *
 	}
 #endif
 
-	/* If the host supports indirect descriptor tables, and we have multiple
-	 * buffers, then go indirect. FIXME: tune this threshold */
-	if (vq->indirect && (out + in) > 1 && vq->num_free) {
-		head = vring_add_indirect(vq, sg, out, in, gfp);
-		if (likely(head >= 0))
-			goto add_head;
-	}
-
 	BUG_ON(out + in > vq->vring.num);
 	BUG_ON(out + in == 0);
 
+
+	/* If the host supports indirect descriptor tables, consider it. */
+	if (vq->indirect) {
+		bool try_indirect;
+
+		/* We tweak the threshold automatically. */
+		adjust_threshold(vq, out, in);
+
+		/* If we can't fit any at all, fall through. */
+		if (vq->num_free == 0)
+			try_indirect = false;
+		else if (out + in > vq->num_free)
+			try_indirect = true;
+		else
+			try_indirect = (out + in > vq->indirect_threshold);
+
+		if (try_indirect) {
+			head = vring_add_indirect(vq, sg, out, in);
+			if (head != vq->vring.num)
+				goto add_head;
+		}
+	}
+
 	if (vq->num_free < out + in) {
 		pr_debug("Can't add buf len %i - avail = %i\n",
 			 out + in, vq->num_free);
@@ -666,6 +711,7 @@ struct virtqueue *vring_new_virtqueue(un
 #endif
 
 	vq->indirect = virtio_has_feature(vdev, VIRTIO_RING_F_INDIRECT_DESC);
+	vq->indirect_threshold = num;
 	vq->event = virtio_has_feature(vdev, VIRTIO_RING_F_EVENT_IDX);
 
 	/* No callback?  Tell other side not to bother us. */


