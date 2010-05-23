Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754277Ab0EWLYb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 May 2010 07:24:31 -0400
Received: from gimli.pxnet.com ([195.227.45.7]:56623 "EHLO mail.pxnet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753709Ab0EWLYZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 May 2010 07:24:25 -0400
X-Greylist: delayed 663 seconds by postgrey-1.27 at vger.kernel.org; Sun, 23 May 2010 07:24:23 EDT
From: Tilman Schmidt <tilman@imap.cc>
Subject: [PATCH 1/2] isdn/capi: make reset_ctr op truly optional
To: Karsten Keil <isdn@linux-pingi.de>, David Miller <davem@davemloft.net>
CC: Hansjoerg Lipp <hjlipp@web.de>, Karsten Keil <keil@b1-systems.de>,
       i4ldeveloper@listserv.isdn4linux.de, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Message-ID: <20100523-patch-gigaset-01.tilman@imap.cc>
In-Reply-To: <20100523-patch-gigaset-00.tilman@imap.cc>
References: <20100523-patch-gigaset-00.tilman@imap.cc>
Date: Sun, 23 May 2010 13:02:08 +0200 (CEST)
X-Spam-Score: -1.088 () AWL,BAYES_05,RDNS_NONE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The CAPI controller operation reset_ctr is marked as optional, and
not all drivers do implement it. Add a check to the kernel CAPI
whether it exists before trying to call it.

Impact: oops prevention
Signed-off-by: Tilman Schmidt <tilman@imap.cc>
---
 drivers/isdn/capi/kcapi.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/drivers/isdn/capi/kcapi.c b/drivers/isdn/capi/kcapi.c
index bd00dce..bde3c88 100644
--- a/drivers/isdn/capi/kcapi.c
+++ b/drivers/isdn/capi/kcapi.c
@@ -1147,6 +1147,12 @@ load_unlock_out:
 		if (ctr->state == CAPI_CTR_DETECTED)
 			goto reset_unlock_out;
 
+		if (ctr->reset_ctr == NULL) {
+			printk(KERN_DEBUG "kcapi: reset: no reset function\n");
+			retval = -ESRCH;
+			goto reset_unlock_out;
+		}
+
 		ctr->reset_ctr(ctr);
 
 		retval = wait_on_ctr_state(ctr, CAPI_CTR_DETECTED);
-- 
1.6.5.3.298.g39add

