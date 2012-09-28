Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032305Ab2I1UZd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 16:25:33 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:43081 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031287Ab2I1UZ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 16:25:27 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Paul Clements <paul.clements@steeleye.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [ 074/218] nbd: clear waiting_queue on shutdown
Date: Fri, 28 Sep 2012 13:14:51 -0700
Message-Id: <20120928201510.074306311@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.1.428.g652398a
In-Reply-To: <20120928201501.208384923@linuxfoundation.org>
References: <20120928201501.208384923@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

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
+	while (!list_empty(&nbd->waiting_queue)) {
+		req = list_entry(nbd->waiting_queue.next, struct request,
+				 queuelist);
+		list_del_init(&req->queuelist);
+		req->errors++;
+		nbd_end_request(req);
+	}
 }
 
 
@@ -594,6 +602,7 @@ static int __nbd_ioctl(struct block_devi
 		nbd->file = NULL;
 		nbd_clear_que(nbd);
 		BUG_ON(!list_empty(&nbd->queue_head));
+		BUG_ON(!list_empty(&nbd->waiting_queue));
 		if (file)
 			fput(file);
 		return 0;


