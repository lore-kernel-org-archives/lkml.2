Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932998Ab0G3R7Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 13:59:16 -0400
Received: from kroah.org ([198.145.64.141]:59100 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932716Ab0G3R5U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 13:57:20 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Jul 30 10:51:48 2010
Message-Id: <20100730175148.666357130@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 30 Jul 2010 10:52:59 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Tilman Schmidt <tilman@imap.cc>,
        "David S. Miller" <davem@davemloft.net>
Subject: [162/205] isdn/gigaset: correct CAPI DATA_B3 Delivery Confirmation
In-Reply-To: <20100730175238.GA3924@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.34-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Tilman Schmidt <tilman@imap.cc>

commit 23b36778b4c82577746d26e4ac0ae66c6f462475 upstream.

The Gigaset CAPI driver handled all DATA_B3_REQ messages as if the
Delivery Confirmation flag bit was set, delaying the emission of the
DATA_B3_CONF reply until the data was actually transmitted. Some
CAPI applications (notably Asterisk) aren't happy with that
behaviour. Change it to actually evaluate the Delivery Confirmation
flag as described the CAPI specification.

Impact: bugfix
Signed-off-by: Tilman Schmidt <tilman@imap.cc>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/isdn/gigaset/capi.c |   83 +++++++++++++++++++++++++++-----------------
 1 file changed, 51 insertions(+), 32 deletions(-)

--- a/drivers/isdn/gigaset/capi.c
+++ b/drivers/isdn/gigaset/capi.c
@@ -331,6 +331,39 @@ static const char *format_ie(const char
 	return result;
 }
 
+/*
+ * emit DATA_B3_CONF message
+ */
+static void send_data_b3_conf(struct cardstate *cs, struct capi_ctr *ctr,
+			      u16 appl, u16 msgid, int channel,
+			      u16 handle, u16 info)
+{
+	struct sk_buff *cskb;
+	u8 *msg;
+
+	cskb = alloc_skb(CAPI_DATA_B3_CONF_LEN, GFP_ATOMIC);
+	if (!cskb) {
+		dev_err(cs->dev, "%s: out of memory\n", __func__);
+		return;
+	}
+	/* frequent message, avoid _cmsg overhead */
+	msg = __skb_put(cskb, CAPI_DATA_B3_CONF_LEN);
+	CAPIMSG_SETLEN(msg, CAPI_DATA_B3_CONF_LEN);
+	CAPIMSG_SETAPPID(msg, appl);
+	CAPIMSG_SETCOMMAND(msg, CAPI_DATA_B3);
+	CAPIMSG_SETSUBCOMMAND(msg,  CAPI_CONF);
+	CAPIMSG_SETMSGID(msg, msgid);
+	CAPIMSG_SETCONTROLLER(msg, ctr->cnr);
+	CAPIMSG_SETPLCI_PART(msg, channel);
+	CAPIMSG_SETNCCI_PART(msg, 1);
+	CAPIMSG_SETHANDLE_CONF(msg, handle);
+	CAPIMSG_SETINFO_CONF(msg, info);
+
+	/* emit message */
+	dump_rawmsg(DEBUG_MCMD, __func__, msg);
+	capi_ctr_handle_message(ctr, appl, cskb);
+}
+
 
 /*
  * driver interface functions
@@ -351,7 +384,6 @@ void gigaset_skb_sent(struct bc_state *b
 	struct gigaset_capi_ctr *iif = cs->iif;
 	struct gigaset_capi_appl *ap = bcs->ap;
 	unsigned char *req = skb_mac_header(dskb);
-	struct sk_buff *cskb;
 	u16 flags;
 
 	/* update statistics */
@@ -368,34 +400,17 @@ void gigaset_skb_sent(struct bc_state *b
 		return;
 	}
 
-	/* ToDo: honor unset "delivery confirmation" bit */
+	/*
+	 * send DATA_B3_CONF if "delivery confirmation" bit was set in request;
+	 * otherwise it has already been sent by do_data_b3_req()
+	 */
 	flags = CAPIMSG_FLAGS(req);
-
-	/* build DATA_B3_CONF message */
-	cskb = alloc_skb(CAPI_DATA_B3_CONF_LEN, GFP_ATOMIC);
-	if (!cskb) {
-		dev_err(cs->dev, "%s: out of memory\n", __func__);
-		return;
-	}
-	/* frequent message, avoid _cmsg overhead */
-	CAPIMSG_SETLEN(cskb->data, CAPI_DATA_B3_CONF_LEN);
-	CAPIMSG_SETAPPID(cskb->data, ap->id);
-	CAPIMSG_SETCOMMAND(cskb->data, CAPI_DATA_B3);
-	CAPIMSG_SETSUBCOMMAND(cskb->data,  CAPI_CONF);
-	CAPIMSG_SETMSGID(cskb->data, CAPIMSG_MSGID(req));
-	CAPIMSG_SETCONTROLLER(cskb->data, iif->ctr.cnr);
-	CAPIMSG_SETPLCI_PART(cskb->data, bcs->channel + 1);
-	CAPIMSG_SETNCCI_PART(cskb->data, 1);
-	CAPIMSG_SETHANDLE_CONF(cskb->data, CAPIMSG_HANDLE_REQ(req));
-	if (flags & ~CAPI_FLAGS_DELIVERY_CONFIRMATION)
-		CAPIMSG_SETINFO_CONF(cskb->data,
-				     CapiFlagsNotSupportedByProtocol);
-	else
-		CAPIMSG_SETINFO_CONF(cskb->data, CAPI_NOERROR);
-
-	/* emit message */
-	dump_rawmsg(DEBUG_LLDATA, "DATA_B3_CONF", cskb->data);
-	capi_ctr_handle_message(&iif->ctr, ap->id, cskb);
+	if (flags & CAPI_FLAGS_DELIVERY_CONFIRMATION)
+		send_data_b3_conf(cs, &iif->ctr, ap->id, CAPIMSG_MSGID(req),
+				  bcs->channel + 1, CAPIMSG_HANDLE_REQ(req),
+				  (flags & ~CAPI_FLAGS_DELIVERY_CONFIRMATION) ?
+					CapiFlagsNotSupportedByProtocol :
+					CAPI_NOERROR);
 }
 EXPORT_SYMBOL_GPL(gigaset_skb_sent);
 
@@ -1806,6 +1821,8 @@ static void do_data_b3_req(struct gigase
 	u16 msglen = CAPIMSG_LEN(skb->data);
 	u16 datalen = CAPIMSG_DATALEN(skb->data);
 	u16 flags = CAPIMSG_FLAGS(skb->data);
+	u16 msgid = CAPIMSG_MSGID(skb->data);
+	u16 handle = CAPIMSG_HANDLE_REQ(skb->data);
 
 	/* frequent message, avoid _cmsg overhead */
 	dump_rawmsg(DEBUG_LLDATA, "DATA_B3_REQ", skb->data);
@@ -1856,12 +1873,14 @@ static void do_data_b3_req(struct gigase
 		return;
 	}
 
-	/* DATA_B3_CONF reply will be sent by gigaset_skb_sent() */
-
 	/*
-	 * ToDo: honor unset "delivery confirmation" bit
-	 * (send DATA_B3_CONF immediately?)
+	 * DATA_B3_CONF will be sent by gigaset_skb_sent() only if "delivery
+	 * confirmation" bit is set; otherwise we have to send it now
 	 */
+	if (!(flags & CAPI_FLAGS_DELIVERY_CONFIRMATION))
+		send_data_b3_conf(cs, &iif->ctr, ap->id, msgid, channel, handle,
+				  flags ? CapiFlagsNotSupportedByProtocol
+					: CAPI_NOERROR);
 }
 
 /*


