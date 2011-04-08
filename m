Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757458Ab1DHD3M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Apr 2011 23:29:12 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:52027 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757407Ab1DHD3K convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Apr 2011 23:29:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=d1uzTh8WDJgv8MUpdA/hcyvGrL1SduMk7hMK0SU2ZpldM0e6wgXEc1sVhkyEQCpk+d
         8nq45GJtL0KA9rxuG4aYAUsN75XN8KYVNsoKFlsZOz3GpyQiKsrjyx08iVirghGUT60R
         fYlUP2Iw2BVvwKwwEB16eXWNdcHWwEbWgQlAw=
MIME-Version: 1.0
In-Reply-To: <BANLkTikUrdte93L=3Nq3TXYMpeqRJfj2YQ@mail.gmail.com>
References: <BANLkTim8anqNv4MEaxCTyC8HyOZp2x=ixQ@mail.gmail.com>
	<20110407163948.GD31060@kroah.com>
	<BANLkTikUrdte93L=3Nq3TXYMpeqRJfj2YQ@mail.gmail.com>
Date: Fri, 8 Apr 2011 11:29:08 +0800
Message-ID: <BANLkTik5VGziYQLQTzMDhYD7CA0QpSNK6g@mail.gmail.com>
Subject: Re: [Regression] USB tethering does not work anymore in 2.6.29-rc2
 (rndis_host, does not receive DHCP offer anymore)
From: huajun li <huajun.li.lee@gmail.com>
To: Gottfried Haider <gottfried.haider@gmail.com>
Cc: Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org,
        linux-net@vger.kernel.org, linux-usb@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/4/8 Gottfried Haider <gottfried.haider@gmail.com>:
>>> This does work on the -rc1 kernel and is 100% reproducible here (same
>>> USB port, rebooting the phone between tries).
>>
>> Any chance you can run 'git bisect' to narrow down the problem to the
>> offending change?
>
> Unfortunately I only have this x120e netbook-type machine available
> for testing and building at the moment, so it would probably take me a
> long time.
>
> Gottfried
> --
> To unsubscribe from this list: send the line "unsubscribe linux-usb" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

Hi,
   I found the new added mask code 'FLAG_POINTTOPOINT' overlapped
'FLAG_MULTI_PACKET' in    include/linux/usb/usbnet.h, this maybe
caused logic issue in rx_process(). I create a patch for this, but
have no such a device to test it, could you have a try? thanks.

Thanks,
--huajun


[PATCH]    Clean up mask code overlaps in driver_info of usbnet

Signed-off-by:  Huajun Li <huajun.li.lee@gmail.com>
---
 include/linux/usb/usbnet.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/usb/usbnet.h b/include/linux/usb/usbnet.h
index 3c7329b..0e18550 100644
--- a/include/linux/usb/usbnet.h
+++ b/include/linux/usb/usbnet.h
@@ -103,8 +103,8 @@ struct driver_info {
  * Indicates to usbnet, that USB driver accumulates multiple IP packets.
  * Affects statistic (counters) and short packet handling.
  */
-#define FLAG_MULTI_PACKET	0x1000
-#define FLAG_RX_ASSEMBLE	0x2000	/* rx packets may span >1 frames */
+#define FLAG_MULTI_PACKET	0x2000
+#define FLAG_RX_ASSEMBLE	0x4000	/* rx packets may span >1 frames */

 	/* init device ... can sleep, or cause probe() failure */
 	int	(*bind)(struct usbnet *, struct usb_interface *);
-- 
1.7.4.1
