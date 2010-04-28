Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751765Ab0D1Edu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 00:33:50 -0400
Received: from mail-pz0-f204.google.com ([209.85.222.204]:57985 "EHLO
	mail-pz0-f204.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751269Ab0D1Ech (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 00:32:37 -0400
From: =?UTF-8?q?Arve=20Hj=C3=B8nnev=C3=A5g?= <arve@android.com>
To: linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Alan Stern <stern@rowland.harvard.edu>,
       Tejun Heo <tj@kernel.org>, Oleg Nesterov <oleg@redhat.com>,
       =?UTF-8?q?Arve=20Hj=C3=B8nnev=C3=A5g?= <arve@android.com>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>,
       =?UTF-8?q?M=C3=A1rton=20N=C3=A9meth?= <nm127@freemail.hu>,
       Sven Neumann <s.neumann@raumfeld.com>,
       Tero Saarni <tero.saarni@gmail.com>,
       Henrik Rydberg <rydberg@euromail.se>, Matthew Garrett <mjg@redhat.com>,
       Jiri Kosina <jkosina@suse.cz>, linux-input@vger.kernel.org
Subject: [PATCH 7/8] Input: Block suspend while event queue is not empty.
Date: Tue, 27 Apr 2010 21:31:58 -0700
Message-Id: <1272429119-12103-8-git-send-email-arve@android.com>
X-Mailer: git-send-email 1.6.5.1
In-Reply-To: <1272429119-12103-7-git-send-email-arve@android.com>
References: <1272429119-12103-1-git-send-email-arve@android.com>
 <1272429119-12103-2-git-send-email-arve@android.com>
 <1272429119-12103-3-git-send-email-arve@android.com>
 <1272429119-12103-4-git-send-email-arve@android.com>
 <1272429119-12103-5-git-send-email-arve@android.com>
 <1272429119-12103-6-git-send-email-arve@android.com>
 <1272429119-12103-7-git-send-email-arve@android.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add an ioctl, EVIOCSSUSPENDBLOCK, to enable a suspend_blocker that will block
suspend while the event queue is not empty. This allows userspace code to
process input events while the device appears to be asleep.

Signed-off-by: Arve Hjønnevåg <arve@android.com>
---
 drivers/input/evdev.c |   22 ++++++++++++++++++++++
 include/linux/input.h |    3 +++
 2 files changed, 25 insertions(+), 0 deletions(-)

diff --git a/drivers/input/evdev.c b/drivers/input/evdev.c
index 2ee6c7a..66e0d16 100644
--- a/drivers/input/evdev.c
+++ b/drivers/input/evdev.c
@@ -20,6 +20,7 @@
 #include <linux/input.h>
 #include <linux/major.h>
 #include <linux/device.h>
+#include <linux/suspend_blocker.h>
 #include "input-compat.h"
 
 struct evdev {
@@ -43,6 +44,8 @@ struct evdev_client {
 	struct fasync_struct *fasync;
 	struct evdev *evdev;
 	struct list_head node;
+	struct suspend_blocker suspend_blocker;
+	bool use_suspend_blocker;
 };
 
 static struct evdev *evdev_table[EVDEV_MINORS];
@@ -55,6 +58,8 @@ static void evdev_pass_event(struct evdev_client *client,
 	 * Interrupts are disabled, just acquire the lock
 	 */
 	spin_lock(&client->buffer_lock);
+	if (client->use_suspend_blocker)
+		suspend_block(&client->suspend_blocker);
 	client->buffer[client->head++] = *event;
 	client->head &= EVDEV_BUFFER_SIZE - 1;
 	spin_unlock(&client->buffer_lock);
@@ -234,6 +239,8 @@ static int evdev_release(struct inode *inode, struct file *file)
 	mutex_unlock(&evdev->mutex);
 
 	evdev_detach_client(evdev, client);
+	if (client->use_suspend_blocker)
+		suspend_blocker_destroy(&client->suspend_blocker);
 	kfree(client);
 
 	evdev_close_device(evdev);
@@ -335,6 +342,8 @@ static int evdev_fetch_next_event(struct evdev_client *client,
 	if (have_event) {
 		*event = client->buffer[client->tail++];
 		client->tail &= EVDEV_BUFFER_SIZE - 1;
+		if (client->use_suspend_blocker && client->head == client->tail)
+			suspend_unblock(&client->suspend_blocker);
 	}
 
 	spin_unlock_irq(&client->buffer_lock);
@@ -585,6 +594,19 @@ static long evdev_do_ioctl(struct file *file, unsigned int cmd,
 		else
 			return evdev_ungrab(evdev, client);
 
+	case EVIOCGSUSPENDBLOCK:
+		return put_user(client->use_suspend_blocker, ip);
+
+	case EVIOCSSUSPENDBLOCK:
+		spin_lock_irq(&client->buffer_lock);
+		if (!client->use_suspend_blocker && p)
+			suspend_blocker_init(&client->suspend_blocker, "evdev");
+		else if (client->use_suspend_blocker && !p)
+			suspend_blocker_destroy(&client->suspend_blocker);
+		client->use_suspend_blocker = !!p;
+		spin_unlock_irq(&client->buffer_lock);
+		return 0;
+
 	default:
 
 		if (_IOC_TYPE(cmd) != 'E')
diff --git a/include/linux/input.h b/include/linux/input.h
index 7ed2251..b2d93b4 100644
--- a/include/linux/input.h
+++ b/include/linux/input.h
@@ -82,6 +82,9 @@ struct input_absinfo {
 
 #define EVIOCGRAB		_IOW('E', 0x90, int)			/* Grab/Release device */
 
+#define EVIOCGSUSPENDBLOCK	_IOR('E', 0x91, int)			/* get suspend block enable */
+#define EVIOCSSUSPENDBLOCK	_IOW('E', 0x91, int)			/* set suspend block enable */
+
 /*
  * Event types
  */
-- 
1.6.5.1

