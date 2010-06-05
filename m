Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933204Ab0FELLj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jun 2010 07:11:39 -0400
Received: from smtp-out11.han.skanova.net ([195.67.226.200]:34426 "EHLO
	smtp-out11.han.skanova.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932827Ab0FELLg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jun 2010 07:11:36 -0400
From: "Henrik Rydberg" <rydberg@euromail.se>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
       Jiri Kosina <jkosina@suse.cz>, Mika Kuoppala <mika.kuoppala@nokia.com>,
       Benjamin Tissoires <tissoire@cena.fr>, Rafi Rubin <rafi@seas.upenn.edu>,
       Henrik Rydberg <rydberg@euromail.se>
Subject: [PATCH 3/3] input: Use driver hint to compute the evdev buffer size (rev2)
Date: Sat,  5 Jun 2010 13:04:29 +0200
Message-Id: <1275735869-2185-4-git-send-email-rydberg@euromail.se>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1275735869-2185-3-git-send-email-rydberg@euromail.se>
References: <1275735869-2185-1-git-send-email-rydberg@euromail.se>
 <1275735869-2185-2-git-send-email-rydberg@euromail.se>
 <1275735869-2185-3-git-send-email-rydberg@euromail.se>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some devices, in particular MT devices, produce a lot of data.  This
leads to a high frequency of lost packets in evdev, which by default
uses a fairly small event buffer. Let the drivers hint the average
number of events per packet for the device by calling the
input_set_events_per_packet(), and use that information when computing
the evdev buffer size.

Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
---
 drivers/input/evdev.c |    5 ++++-
 include/linux/input.h |   17 +++++++++++++++++
 2 files changed, 21 insertions(+), 1 deletions(-)

diff --git a/drivers/input/evdev.c b/drivers/input/evdev.c
index 463bf1b..2cf7b3a 100644
--- a/drivers/input/evdev.c
+++ b/drivers/input/evdev.c
@@ -11,6 +11,7 @@
 #define EVDEV_MINOR_BASE	64
 #define EVDEV_MINORS		32
 #define EVDEV_MIN_BUFFER_SIZE	64
+#define EVDEV_BUF_PACKETS	8
 
 #include <linux/poll.h>
 #include <linux/sched.h>
@@ -797,7 +798,9 @@ static void evdev_cleanup(struct evdev *evdev)
 
 static int evdev_compute_buffer_size(struct input_dev *dev)
 {
-	return EVDEV_MIN_BUFFER_SIZE;
+	int nev = dev->hint_events_per_packet * EVDEV_BUF_PACKETS;
+	nev = max(nev, EVDEV_MIN_BUFFER_SIZE);
+	return roundup_pow_of_two(nev);
 }
 
 /*
diff --git a/include/linux/input.h b/include/linux/input.h
index bd00786..b2a8a59 100644
--- a/include/linux/input.h
+++ b/include/linux/input.h
@@ -1162,6 +1162,8 @@ struct input_dev {
 	unsigned long ffbit[BITS_TO_LONGS(FF_CNT)];
 	unsigned long swbit[BITS_TO_LONGS(SW_CNT)];
 
+	unsigned int hint_events_per_packet;
+
 	unsigned int keycodemax;
 	unsigned int keycodesize;
 	void *keycode;
@@ -1439,6 +1441,21 @@ static inline void input_mt_slot(struct input_dev *dev, int slot)
 
 void input_set_capability(struct input_dev *dev, unsigned int type, unsigned int code);
 
+/**
+ * input_set_events_per_packet - tell handlers about the driver event rate
+ * @dev: the input device used by the driver
+ * @nev: the average number of events between calls to input_sync()
+ *
+ * If the event rate sent from a device is unusually large, use this
+ * function to set the expected event rate. This will allow handlers
+ * to set up an approriate buffer size for the event stream, in order
+ * to minimize information loss.
+ */
+static inline void input_set_events_per_packet(struct input_dev *dev, int nev)
+{
+	dev->hint_events_per_packet = nev;
+}
+
 static inline void input_set_abs_params(struct input_dev *dev, int axis, int min, int max, int fuzz, int flat)
 {
 	dev->absmin[axis] = min;
-- 
1.6.3.3

