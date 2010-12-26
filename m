Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752696Ab0LZUJk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Dec 2010 15:09:40 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:18127 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752210Ab0LZUJg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Dec 2010 15:09:36 -0500
Date: Sun, 26 Dec 2010 20:59:58 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: gigaset307x-common@lists.sourceforge.net
cc: Tilman Schmidt <tilman@imap.cc>, Hansjoerg Lipp <hjlipp@web.de>,
        Karsten Keil <isdn@linux-pingi.de>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] ISDN, Gigaset: Fix memory leak in do_disconnect_req()
Message-ID: <alpine.LNX.2.00.1012262053130.20797@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

In drivers/isdn/gigaset/capi.c::do_disconnect_req() we will leak the 
memory allocated (with kmalloc) to 'b3cmsg' if the call to alloc_skb() 
fails.

...
		b3cmsg = kmalloc(sizeof(*b3cmsg), GFP_KERNEL);
	allocation here ------^
		if (!b3cmsg) {
			dev_err(cs->dev, "%s: out of memory\n", __func__);
			send_conf(iif, ap, skb, CAPI_MSGOSRESOURCEERR);
			return;
		}
		capi_cmsg_header(b3cmsg, ap->id, CAPI_DISCONNECT_B3, CAPI_IND,
				 ap->nextMessageNumber++,
				 cmsg->adr.adrPLCI | (1 << 16));
		b3cmsg->Reason_B3 = CapiProtocolErrorLayer1;
		b3skb = alloc_skb(CAPI_DISCONNECT_B3_IND_BASELEN, GFP_KERNEL);
		if (b3skb == NULL) {
			dev_err(cs->dev, "%s: out of memory\n", __func__);
			send_conf(iif, ap, skb, CAPI_MSGOSRESOURCEERR);
			return;
	leak here ------^
...

This leak is easily fixed by just kfree()'ing the memory allocated to 
'b3cmsg' right before we return. The following patch does that.


Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 capi.c |    1 +
 1 file changed, 1 insertion(+)

  compile tested only since I have no way to actually test this.

diff --git a/drivers/isdn/gigaset/capi.c b/drivers/isdn/gigaset/capi.c
index bcc174e..658e75f 100644
--- a/drivers/isdn/gigaset/capi.c
+++ b/drivers/isdn/gigaset/capi.c
@@ -1900,6 +1900,7 @@ static void do_disconnect_req(struct gigaset_capi_ctr *iif,
 		if (b3skb == NULL) {
 			dev_err(cs->dev, "%s: out of memory\n", __func__);
 			send_conf(iif, ap, skb, CAPI_MSGOSRESOURCEERR);
+			kfree(b3cmsg);
 			return;
 		}
 		capi_cmsg2message(b3cmsg,


-- 
Jesper Juhl <jj@chaosbits.net>            http://www.chaosbits.net/
Don't top-post http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please.

