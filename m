Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755770Ab0EQTM3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 15:12:29 -0400
Received: from ey-out-2122.google.com ([74.125.78.27]:10267 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755655Ab0EQTM1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 15:12:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=G/GpaqOH7lfwYLP8A8YYAWOlNui79F1C0RyNhgtadELzqtOh/RnyJg+BV3rAUluTDW
         ef0ofPSZUXLwypif7DBFy8BZIvqXDMplYB1/fHNxlk3FdbjLxIDlCA45O3inDGYClqgA
         FitCdshq4pI85TrbSwrsYhyLyfg27K87CeDns=
Message-ID: <4BF19517.90301@gmail.com>
Date: Mon, 17 May 2010 21:12:23 +0200
From: Maurus Cuelenaere <mcuelenaere@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; nl; rv:1.9.1.9) Gecko/20100317 Lightning/1.0b1 Thunderbird/3.0.4
MIME-Version: 1.0
To: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
CC: David Brownell <dbrownell@users.sourceforge.net>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 1/2] USB: gadget: fix null pointer dereference on non-dual
 speed gadgets
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The composite driver doesn't verify whether gadgets are dual speed when using
the high speed descriptors.

USB drivers don't set usb_function->hs_descriptors on non-dual speed gadgets,
which result in dereferencing a NULL pointer in set_config().

Signed-off-by: Maurus Cuelenaere <mcuelenaere@gmail.com>
---
 drivers/usb/gadget/composite.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/usb/gadget/composite.c b/drivers/usb/gadget/composite.c
index 09289bb..fa07267 100644
--- a/drivers/usb/gadget/composite.c
+++ b/drivers/usb/gadget/composite.c
@@ -431,7 +431,8 @@ static int set_config(struct usb_composite_dev *cdev,
 		 * function's setup callback instead of the current
 		 * configuration's setup callback.
 		 */
-		if (gadget->speed == USB_SPEED_HIGH)
+		if (gadget->speed == USB_SPEED_HIGH
+		    && gadget_is_dualspeed(gadget))
 			descriptors = f->hs_descriptors;
 		else
 			descriptors = f->descriptors;
-- 
1.7.1


