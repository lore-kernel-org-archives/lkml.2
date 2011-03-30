Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933197Ab1C3VGP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 17:06:15 -0400
Received: from mga14.intel.com ([143.182.124.37]:31444 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933107Ab1C3VGI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 17:06:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,270,1299484800"; 
   d="scan'208";a="411276746"
From: Andi Kleen <andi@firstfloor.org>
References: <20110330203.501921634@firstfloor.org>
In-Reply-To: <20110330203.501921634@firstfloor.org>
To: stern@rowland.harvard.edu, ak@linux.intel.com, neben@vmware.com,
        gregkh@suse.de, linux-kernel@vger.kernel.org, stable@kernel.org,
        tim.bird@am.sony.com
Subject: [PATCH] [30/275] USB: prevent buggy hubs from crashing the USB stack
Message-Id: <20110330210425.4A3F63E1A05@tassilo.jf.intel.com>
Date: Wed, 30 Mar 2011 14:04:25 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Alan Stern <stern@rowland.harvard.edu>

commit d199c96d41d80a567493e12b8e96ea056a1350c1 upstream.

If anyone comes across a high-speed hub that (by mistake or by design)
claims to have no Transaction Translators, plugging a full- or
low-speed device into it will cause the USB stack to crash.  This
patch (as1446) prevents the problem by ignoring such devices, since
the kernel has no way to communicate with them.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Andi Kleen <ak@linux.intel.com>
Tested-by: Perry Neben <neben@vmware.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/core/hub.c |    5 +++++
 1 file changed, 5 insertions(+)

Index: linux-2.6.35.y/drivers/usb/core/hub.c
===================================================================
--- linux-2.6.35.y.orig/drivers/usb/core/hub.c	2011-03-29 22:51:56.618274449 -0700
+++ linux-2.6.35.y/drivers/usb/core/hub.c	2011-03-29 23:55:06.774293840 -0700
@@ -2721,6 +2721,11 @@
 		udev->ttport = hdev->ttport;
 	} else if (udev->speed != USB_SPEED_HIGH
 			&& hdev->speed == USB_SPEED_HIGH) {
+		if (!hub->tt.hub) {
+			dev_err(&udev->dev, "parent hub has no TT\n");
+			retval = -EINVAL;
+			goto fail;
+		}
 		udev->tt = &hub->tt;
 		udev->ttport = port1;
 	}
