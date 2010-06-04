Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757233Ab0FDCfB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 22:35:01 -0400
Received: from ozlabs.org ([203.10.76.45]:32933 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756997Ab0FDCfA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 22:35:00 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [PATCHv3 1/2] virtio: support layout with avail ring before idx
Date: Fri, 4 Jun 2010 12:04:57 +0930
User-Agent: KMail/1.13.2 (Linux/2.6.32-22-generic; KDE/4.4.2; i686; ; )
Cc: linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org,
       kvm@vger.kernel.org, qemu-devel@nongnu.org,
       Andrew Morton <akpm@linux-foundation.org>
References: <cover.1275403477.git.mst@redhat.com> <10a74b58c908bad64ff890c881e2b2de88687f0e.1275403477.git.mst@redhat.com>
In-Reply-To: <10a74b58c908bad64ff890c881e2b2de88687f0e.1275403477.git.mst@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201006041204.57973.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2 Jun 2010 12:17:12 am Michael S. Tsirkin wrote:
> This adds an (unused) option to put available ring before control (avail
> index, flags), and adds padding between index and flags. This avoids
> cache line sharing between control and ring, and also makes it possible
> to extend avail control without incurring extra cache misses.
> 
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

No no no no.  254?  You're trying to Morton me![1]

How's this (untested):

diff --git a/include/linux/virtio_ring.h b/include/linux/virtio_ring.h
--- a/include/linux/virtio_ring.h
+++ b/include/linux/virtio_ring.h
@@ -74,8 +74,8 @@ struct vring {
 /* The standard layout for the ring is a continuous chunk of memory which looks
  * like this.  We assume num is a power of 2.
  *
- * struct vring
- * {
+ * struct vring {
+ *	*** The driver writes to this part.
  *	// The actual descriptors (16 bytes each)
  *	struct vring_desc desc[num];
  *
@@ -84,9 +84,11 @@ struct vring {
  *	__u16 avail_idx;
  *	__u16 available[num];
  *
- *	// Padding to the next align boundary.
+ *	// Padding so used_flags is on the next align boundary.
  *	char pad[];
+ *	__u16 last_used; // On a cacheline of its own.
  *
+ *	*** The device writes to this part.
  *	// A ring of used descriptor heads with free-running index.
  *	__u16 used_flags;
  *	__u16 used_idx;
@@ -110,6 +112,12 @@ static inline unsigned vring_size(unsign
 		+ sizeof(__u16) * 2 + sizeof(struct vring_used_elem) * num;
 }
 
+/* Last used index sits at the very end of the driver part of the struct */
+static inline __u16 *vring_last_used_idx(const struct vring *vr)
+{
+	return (__u16 *)vr->used - 1;
+}
+
 #ifdef __KERNEL__
 #include <linux/irqreturn.h>
 struct virtio_device;

Cheers,
Rusty.
[1] Andrew Morton has this technique where he posts a solution so ugly it
    forces others to fix it properly.  Ego-roping, basically.
