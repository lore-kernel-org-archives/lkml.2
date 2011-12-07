Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757838Ab1LGQZZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 11:25:25 -0500
Received: from cantor2.suse.de ([195.135.220.15]:34628 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757802Ab1LGQZO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 11:25:14 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Dec  7 08:12:20 2011
Message-Id: <20111207161220.218226125@clark.kroah.org>
User-Agent: quilt/0.50-23.1
Date: Wed, 07 Dec 2011 08:12:08 -0800
From: Greg KH <gregkh@suse.de>
To: <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>
Cc: <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <alan@lxorguk.ukuu.org.uk>, Alessandro Rubini <rubini@gnudd.com>,
        Federico Vaga <federico.vaga@gmail.com>
Subject: [066/104] Staging: comedi: fix mmap_count
In-Reply-To: <20111207161246.GA10995@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Federico Vaga <federico.vaga@gmail.com>

commit df30b21cb0eed5ba8a8e0cdfeebc66ba8cde821d upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/staging/comedi/comedi_fops.c |   19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

--- a/drivers/staging/comedi/comedi_fops.c
+++ b/drivers/staging/comedi/comedi_fops.c
@@ -1432,7 +1432,21 @@ static int do_cancel(struct comedi_devic
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
@@ -1446,7 +1460,8 @@ static void comedi_unmap(struct vm_area_
 }
 
 static struct vm_operations_struct comedi_vm_ops = {
-	.close = comedi_unmap,
+	.open = comedi_vm_open,
+	.close = comedi_vm_close,
 };
 
 static int comedi_mmap(struct file *file, struct vm_area_struct *vma)


