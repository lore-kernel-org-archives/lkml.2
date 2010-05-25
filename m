Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754710Ab0EYLyA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 07:54:00 -0400
Received: from ch-smtp03.sth.basefarm.net ([80.76.149.214]:42181 "EHLO
	ch-smtp03.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754053Ab0EYLx6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 07:53:58 -0400
From: "Henrik Rydberg" <rydberg@euromail.se>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org, Mika Kuoppala <mika.kuoppala@nokia.com>,
       Peter Hutterer <peter.hutterer@who-t.net>,
       Benjamin Tissoires <tissoire@cena.fr>, Stephane Chatty <chatty@enac.fr>,
       Rafi Rubin <rafi@seas.upenn.edu>, Michael Poole <mdpoole@troilus.org>,
       Henrik Rydberg <rydberg@euromail.se>
Subject: [PATCH 2/2] input: evdev: Add EVIOC mechanism to extract the MT slot state
Date: Tue, 25 May 2010 13:52:59 +0200
Message-Id: <1274788379-11026-3-git-send-email-rydberg@euromail.se>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1274788379-11026-2-git-send-email-rydberg@euromail.se>
References: <1274788379-11026-1-git-send-email-rydberg@euromail.se>
 <1274788379-11026-2-git-send-email-rydberg@euromail.se>
X-Originating-IP: 83.248.196.134
X-Scan-Result: No virus found in message 1OGshF-0000an-CG.
X-Scan-Signature: ch-smtp03.sth.basefarm.net 1OGshF-0000an-CG 07591cac834a90e97ad581a993bdda31
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the ability to extract the MT slot state sequentially
via EVIOCGABS. The slot parameter is first selected by calling
EVIOCSABS with ABS_MT_SLOT as argument, followed by a set of EVIOCGABS
calls. The slot selection is local to the evdev client handler, and
does not affect the actual input state.

Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
---
 drivers/input/evdev.c |    9 ++++++++-
 1 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/drivers/input/evdev.c b/drivers/input/evdev.c
index 2ee6c7a..8b68b88 100644
--- a/drivers/input/evdev.c
+++ b/drivers/input/evdev.c
@@ -43,6 +43,7 @@ struct evdev_client {
 	struct fasync_struct *fasync;
 	struct evdev *evdev;
 	struct list_head node;
+	int slot; /* used to extract MT events via EVIOC */
 };
 
 static struct evdev *evdev_table[EVDEV_MINORS];
@@ -624,7 +625,8 @@ static long evdev_do_ioctl(struct file *file, unsigned int cmd,
 
 				t = _IOC_NR(cmd) & ABS_MAX;
 
-				abs.value = dev->abs[t];
+				abs.value = input_mt_get_abs_value(dev, t,
+					client->slot);
 				abs.minimum = dev->absmin[t];
 				abs.maximum = dev->absmax[t];
 				abs.fuzz = dev->absfuzz[t];
@@ -665,6 +667,11 @@ static long evdev_do_ioctl(struct file *file, unsigned int cmd,
 								  sizeof(struct input_absinfo))))
 					return -EFAULT;
 
+				if (t == ABS_MT_SLOT) {
+					client->slot = abs.value;
+					return 0;
+				}
+
 				/*
 				 * Take event lock to ensure that we are not
 				 * changing device parameters in the middle
-- 
1.6.3.3

