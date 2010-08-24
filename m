Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934440Ab0HXXnj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 19:43:39 -0400
Received: from kroah.org ([198.145.64.141]:52237 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932486Ab0HXWyJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 18:54:09 -0400
X-Mailbox-Line: From gregkh@clark.site Tue Aug 24 15:25:25 2010
Message-Id: <20100824222525.528405312@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 24 Aug 2010 15:24:48 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Dan Carpenter <error27@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [36/59] isdn: fix information leak
In-Reply-To: <20100824224625.GA5449@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------


From: Dan Carpenter <error27@gmail.com>

[ Upstream commit 4b030d4288a569d6bdeca884d7f102d951f097f2 ]

The main motivation of this patch changing strcpy() to strlcpy().
We strcpy() to copy a 48 byte buffers into a 49 byte buffers.  So at
best the last byte has leaked information, or maybe there is an
overflow?  Anyway, this patch closes the information leaks by zeroing
the memory and the calls to strlcpy() prevent overflows.

Signed-off-by: Dan Carpenter <error27@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/isdn/sc/ioctl.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/drivers/isdn/sc/ioctl.c
+++ b/drivers/isdn/sc/ioctl.c
@@ -174,7 +174,7 @@ int sc_ioctl(int card, scs_ioctl *data)
 		pr_debug("%s: SCIOGETSPID: ioctl received\n",
 				sc_adapter[card]->devicename);
 
-		spid = kmalloc(SCIOC_SPIDSIZE, GFP_KERNEL);
+		spid = kzalloc(SCIOC_SPIDSIZE, GFP_KERNEL);
 		if (!spid) {
 			kfree(rcvmsg);
 			return -ENOMEM;
@@ -194,7 +194,7 @@ int sc_ioctl(int card, scs_ioctl *data)
 			kfree(rcvmsg);
 			return status;
 		}
-		strcpy(spid, rcvmsg->msg_data.byte_array);
+		strlcpy(spid, rcvmsg->msg_data.byte_array, SCIOC_SPIDSIZE);
 
 		/*
 		 * Package the switch type and send to user space
@@ -272,12 +272,12 @@ int sc_ioctl(int card, scs_ioctl *data)
 			return status;
 		}
 
-		dn = kmalloc(SCIOC_DNSIZE, GFP_KERNEL);
+		dn = kzalloc(SCIOC_DNSIZE, GFP_KERNEL);
 		if (!dn) {
 			kfree(rcvmsg);
 			return -ENOMEM;
 		}
-		strcpy(dn, rcvmsg->msg_data.byte_array);
+		strlcpy(dn, rcvmsg->msg_data.byte_array, SCIOC_DNSIZE);
 		kfree(rcvmsg);
 
 		/*
@@ -348,7 +348,7 @@ int sc_ioctl(int card, scs_ioctl *data)
 		pr_debug("%s: SCIOSTAT: ioctl received\n",
 				sc_adapter[card]->devicename);
 
-		bi = kmalloc (sizeof(boardInfo), GFP_KERNEL);
+		bi = kzalloc(sizeof(boardInfo), GFP_KERNEL);
 		if (!bi) {
 			kfree(rcvmsg);
 			return -ENOMEM;


