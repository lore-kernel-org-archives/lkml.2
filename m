Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755951Ab2BLXOV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Feb 2012 18:14:21 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:12599 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754631Ab2BLXOU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Feb 2012 18:14:20 -0500
Date: Mon, 13 Feb 2012 00:15:02 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: devel@driverdev.osuosl.org
cc: linux-kernel@vger.kernel.org, Andrea Merello <andreamrl@tiscali.it>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Sean MacLennan <seanm@seanm.ca>, Mike McCormack <mikem@ring3k.org>
Subject: [PATCH] Staging, rtl8192e, softmac: remove redundant memset and fix
 mem leak
Message-ID: <alpine.LNX.2.00.1202130012140.13814@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In drivers/staging/rtl8192e/rtllib_softmac.c::rtllib_rx_assoc_resp()
we allocate memory for 'network' with kzalloc() and then proceed to
zero the already zeroed mem we got from kzalloc() with
memset(). That's redundant, so remove the memset()

We also fail to kfree() the memory we allocated for 'network' if we do not enter

  if (ieee->current_network.qos_data.supported == 1) {

and the variable then goes out of scope.

To fix that I simply moved the kfree() that was inside that 'if'
statement to instead be just after it. It then covers both the case
where we take the branch and when we don't.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 drivers/staging/rtl8192e/rtllib_softmac.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

  Compile tested only.

diff --git a/drivers/staging/rtl8192e/rtllib_softmac.c b/drivers/staging/rtl8192e/rtllib_softmac.c
index 1637f11..c5a15db 100644
--- a/drivers/staging/rtl8192e/rtllib_softmac.c
+++ b/drivers/staging/rtl8192e/rtllib_softmac.c
@@ -2234,7 +2234,6 @@ inline int rtllib_rx_assoc_resp(struct rtllib_device *ieee, struct sk_buff *skb,
 
 			if (!network)
 				return 1;
-			memset(network, 0, sizeof(*network));
 			ieee->state = RTLLIB_LINKED;
 			ieee->assoc_id = aid;
 			ieee->softmac_stats.rx_ass_ok++;
@@ -2259,8 +2258,8 @@ inline int rtllib_rx_assoc_resp(struct rtllib_device *ieee, struct sk_buff *skb,
 					ieee->handle_assoc_response(ieee->dev,
 						 (struct rtllib_assoc_response_frame *)header,
 						 network);
-				kfree(network);
 			}
+			kfree(network);
 
 			kfree(ieee->assocresp_ies);
 			ieee->assocresp_ies = NULL;
-- 
1.7.9


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

