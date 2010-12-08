Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756106Ab0LHArQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 19:47:16 -0500
Received: from kroah.org ([198.145.64.141]:46094 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756026Ab0LHArL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 19:47:11 -0500
X-Mailbox-Line: From gregkh@clark.site Tue Dec  7 16:44:29 2010
Message-Id: <20101208004429.006887305@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 07 Dec 2010 16:43:53 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Stefan Richter <stefanr@s5r6.in-berlin.de>,
        maximilian attems <max@stro.at>
Subject: [047/127] firewire: cdev: fix information leak
In-Reply-To: <20101208004456.GA23578@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Stefan Richter <stefanr@s5r6.in-berlin.de>

commit 9cac00b8f0079d5d3d54ec4dae453d58dec30e7c upstream.

A userspace client got to see uninitialized stack-allocated memory if it
specified an _IOC_READ type of ioctl and an argument size larger than
expected by firewire-core's ioctl handlers (but not larger than the
core's union ioctl_arg).

Fix this by clearing the requested buffer size to zero, but only at _IOR
ioctls.  This way, there is almost no runtime penalty to legitimate
ioctls.  The only legitimate _IOR is FW_CDEV_IOC_GET_CYCLE_TIMER with 12
or 16 bytes to memset.

[Another way to fix this would be strict checking of argument size (and
possibly direction) vs. command number.  However, we then need a lookup
table, and we need to allow for slight size deviations in case of 32bit
userland on 64bit kernel.]

Reported-by: Clemens Ladisch <clemens@ladisch.de>
Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
[ Backported to 2.6.32 firewire core -maks ]
Signed-off-by: maximilian attems <max@stro.at>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/firewire/core-cdev.c |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

--- a/drivers/firewire/core-cdev.c
+++ b/drivers/firewire/core-cdev.c
@@ -1299,24 +1299,24 @@ static int dispatch_ioctl(struct client
 	int ret;
 
 	if (_IOC_TYPE(cmd) != '#' ||
-	    _IOC_NR(cmd) >= ARRAY_SIZE(ioctl_handlers))
+	    _IOC_NR(cmd) >= ARRAY_SIZE(ioctl_handlers) ||
+	    _IOC_SIZE(cmd) > sizeof(buffer))
 		return -EINVAL;
 
-	if (_IOC_DIR(cmd) & _IOC_WRITE) {
-		if (_IOC_SIZE(cmd) > sizeof(buffer) ||
-		    copy_from_user(buffer, arg, _IOC_SIZE(cmd)))
+	if (_IOC_DIR(cmd) == _IOC_READ)
+		memset(&buffer, 0, _IOC_SIZE(cmd));
+
+	if (_IOC_DIR(cmd) & _IOC_WRITE)
+		if (copy_from_user(buffer, arg, _IOC_SIZE(cmd)))
 			return -EFAULT;
-	}
 
 	ret = ioctl_handlers[_IOC_NR(cmd)](client, buffer);
 	if (ret < 0)
 		return ret;
 
-	if (_IOC_DIR(cmd) & _IOC_READ) {
-		if (_IOC_SIZE(cmd) > sizeof(buffer) ||
-		    copy_to_user(arg, buffer, _IOC_SIZE(cmd)))
+	if (_IOC_DIR(cmd) & _IOC_READ)
+		if (copy_to_user(arg, buffer, _IOC_SIZE(cmd)))
 			return -EFAULT;
-	}
 
 	return ret;
 }


