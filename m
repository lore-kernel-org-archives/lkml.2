Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751585Ab1CQFvs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 01:51:48 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:64737 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750976Ab1CQFvq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 01:51:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=SU3mpq9E6WzBQ+2psRnf1VLuvprNdpvIIZqK8IVoHxdKkZViz8j2HKrDl0dDwukDOY
         TN31DlFsSfI2ohBFoITzwe5e/6G+V3inG3KvXjrc81OqK+WEmHAoEuUoSEG8I4R0/V4H
         vYY9eUqEKAypX9cVXSVVi+VUPtZh91wtr2JDQ=
Subject: [BUG] usb_wwan: build error
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Oliver Neukum <oneukum@suse.de>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@suse.de>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 17 Mar 2011 06:51:40 +0100
Message-ID: <1300341100.10164.523.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit 16871dcac74c (usb_wwan: error case of resume) added a build error
if CONFIG_PM_RUNTIME is not defined.

  CC [M]  drivers/usb/serial/usb_wwan.o
drivers/usb/serial/usb_wwan.c: In function ‘play_delayed’:
drivers/usb/serial/usb_wwan.c:702: error: ‘struct dev_pm_info’ has no
member named ‘usage_count’

I suspect we should use pm_runtime_put_noidle() instead

Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
---
 drivers/usb/serial/usb_wwan.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/usb/serial/usb_wwan.c b/drivers/usb/serial/usb_wwan.c
index a65ddd5..916405c 100644
--- a/drivers/usb/serial/usb_wwan.c
+++ b/drivers/usb/serial/usb_wwan.c
@@ -698,8 +698,7 @@ static void play_delayed(struct usb_serial_port *port)
 			/* we have to throw away the rest */
 			do {
 				unbusy_queued_urb(urb, portdata);
-				//extremely dirty
-				atomic_dec(&port->serial->interface->dev.power.usage_count);
+				pm_runtime_put_noidle(&port->serial->interface->dev);
 			} while ((urb = usb_get_from_anchor(&portdata->delayed)));
 			break;
 		}


