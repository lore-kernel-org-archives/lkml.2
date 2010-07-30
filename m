Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760198Ab0G3SQG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 14:16:06 -0400
Received: from kroah.org ([198.145.64.141]:58854 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760063Ab0G3R4y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 13:56:54 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Jul 30 10:51:46 2010
Message-Id: <20100730175146.323007759@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 30 Jul 2010 10:52:33 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>
Subject: [136/205] USB: Fix USB3.0 Port Speed Downgrade after port reset
In-Reply-To: <20100730175238.GA3924@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.34-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Sarah Sharp <sarah.a.sharp@linux.intel.com>

commit 809cd1cb80d7dffe75dc94bc94ef2aab3dadc86a upstream.

Without this fix, a USB 3.0 port is downgraded to full speed after a port
reset of a configured device.  The USB 3.0 terminations will be disabled
permanently, and USB 3.0 devices will always enumerate as full speed
devices, until the host controller is unplugged (if it is an ExpressCard)
or the computer is rebooted.

Fajun Chen traced this traced the speed downgrade issue to the port reset
and the interpretation of port status in USB hub driver code.  The hub
code was not testing for the port being a SuperSpeed port, and it fell
through to the else case of Full Speed.

The following patch adds SuperSpeed mapping from the port status, and
fixes the speed downgrade issue.

Reported-by: Fajun Chen <fajun.chen@seagate.com>
Signed-off-by: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>


---
 drivers/usb/core/hub.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -1971,6 +1971,8 @@ static int hub_port_wait_reset(struct us
 		    (portstatus & USB_PORT_STAT_ENABLE)) {
 			if (hub_is_wusb(hub))
 				udev->speed = USB_SPEED_WIRELESS;
+			else if (portstatus & (1 << USB_PORT_FEAT_SUPERSPEED))
+				udev->speed = USB_SPEED_SUPER;
 			else if (portstatus & USB_PORT_STAT_HIGH_SPEED)
 				udev->speed = USB_SPEED_HIGH;
 			else if (portstatus & USB_PORT_STAT_LOW_SPEED)


