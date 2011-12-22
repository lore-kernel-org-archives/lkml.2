Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755255Ab1LVLIl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Dec 2011 06:08:41 -0500
Received: from asix.com.tw ([113.196.140.82]:61905 "EHLO asix.com.tw"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755149Ab1LVLIh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Dec 2011 06:08:37 -0500
X-Greylist: delayed 679 seconds by postgrey-1.27 at vger.kernel.org; Thu, 22 Dec 2011 06:08:36 EST
From: "ASIX Allan Email [office]" <allan@asix.com.tw>
To: <davem@davemloft.net>
Cc: <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        "'Freddy Xin'" <freddy@asix.com.tw>,
        "'Grant Grundler'" <grundler@chromium.org>,
        "'Eugene'" <elubarsky@gmail.com>,
        "=?utf-8?Q?'ASIX_Louis_=5B=E8=98=87=E5=A8=81=E9=99=B8=5D'?=" 
	<louis@asix.com.tw>
Subject: [PATCH] drivers/net/usb/asix: fixed asix_get_wol reported wrong wol status issue
Date: Thu, 22 Dec 2011 18:56:54 +0800
Message-ID: <000c01ccc098$6b6c6690$424533b0$@com.tw>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="utf-8"
Content-Transfer-Encoding: 8BIT
X-Priority: 1 (Highest)
X-MSMail-Priority: High
X-Mailer: Microsoft Office Outlook 12.0
Thread-Index: AczAmGp+kERwnuDCRHmRDqyb3ZlZUg==
Content-Language: zh-tw
Importance: High
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear David,

This is my first time to submit the driver patch onto Linux kernel mainline source. Please correct me if anything is wrong on my submission way or email format. Thanks a lot for your great helps.  

========
Fixed the asix_get_wol() routine reported wrong wol status issue. 
This fix had been verified on x86 Linux kernel 3.0.0-12-generic system with AX88772A/AX88772/Belkin AX88178 USB dongles, and the wol function works fine (can be waked up by receiving the magic packets). 

Signed-off-by: Allan Chou <allan@asix.com.tw>
Tested-by: Allan Chou <allan@asix.com.tw>
---
diff --uprN a/drivers/net/usb/asix.c b/drivers/net/usb/asix.c
--- a/drivers/net/usb/asix.c	2011-12-15 14:01:49.000000000 +0800
+++ b/drivers/net/usb/asix.c	2011-12-22 18:20:39.000000000 +0800
@@ -36,7 +36,7 @@
 #include <linux/usb/usbnet.h>
 #include <linux/slab.h>
 
-#define DRIVER_VERSION "08-Nov-2011"
+#define DRIVER_VERSION "22-Dec-2011"
 #define DRIVER_NAME "asix"
 
 /* ASIX AX8817X based USB 2.0 Ethernet Devices */
@@ -689,6 +689,10 @@ asix_get_wol(struct net_device *net, str
 	}
 	wolinfo->supported = WAKE_PHY | WAKE_MAGIC;
 	wolinfo->wolopts = 0;
+	if (opt & AX_MONITOR_LINK)
+		wolinfo->wolopts |= WAKE_PHY;
+	if (opt & AX_MONITOR_MAGIC)
+		wolinfo->wolopts |= WAKE_MAGIC;
 }
 
 static int


---
Best regards,
Allan Chou
Technical Support Division
ASIX Electronics Corporation
TEL: 886-3-5799500 ext.228
FAX: 886-3-5799558
E-mail: allan@asix.com.tw 
http://www.asix.com.tw/ 


-----Original Message-----
From: allan [mailto:allan@asix.com.tw] 
Sent: Saturday, December 17, 2011 10:36 AM
To: 'Grant Grundler'
Cc: 'Eugene'; 'netdev@vger.kernel.org'; 'Freddy Xin'; 'ASIX Louis [蘇威陸]'
Subject: RE: drivers/net/usb/asix: bug in asix_get_wol

Dear Grant,

I will double check this issue and submit the revised patch to Linux kernel mainline source next week. Thanks a lot for your great helps.


---
Best regards,
Allan Chou
Technical Support Division
ASIX Electronics Corporation
TEL: 886-3-5799500 ext.228
FAX: 886-3-5799558
E-mail: allan@asix.com.tw 
http://www.asix.com.tw/ 

-----Original Message-----
From: grundler@google.com [mailto:grundler@google.com] On Behalf Of Grant Grundler
Sent: Saturday, December 17, 2011 6:16 AM
To: ASIX Allan Email [office]
Cc: Eugene; netdev@vger.kernel.org; Freddy Xin; ASIX Louis [蘇威陸]
Subject: Re: drivers/net/usb/asix: bug in asix_get_wol

On Thu, Dec 15, 2011 at 9:15 PM, ASIX Allan Email [office]
<allan@asix.com.tw> wrote:
> Resend without attachment due to below email server error.
...
> -----Original Message-----
> From: ASIX Allan Email [office] [mailto:allan@asix.com.tw]
> Sent: Friday, December 16, 2011 11:38 AM
> To: 'Grant Grundler'; 'Eugene'
> Cc: 'netdev@vger.kernel.org'; 'Freddy Xin'; ASIX Louis [蘇威陸]
> Subject: RE: drivers/net/usb/asix: bug in asix_get_wol
> Importance: High
>
> Dear Grant and Eugene,
>
> Please refer to the attached file and below statements to modify the
> asix_get_wol() routine and let us know if this suggestion can solve
> your issues or not? Thanks a lot.

Allan,
Thanks for the response but it doesn't answer my previous question.
Let me ask the same question differently.

Does WOL support in asix driver need more than the four lines of code?
Ie does MONITOR_MODE need to be enabled or anything like that?

> ================
> static void
> asix_get_wol(struct net_device *net, struct ethtool_wolinfo *wolinfo)
> {
>        struct usbnet *dev = netdev_priv(net);
>        u8 opt;
>
>        if (asix_read_cmd(dev, AX_CMD_READ_MONITOR_MODE, 0, 0, 1, &opt) < 0) {
>                wolinfo->supported = 0;
>                wolinfo->wolopts = 0;
>                return;
>        }
>        wolinfo->supported = WAKE_PHY | WAKE_MAGIC;
>        wolinfo->wolopts = 0;
>        if (opt & AX_MONITOR_LINK)
>                wolinfo->wolopts |= WAKE_PHY;
>        if (opt & AX_MONITOR_MAGIC)
>                wolinfo->wolopts |= WAKE_MAGIC;
> }

This looks remarkably similar to the code Eugene said enables WOL for
him (and it works). I not able to find any difference.

If you believe it was a mistake to remove these four lines of code,
please submit a patch (See Documentation/SubmittingPatches)  to add
them back. You can add a "Tested-by: Eugene <elubarsky@gmail.com>"
line after your own "Signed-off-by:" in the patch.

thanks!
grant


