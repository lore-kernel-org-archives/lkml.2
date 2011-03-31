Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754463Ab1CaFFQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 01:05:16 -0400
Received: from leo.clearchain.com ([199.73.29.74]:23712 "EHLO
	mail.clearchain.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752723Ab1CaFFN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 01:05:13 -0400
Date: Thu, 31 Mar 2011 15:05:03 +1000
From: Peter Hutterer <peter.hutterer@who-t.net>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] uinput: Allow for 0/0 min/max on absolute axes.
Message-ID: <20110331050503.GA9318@barra.bne.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Greylist: Sender is SPF-compliant, not delayed by milter-greylist-4.0.1 (mail.clearchain.com [127.0.0.1]); Thu, 31 Mar 2011 15:35:09 +1030 (CST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some devices provide absolute axes with min/max of 0/0 (e.g. wacom's
ABS_MISC axis). Current uinput restrictions do not allow duplication of
these devices and require hacks in userspace to work around this.

If the kernel accepts physical devices with a min/max of 0/0, uinput
shouldn't disallow the same range.

Signed-off-by: Peter Hutterer <peter.hutterer@who-t.net>
---
 drivers/input/misc/uinput.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/drivers/input/misc/uinput.c b/drivers/input/misc/uinput.c
index b941078..d7cc037 100644
--- a/drivers/input/misc/uinput.c
+++ b/drivers/input/misc/uinput.c
@@ -301,10 +301,14 @@ static int uinput_validate_absbits(struct input_dev *dev)
 	int retval = 0;
 
 	for (cnt = 0; cnt < ABS_CNT; cnt++) {
+		int min, max;
 		if (!test_bit(cnt, dev->absbit))
 			continue;
 
-		if (input_abs_get_max(dev, cnt) <= input_abs_get_min(dev, cnt)) {
+		min = input_abs_get_min(dev, cnt);
+		max = input_abs_get_max(dev, cnt);
+
+		if ((min != 0 || max != 0) && max <= min) {
 			printk(KERN_DEBUG
 				"%s: invalid abs[%02x] min:%d max:%d\n",
 				UINPUT_NAME, cnt,
-- 
1.7.4.2

