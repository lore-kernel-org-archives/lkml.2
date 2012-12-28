Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754869Ab2L1T0o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2012 14:26:44 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:55650 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932428Ab2L1TTm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2012 14:19:42 -0500
Message-Id: <20121228190337.486886273@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Fri, 28 Dec 2012 20:04:06 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Will Deacon <will.deacon@arm.com>,
        Sasha Levin <levinsasha928@gmail.com>,
        Rusty Russell <rusty@rustcorp.com.au>
Subject: [ 036/173] virtio: 9p: correctly pass physical address to userspace for high
 pages
In-Reply-To: <20121228190330.025298996@decadent.org.uk>
X-SA-Exim-Connect-IP: 151.217.219.220
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Will Deacon <will.deacon@arm.com>

commit b9cdc88df8e63e81c723b82c286fc97f5d0dc325 upstream.

When using a virtio transport, the 9p net device may pass the physical
address of a kernel buffer to userspace via a scatterlist inside a
virtqueue. If the kernel buffer is mapped outside of the linear mapping
(e.g. highmem), then virt_to_page will return a bogus value and we will
populate the scatterlist with junk.

This patch uses kmap_to_page when populating the page array for a kernel
buffer.

Cc: Sasha Levin <levinsasha928@gmail.com>
Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/9p/trans_virtio.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/9p/trans_virtio.c b/net/9p/trans_virtio.c
index 35b8911..fd05c81 100644
--- a/net/9p/trans_virtio.c
+++ b/net/9p/trans_virtio.c
@@ -39,6 +39,7 @@
 #include <linux/inet.h>
 #include <linux/idr.h>
 #include <linux/file.h>
+#include <linux/highmem.h>
 #include <linux/slab.h>
 #include <net/9p/9p.h>
 #include <linux/parser.h>
@@ -325,7 +326,7 @@ static int p9_get_mapped_pages(struct virtio_chan *chan,
 		int count = nr_pages;
 		while (nr_pages) {
 			s = rest_of_page(data);
-			pages[index++] = virt_to_page(data);
+			pages[index++] = kmap_to_page(data);
 			data += s;
 			nr_pages--;
 		}


