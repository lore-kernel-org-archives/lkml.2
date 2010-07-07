Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754960Ab0GGMNW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jul 2010 08:13:22 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:42578 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753078Ab0GGMNV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jul 2010 08:13:21 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Wed, 7 Jul 2010 14:13:14 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATH] firewire: core: ensure some userspace API constants match
 corresponding kernel API constants
To: linux1394-devel@lists.sourceforge.net
cc: linux-kernel@vger.kernel.org
Message-ID: <tkrat.f278c45247385297@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The FW_ISO_ constants of the in-kernel API of firewire-core and
FW_CDEV_ISO_ constants of the userspace API of firewire-core have
nothing to do with each other --- except that the core-cdev.c
implementation relies on them having the same values.

Hence put some compile-time assertions into core-cdev.c.  It's lame but
I prefer it over including the userspace API header into the kernelspace
API header and defining kernelspace API constants from userspace API
constants.  Nor do I want to expose the kernelspace constants in one of
the two firewire headers that are exported to userland since this only
concerns the core-cdev.c implementation.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/core-cdev.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

Index: b/drivers/firewire/core-cdev.c
===================================================================
--- a/drivers/firewire/core-cdev.c
+++ b/drivers/firewire/core-cdev.c
@@ -18,6 +18,7 @@
  * Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
  */
 
+#include <linux/bug.h>
 #include <linux/compat.h>
 #include <linux/delay.h>
 #include <linux/device.h>
@@ -912,6 +913,9 @@ static int ioctl_create_iso_context(stru
 	struct fw_cdev_create_iso_context *a = &arg->create_iso_context;
 	struct fw_iso_context *context;
 
+	BUILD_BUG_ON(FW_CDEV_ISO_CONTEXT_TRANSMIT != FW_ISO_CONTEXT_TRANSMIT ||
+		     FW_CDEV_ISO_CONTEXT_RECEIVE  != FW_ISO_CONTEXT_RECEIVE);
+
 	if (a->channel > 63)
 		return -EINVAL;
 
@@ -1063,6 +1067,13 @@ static int ioctl_start_iso(struct client
 {
 	struct fw_cdev_start_iso *a = &arg->start_iso;
 
+	BUILD_BUG_ON(
+	    FW_CDEV_ISO_CONTEXT_MATCH_TAG0 != FW_ISO_CONTEXT_MATCH_TAG0 ||
+	    FW_CDEV_ISO_CONTEXT_MATCH_TAG1 != FW_ISO_CONTEXT_MATCH_TAG1 ||
+	    FW_CDEV_ISO_CONTEXT_MATCH_TAG2 != FW_ISO_CONTEXT_MATCH_TAG2 ||
+	    FW_CDEV_ISO_CONTEXT_MATCH_TAG3 != FW_ISO_CONTEXT_MATCH_TAG3 ||
+	    FW_CDEV_ISO_CONTEXT_MATCH_ALL_TAGS != FW_ISO_CONTEXT_MATCH_ALL_TAGS);
+
 	if (client->iso_context == NULL || a->handle != 0)
 		return -EINVAL;
 
 

-- 
Stefan Richter
-=====-==-=- -=== --===
http://arcgraph.de/sr/

