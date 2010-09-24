Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932473Ab0IXQ1w (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 12:27:52 -0400
Received: from kroah.org ([198.145.64.141]:45997 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753818Ab0IXQ1v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 12:27:51 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Sep 24 09:26:15 2010
Message-Id: <20100924162615.000690313@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 24 Sep 2010 09:23:49 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Mathias Nyman <mathias.nyman@nokia.com>
Subject: [01/80] usb: musb_debugfs: dont use the struct file private_data field with seq_files
In-Reply-To: <20100924162706.GA7381@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Mathias Nyman <mathias.nyman@nokia.com>

commit 024cfa5943a7e89565c60b612d698c2bfb3da66a upstream.

seq_files use the private_data field of a file struct for storing a seq_file structure,
data should be stored in seq_file's own private field (e.g. file->private_data->private)
Otherwise seq_release() will free the private data when the file is closed.

Signed-off-by: Mathias Nyman <mathias.nyman@nokia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/musb/musb_debugfs.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/drivers/usb/musb/musb_debugfs.c
+++ b/drivers/usb/musb/musb_debugfs.c
@@ -195,15 +195,14 @@ static const struct file_operations musb
 
 static int musb_test_mode_open(struct inode *inode, struct file *file)
 {
-	file->private_data = inode->i_private;
-
 	return single_open(file, musb_test_mode_show, inode->i_private);
 }
 
 static ssize_t musb_test_mode_write(struct file *file,
 		const char __user *ubuf, size_t count, loff_t *ppos)
 {
-	struct musb		*musb = file->private_data;
+	struct seq_file		*s = file->private_data;
+	struct musb		*musb = s->private;
 	u8			test = 0;
 	char			buf[18];
 


