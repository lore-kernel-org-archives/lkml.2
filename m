Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759229Ab2FQSet (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2012 14:34:49 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:50222 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758153Ab2FQSWn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2012 14:22:43 -0400
Message-Id: <20120617175951.096045500@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 17 Jun 2012 19:00:48 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Daniel Mack <zonque@gmail.com>,
        bEN <ml_all@circa.be>, Ivan Perrone <ivanperrone@hotmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [ 67/69] USB: fix gathering of interface associations
In-Reply-To: <20120617175941.281333656@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Mack <zonque@gmail.com>

commit b3a3dd074f7053ef824ad077e5331b52220ceba1 upstream.

TEAC's UD-H01 (and probably other devices) have a gap in the interface
number allocation of their descriptors:

  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength          220
    bNumInterfaces          3
    [...]
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       0
      [...]
    Interface Association:
      bLength                 8
      bDescriptorType        11
      bFirstInterface         2
      bInterfaceCount         2
      bFunctionClass          1 Audio
      bFunctionSubClass       0
      bFunctionProtocol      32
      iFunction               4
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        2
      bAlternateSetting       0
      [...]

Once a configuration is selected, usb_set_configuration() walks the
known interfaces of a given configuration and calls find_iad() on
each of them to set the interface association pointer the interface
is included in.

The problem here is that the loop variable is taken for the interface
number in the comparison logic that gathers the association. Which is
fine as long as the descriptors are sane.

In the case above, however, the logic gets out of sync and the
interface association fields of all interfaces beyond the interface
number gap are wrong.

Fix this by passing the interface's bInterfaceNumber to find_iad()
instead.

Signed-off-by: Daniel Mack <zonque@gmail.com>
Reported-by: bEN <ml_all@circa.be>
Reported-by: Ivan Perrone <ivanperrone@hotmail.com>
Tested-by: ivan perrone <ivanperrone@hotmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/usb/core/message.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/core/message.c b/drivers/usb/core/message.c
index b548cf1..bdd1c67 100644
--- a/drivers/usb/core/message.c
+++ b/drivers/usb/core/message.c
@@ -1838,7 +1838,6 @@ free_interfaces:
 		intfc = cp->intf_cache[i];
 		intf->altsetting = intfc->altsetting;
 		intf->num_altsetting = intfc->num_altsetting;
-		intf->intf_assoc = find_iad(dev, cp, i);
 		kref_get(&intfc->ref);
 
 		alt = usb_altnum_to_altsetting(intf, 0);
@@ -1851,6 +1850,8 @@ free_interfaces:
 		if (!alt)
 			alt = &intf->altsetting[0];
 
+		intf->intf_assoc =
+			find_iad(dev, cp, alt->desc.bInterfaceNumber);
 		intf->cur_altsetting = alt;
 		usb_enable_interface(dev, intf, true);
 		intf->dev.parent = &dev->dev;


