Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755220Ab2HZMy5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Aug 2012 08:54:57 -0400
Received: from smtprelay-b21.telenor.se ([195.54.99.212]:36253 "EHLO
	smtprelay-b21.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754717Ab2HZMyZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Aug 2012 08:54:25 -0400
X-SENDER-IP: [85.230.170.20]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApJiAFMcOlBV5qoUPGdsb2JhbABFhRoiAYUAsC0ZAQEBAR4ZDSeCIQEFJy8TAQ8QCEk5ChQGARKIEbtKFIp9hwgDm0CND4FW
X-IronPort-AV: E=Sophos;i="4.77,830,1336341600"; 
   d="scan'208";a="103157759"
From: "Henrik Rydberg" <rydberg@euromail.se>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Jiri Kosina <jkosina@suse.cz>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Henrik Rydberg <rydberg@euromail.se>
Subject: [PATCH 17/20] HID: Only dump input if someone is listening
Date: Sun, 26 Aug 2012 14:57:35 +0200
Message-Id: <1345985858-445-18-git-send-email-rydberg@euromail.se>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1345985858-445-1-git-send-email-rydberg@euromail.se>
References: <1345985858-445-1-git-send-email-rydberg@euromail.se>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Going through the motions of printing the debug message information
takes a long time; using the keyboard can lead to a 160 us irqsoff
latency. This patch skips hid_dump_input() when there are no open
handles, which brings latency down to 100 us.

Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
---
 drivers/hid/hid-core.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index 60ea284..5b74e78 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -996,7 +996,8 @@ static void hid_process_event(struct hid_device *hid, struct hid_field *field,
 	struct hid_driver *hdrv = hid->driver;
 	int ret;
 
-	hid_dump_input(hid, usage, value);
+	if (!list_empty(&hid->debug_list))
+		hid_dump_input(hid, usage, value);
 
 	if (hdrv && hdrv->event && hid_match_usage(hid, usage)) {
 		ret = hdrv->event(hid, field, usage, value);
-- 
1.7.12

