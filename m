Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753283Ab0EKQ3k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 12:29:40 -0400
Received: from mail-pz0-f204.google.com ([209.85.222.204]:61901 "EHLO
	mail-pz0-f204.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750884Ab0EKQ3i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 12:29:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=qv7kpE6Q3+0BEYEg5QaJ507gdt5x4X0oPWfPYNwNbG1187ozIwhBw2nL1XbisJCaAF
         Bcwi6AQYBzjcuo8Li5tby/8hAHf2wk9BC18aopDt+iPN8m1wkqdW5SVIuVBDvv1IKgc+
         z78REdzcWxTN4XEguS4dX+5VoRA7DOHwK50hc=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: linux-bluetooth@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, jkosina@suse.cz, mdpoole@troilus.org,
       "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH] HID:magicmouse: This fixes a connection problem with the magicmouse.
Date: Tue, 11 May 2010 09:29:23 -0700
Message-Id: <1273595363-4020-1-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.6.5.GIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With the latest HEAD, I've noticed that I needed to add: HIDRAW=y
in order for my apple magicmouse to connect.
After receiving some posts, it seems this it not
the case(HIDRAW just relays HID events to userspace).

The bisect results of this issue resulted in commit:
HID:magicmouse: fix oops after device removal.
(hash:28918c211d86b6eeb70182c523800c7bc442960c)

After examining this commit, I've noticed that
HID_CONNECT_DEFAULT has also an entry in there
of HID_CONNECT_HIDINPUT, not sure what "~" means,
before HID_CONNECT_HIDINPUT, but after removing
this(correct me if I'm wrong)"double" definition, 
I'm able to have my magicmouse connect without the 
need of HIDRAW, and also this in dmesg:

magicmouse 0005:05AC:030D.0004: claimed by neither input, hiddev nor hidraw
magicmouse 0005:05AC:030D.0004: magicmouse hw start failed

and as well as the crash that the above commit fixes when waking
up from suspend(mouse connects perfectly upon wakeup).

Please have a look, and if this works, take it
if theres another solution let me know.
(so I can enjoy the power of the magicmouse!!).


Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 drivers/hid/hid-magicmouse.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/hid/hid-magicmouse.c b/drivers/hid/hid-magicmouse.c
index 0d471fc..0de5e96 100644
--- a/drivers/hid/hid-magicmouse.c
+++ b/drivers/hid/hid-magicmouse.c
@@ -354,7 +354,7 @@ static int magicmouse_probe(struct hid_device *hdev,
 		goto err_free;
 	}
 
-	ret = hid_hw_start(hdev, HID_CONNECT_DEFAULT & ~HID_CONNECT_HIDINPUT);
+	ret = hid_hw_start(hdev, HID_CONNECT_DEFAULT);
 	if (ret) {
 		dev_err(&hdev->dev, "magicmouse hw start failed\n");
 		goto err_free;
-- 
1.6.5.GIT

