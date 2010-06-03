Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932621Ab0FCIC2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 04:02:28 -0400
Received: from ch-smtp02.sth.basefarm.net ([80.76.149.213]:52491 "EHLO
	ch-smtp02.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757973Ab0FCICW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 04:02:22 -0400
From: "Henrik Rydberg" <rydberg@euromail.se>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
       Jiri Kosina <jkosina@suse.cz>, Mika Kuoppala <mika.kuoppala@nokia.com>,
       Benjamin Tissoires <tissoire@cena.fr>, Rafi Rubin <rafi@seas.upenn.edu>,
       Henrik Rydberg <rydberg@euromail.se>
Subject: [PATCH 3/4] input: evdev: Convert to dynamic event buffer (rev3)
Date: Thu,  3 Jun 2010 10:01:01 +0200
Message-Id: <1275552062-8153-4-git-send-email-rydberg@euromail.se>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1275552062-8153-3-git-send-email-rydberg@euromail.se>
References: <1275552062-8153-1-git-send-email-rydberg@euromail.se>
 <1275552062-8153-2-git-send-email-rydberg@euromail.se>
 <1275552062-8153-3-git-send-email-rydberg@euromail.se>
X-Originating-IP: 83.248.196.134
X-Scan-Result: No virus found in message 1OK5Mu-0000tb-7y.
X-Scan-Signature: ch-smtp02.sth.basefarm.net 1OK5Mu-0000tb-7y e25adbad41877d93ed15e070f89d9980
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allocate the event buffer dynamically, and prepare to compute the
buffer size in a separate function. This patch defines the size
computation to be identical to the current code, and does not contain
any logical changes.

Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
---
 drivers/input/evdev.c |   23 +++++++++++++++++++----
 1 files changed, 19 insertions(+), 4 deletions(-)

diff --git a/drivers/input/evdev.c b/drivers/input/evdev.c
index 7f0c7da..2e2a339 100644
--- a/drivers/input/evdev.c
+++ b/drivers/input/evdev.c
@@ -10,7 +10,7 @@
 
 #define EVDEV_MINOR_BASE	64
 #define EVDEV_MINORS		32
-#define EVDEV_BUFFER_SIZE	64
+#define EVDEV_MIN_BUFFER_SIZE	64
 
 #include <linux/poll.h>
 #include <linux/sched.h>
@@ -35,7 +35,8 @@ struct evdev {
 	struct mutex mutex;
 	struct device dev;
 	struct buflock_writer writer;
-	struct input_event buffer[EVDEV_BUFFER_SIZE];
+	unsigned int bufsize;
+	struct input_event *buffer;
 };
 
 struct evdev_client {
@@ -74,7 +75,7 @@ static void evdev_event(struct input_handle *handle,
 	event.value = value;
 
 	/* lock-less write */
-	buflock_write(evdev->writer, evdev->buffer, EVDEV_BUFFER_SIZE, event);
+	buflock_write(evdev->writer, evdev->buffer, evdev->bufsize, event);
 
 	rcu_read_lock();
 
@@ -121,6 +122,7 @@ static void evdev_free(struct device *dev)
 	struct evdev *evdev = container_of(dev, struct evdev, dev);
 
 	input_put_device(evdev->handle.dev);
+	kfree(evdev->buffer);
 	kfree(evdev);
 }
 
@@ -333,7 +335,7 @@ static int evdev_fetch_next_event(struct evdev_client *client,
 	have_event = !buflock_reader_empty(client->reader);
 	if (have_event)
 		buflock_read(client->reader, evdev->writer,
-			     evdev->buffer, EVDEV_BUFFER_SIZE, *event);
+			     evdev->buffer, evdev->bufsize, *event);
 
 	spin_unlock_irq(&client->entry_lock);
 
@@ -786,6 +788,11 @@ static void evdev_cleanup(struct evdev *evdev)
 	}
 }
 
+static int evdev_compute_buffer_size(struct input_dev *dev)
+{
+	return EVDEV_MIN_BUFFER_SIZE;
+}
+
 /*
  * Create new evdev device. Note that input core serializes calls
  * to connect and disconnect so we don't need to lock evdev_table here.
@@ -830,6 +837,14 @@ static int evdev_connect(struct input_handler *handler, struct input_dev *dev,
 	evdev->dev.release = evdev_free;
 	device_initialize(&evdev->dev);
 
+	evdev->bufsize = evdev_compute_buffer_size(dev);
+	evdev->buffer = kzalloc(evdev->bufsize * sizeof(struct input_event),
+				GFP_KERNEL);
+	if (!evdev->buffer) {
+		error = -ENOMEM;
+		goto err_free_evdev;
+	}
+
 	error = input_register_handle(&evdev->handle);
 	if (error)
 		goto err_free_evdev;
-- 
1.6.3.3

