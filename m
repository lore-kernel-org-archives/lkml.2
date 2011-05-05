Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755118Ab1EEPJz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 11:09:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44237 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754130Ab1EEPJK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 11:09:10 -0400
Date: Thu, 5 May 2011 18:08:10 +0300
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
Subject: [PATCH 2/3] virtio_ring: check used_event offset
Message-ID: <09cf2579f7892eed2bf63daad3ee9b79cfd67b68.1304605817.git.mst@redhat.com>
References: <cover.1304605816.git.mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1304605816.git.mst@redhat.com>
X-Mutt-Fcc: =sent
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nothing's wrong with vring_size as is, but it's nice
to check that the new field in the avail ring
won't overlow into the used ring.

Reported-by: Tom Lendacky <tahm@linux.vnet.ibm.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 include/linux/virtio_ring.h |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/include/linux/virtio_ring.h b/include/linux/virtio_ring.h
index 2a3b0ea..089cbf2 100644
--- a/include/linux/virtio_ring.h
+++ b/include/linux/virtio_ring.h
@@ -119,7 +119,13 @@ static inline void vring_init(struct vring *vr, unsigned int num, void *p,
 
 static inline unsigned vring_size(unsigned int num, unsigned long align)
 {
-	return ((sizeof(struct vring_desc) * num + sizeof(__u16) * (2 + num)
+#ifdef __KERNEL__
+	/* Older versions did not have used_event field at the end of the
+	 * avail ring. Used ring offset must be compatible with such devices. */
+	size_t s = sizeof(struct vring_desc) * num + sizeof(__u16) * (2 + num);
+	BUG_ON(ALIGN(s, align) != ALIGN(s + sizeof(__u16), align));
+#endif
+	return ((sizeof(struct vring_desc) * num + sizeof(__u16) * (3 + num)
 		 + align - 1) & ~(align - 1))
 		+ sizeof(__u16) * 3 + sizeof(struct vring_used_elem) * num;
 }
-- 
1.7.5.53.gc233e

