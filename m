Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759741Ab0G3RyY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 13:54:24 -0400
Received: from kroah.org ([198.145.64.141]:57770 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759692Ab0G3RyH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 13:54:07 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Jul 30 10:51:33 2010
Message-Id: <20100730175133.867454088@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 30 Jul 2010 10:50:20 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        "David S. Miller" <davem@davemloft.net>
Subject: [003/205] virtio_net: do not reschedule rx refill forever
In-Reply-To: <20100730175238.GA3924@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.34-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Michael S. Tsirkin <mst@redhat.com>

commit 1788f49548860fa1c861ee3454d47b466c877e43 upstream.

We currently fill all of RX ring, then add_buf
returns ENOSPC, which gets mis-detected as an out of
memory condition and causes us to reschedule the work,
and so on forever. Fix this by oom = err == -ENOMEM;

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/virtio_net.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -417,7 +417,7 @@ static int add_recvbuf_mergeable(struct
 static bool try_fill_recv(struct virtnet_info *vi, gfp_t gfp)
 {
 	int err;
-	bool oom = false;
+	bool oom;
 
 	do {
 		if (vi->mergeable_rx_bufs)
@@ -427,10 +427,9 @@ static bool try_fill_recv(struct virtnet
 		else
 			err = add_recvbuf_small(vi, gfp);
 
-		if (err < 0) {
-			oom = true;
+		oom = err == -ENOMEM;
+		if (err < 0)
 			break;
-		}
 		++vi->num;
 	} while (err > 0);
 	if (unlikely(vi->num > vi->max))


