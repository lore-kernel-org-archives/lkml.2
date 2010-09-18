Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756728Ab0IRTPQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Sep 2010 15:15:16 -0400
Received: from kroah.org ([198.145.64.141]:43397 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756812Ab0IRTPN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Sep 2010 15:15:13 -0400
X-Mailbox-Line: From gregkh@clark.site Sat Sep 18 12:13:01 2010
Message-Id: <20100918191301.616041702@clark.site>
User-Agent: quilt/0.48-11.2
Date: Sat, 18 Sep 2010 12:12:28 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Toby Gray <toby.gray@realvnc.com>, Oliver Neukum <oliver@neukum.name>
Subject: [050/129] USB: cdc-acm: Fixing crash when ACM probing interfaces with no endpoint descriptors.
In-Reply-To: <20100918191317.GA11386@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Toby Gray <toby.gray@realvnc.com>

commit 577045c0a76e34294f902a7d5d60e90b04d094d0 upstream.

Certain USB devices, such as the Nokia X6 mobile phone, don't expose any
endpoint descriptors on some of their interfaces. If the ACM driver is forced
to probe all interfaces on a device the a NULL pointer dereference will occur
when the ACM driver attempts to use the endpoint of the alternative settings.
One way to get the ACM driver to probe all the interfaces is by using the
/sys/bus/usb/drivers/cdc_acm/new_id interface.

This patch checks that the endpoint pointer for the current alternate settings
is non-NULL before using it.

Signed-off-by: Toby Gray <toby.gray@realvnc.com>
Cc: Oliver Neukum <oliver@neukum.name>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/class/cdc-acm.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/usb/class/cdc-acm.c
+++ b/drivers/usb/class/cdc-acm.c
@@ -971,7 +971,8 @@ static int acm_probe(struct usb_interfac
 	}
 
 	if (!buflen) {
-		if (intf->cur_altsetting->endpoint->extralen &&
+		if (intf->cur_altsetting->endpoint &&
+				intf->cur_altsetting->endpoint->extralen &&
 				intf->cur_altsetting->endpoint->extra) {
 			dev_dbg(&intf->dev,
 				"Seeking extra descriptors on endpoint\n");


