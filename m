Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933407Ab1ESXLR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 19:11:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32996 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933288Ab1ESXKw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 19:10:52 -0400
Date: Fri, 20 May 2011 02:10:27 +0300
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
Subject: [PATCHv2 02/14] virtio ring: inline function to check for events
Message-ID: <16ce853af7a80d0f7cb0c1118ba8e19adc184ad0.1305846412.git.mst@redhat.com>
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

With the new used_event and avail_event and features, both
host and guest need similar logic to check whether events are
enabled, so it helps to put the common code in the header.

Note that Xen has similar logic for notification hold-off
in include/xen/interface/io/ring.h with req_event and req_prod
corresponding to event_idx + 1 and new_idx respectively.
+1 comes from the fact that req_event and req_prod in Xen start at 1,
while event index in virtio starts at 0.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 include/linux/virtio_ring.h |   14 ++++++++++++++
 1 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/include/linux/virtio_ring.h b/include/linux/virtio_ring.h
index 70b0b39..cf020e3 100644
--- a/include/linux/virtio_ring.h
+++ b/include/linux/virtio_ring.h
@@ -123,6 +123,20 @@ static inline unsigned vring_size(unsigned int num, unsigned long align)
 		+ sizeof(__u16) * 3 + sizeof(struct vring_used_elem) * num;
 }
 
+/* The following is used with USED_EVENT_IDX and AVAIL_EVENT_IDX */
+/* Assuming a given event_idx value from the other size, if
+ * we have just incremented index from old to new_idx,
+ * should we trigger an event? */
+static inline int vring_need_event(__u16 event_idx, __u16 new_idx, __u16 old)
+{
+	/* Note: Xen has similar logic for notification hold-off
+	 * in include/xen/interface/io/ring.h with req_event and req_prod
+	 * corresponding to event_idx + 1 and new_idx respectively.
+	 * Note also that req_event and req_prod in Xen start at 1,
+	 * event indexes in virtio start at 0. */
+	return (__u16)(new_idx - event_idx - 1) < (__u16)(new_idx - old);
+}
+
 #ifdef __KERNEL__
 #include <linux/irqreturn.h>
 struct virtio_device;
-- 
1.7.5.53.gc233e

