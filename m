Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965305Ab2CBIl6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2012 03:41:58 -0500
Received: from mailout-de.gmx.net ([213.165.64.22]:50572 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755098Ab2CBIl4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2012 03:41:56 -0500
X-Authenticated: #10150493
X-Provags-ID: V01U2FsdGVkX1888IFRWWc8MAmzfb0XnjgfpvGJLjU0wD+MTJdNoC
	gBspZFQvv8ca9D
Message-ID: <4F5087CE.50304@gmx.de>
Date: Fri, 02 Mar 2012 09:41:50 +0100
From: Thomas Faber <thfabba@gmx.de>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:10.0.1) Gecko/20120208 Thunderbird/10.0.1
MIME-Version: 1.0
To: Felipe Balbi <balbi@ti.com>, linux-usb@vger.kernel.org
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] usb: gadgetfs: return number of bytes on ep0 read request
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A read from GadgetFS endpoint 0 during the data stage of a control
request would always return 0 on success (as returned by
wait_event_interruptible) despite having written data into the user
buffer.
This patch makes it correctly set the return value to the number of
bytes read.

Signed-off-by: Thomas Faber <thfabba@gmx.de>
---
 drivers/usb/gadget/inode.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/usb/gadget/inode.c b/drivers/usb/gadget/inode.c
index ae04266..4f18a0e 100644
--- a/drivers/usb/gadget/inode.c
+++ b/drivers/usb/gadget/inode.c
@@ -1043,6 +1043,8 @@ ep0_read (struct file *fd, char __user *buf, size_t len, loff_t *ptr)
 // FIXME don't call this with the spinlock held ...
 				if (copy_to_user (buf, dev->req->buf, len))
 					retval = -EFAULT;
+				else
+					retval = len;
 				clean_req (dev->gadget->ep0, dev->req);
 				/* NOTE userspace can't yet choose to stall */
 			}
-- 
1.7.3.4
