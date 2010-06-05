Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933007Ab0FELLJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jun 2010 07:11:09 -0400
Received: from smtp-out12.han.skanova.net ([195.67.226.212]:35769 "EHLO
	smtp-out12.han.skanova.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755608Ab0FELLH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jun 2010 07:11:07 -0400
From: "Henrik Rydberg" <rydberg@euromail.se>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
       Jiri Kosina <jkosina@suse.cz>, Mika Kuoppala <mika.kuoppala@nokia.com>,
       Benjamin Tissoires <tissoire@cena.fr>, Rafi Rubin <rafi@seas.upenn.edu>,
       Henrik Rydberg <rydberg@euromail.se>
Subject: [PATCH 2/3] input: evdev: Convert to dynamic event buffer (rev4)
Date: Sat,  5 Jun 2010 13:04:28 +0200
Message-Id: <1275735869-2185-3-git-send-email-rydberg@euromail.se>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1275735869-2185-2-git-send-email-rydberg@euromail.se>
References: <1275735869-2185-1-git-send-email-rydberg@euromail.se>
 <1275735869-2185-2-git-send-email-rydberg@euromail.se>
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
index 7117589..463bf1b 100644
--- a/drivers/input/evdev.c
+++ b/drivers/input/evdev.c
@@ -10,7 +10,7 @@
 
 #define EVDEV_MINOR_BASE	64
 #define EVDEV_MINORS		32
-#define EVDEV_BUFFER_SIZE	64
+#define EVDEV_MIN_BUFFER_SIZE	64
 
 #include <linux/poll.h>
 #include <linux/sched.h>
@@ -34,7 +34,8 @@ struct evdev {
 	struct mutex mutex;
 	struct device dev;
 	int head;
-	struct input_event buffer[EVDEV_BUFFER_SIZE];
+	unsigned int bufsize;
+	struct input_event *buffer;
 };
 
 struct evdev_client {
@@ -75,7 +76,7 @@ static void evdev_event(struct input_handle *handle,
 
 	/* dev->event_lock held */
 	evdev->buffer[evdev->head] = event;
-	evdev->head = (evdev->head + 1) & (EVDEV_BUFFER_SIZE - 1);
+	evdev->head = (evdev->head + 1) & (evdev->bufsize - 1);
 
 	rcu_read_lock();
 
@@ -122,6 +123,7 @@ static void evdev_free(struct device *dev)
 	struct evdev *evdev = container_of(dev, struct evdev, dev);
 
 	input_put_device(evdev->handle.dev);
+	kfree(evdev->buffer);
 	kfree(evdev);
 }
 
@@ -340,7 +342,7 @@ static int evdev_fetch_next_event(struct evdev_client *client,
 	have_event = client->head != client->tail;
 	if (have_event) {
 		*event = evdev->buffer[client->tail++];
-		client->tail &= EVDEV_BUFFER_SIZE - 1;
+		client->tail &= evdev->bufsize - 1;
 	}
 
 	spin_unlock_irq(&dev->event_lock);
@@ -793,6 +795,11 @@ static void evdev_cleanup(struct evdev *evdev)
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
@@ -837,6 +844,14 @@ static int evdev_connect(struct input_handler *handler, struct input_dev *dev,
 	evdev->dev.release = evdev_free;
 	device_initialize(&evdev->dev);
 
+	evdev->bufsize = evdev_compute_buffer_size(dev);
+	evdev->buffer = kcalloc(evdev->bufsize, sizeof(struct input_event),
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

