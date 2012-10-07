Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753417Ab2JGXWO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2012 19:22:14 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:38119 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752550Ab2JGXVs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2012 19:21:48 -0400
Message-Id: <20121007225835.427609279@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 07 Oct 2012 23:58:39 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Paul Clements <paul.clements@steeleye.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [ 005/108] nbd: clear waiting_queue on shutdown
In-Reply-To: <20121007225834.673681075@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paul Clements <paul.clements@steeleye.com>

commit fded4e090c60100d709318896c79816d68d5b47d upstream.

Fix a serious but uncommon bug in nbd which occurs when there is heavy
I/O going to the nbd device while, at the same time, a failure (server,
network) or manual disconnect of the nbd connection occurs.

There is a small window between the time that the nbd_thread is stopped
and the socket is shutdown where requests can continue to be queued to
nbd's internal waiting_queue.  When this happens, those requests are
never completed or freed.

The fix is to clear the waiting_queue on shutdown of the nbd device, in
the same way that the nbd request queue (queue_head) is already being
cleared.

Signed-off-by: Paul Clements <paul.clements@steeleye.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
[bwh: Backported to 3.2: local nbd_device pointers are called 'lo' not 'nbd']
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/block/nbd.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/drivers/block/nbd.c
+++ b/drivers/block/nbd.c
@@ -445,6 +445,14 @@ static void nbd_clear_que(struct nbd_dev
 		req->errors++;
 		nbd_end_request(req);
 	}
+
+	while (!list_empty(&lo->waiting_queue)) {
+		req = list_entry(lo->waiting_queue.next, struct request,
+				 queuelist);
+		list_del_init(&req->queuelist);
+		req->errors++;
+		nbd_end_request(req);
+	}
 }
 
 
@@ -594,6 +602,7 @@ static int __nbd_ioctl(struct block_devi
 		lo->file = NULL;
 		nbd_clear_que(lo);
 		BUG_ON(!list_empty(&lo->queue_head));
+		BUG_ON(!list_empty(&lo->waiting_queue));
 		if (file)
 			fput(file);
 		return 0;


