Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933279Ab1ESXKo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 19:10:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30711 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932336Ab1ESXKm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 19:10:42 -0400
Date: Fri, 20 May 2011 02:10:17 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Rusty Russell <rusty@rustcorp.com.au>, Carsten Otte <cotte@de.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>, linux390@de.ibm.com,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Shirley Ma <xma@us.ibm.com>, lguest@lists.ozlabs.org,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        Krishna Kumar <krkumar2@in.ibm.com>,
        Tom Lendacky <tahm@linux.vnet.ibm.com>, steved@us.ibm.com,
        habanero@linux.vnet.ibm.com
Subject: [PATCHv2 01/14] virtio: event index interface
Message-ID: <995d19795d84a76f9836f4d9484fb4ef8eae36e9.1305846412.git.mst@redhat.com>
References: <cover.1305846412.git.mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1305846412.git.mst@redhat.com>
X-Mutt-Fcc: =sent
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Define a new feature bit for the guest and host to utilize
an event index (like Xen) instead if a flag bit to enable/disable
interrupts and kicks.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 include/linux/virtio_ring.h |   15 ++++++++++++++-
 1 files changed, 14 insertions(+), 1 deletions(-)

diff --git a/include/linux/virtio_ring.h b/include/linux/virtio_ring.h
index e4d144b..70b0b39 100644
--- a/include/linux/virtio_ring.h
+++ b/include/linux/virtio_ring.h
@@ -29,6 +29,12 @@
 /* We support indirect buffer descriptors */
 #define VIRTIO_RING_F_INDIRECT_DESC	28
 
+/* The Guest publishes the used index for which it expects an interrupt
+ * at the end of the avail ring. Host should ignore the avail->flags field. */
+/* The Host publishes the avail index for which it expects a kick
+ * at the end of the used ring. Guest should ignore the used->flags field. */
+#define VIRTIO_RING_F_EVENT_IDX		29
+
 /* Virtio ring descriptors: 16 bytes.  These can chain together via "next". */
 struct vring_desc {
 	/* Address (guest-physical). */
@@ -83,6 +89,7 @@ struct vring {
  *	__u16 avail_flags;
  *	__u16 avail_idx;
  *	__u16 available[num];
+ *	__u16 used_event_idx;
  *
  *	// Padding to the next align boundary.
  *	char pad[];
@@ -91,8 +98,14 @@ struct vring {
  *	__u16 used_flags;
  *	__u16 used_idx;
  *	struct vring_used_elem used[num];
+ *	__u16 avail_event_idx;
  * };
  */
+/* We publish the used event index at the end of the available ring, and vice
+ * versa. They are at the end for backwards compatibility. */
+#define vring_used_event(vr) ((vr)->avail->ring[(vr)->num])
+#define vring_avail_event(vr) (*(__u16 *)&(vr)->used->ring[(vr)->num])
+
 static inline void vring_init(struct vring *vr, unsigned int num, void *p,
 			      unsigned long align)
 {
@@ -107,7 +120,7 @@ static inline unsigned vring_size(unsigned int num, unsigned long align)
 {
 	return ((sizeof(struct vring_desc) * num + sizeof(__u16) * (2 + num)
 		 + align - 1) & ~(align - 1))
-		+ sizeof(__u16) * 2 + sizeof(struct vring_used_elem) * num;
+		+ sizeof(__u16) * 3 + sizeof(struct vring_used_elem) * num;
 }
 
 #ifdef __KERNEL__
-- 
1.7.5.53.gc233e

