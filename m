Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933503Ab1DNRrb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 13:47:31 -0400
Received: from mail.windriver.com ([147.11.1.11]:38578 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933465Ab1DNRrZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 13:47:25 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Antonio Ospite <ospite@studenti.unina.it>,
        Jiri Kosina <jkosina@suse.cz>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 102/209] HID: hidraw, fix a NULL pointer dereference in hidraw_ioctl
Date: Thu, 14 Apr 2011 13:42:12 -0400
Message-Id: <1302803039-9400-103-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1302803039-9400-1-git-send-email-paul.gortmaker@windriver.com>
References: <1302803039-9400-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Antonio Ospite <ospite@studenti.unina.it>

  =====================================================================
  | This is a commit scheduled for the next v2.6.34 longterm release. |
  | If you see a problem with using this for longterm, please comment.|
  =====================================================================

commit d20d5ffab92f00188f360c44c791a5ffb988247c upstream.

BUG: unable to handle kernel NULL pointer dereference at 0000000000000028
IP: [<ffffffffa02c66b4>] hidraw_ioctl+0xfc/0x32c [hid]
[...]

This is reproducible by disconnecting the device while userspace does
ioctl in a loop and doesn't check return values in order to exit the
loop.

[PG: slightly/trivially reworked for backport to 34]

Signed-off-by: Antonio Ospite <ospite@studenti.unina.it>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/hid/hidraw.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/drivers/hid/hidraw.c b/drivers/hid/hidraw.c
index 6eadf1a..0db1a0f 100644
--- a/drivers/hid/hidraw.c
+++ b/drivers/hid/hidraw.c
@@ -243,6 +243,11 @@ static long hidraw_ioctl(struct file *file, unsigned int cmd,
 	void __user *user_arg = (void __user*) arg;
 
 	lock_kernel();
+	if (!dev) {
+		ret = -ENODEV;
+		goto out;
+	}
+
 	switch (cmd) {
 		case HIDIOCGRDESCSIZE:
 			if (put_user(dev->hid->rsize, (int __user *)arg))
@@ -315,6 +320,7 @@ static long hidraw_ioctl(struct file *file, unsigned int cmd,
 
 		ret = -ENOTTY;
 	}
+out:
 	unlock_kernel();
 	return ret;
 }
-- 
1.7.4.4

