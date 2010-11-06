Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755240Ab0KFJHE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Nov 2010 05:07:04 -0400
Received: from mail.pripojeni.net ([217.66.174.14]:38021 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1753866Ab0KFJHA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Nov 2010 05:07:00 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: jirislaby@gmail.com
Cc: linux-kernel@vger.kernel.org, Amit Shah <amit.shah@redhat.com>,
        virtualization@lists.linux-foundation.org,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH] Char: virtio_console, fix memory leak
Date: Sat,  6 Nov 2010 10:06:50 +0100
Message-Id: <1289034412-24278-2-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1289034412-24278-1-git-send-email-jslaby@suse.cz>
References: <1289034412-24278-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stanse found that in init_vqs, memory is leaked under certain
circumstanses (the fail path order is incorrect). Fix that by checking
allocations in one turn and free all of them at once if some fails
(some may be NULL, but this is OK).

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Amit Shah <amit.shah@redhat.com>
Cc: virtualization@lists.linux-foundation.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/char/virtio_console.c |   37 +++++++++----------------------------
 1 files changed, 9 insertions(+), 28 deletions(-)

diff --git a/drivers/char/virtio_console.c b/drivers/char/virtio_console.c
index 6c1b676..896a2ce 100644
--- a/drivers/char/virtio_console.c
+++ b/drivers/char/virtio_console.c
@@ -1547,31 +1547,16 @@ static int init_vqs(struct ports_device *portdev)
 	nr_queues = use_multiport(portdev) ? (nr_ports + 1) * 2 : 2;
 
 	vqs = kmalloc(nr_queues * sizeof(struct virtqueue *), GFP_KERNEL);
-	if (!vqs) {
-		err = -ENOMEM;
-		goto fail;
-	}
 	io_callbacks = kmalloc(nr_queues * sizeof(vq_callback_t *), GFP_KERNEL);
-	if (!io_callbacks) {
-		err = -ENOMEM;
-		goto free_vqs;
-	}
 	io_names = kmalloc(nr_queues * sizeof(char *), GFP_KERNEL);
-	if (!io_names) {
-		err = -ENOMEM;
-		goto free_callbacks;
-	}
 	portdev->in_vqs = kmalloc(nr_ports * sizeof(struct virtqueue *),
 				  GFP_KERNEL);
-	if (!portdev->in_vqs) {
-		err = -ENOMEM;
-		goto free_names;
-	}
 	portdev->out_vqs = kmalloc(nr_ports * sizeof(struct virtqueue *),
 				   GFP_KERNEL);
-	if (!portdev->out_vqs) {
+	if (!vqs || !io_callbacks || !io_names || !portdev->in_vqs ||
+			!portdev->out_vqs) {
 		err = -ENOMEM;
-		goto free_invqs;
+		goto free;
 	}
 
 	/*
@@ -1605,7 +1590,7 @@ static int init_vqs(struct ports_device *portdev)
 					      io_callbacks,
 					      (const char **)io_names);
 	if (err)
-		goto free_outvqs;
+		goto free;
 
 	j = 0;
 	portdev->in_vqs[0] = vqs[0];
@@ -1621,23 +1606,19 @@ static int init_vqs(struct ports_device *portdev)
 			portdev->out_vqs[i] = vqs[j + 1];
 		}
 	}
-	kfree(io_callbacks);
 	kfree(io_names);
+	kfree(io_callbacks);
 	kfree(vqs);
 
 	return 0;
 
-free_names:
-	kfree(io_names);
-free_callbacks:
-	kfree(io_callbacks);
-free_outvqs:
+free:
 	kfree(portdev->out_vqs);
-free_invqs:
 	kfree(portdev->in_vqs);
-free_vqs:
+	kfree(io_names);
+	kfree(io_callbacks);
 	kfree(vqs);
-fail:
+
 	return err;
 }
 
-- 
1.7.3.1


