Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030948Ab2HGWmS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 18:42:18 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:41610 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030936Ab2HGWmO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 18:42:14 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Dan Carpenter <dan.carpenter@oracle.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 091/109] USB: kaweth.c: use GFP_ATOMIC under spin_lock
Date: Tue,  7 Aug 2012 15:35:50 -0700
Message-Id: <20120807222051.074308790@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120807222043.089735600@linuxfoundation.org>
References: <20120807222043.089735600@linuxfoundation.org>
User-Agent: quilt/0.60-20.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit e4c7f259c5be99dcfc3d98f913590663b0305bf8 ]

The problem is that we call this with a spin lock held.  The call tree
is:
	kaweth_start_xmit() holds kaweth->device_lock.
	-> kaweth_async_set_rx_mode()
	   -> kaweth_control()
	      -> kaweth_internal_control_msg()

The kaweth_internal_control_msg() function is only called from
kaweth_control() which used GFP_ATOMIC for its allocations.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/usb/kaweth.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/usb/kaweth.c
+++ b/drivers/net/usb/kaweth.c
@@ -1302,7 +1302,7 @@ static int kaweth_internal_control_msg(s
         int retv;
         int length = 0; /* shut up GCC */
 
-        urb = usb_alloc_urb(0, GFP_NOIO);
+	urb = usb_alloc_urb(0, GFP_ATOMIC);
         if (!urb)
                 return -ENOMEM;
 


