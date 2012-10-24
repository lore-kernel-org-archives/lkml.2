Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934277Ab2JXCtu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 22:49:50 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:62743 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934056Ab2JXCts (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 22:49:48 -0400
From: Ming Lei <ming.lei@canonical.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Ming Lei <ming.lei@canonical.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 1/2] firmware loader: document kernel direct loading
Date: Wed, 24 Oct 2012 10:49:33 +0800
Message-Id: <1351046973-2178-1-git-send-email-ming.lei@canonical.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds description on recently introduced direct firmware
loading by Linus.

Cc: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Ming Lei <ming.lei@canonical.com>
---
 Documentation/firmware_class/README |   26 +++++++++++++++++---------
 1 file changed, 17 insertions(+), 9 deletions(-)

diff --git a/Documentation/firmware_class/README b/Documentation/firmware_class/README
index 7eceaff..815b711 100644
--- a/Documentation/firmware_class/README
+++ b/Documentation/firmware_class/README
@@ -18,32 +18,40 @@
  High level behavior (mixed):
  ============================
 
- kernel(driver): calls request_firmware(&fw_entry, $FIRMWARE, device)
-
- userspace:
+ 1), kernel(driver):
+	- calls request_firmware(&fw_entry, $FIRMWARE, device)
+	- kernel searchs the fimware image with name $FIRMWARE directly
+	in the below search path of root filesystem:
+		"/lib/firmware/updates/" UTS_RELEASE,
+		"/lib/firmware/updates",
+		"/lib/firmware/" UTS_RELEASE,
+		"/lib/firmware"
+	- If found, goto 7), else goto 2)
+
+ 2), userspace:
  	- /sys/class/firmware/xxx/{loading,data} appear.
 	- hotplug gets called with a firmware identifier in $FIRMWARE
 	  and the usual hotplug environment.
 		- hotplug: echo 1 > /sys/class/firmware/xxx/loading
 
- kernel: Discard any previous partial load.
+ 3), kernel: Discard any previous partial load.
 
- userspace:
+ 4), userspace:
 		- hotplug: cat appropriate_firmware_image > \
 					/sys/class/firmware/xxx/data
 
- kernel: grows a buffer in PAGE_SIZE increments to hold the image as it
+ 5), kernel: grows a buffer in PAGE_SIZE increments to hold the image as it
 	 comes in.
 
- userspace:
+ 6), userspace:
 		- hotplug: echo 0 > /sys/class/firmware/xxx/loading
 
- kernel: request_firmware() returns and the driver has the firmware
+ 7), kernel: request_firmware() returns and the driver has the firmware
 	 image in fw_entry->{data,size}. If something went wrong
 	 request_firmware() returns non-zero and fw_entry is set to
 	 NULL.
 
- kernel(driver): Driver code calls release_firmware(fw_entry) releasing
+ 8), kernel(driver): Driver code calls release_firmware(fw_entry) releasing
 		 the firmware image and any related resource.
 
  High level behavior (driver code):
-- 
1.7.9.5

