Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932838Ab2JAXBI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 19:01:08 -0400
Received: from 1wt.eu ([62.212.114.60]:35279 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932799Ab2JAXBA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 19:01:00 -0400
Message-Id: <20121001225202.436811395@1wt.eu>
User-Agent: quilt/0.48-1
Date: Tue, 02 Oct 2012 00:53:51 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Willy Tarreau <w@1wt.eu>
Subject: [ 114/180] USB: kaweth.c: use GFP_ATOMIC under spin_lock
In-Reply-To: <6a854f579a99b4fe2efaca1057e8ae22@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 drivers/net/usb/kaweth.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/usb/kaweth.c b/drivers/net/usb/kaweth.c
index e391ef9..fd8e335 100644
--- a/drivers/net/usb/kaweth.c
+++ b/drivers/net/usb/kaweth.c
@@ -1325,7 +1325,7 @@ static int kaweth_internal_control_msg(struct usb_device *usb_dev,
         int retv;
         int length = 0; /* shut up GCC */
 
-        urb = usb_alloc_urb(0, GFP_NOIO);
+	urb = usb_alloc_urb(0, GFP_ATOMIC);
         if (!urb)
                 return -ENOMEM;
 
-- 
1.7.2.1.45.g54fbc



