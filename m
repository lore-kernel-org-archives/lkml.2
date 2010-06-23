Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752929Ab0FWLPq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 07:15:46 -0400
Received: from ch-smtp01.sth.basefarm.net ([80.76.149.212]:40946 "EHLO
	ch-smtp01.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752867Ab0FWLPo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 07:15:44 -0400
From: "Henrik Rydberg" <rydberg@euromail.se>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
       Jiri Kosina <jkosina@suse.cz>, Ping Cheng <pingc@wacom.com>,
       Benjamin Tissoires <tissoire@cena.fr>,
       Chase Douglas <chase.douglas@canonical.com>,
       Rafi Rubin <rafi@seas.upenn.edu>, Henrik Rydberg <rydberg@euromail.se>
Subject: [PATCH 1/5] input: evdev: Convert to dynamic event buffer (rev5)
Date: Wed, 23 Jun 2010 13:14:42 +0200
Message-Id: <1277291686-7153-2-git-send-email-rydberg@euromail.se>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1277291686-7153-1-git-send-email-rydberg@euromail.se>
References: <1277291686-7153-1-git-send-email-rydberg@euromail.se>
X-Originating-IP: 83.248.196.134
X-Scan-Result: No virus found in message 1ORNuy-0007M2-4U.
X-Scan-Signature: ch-smtp01.sth.basefarm.net 1ORNuy-0007M2-4U 997b87098550d5ee49799237ff1ea197
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allocate the event buffer dynamically, and prepare to compute the
buffer size in a separate function. This patch defines the size
computation to be identical to the current code, and does not contain
any logical changes.

Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
---
 drivers/input/evdev.c |   25 +++++++++++++++++++++----
 1 files changed, 21 insertions(+), 4 deletions(-)

diff --git a/drivers/input/evdev.c b/drivers/input/evdev.c
index 2ee6c7a..5d84e59 100644
--- a/drivers/input/evdev.c
+++ b/drivers/input/evdev.c
@@ -10,7 +10,7 @@
 
 #define EVDEV_MINOR_BASE	64
 #define EVDEV_MINORS		32
-#define EVDEV_BUFFER_SIZE	64
+#define EVDEV_MIN_BUFFER_SIZE	64
 
 #include <linux/poll.h>
 #include <linux/sched.h>
@@ -36,7 +36,8 @@ struct evdev {
 };
 
 struct evdev_client {
-	struct input_event buffer[EVDEV_BUFFER_SIZE];
+	struct input_event *buffer;
+	int bufsize;
 	int head;
 	int tail;
 	spinlock_t buffer_lock; /* protects access to buffer, head and tail */
@@ -48,6 +49,11 @@ struct evdev_client {
 static struct evdev *evdev_table[EVDEV_MINORS];
 static DEFINE_MUTEX(evdev_table_mutex);
 
+static int evdev_compute_buffer_size(struct input_dev *dev)
+{
+	return EVDEV_MIN_BUFFER_SIZE;
+}
+
 static void evdev_pass_event(struct evdev_client *client,
 			     struct input_event *event)
 {
@@ -56,7 +62,7 @@ static void evdev_pass_event(struct evdev_client *client,
 	 */
 	spin_lock(&client->buffer_lock);
 	client->buffer[client->head++] = *event;
-	client->head &= EVDEV_BUFFER_SIZE - 1;
+	client->head &= client->bufsize - 1;
 	spin_unlock(&client->buffer_lock);
 
 	if (event->type == EV_SYN)
@@ -234,6 +240,7 @@ static int evdev_release(struct inode *inode, struct file *file)
 	mutex_unlock(&evdev->mutex);
 
 	evdev_detach_client(evdev, client);
+	kfree(client->buffer);
 	kfree(client);
 
 	evdev_close_device(evdev);
@@ -269,6 +276,14 @@ static int evdev_open(struct inode *inode, struct file *file)
 		goto err_put_evdev;
 	}
 
+	client->bufsize = evdev_compute_buffer_size(evdev->handle.dev);
+	client->buffer = kcalloc(client->bufsize, sizeof(struct input_event),
+				 GFP_KERNEL);
+	if (!client->buffer) {
+		error = -ENOMEM;
+		goto err_free_memory;
+	}
+
 	spin_lock_init(&client->buffer_lock);
 	client->evdev = evdev;
 	evdev_attach_client(evdev, client);
@@ -284,6 +299,8 @@ static int evdev_open(struct inode *inode, struct file *file)
 
  err_free_client:
 	evdev_detach_client(evdev, client);
+	kfree(client->buffer);
+ err_free_memory:
 	kfree(client);
  err_put_evdev:
 	put_device(&evdev->dev);
@@ -334,7 +351,7 @@ static int evdev_fetch_next_event(struct evdev_client *client,
 	have_event = client->head != client->tail;
 	if (have_event) {
 		*event = client->buffer[client->tail++];
-		client->tail &= EVDEV_BUFFER_SIZE - 1;
+		client->tail &= client->bufsize - 1;
 	}
 
 	spin_unlock_irq(&client->buffer_lock);
-- 
1.6.3.3

