Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933522Ab1DNRrg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 13:47:36 -0400
Received: from mail.windriver.com ([147.11.1.11]:38603 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932892Ab1DNRr0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 13:47:26 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Antonio Ospite <ospite@studenti.unina.it>,
        Jiri Kosina <jkosina@suse.cz>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 103/209] HID: hidraw, fix a NULL pointer dereference in hidraw_write
Date: Thu, 14 Apr 2011 13:42:13 -0400
Message-Id: <1302803039-9400-104-git-send-email-paul.gortmaker@windriver.com>
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

commit e42dee9a99a3ecd32b5c027e8f7411fb5bc11eb6 upstream.

BUG: unable to handle kernel NULL pointer dereference at 0000000000000028
IP: [<ffffffffa0f0a625>] hidraw_write+0x3b/0x116 [hid]
[...]

This is reproducible by disconnecting the device while userspace writes
to dev node in a loop and doesn't check return values in order to exit
the loop.

[PG: slightly/trivially reworked for backport to 34]

Signed-off-by: Antonio Ospite <ospite@studenti.unina.it>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/hid/hidraw.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/hid/hidraw.c b/drivers/hid/hidraw.c
index 0db1a0f..9d3c663 100644
--- a/drivers/hid/hidraw.c
+++ b/drivers/hid/hidraw.c
@@ -106,11 +106,15 @@ out:
 static ssize_t hidraw_write(struct file *file, const char __user *buffer, size_t count, loff_t *ppos)
 {
 	unsigned int minor = iminor(file->f_path.dentry->d_inode);
-	/* FIXME: What stops hidraw_table going NULL */
-	struct hid_device *dev = hidraw_table[minor]->hid;
+	struct hid_device *dev;
 	__u8 *buf;
 	int ret = 0;
 
+	if (!hidraw_table[minor])
+		return -ENODEV;
+
+	dev = hidraw_table[minor]->hid;
+
 	if (!dev->hid_output_raw_report)
 		return -ENODEV;
 
-- 
1.7.4.4

