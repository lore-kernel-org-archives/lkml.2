Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932115Ab1G1Xzk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jul 2011 19:55:40 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:53585 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756162Ab1G1Xze (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jul 2011 19:55:34 -0400
Subject: block: part_discard_alignment_show patch/unpatch
From: Max Asbock <masbock@linux.vnet.ibm.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: jaxboe@fusionio.com, boyu.mt@taobao.com
Content-Type: text/plain
Date: Thu, 28 Jul 2011 16:56:52 -0700
Message-Id: <1311897412.11874.5.camel@w-amax.beaverton.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Several months a patch was posted to remove the discard_alignment field
in hd_struct. And a change was made to part_discard_alignment_show to
calculate this value when queried. This patch caused crashes and was
removed again. It seems to me that the patch failed because the struct
gendisk should have been obtained like this:
struct gendisk *disk = dev_to_disk(dev->parent);
instead of 
struct gendisk *disk = dev_to_disk(dev);

Here is part of the original patch by Tao Ma:
diff --git a/fs/partitions/check.c b/fs/partitions/check.c 
index ac54697..ec4f4ae 100644
--- a/fs/partitions/check.c
+++ b/fs/partitions/check.c
@@ -255,7 +255,12 @@ ssize_t part_discard_alignment_show(struct device *dev,
 				   struct device_attribute *attr, char *buf)
 {
 	struct hd_struct *p = dev_to_part(dev);
-	return sprintf(buf, "%u\n", p->discard_alignment);
+	struct gendisk *disk = dev_to_disk(dev);
+
+	return sprintf(buf, "%u\n",
+		       (unsigned long long)queue_limit_discard_alignment(
+							&disk->queue->limits,
+							p->start_sect));
 }
 
The struct device that is passed in is not embedded in a struct gendisk.
Therefore de-referencing disk->queue will cause a crash. dev->parent is
embedded in a struct gendisk.

This may not be relevant for the current main-line kernel as this patch
has been backed out.
Disclaimer: I am not really familiar with this code, I just happened to
experience a crash with a (non-mainline) kernel that had this patch and
started to look at it.

- Max 






