Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754778Ab1A2BRh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jan 2011 20:17:37 -0500
Received: from mail-in-01.arcor-online.net ([151.189.21.41]:54622 "EHLO
	mail-in-01.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754722Ab1A2BRf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jan 2011 20:17:35 -0500
X-DKIM: Sendmail DKIM Filter v2.8.2 mail-in-16.arcor-online.net D8EBC87C1
Subject: [PATCH] HID: hidraw: fixed hidraw_disconnect()
From: Stefan Achatz <erazor_de@users.sourceforge.net>
Reply-To: erazor_de@users.sourceforge.net
To: Jiri Kosina <jkosina@suse.cz>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 29 Jan 2011 02:17:30 +0100
Message-ID: <1296263850.2299.11.camel@neuromancer>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 (2.30.3-1.fc13) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hidraw_disconnect() first sets an entry in hidraw_table to NULL
and calls device_destroy() afterwards. The thereby called
hidraw_release() tries to read this already cleared value resulting
in never removing any device from the list.
This got fixed by changing the order of events.

Maybe commit 0a504541b3ba593535d70f3124546e5e471a175e should be
undone if the talkativeness was misdiagnosed due to this error.

Signed-off-by: Stefan Achatz <erazor_de@users.sourceforge.net>
---
 drivers/hid/hidraw.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/hid/hidraw.c b/drivers/hid/hidraw.c
index 468e87b..5516ea4 100644
--- a/drivers/hid/hidraw.c
+++ b/drivers/hid/hidraw.c
@@ -428,12 +428,12 @@ void hidraw_disconnect(struct hid_device *hid)
 
 	hidraw->exist = 0;
 
+	device_destroy(hidraw_class, MKDEV(hidraw_major, hidraw->minor));
+
 	mutex_lock(&minors_lock);
 	hidraw_table[hidraw->minor] = NULL;
 	mutex_unlock(&minors_lock);
 
-	device_destroy(hidraw_class, MKDEV(hidraw_major, hidraw->minor));
-
 	if (hidraw->open) {
 		hid_hw_close(hid);
 		wake_up_interruptible(&hidraw->wait);
-- 
1.7.3.4



