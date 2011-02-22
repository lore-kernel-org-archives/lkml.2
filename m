Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752758Ab1BVWVE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 17:21:04 -0500
Received: from kroah.org ([198.145.64.141]:46539 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751824Ab1BVWVA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 17:21:00 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 22 14:18:37 2011
Message-Id: <20110222221837.247265755@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 22 Feb 2011 14:16:41 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Kashyap Desai <kashyap.desai@lsi.com>,
        James Bottomley <James.Bottomley@suse.de>
Subject: [02/70] [SCSI] mptfusion: mptctl_release is required in mptctl.c
In-Reply-To: <20110222222003.GA15831@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Kashyap, Desai <kashyap.desai@lsi.com>

commit 84857c8bf83e8aa87afc57d2956ba01f11d82386 upstream.

Added missing release callback for file_operations mptctl_fops.
Without release callback there will be never freed. It remains on
mptctl's eent list even after the file is closed and released.

Relavent RHEL bugzilla is 660871

Signed-off-by: Kashyap Desai <kashyap.desai@lsi.com>
Signed-off-by: James Bottomley <James.Bottomley@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/message/fusion/mptctl.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/message/fusion/mptctl.c
+++ b/drivers/message/fusion/mptctl.c
@@ -597,6 +597,13 @@ mptctl_event_process(MPT_ADAPTER *ioc, E
 }
 
 static int
+mptctl_release(struct inode *inode, struct file *filep)
+{
+	fasync_helper(-1, filep, 0, &async_queue);
+	return 0;
+}
+
+static int
 mptctl_fasync(int fd, struct file *filep, int mode)
 {
 	MPT_ADAPTER	*ioc;
@@ -2815,6 +2822,7 @@ static const struct file_operations mptc
 	.llseek =	no_llseek,
 	.fasync = 	mptctl_fasync,
 	.unlocked_ioctl = mptctl_ioctl,
+	.release =	mptctl_release,
 #ifdef CONFIG_COMPAT
 	.compat_ioctl = compat_mpctl_ioctl,
 #endif


