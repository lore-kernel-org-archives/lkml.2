Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754891Ab0E3U1x (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 May 2010 16:27:53 -0400
Received: from mgw1.diku.dk ([130.225.96.91]:36193 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754405Ab0E3U1v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 May 2010 16:27:51 -0400
Date: Sun, 30 May 2010 22:27:46 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: Greg Kroah-Hartman <gregkh@suse.de>, devel@driverdev.osuosl.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 2/3] drivers/staging: Use GFP_ATOMIC when a lock is held
Message-ID: <Pine.LNX.4.64.1005302227290.19253@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

In each case, the containing function is only called from one place, where
a spin lock is held.

The semantic patch that makes this change is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@gfp exists@
identifier fn;
position p;
@@

fn(...) {
... when != spin_unlock
    when any
  GFP_KERNEL@p
 ... when any
}

@locked@
identifier gfp.fn;
@@

spin_lock(...)
... when != spin_unlock
fn(...)

@depends on locked@
position gfp.p;
@@

- GFP_KERNEL@p
+ GFP_ATOMIC
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/staging/iio/ring_sw.c              |    2 +-
 drivers/staging/vme/bridges/vme_ca91cx42.c |    2 +-
 drivers/staging/vme/bridges/vme_tsi148.c   |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff -u -p a/drivers/staging/iio/ring_sw.c b/drivers/staging/iio/ring_sw.c
--- a/drivers/staging/iio/ring_sw.c
+++ b/drivers/staging/iio/ring_sw.c
@@ -20,7 +20,7 @@ static inline int __iio_allocate_sw_ring
 	if ((length == 0) || (bytes_per_datum == 0))
 		return -EINVAL;
 	__iio_update_ring_buffer(&ring->buf, bytes_per_datum, length);
-	ring->data = kmalloc(length*ring->buf.bpd, GFP_KERNEL);
+	ring->data = kmalloc(length*ring->buf.bpd, GFP_ATOMIC);
 	ring->read_p = NULL;
 	ring->write_p = NULL;
 	ring->last_written_p = NULL;
diff -u -p a/drivers/staging/vme/bridges/vme_ca91cx42.c b/drivers/staging/vme/bridges/vme_ca91cx42.c
--- a/drivers/staging/vme/bridges/vme_ca91cx42.c
+++ b/drivers/staging/vme/bridges/vme_ca91cx42.c
@@ -523,7 +523,7 @@ static int ca91cx42_alloc_resource(struc
 	}
 
 	if (image->bus_resource.name == NULL) {
-		image->bus_resource.name = kmalloc(VMENAMSIZ+3, GFP_KERNEL);
+		image->bus_resource.name = kmalloc(VMENAMSIZ+3, GFP_ATOMIC);
 		if (image->bus_resource.name == NULL) {
 			dev_err(ca91cx42_bridge->parent, "Unable to allocate "
 				"memory for resource name\n");
diff -u -p a/drivers/staging/vme/bridges/vme_tsi148.c b/drivers/staging/vme/bridges/vme_tsi148.c
--- a/drivers/staging/vme/bridges/vme_tsi148.c
+++ b/drivers/staging/vme/bridges/vme_tsi148.c
@@ -828,7 +828,7 @@ static int tsi148_alloc_resource(struct 
 		return 0;
 
 	if (image->bus_resource.name == NULL) {
-		image->bus_resource.name = kmalloc(VMENAMSIZ+3, GFP_KERNEL);
+		image->bus_resource.name = kmalloc(VMENAMSIZ+3, GFP_ATOMIC);
 		if (image->bus_resource.name == NULL) {
 			dev_err(tsi148_bridge->parent, "Unable to allocate "
 				"memory for resource name\n");
