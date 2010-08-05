Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760900Ab0HEWeK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 18:34:10 -0400
Received: from kroah.org ([198.145.64.141]:37754 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934144Ab0HEWYo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 18:24:44 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Magnus Damm <damm@opensource.se>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 12/28] firmware: Update hotplug script
Date: Thu,  5 Aug 2010 15:24:02 -0700
Message-Id: <1281047058-23716-12-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.2
In-Reply-To: <20100805213314.GB13744@kroah.com>
References: <20100805213314.GB13744@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Magnus Damm <damm@opensource.se>

Update the in-kernel hotplug example script to work
properly with recent kernels. Without this fix the
script may load the firmware twice - both at "add"
and "remove" time.

The second load only triggers in the case when multiple
firmware images are used. A good example is the b43
driver which does not work properly without this fix.

Signed-off-by: Magnus Damm <damm@opensource.se>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 Documentation/firmware_class/hotplug-script |   17 +++++++++--------
 1 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/Documentation/firmware_class/hotplug-script b/Documentation/firmware_class/hotplug-script
index 1990130..8143a95 100644
--- a/Documentation/firmware_class/hotplug-script
+++ b/Documentation/firmware_class/hotplug-script
@@ -6,11 +6,12 @@
 
 HOTPLUG_FW_DIR=/usr/lib/hotplug/firmware/
 
-echo 1 > /sys/$DEVPATH/loading
-cat $HOTPLUG_FW_DIR/$FIRMWARE > /sys/$DEVPATH/data
-echo 0 > /sys/$DEVPATH/loading
-
-# To cancel the load in case of error:
-#
-#	echo -1 > /sys/$DEVPATH/loading
-#
+if [ "$SUBSYSTEM" == "firmware" -a "$ACTION" == "add" ]; then
+  if [ -f $HOTPLUG_FW_DIR/$FIRMWARE ]; then
+    echo 1 > /sys/$DEVPATH/loading
+    cat $HOTPLUG_FW_DIR/$FIRMWARE > /sys/$DEVPATH/data
+    echo 0 > /sys/$DEVPATH/loading
+  else
+    echo -1 > /sys/$DEVPATH/loading
+  fi
+fi
-- 
1.7.2

