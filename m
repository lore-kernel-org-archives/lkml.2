Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932617Ab2DXWgN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 18:36:13 -0400
Received: from mail-pz0-f51.google.com ([209.85.210.51]:33944 "EHLO
	mail-pz0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758079Ab2DXWgK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 18:36:10 -0400
Message-Id: <20120424223245.748856519@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Tue, 24 Apr 2012 15:33:25 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        Andrzej Pietrasiewicz <andrzej.p@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>, Felipe Balbi <balbi@ti.com>
Subject: [ 44/62] usb: gadget: eliminate NULL pointer dereference (bugfix)
In-Reply-To: <20120424223305.GA7748@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.3-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/gadget/f_fs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/gadget/f_fs.c
+++ b/drivers/usb/gadget/f_fs.c
@@ -712,7 +712,7 @@ static long ffs_ep0_ioctl(struct file *f
 	if (code == FUNCTIONFS_INTERFACE_REVMAP) {
 		struct ffs_function *func = ffs->func;
 		ret = func ? ffs_func_revmap_intf(func, value) : -ENODEV;
-	} else if (gadget->ops->ioctl) {
+	} else if (gadget && gadget->ops->ioctl) {
 		ret = gadget->ops->ioctl(gadget, code, value);
 	} else {
 		ret = -ENOTTY;


