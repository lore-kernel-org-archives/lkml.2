Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753681Ab2E1D3S (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2012 23:29:18 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51880 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752763Ab2E1D3H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2012 23:29:07 -0400
Message-Id: <20120528031205.933245738@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 28 May 2012 04:12:24 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Tilman Schmidt <tilman@imap.cc>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 022/117] isdn/gigaset: fix CAPI disconnect B3 handling
In-Reply-To: <20120528031202.829379252@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tilman Schmidt <tilman@imap.cc>

commit 62a1cfe052346b96a552b6a9178d412c709711bb upstream.

If DISCONNECT_B3_IND was synthesized because of a DISCONNECT_REQ
with existing logical connections, the connection state wasn't
updated accordingly. Also the emitted DISCONNECT_B3_IND message
wasn't included in the debug log as requested.
This patch fixes both of these issues.

Signed-off-by: Tilman Schmidt <tilman@imap.cc>
Signed-off-by: David S. Miller <davem@davemloft.net>
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/isdn/gigaset/capi.c |    4 ++++
 1 file changed, 4 insertions(+)

--- linux.orig/drivers/isdn/gigaset/capi.c
+++ linux/drivers/isdn/gigaset/capi.c
@@ -1887,6 +1887,9 @@
 
 	/* check for active logical connection */
 	if (bcs->apconnstate >= APCONN_ACTIVE) {
+		/* clear it */
+		bcs->apconnstate = APCONN_SETUP;
+
 		/*
 		 * emit DISCONNECT_B3_IND with cause 0x3301
 		 * use separate cmsg structure, as the content of iif->acmsg
@@ -1911,6 +1914,7 @@
 		}
 		capi_cmsg2message(b3cmsg,
 			__skb_put(b3skb, CAPI_DISCONNECT_B3_IND_BASELEN));
+		dump_cmsg(DEBUG_CMD, __func__, b3cmsg);
 		kfree(b3cmsg);
 		capi_ctr_handle_message(&iif->ctr, ap->id, b3skb);
 	}


