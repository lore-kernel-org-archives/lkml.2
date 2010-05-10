Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933494Ab0EJXmv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 19:42:51 -0400
Received: from kroah.org ([198.145.64.141]:32960 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932350Ab0EJWvz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 18:51:55 -0400
X-Mailbox-Line: From gregkh@kvm.kroah.org Mon May 10 15:33:19 2010
Message-Id: <20100510223319.460566761@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Mon, 10 May 2010 15:31:56 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Roel Kluin <roel.kluin@gmail.com>,
       Alan Stern <stern@rowland.harvard.edu>,
       Sarah Sharp <sarah.a.sharp@linux.intel.com>
Subject: [025/117] USB: dont read past config->interface[] if usb_control_msg() fails in usb_reset_configuration()
In-Reply-To: <20100510223700.GA18404@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Roel Kluin <roel.kluin@gmail.com>

commit e4a3d94658b5760fc947d7f7185c57db47ca362a upstream.

While looping over the interfaces, if usb_hcd_alloc_bandwidth() fails it calls
hcd->driver->reset_bandwidth(), so there was no need to reinstate the interface
again.

If no break occurred, the index equals config->desc.bNumInterfaces. A
subsequent usb_control_msg() failure resulted in a read from
config->interface[config->desc.bNumInterfaces] at label reset_old_alts.

In either case the last interface should be skipped.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Acked-by: Alan Stern <stern@rowland.harvard.edu>
Acked-by: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/core/message.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/core/message.c
+++ b/drivers/usb/core/message.c
@@ -1471,7 +1471,7 @@ int usb_reset_configuration(struct usb_d
 	/* If not, reinstate the old alternate settings */
 	if (retval < 0) {
 reset_old_alts:
-		for (; i >= 0; i--) {
+		for (i--; i >= 0; i--) {
 			struct usb_interface *intf = config->interface[i];
 			struct usb_host_interface *alt;
 


