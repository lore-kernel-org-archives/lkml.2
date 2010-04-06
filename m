Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932185Ab0DFWAX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 18:00:23 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:49156 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757519Ab0DFWAB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 18:00:01 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Tue, 6 Apr 2010 23:59:45 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH] firewire: cdev: fix information leak
To: linux1394-devel@lists.sourceforge.net
cc: Clemens Ladisch <clemens@ladisch.de>, linux-kernel@vger.kernel.org
In-Reply-To: <tkrat.630b7e060062afa9@s5r6.in-berlin.de>
Message-ID: <tkrat.30d7a4f8f7a97b2b@s5r6.in-berlin.de>
References: <4BBAD1BC.2070100@ladisch.de> <4BBADAA1.9050508@s5r6.in-berlin.de>
 <4BBAF7EE.5000804@ladisch.de> <4BBB8851.6000509@s5r6.in-berlin.de>
 <tkrat.0047dfa7530926c0@s5r6.in-berlin.de>
 <tkrat.630b7e060062afa9@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A userspace client got to see uninitialized stack-allocated memory if it
specified an _IOC_READ type of ioctl and an argument size larger than
expected by firewire-core's ioctl handlers (but not larger than the
core's union ioctl_arg).

Fix this by clearing the requested buffer size to zero, but only at _IOR
ioctls.  This way, there is almost no runtime penalty to legit ioctls.
The only legit _IOR is FW_CDEV_IOC_GET_CYCLE_TIMER with 12...16 bytes to
memset.

[Another way to fix this would be strict checking of argument size (and
possibly direction) vs. command number.  However, we then need a lookup
table, and we need to allow for slight size deviations in case of 32bit
userland on 64bit kernel.]

Reported-by: Clemens Ladisch <clemens@ladisch.de>
Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/core-cdev.c |   18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

Index: b/drivers/firewire/core-cdev.c
===================================================================
--- a/drivers/firewire/core-cdev.c
+++ b/drivers/firewire/core-cdev.c
@@ -1346,41 +1346,43 @@ static int (* const ioctl_handlers[])(st
 static int dispatch_ioctl(struct client *client,
 			  unsigned int cmd, void __user *arg)
 {
 	union ioctl_arg buffer;
 	int ret;
 
 	if (fw_device_is_shutdown(client->device))
 		return -ENODEV;
 
 	if (_IOC_TYPE(cmd) != '#' ||
 	    _IOC_NR(cmd) >= ARRAY_SIZE(ioctl_handlers))
 		return -EINVAL;
 
-	if (_IOC_DIR(cmd) & _IOC_WRITE) {
-		if (_IOC_SIZE(cmd) > sizeof(buffer) ||
-		    copy_from_user(&buffer, arg, _IOC_SIZE(cmd)))
+	if (_IOC_SIZE(cmd) > sizeof(buffer))
+		return -EFAULT;
+
+	if (_IOC_DIR(cmd) == _IOC_READ)
+		memset(&buffer, 0, _IOC_SIZE(cmd));
+
+	if (_IOC_DIR(cmd) & _IOC_WRITE)
+		if (copy_from_user(&buffer, arg, _IOC_SIZE(cmd)))
 			return -EFAULT;
-	}
 
 	ret = ioctl_handlers[_IOC_NR(cmd)](client, &buffer);
 	if (ret < 0)
 		return ret;
 
-	if (_IOC_DIR(cmd) & _IOC_READ) {
-		if (_IOC_SIZE(cmd) > sizeof(buffer) ||
-		    copy_to_user(arg, &buffer, _IOC_SIZE(cmd)))
+	if (_IOC_DIR(cmd) & _IOC_READ)
+		if (copy_to_user(arg, &buffer, _IOC_SIZE(cmd)))
 			return -EFAULT;
-	}
 
 	return ret;
 }
 
 static long fw_device_op_ioctl(struct file *file,
 			       unsigned int cmd, unsigned long arg)
 {
 	return dispatch_ioctl(file->private_data, cmd, (void __user *)arg);
 }
 
 #ifdef CONFIG_COMPAT
 static long fw_device_op_compat_ioctl(struct file *file,
 				      unsigned int cmd, unsigned long arg)

-- 
Stefan Richter
-=====-==-=- -=-- --==-
http://arcgraph.de/sr/

