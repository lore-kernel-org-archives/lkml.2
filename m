Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751697Ab0E0McQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 08:32:16 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:48491 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750852Ab0E0McO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 08:32:14 -0400
Date: Thu, 27 May 2010 14:32:09 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: Peter Berger <pberger@brimson.com>,
       Al Borchers <alborchers@steinerpoint.com>,
       Greg Kroah-Hartman <gregkh@suse.de>, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 1/11] drivers/usb/serial: Eliminate a NULL pointer dereference
Message-ID: <Pine.LNX.4.64.1005271431530.5422@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

If port is NULL, then the call to dev_err will dereference a value that is
a small offset from NULL.

A simplified version of the semantic match that finds this problem is as
follows: (http://coccinelle.lip6.fr/)

// <smpl>
@r exists@
expression E,E1;
identifier f;
statement S1,S2,S3;
@@

if ((E == NULL && ...) || ...)
{
  ... when != if (...) S1 else S2
      when != E = E1
* E->f
  ... when any
  return ...;
}
else S3
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/usb/serial/digi_acceleport.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/usb/serial/digi_acceleport.c b/drivers/usb/serial/digi_acceleport.c
index 3edda3e..fd35f73 100644
--- a/drivers/usb/serial/digi_acceleport.c
+++ b/drivers/usb/serial/digi_acceleport.c
@@ -1239,8 +1239,7 @@ static void digi_write_bulk_callback(struct urb *urb)
 
 	/* port and serial sanity check */
 	if (port == NULL || (priv = usb_get_serial_port_data(port)) == NULL) {
-		dev_err(&port->dev,
-			"%s: port or port->private is NULL, status=%d\n",
+		pr_err("%s: port or port->private is NULL, status=%d\n",
 			__func__, status);
 		return;
 	}
