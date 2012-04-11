Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753882Ab2DKWft (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 18:35:49 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:18277 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752224Ab2DKWfs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 18:35:48 -0400
Date: Thu, 12 Apr 2012 00:35:46 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: linux-kernel@vger.kernel.org
cc: devel@driverdev.osuosl.org, Xi Wang <xi.wang@gmail.com>,
        Joe Perches <joe@perches.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Forest Bond <forest@alittletooquiet.net>
Subject: [PATCH] staging: vt6656: Don't leak memory in
 drivers/staging/vt6656/ioctl.c::private_ioctl()
Message-ID: <alpine.LNX.2.00.1204120032050.2137@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If copy_to_user() fails in the WLAN_CMD_GET_NODE_LIST case of the
switch in drivers/staging/vt6656/ioctl.c::private_ioctl() we'll leak
the memory allocated to 'pNodeList'. Fix that by kfree'ing the memory
in the failure case.
Also remove a pointless cast (to type 'PSNodeList') of a kmalloc()
return value - kmalloc() returns a void pointer that is implicitly
converted, so there is no need for an explicit cast.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 drivers/staging/vt6656/ioctl.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/vt6656/ioctl.c b/drivers/staging/vt6656/ioctl.c
index 1463d76..d59456c 100644
--- a/drivers/staging/vt6656/ioctl.c
+++ b/drivers/staging/vt6656/ioctl.c
@@ -565,7 +565,7 @@ int private_ioctl(PSDevice pDevice, struct ifreq *rq)
 			result = -ENOMEM;
 			break;
 		}
-		pNodeList = (PSNodeList)kmalloc(sizeof(SNodeList) + (sNodeList.uItem * sizeof(SNodeItem)), (int)GFP_ATOMIC);
+		pNodeList = kmalloc(sizeof(SNodeList) + (sNodeList.uItem * sizeof(SNodeItem)), (int)GFP_ATOMIC);
 		if (pNodeList == NULL) {
 			result = -ENOMEM;
 			break;
@@ -601,6 +601,7 @@ int private_ioctl(PSDevice pDevice, struct ifreq *rq)
 			}
 		}
 		if (copy_to_user(pReq->data, pNodeList, sizeof(SNodeList) + (sNodeList.uItem * sizeof(SNodeItem)))) {
+			kfree(pNodeList);
 			result = -EFAULT;
 			break;
 		}
-- 
1.7.10


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

