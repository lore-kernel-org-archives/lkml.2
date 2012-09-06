Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759504Ab2IFDB5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 23:01:57 -0400
Received: from ozlabs.org ([203.10.76.45]:52285 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754679Ab2IFDAz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 23:00:55 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Sasha Levin <levinsasha928@gmail.com>,
        "Michael S. Tsirkin" <mst@redhat.com>
Cc: virtualization@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        avi@redhat.com, kvm@vger.kernel.org
Subject: Re: [PATCH v2 2/2] virtio-ring: Allocate indirect buffers from cache when possible
In-Reply-To: <503E4873.6060607@gmail.com>
References: <1346159043-16446-1-git-send-email-levinsasha928@gmail.com> <1346159043-16446-2-git-send-email-levinsasha928@gmail.com> <20120828132032.GB2039@redhat.com> <503CC904.3050207@gmail.com> <20120829110748.GB5970@redhat.com> <503E2F27.5060904@gmail.com> <20120829153833.GE7407@redhat.com> <503E4873.6060607@gmail.com>
User-Agent: Notmuch/0.13.2 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Thu, 06 Sep 2012 10:32:48 +0930
Message-ID: <871uigj747.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sasha Levin <levinsasha928@gmail.com> writes:
>> On Wed, Aug 29, 2012 at 05:03:03PM +0200, Sasha Levin wrote:
>>> I've also re-ran it on a IBM server type host instead of my laptop. Here are the
>>> results:
>>>
>>> Vanilla kernel:
>>>
>>> MIGRATED TCP STREAM TEST from 0.0.0.0 (0.0.0.0) port 0 AF_INET to 192.168.33.1
>>> () port 0 AF_INET
>>> enable_enobufs failed: getprotobyname
>>> Recv   Send    Send
>>> Socket Socket  Message  Elapsed
>>> Size   Size    Size     Time     Throughput
>>> bytes  bytes   bytes    secs.    10^6bits/sec
>>>
>>>  87380  16384  16384    10.00    7922.72
>>>
>>> Patch 1, with threshold=16:
>>>
>>> MIGRATED TCP STREAM TEST from 0.0.0.0 (0.0.0.0) port 0 AF_INET to 192.168.33.1
>>> () port 0 AF_INET
>>> enable_enobufs failed: getprotobyname
>>> Recv   Send    Send
>>> Socket Socket  Message  Elapsed
>>> Size   Size    Size     Time     Throughput
>>> bytes  bytes   bytes    secs.    10^6bits/sec
>>>
>>>  87380  16384  16384    10.00    8415.07
>>>
>>> Patch 2:
>>>
>>> MIGRATED TCP STREAM TEST from 0.0.0.0 (0.0.0.0) port 0 AF_INET to 192.168.33.1
>>> () port 0 AF_INET
>>> enable_enobufs failed: getprotobyname
>>> Recv   Send    Send
>>> Socket Socket  Message  Elapsed
>>> Size   Size    Size     Time     Throughput
>>> bytes  bytes   bytes    secs.    10^6bits/sec
>>>
>>>  87380  16384  16384    10.00    8931.05
>>>
>>>
>>> Note that these are simple tests with netperf listening on one end and a simple
>>> 'netperf -H [host]' within the guest. If there are other tests which may be
>>> interesting please let me know.

It might be worth just unconditionally having a cache for the 2
descriptor case.  This is what I get with qemu tap, though for some
reason the device features don't have guest or host CSUM, so my setup is
probably screwed:

Queue histogram for virtio0:
Size distribution for input (max=128427):
  1: 128427  ################################################################
Size distribution for output (max=256485):
  2: 256485  ################################################################
Size distribution for control (max=10):
  3: 10      ################################################################
  4: 5       ################################

Here's a patch, what do you get (run ifconfig to trigger the dump; yeah,
it's a hack!)

Hack: histogram of buffer sizes for virtio devices.

Currently triggered by a stats query (eg ifconfig) on a net device.

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -727,6 +727,8 @@ static struct rtnl_link_stats64 *virtnet
 	tot->rx_length_errors = dev->stats.rx_length_errors;
 	tot->rx_frame_errors = dev->stats.rx_frame_errors;
 
+	virtio_dev_dump_histogram(vi->vdev);
+
 	return tot;
 }
 
diff --git a/drivers/virtio/virtio.c b/drivers/virtio/virtio.c
--- a/drivers/virtio/virtio.c
+++ b/drivers/virtio/virtio.c
@@ -108,6 +108,16 @@ void virtio_check_driver_offered_feature
 }
 EXPORT_SYMBOL_GPL(virtio_check_driver_offered_feature);
 
+void virtio_dev_dump_histogram(const struct virtio_device *vdev)
+{
+	const struct virtqueue *vq;
+
+	printk("Queue histogram for %s:\n", dev_name(&vdev->dev));
+	list_for_each_entry(vq, &vdev->vqs, list)
+		virtqueue_dump_histogram(vq);
+}
+EXPORT_SYMBOL_GPL(virtio_dev_dump_histogram);
+
 static int virtio_dev_probe(struct device *_d)
 {
 	int err, i;
diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
--- a/drivers/virtio/virtio_ring.c
+++ b/drivers/virtio/virtio_ring.c
@@ -120,6 +120,8 @@ struct vring_virtqueue
 	ktime_t last_add_time;
 #endif
 
+	unsigned int *histo;
+
 	/* Tokens for callbacks. */
 	void *data[];
 };
@@ -259,6 +261,8 @@ int virtqueue_add_buf(struct virtqueue *
 	BUG_ON(out + in > vq->vring.num);
 	BUG_ON(out + in == 0);
 
+	vq->histo[out+in]++;
+
 	/* If the host supports indirect descriptor tables, consider it. */
 	if (vq->indirect) {
 		bool try_indirect;
@@ -726,6 +730,7 @@ struct virtqueue *vring_new_virtqueue(un
 	}
 	vq->data[i] = NULL;
 
+	vq->histo = kzalloc(num * sizeof(vq->histo[0]), GFP_KERNEL);
 	return &vq->vq;
 }
 EXPORT_SYMBOL_GPL(vring_new_virtqueue);
@@ -772,4 +777,33 @@ unsigned int virtqueue_get_vring_size(st
 }
 EXPORT_SYMBOL_GPL(virtqueue_get_vring_size);
 
+void virtqueue_dump_histogram(const struct virtqueue *_vq)
+{
+	const struct vring_virtqueue *vq = to_vvq(_vq);
+	int i, j, start = 0, end = 0, max = 1;
+	char line[120];
+
+	for (i = 0; i < vq->vring.num; i++) {
+		if (!vq->histo[i])
+			continue;
+
+		end = i;
+		if (!vq->histo[start])
+			start = i;
+
+		if (vq->histo[i] > max)
+			max = vq->histo[i];
+	}
+
+	printk("Size distribution for %s (max=%u):\n", _vq->name, max);
+	for (i = start; i <= end; i++) {
+		unsigned int off;
+		off = sprintf(line, "%3u: %-7u ", i, vq->histo[i]);
+		for (j = 0; j < vq->histo[i] * 64 / max; j++)
+			line[off++] = '#';
+		line[off] = '\0';
+		printk("%s\n", line);
+	}
+}
+
 MODULE_LICENSE("GPL");
diff --git a/include/linux/virtio.h b/include/linux/virtio.h
--- a/include/linux/virtio.h
+++ b/include/linux/virtio.h
@@ -52,6 +52,9 @@ unsigned int virtqueue_get_vring_size(st
 
 int virtqueue_get_queue_index(struct virtqueue *vq);
 
+void virtio_dev_dump_histogram(const struct virtio_device *vdev);
+void virtqueue_dump_histogram(const struct virtqueue *vq);
+
 /**
  * virtio_device - representation of a device using virtio
  * @index: unique position on the virtio bus
