Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031948Ab2I1UWb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 16:22:31 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:37576 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031652Ab2I1UWQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 16:22:16 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Mathias Krause <minipli@googlemail.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Gustavo Padovan <gustavo@padovan.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 015/218] Bluetooth: RFCOMM - Fix info leak in ioctl(RFCOMMGETDEVLIST)
Date: Fri, 28 Sep 2012 13:13:52 -0700
Message-Id: <20120928201503.046349227@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.1.428.g652398a
In-Reply-To: <20120928201501.208384923@linuxfoundation.org>
References: <20120928201501.208384923@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Mathias Krause <minipli@googlemail.com>

[ Upstream commit f9432c5ec8b1e9a09b9b0e5569e3c73db8de432a ]

The RFCOMM code fails to initialize the two padding bytes of struct
rfcomm_dev_list_req inserted for alignment before copying it to
userland. Additionally there are two padding bytes in each instance of
struct rfcomm_dev_info. The ioctl() that for disclosures two bytes plus
dev_num times two bytes uninitialized kernel heap memory.

Allocate the memory using kzalloc() to fix this issue.

Signed-off-by: Mathias Krause <minipli@googlemail.com>
Cc: Marcel Holtmann <marcel@holtmann.org>
Cc: Gustavo Padovan <gustavo@padovan.org>
Cc: Johan Hedberg <johan.hedberg@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bluetooth/rfcomm/tty.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/bluetooth/rfcomm/tty.c
+++ b/net/bluetooth/rfcomm/tty.c
@@ -467,7 +467,7 @@ static int rfcomm_get_dev_list(void __us
 
 	size = sizeof(*dl) + dev_num * sizeof(*di);
 
-	dl = kmalloc(size, GFP_KERNEL);
+	dl = kzalloc(size, GFP_KERNEL);
 	if (!dl)
 		return -ENOMEM;
 


