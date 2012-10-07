Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754324Ab2JGXXE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2012 19:23:04 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:38406 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754082Ab2JGXWh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2012 19:22:37 -0400
Message-Id: <20121007225844.240289438@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 07 Oct 2012 23:59:43 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Matthieu CASTET <matthieu.castet@parrot.com>,
        Jiri Kosina <jkosina@suse.cz>
Subject: [ 069/108] HID: hidraw: fix list->buffer memleak
In-Reply-To: <20121007225834.673681075@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthieu CASTET <matthieu.castet@parrot.com>

commit 4c7b417ecb756e85dfc955b0e7a04fd45585533e upstream.

If we don't read fast enough hidraw device, hidraw_report_event
will cycle and we will leak list->buffer.
Also list->buffer are not free on release.
After this patch, kmemleak report nothing.

Signed-off-by: Matthieu CASTET <matthieu.castet@parrot.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/hid/hidraw.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/hid/hidraw.c b/drivers/hid/hidraw.c
index 36fa77b..3b6f7bf 100644
--- a/drivers/hid/hidraw.c
+++ b/drivers/hid/hidraw.c
@@ -96,6 +96,7 @@ static ssize_t hidraw_read(struct file *file, char __user *buffer, size_t count,
 		}
 
 		kfree(list->buffer[list->tail].value);
+		list->buffer[list->tail].value = NULL;
 		list->tail = (list->tail + 1) & (HIDRAW_BUFFER_SIZE - 1);
 	}
 out:
@@ -300,6 +301,7 @@ static int hidraw_release(struct inode * inode, struct file * file)
 	struct hidraw *dev;
 	struct hidraw_list *list = file->private_data;
 	int ret;
+	int i;
 
 	mutex_lock(&minors_lock);
 	if (!hidraw_table[minor]) {
@@ -317,6 +319,9 @@ static int hidraw_release(struct inode * inode, struct file * file)
 			kfree(list->hidraw);
 		}
 	}
+
+	for (i = 0; i < HIDRAW_BUFFER_SIZE; ++i)
+		kfree(list->buffer[i].value);
 	kfree(list);
 	ret = 0;
 unlock:
@@ -446,12 +451,17 @@ int hidraw_report_event(struct hid_device *hid, u8 *data, int len)
 	int ret = 0;
 
 	list_for_each_entry(list, &dev->list, node) {
+		int new_head = (list->head + 1) & (HIDRAW_BUFFER_SIZE - 1);
+
+		if (new_head == list->tail)
+			continue;
+
 		if (!(list->buffer[list->head].value = kmemdup(data, len, GFP_ATOMIC))) {
 			ret = -ENOMEM;
 			break;
 		}
 		list->buffer[list->head].len = len;
-		list->head = (list->head + 1) & (HIDRAW_BUFFER_SIZE - 1);
+		list->head = new_head;
 		kill_fasync(&list->fasync, SIGIO, POLL_IN);
 	}
 


