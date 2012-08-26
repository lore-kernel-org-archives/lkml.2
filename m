Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754094Ab2HZMx2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Aug 2012 08:53:28 -0400
Received: from smtprelay-b12.telenor.se ([62.127.194.21]:51392 "EHLO
	smtprelay-b12.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753286Ab2HZMwz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Aug 2012 08:52:55 -0400
X-SENDER-IP: [85.230.170.20]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApRZALMbOlBV5qoUPGdsb2JhbABFhRqFI7AtGQEBAQEeGQ0ngiEBBScvEwEPEAhJOQoUBgESiBG7SRSSBQObQI0P
X-IronPort-AV: E=Sophos;i="4.77,830,1336341600"; 
   d="scan'208";a="176482237"
From: "Henrik Rydberg" <rydberg@euromail.se>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Jiri Kosina <jkosina@suse.cz>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Henrik Rydberg <rydberg@euromail.se>
Subject: [PATCH v2 03/20] Input: Improve the events-per-packet estimate
Date: Sun, 26 Aug 2012 14:57:21 +0200
Message-Id: <1345985858-445-4-git-send-email-rydberg@euromail.se>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1345985858-445-1-git-send-email-rydberg@euromail.se>
References: <1345985858-445-1-git-send-email-rydberg@euromail.se>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The events-per-packet estimate has so far been used by MT devices
only. This patch adjusts the packet buffer size to also accomodate the
KEY and MSC events.  Keyboards normally send one or two keys at a
time. MT devices normally send a number of button keys along with the
MT information.  The buffer size chosen here covers those cases, and
matches the default buffer size in evdev.

Reviewed-by: Ping Cheng <pingc@wacom.com>
Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
---
 drivers/input/input.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/input/input.c b/drivers/input/input.c
index 6e90705..8ebf116 100644
--- a/drivers/input/input.c
+++ b/drivers/input/input.c
@@ -1777,6 +1777,9 @@ static unsigned int input_estimate_events_per_packet(struct input_dev *dev)
 		if (test_bit(i, dev->relbit))
 			events++;
 
+	/* Make room for KEY and MSC events */
+	events += 7;
+
 	return events;
 }
 
@@ -1815,6 +1818,7 @@ int input_register_device(struct input_dev *dev)
 {
 	static atomic_t input_no = ATOMIC_INIT(0);
 	struct input_handler *handler;
+	unsigned int packet_size;
 	const char *path;
 	int error;
 
@@ -1827,9 +1831,9 @@ int input_register_device(struct input_dev *dev)
 	/* Make sure that bitmasks not mentioned in dev->evbit are clean. */
 	input_cleanse_bitmasks(dev);
 
-	if (!dev->hint_events_per_packet)
-		dev->hint_events_per_packet =
-				input_estimate_events_per_packet(dev);
+	packet_size = input_estimate_events_per_packet(dev);
+	if (dev->hint_events_per_packet < packet_size)
+		dev->hint_events_per_packet = packet_size;
 
 	/*
 	 * If delay and period are pre-set by the driver, then autorepeating
-- 
1.7.12

