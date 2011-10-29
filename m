Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754173Ab1J2Ho5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Oct 2011 03:44:57 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:58990 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752947Ab1J2Ho4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Oct 2011 03:44:56 -0400
From: Federico Vaga <federico.vaga@gmail.com>
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        fmhess@users.sourceforge.net, abbotti@mev.co.uk, rubini@gnudd.com,
        federico.vaga@gmail.com
Subject: [PATCH] Staging: comedi: fix mmap_count
Date: Sat, 29 Oct 2011 09:45:39 +0200
Message-Id: <1319874339-8088-1-git-send-email-federico.vaga@gmail.com>
X-Mailer: git-send-email 1.7.6.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In comedi_fops, mmap_count is decremented at comedi_vm_ops->close but
it is not incremented at comedi_vm_ops->open. This may result in a negative
counter.  The patch introduces the open method to keep the counter
consistent.

The bug was triggerd by this sample code:

        mmap(0, ...., comedi_fd);
        fork();
        exit(0);

Acked-by: Alessandro Rubini <rubini@gnudd.com>
Signed-off-by: Federico Vaga <federico.vaga@gmail.com>
---
 drivers/staging/comedi/comedi_fops.c |   19 +++++++++++++++++--
 1 files changed, 17 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/comedi/comedi_fops.c b/drivers/staging/comedi/comedi_fops.c
index 21d8c1c..173242c 100644
--- a/drivers/staging/comedi/comedi_fops.c
+++ b/drivers/staging/comedi/comedi_fops.c
@@ -1432,7 +1432,21 @@ static int do_cancel(struct comedi_device *dev, struct comedi_subdevice *s)
 	return ret;
 }
 
-static void comedi_unmap(struct vm_area_struct *area)
+
+static void comedi_vm_open(struct vm_area_struct *area)
+{
+	struct comedi_async *async;
+	struct comedi_device *dev;
+
+	async = area->vm_private_data;
+	dev = async->subdevice->device;
+
+	mutex_lock(&dev->mutex);
+	async->mmap_count++;
+	mutex_unlock(&dev->mutex);
+}
+
+static void comedi_vm_close(struct vm_area_struct *area)
 {
 	struct comedi_async *async;
 	struct comedi_device *dev;
@@ -1446,7 +1460,8 @@ static void comedi_unmap(struct vm_area_struct *area)
 }
 
 static struct vm_operations_struct comedi_vm_ops = {
-	.close = comedi_unmap,
+	.open = comedi_vm_open,
+	.close = comedi_vm_close,
 };
 
 static int comedi_mmap(struct file *file, struct vm_area_struct *vma)
-- 
1.5.6.5

