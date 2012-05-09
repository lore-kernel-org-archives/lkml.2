Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755629Ab2EIFwx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 01:52:53 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:38728 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755513Ab2EIFwu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 01:52:50 -0400
Message-Id: <20120509055034.603564203@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Wed, 09 May 2012 06:51:05 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        Andrzej Pietrasiewicz <andrzej.p@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>, Felipe Balbi <balbi@ti.com>
Subject: [ 036/167] [PATCH] usb: gadget: eliminate NULL pointer dereference (bugfix)
In-Reply-To: <20120509055029.588587017@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrzej Pietrasiewicz <andrzej.p@samsung.com>

commit 92b0abf80c5c5f0e0d71d1309688a330fd74731b upstream.

usb: gadget: eliminate NULL pointer dereference (bugfix)

This patch fixes a bug which causes NULL pointer dereference in
ffs_ep0_ioctl. The bug happens when the FunctionFS is not bound (either
has not been bound yet or has been bound and then unbound) and can be
reproduced with running the following commands:

$ insmod g_ffs.ko
$ mount -t functionfs func /dev/usbgadget
$ ./null

where null.c is:

#include <fcntl.h>
#include <linux/usb/functionfs.h>

int main(void)
{
	int fd = open("/dev/usbgadget/ep0", O_RDWR);
	ioctl(fd, FUNCTIONFS_CLEAR_HALT);

	return 0;
}

Signed-off-by: Andrzej Pietrasiewicz <andrzej.p@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
Signed-off-by: Felipe Balbi <balbi@ti.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/usb/gadget/f_fs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/gadget/f_fs.c b/drivers/usb/gadget/f_fs.c
index d187ae7..f52cb1a 100644
--- a/drivers/usb/gadget/f_fs.c
+++ b/drivers/usb/gadget/f_fs.c
@@ -712,7 +712,7 @@ static long ffs_ep0_ioctl(struct file *file, unsigned code, unsigned long value)
 	if (code == FUNCTIONFS_INTERFACE_REVMAP) {
 		struct ffs_function *func = ffs->func;
 		ret = func ? ffs_func_revmap_intf(func, value) : -ENODEV;
-	} else if (gadget->ops->ioctl) {
+	} else if (gadget && gadget->ops->ioctl) {
 		ret = gadget->ops->ioctl(gadget, code, value);
 	} else {
 		ret = -ENOTTY;
-- 
1.7.10



