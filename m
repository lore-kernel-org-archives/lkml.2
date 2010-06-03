Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757992Ab0FCICI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 04:02:08 -0400
Received: from ch-smtp02.sth.basefarm.net ([80.76.149.213]:52248 "EHLO
	ch-smtp02.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757653Ab0FCICB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 04:02:01 -0400
From: "Henrik Rydberg" <rydberg@euromail.se>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
       Jiri Kosina <jkosina@suse.cz>, Mika Kuoppala <mika.kuoppala@nokia.com>,
       Benjamin Tissoires <tissoire@cena.fr>, Rafi Rubin <rafi@seas.upenn.edu>,
       Henrik Rydberg <rydberg@euromail.se>
Subject: [PATCH 4/4] input: Use driver hint to compute the evdev buffer size
Date: Thu,  3 Jun 2010 10:01:02 +0200
Message-Id: <1275552062-8153-5-git-send-email-rydberg@euromail.se>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1275552062-8153-4-git-send-email-rydberg@euromail.se>
References: <1275552062-8153-1-git-send-email-rydberg@euromail.se>
 <1275552062-8153-2-git-send-email-rydberg@euromail.se>
 <1275552062-8153-3-git-send-email-rydberg@euromail.se>
 <1275552062-8153-4-git-send-email-rydberg@euromail.se>
X-Originating-IP: 83.248.196.134
X-Scan-Result: No virus found in message 1OK5N0-0000zO-77.
X-Scan-Signature: ch-smtp02.sth.basefarm.net 1OK5N0-0000zO-77 e46dd4e5c6bc6a7dbba5ebdcc12ce92e
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
 include/linux/input.h |    7 +++++++
 2 files changed, 11 insertions(+), 1 deletions(-)

diff --git a/drivers/input/evdev.c b/drivers/input/evdev.c
index 2e2a339..f08b1d2 100644
--- a/drivers/input/evdev.c
+++ b/drivers/input/evdev.c
@@ -11,6 +11,7 @@
 #define EVDEV_MINOR_BASE	64
 #define EVDEV_MINORS		32
 #define EVDEV_MIN_BUFFER_SIZE	64
+#define EVDEV_BUF_PACKETS	8
 
 #include <linux/poll.h>
 #include <linux/sched.h>
@@ -790,7 +791,9 @@ static void evdev_cleanup(struct evdev *evdev)
 
 static int evdev_compute_buffer_size(struct input_dev *dev)
 {
-	return EVDEV_MIN_BUFFER_SIZE;
+	int nev = dev->hint_events_per_packet * EVDEV_BUF_PACKETS;
+	nev = max(nev, EVDEV_MIN_BUFFER_SIZE);
+	return roundup_pow_of_two(nev);
 }
 
 /*
diff --git a/include/linux/input.h b/include/linux/input.h
index bd00786..35b015d 100644
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
@@ -1439,6 +1441,11 @@ static inline void input_mt_slot(struct input_dev *dev, int slot)
 
 void input_set_capability(struct input_dev *dev, unsigned int type, unsigned int code);
 
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

