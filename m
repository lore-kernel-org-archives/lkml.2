Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932417Ab0KSVpr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 16:45:47 -0500
Received: from kroah.org ([198.145.64.141]:51904 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932393Ab0KSVpn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 16:45:43 -0500
X-Mailbox-Line: From gregkh@clark.site Fri Nov 19 13:44:12 2010
Message-Id: <20101119214412.882240243@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 19 Nov 2010 13:43:22 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Dan Carpenter <error27@gmail.com>,
        James Bottomley <James.Bottomley@suse.de>
Subject: [42/45] [SCSI] gdth: integer overflow in ioctl
In-Reply-To: <20101119214439.GA26350@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Dan Carpenter <error27@gmail.com>

commit f63ae56e4e97fb12053590e41a4fa59e7daa74a4 upstream.

gdth_ioctl_alloc() takes the size variable as an int.
copy_from_user() takes the size variable as an unsigned long.
gen.data_len and gen.sense_len are unsigned longs.
On x86_64 longs are 64 bit and ints are 32 bit.

We could pass in a very large number and the allocation would truncate
the size to 32 bits and allocate a small buffer.  Then when we do the
copy_from_user(), it would result in a memory corruption.

Signed-off-by: Dan Carpenter <error27@gmail.com>
Signed-off-by: James Bottomley <James.Bottomley@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/scsi/gdth.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/scsi/gdth.c
+++ b/drivers/scsi/gdth.c
@@ -4174,6 +4174,14 @@ static int ioc_general(void __user *arg,
     ha = gdth_find_ha(gen.ionode);
     if (!ha)
         return -EFAULT;
+
+    if (gen.data_len > INT_MAX)
+        return -EINVAL;
+    if (gen.sense_len > INT_MAX)
+        return -EINVAL;
+    if (gen.data_len + gen.sense_len > INT_MAX)
+        return -EINVAL;
+
     if (gen.data_len + gen.sense_len != 0) {
         if (!(buf = gdth_ioctl_alloc(ha, gen.data_len + gen.sense_len,
                                      FALSE, &paddr)))


