Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751618Ab2FKTB6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 15:01:58 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:34017 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750788Ab2FKTB5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 15:01:57 -0400
Date: Mon, 11 Jun 2012 14:52:41 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Jan Beulich <JBeulich@suse.com>
Cc: "axboe@kernel.dk" <axboe@kernel.dk>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: Re: [Xen-devel] [PATCH 2/2] xen/blkfront: Add BUG_ON to deal with
 misbehaving backends.
Message-ID: <20120611185241.GJ14535@phenom.dumpdata.com>
References: <1337982603-15692-1-git-send-email-konrad.wilk@oracle.com>
 <1337982603-15692-3-git-send-email-konrad.wilk@oracle.com>
 <alpine.DEB.2.00.1205281111460.26786@kaball-desktop>
 <4FC4A10F0200007800086842@nat28.tlf.novell.com>
 <20120531181712.GA19700@phenom.dumpdata.com>
 <alpine.DEB.2.00.1206011111590.26786@kaball-desktop>
 <20120607215942.GA13592@phenom.dumpdata.com>
 <4FD1C20A0200007800088AC4@nat28.tlf.novell.com>
 <20120611182229.GC14535@phenom.dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120611182229.GC14535@phenom.dumpdata.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Getting out of the loop here isn't really what I'd call "limp along" -
> > it'd likely get the communication to a halt (if there are more
> > responses ready). I'd rather see this print something, and then
> > continue the loop. Or alternatively, if we really want to stop
> > communication in such a case, initiate tear down of the device.

And this is what I get from reading without coffee.. This patch
does the 'continue' instead of tear down of the device. Long-term
tear-down is proper but that is a bit more complex.

>From 24a400057010ef280c3ebe33d1c4d74de43dcbea Mon Sep 17 00:00:00 2001
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Date: Fri, 25 May 2012 17:34:51 -0400
Subject: [PATCH] xen/blkfront: Add WARN to deal with misbehaving backends.

Part of the ring structure is the 'id' field which is under
control of the frontend. The frontend stamps it with "some"
value (this some in this implementation being a value less
than BLK_RING_SIZE), and when it gets a response expects
said value to be in the response structure. We have a check
for the id field when spolling new requests but not when
de-spolling responses.

We also add an extra check in add_id_to_freelist to make
sure that the 'struct request' was not NULL - as we cannot
pass a NULL to __blk_end_request_all, otherwise that crashes
(and all the operations that the response is dealing with
end up with __blk_end_request_all).

Lastly we also print the name of the operation that failed.

[v1: s/BUG/WARN/ suggested by Stefano]
[v2: Add extra check in add_id_to_freelist]
[v3: Redid op_name per Jan's suggestion]
[v4: add const * and add WARN on failure returns]
Acked-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 drivers/block/xen-blkfront.c |   58 +++++++++++++++++++++++++++++++++--------
 1 files changed, 46 insertions(+), 12 deletions(-)

diff --git a/drivers/block/xen-blkfront.c b/drivers/block/xen-blkfront.c
index 60eed4b..e4fb337 100644
--- a/drivers/block/xen-blkfront.c
+++ b/drivers/block/xen-blkfront.c
@@ -141,14 +141,36 @@ static int get_id_from_freelist(struct blkfront_info *info)
 	return free;
 }
 
-static void add_id_to_freelist(struct blkfront_info *info,
+static int add_id_to_freelist(struct blkfront_info *info,
 			       unsigned long id)
 {
+	if (info->shadow[id].req.u.rw.id != id)
+		return -EINVAL;
+	if (info->shadow[id].request == NULL)
+		return -EINVAL;
 	info->shadow[id].req.u.rw.id  = info->shadow_free;
 	info->shadow[id].request = NULL;
 	info->shadow_free = id;
+	return 0;
 }
 
+static const char *op_name(int op)
+{
+	static const char *const names[] = {
+		[BLKIF_OP_READ] = "read",
+		[BLKIF_OP_WRITE] = "write",
+		[BLKIF_OP_WRITE_BARRIER] = "barrier",
+		[BLKIF_OP_FLUSH_DISKCACHE] = "flush",
+		[BLKIF_OP_DISCARD] = "discard" };
+
+	if (op < 0 || op >= ARRAY_SIZE(names))
+		return "unknown";
+
+	if (!names[op])
+		return "reserved";
+
+	return names[op];
+}
 static int xlbd_reserve_minors(unsigned int minor, unsigned int nr)
 {
 	unsigned int end = minor + nr;
@@ -746,20 +768,36 @@ static irqreturn_t blkif_interrupt(int irq, void *dev_id)
 
 		bret = RING_GET_RESPONSE(&info->ring, i);
 		id   = bret->id;
+		/*
+		 * The backend has messed up and given us an id that we would
+		 * never have given to it (we stamp it up to BLK_RING_SIZE -
+		 * look in get_id_from_freelist.
+		 */
+		if (id >= BLK_RING_SIZE) {
+			WARN(1, "%s: response to %s has incorrect id (%ld)\n",
+			     info->gd->disk_name, op_name(bret->operation), id);
+			/* We can't safely get the 'struct request' as
+			 * the id is busted. */
+			continue;
+		}
 		req  = info->shadow[id].request;
 
 		if (bret->operation != BLKIF_OP_DISCARD)
 			blkif_completion(&info->shadow[id]);
 
-		add_id_to_freelist(info, id);
+		if (add_id_to_freelist(info, id)) {
+			WARN(1, "%s: response to %s (id %ld) couldn't be recycled!\n",
+			     info->gd->disk_name, op_name(bret->operation), id);
+			continue;
+		}
 
 		error = (bret->status == BLKIF_RSP_OKAY) ? 0 : -EIO;
 		switch (bret->operation) {
 		case BLKIF_OP_DISCARD:
 			if (unlikely(bret->status == BLKIF_RSP_EOPNOTSUPP)) {
 				struct request_queue *rq = info->rq;
-				printk(KERN_WARNING "blkfront: %s: discard op failed\n",
-					   info->gd->disk_name);
+				printk(KERN_WARNING "blkfront: %s: %s op failed\n",
+					   info->gd->disk_name, op_name(bret->operation));
 				error = -EOPNOTSUPP;
 				info->feature_discard = 0;
 				info->feature_secdiscard = 0;
@@ -771,18 +809,14 @@ static irqreturn_t blkif_interrupt(int irq, void *dev_id)
 		case BLKIF_OP_FLUSH_DISKCACHE:
 		case BLKIF_OP_WRITE_BARRIER:
 			if (unlikely(bret->status == BLKIF_RSP_EOPNOTSUPP)) {
-				printk(KERN_WARNING "blkfront: %s: write %s op failed\n",
-				       info->flush_op == BLKIF_OP_WRITE_BARRIER ?
-				       "barrier" :  "flush disk cache",
-				       info->gd->disk_name);
+				printk(KERN_WARNING "blkfront: %s: %s op failed\n",
+				       info->gd->disk_name, op_name(bret->operation));
 				error = -EOPNOTSUPP;
 			}
 			if (unlikely(bret->status == BLKIF_RSP_ERROR &&
 				     info->shadow[id].req.u.rw.nr_segments == 0)) {
-				printk(KERN_WARNING "blkfront: %s: empty write %s op failed\n",
-				       info->flush_op == BLKIF_OP_WRITE_BARRIER ?
-				       "barrier" :  "flush disk cache",
-				       info->gd->disk_name);
+				printk(KERN_WARNING "blkfront: %s: empty %s op failed\n",
+				       info->gd->disk_name, op_name(bret->operation));
 				error = -EOPNOTSUPP;
 			}
 			if (unlikely(error)) {
-- 
1.7.7.6

