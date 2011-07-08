Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755453Ab1GHFHg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 01:07:36 -0400
Received: from cantor2.suse.de ([195.135.220.15]:42597 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755406Ab1GHFF7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jul 2011 01:05:59 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Thu Jul  7 17:17:02 2011
Message-Id: <20110708001702.444757454@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Thu, 07 Jul 2011 17:17:12 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Alan Stern <stern@rowland.harvard.edu>
Subject: [100/107] USB: fix regression occurring during device removal
In-Reply-To: <20110708001740.GA14031@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.39-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Alan Stern <stern@rowland.harvard.edu>

commit e534c5b831c8b8e9f5edee5c8a37753c808b80dc upstream.

This patch (as1476) fixes a regression introduced by
fccf4e86200b8f5edd9a65da26f150e32ba79808 (USB: Free bandwidth when
usb_disable_device is called).  usb_disconnect() grabs the
bandwidth_mutex before calling usb_disable_device(), which calls down
indirectly to usb_set_interface(), which tries to acquire the
bandwidth_mutex.

The fix causes usb_set_interface() to return early when it is called
for an interface that has already been unregistered, which is what
happens in usb_disable_device().

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Tested-by: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/core/message.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/usb/core/message.c
+++ b/drivers/usb/core/message.c
@@ -1286,6 +1286,8 @@ int usb_set_interface(struct usb_device
 			interface);
 		return -EINVAL;
 	}
+	if (iface->unregistering)
+		return -ENODEV;
 
 	alt = usb_altnum_to_altsetting(iface, alternate);
 	if (!alt) {


