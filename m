Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754139Ab0INRBR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 13:01:17 -0400
Received: from mailout.uni-due.de ([132.252.185.19]:45798 "EHLO
	mailout.uni-due.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751492Ab0INRBQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 13:01:16 -0400
X-Greylist: delayed 1022 seconds by postgrey-1.27 at vger.kernel.org; Tue, 14 Sep 2010 13:01:16 EDT
From: Thomas Dreibholz <dreibh@iem.uni-due.de>
Organization: University of Duisburg-Essen, Institute for Experimental Mathematics
To: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] net: SCTP NULL-pointer dereference problem description and fix
Date: Tue, 14 Sep 2010 19:01:09 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.35-20-generic; KDE/4.5.1; x86_64; ; )
Cc: Martin Becke <martin.becke@uni-due.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201009141901.13357.dreibh@iem.uni-due.de>
X-Spam-Scanned: SpamAssassin: 3.002004 - http://www.spamassassin.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sctp_assoc_update_retran_path() in net/sctp/associola.c may dereference a 
NULL-pointer when compiled with SCTP_DEBUG option: t will be NULL if there is 
no usable path for retransmission. SCTP_DEBUG_PRINTK_IPADDR() makes an access 
to t->ipaddr.v4.sin_port, without checking t before. t==NULL => oops.

The patch below against 2.6.36-rc4 (git repository) simply ensures that t is 
checked for not being set to NULL before calling SCTP_DEBUG_PRINTK_IPADDR().


Signed-off-by: Thomas Dreibholz <dreibh@iem.uni-due.de>
---
diff --git a/net/sctp/associola.c b/net/sctp/associola.c
index e41feff..b2688a4 100644
--- a/net/sctp/associola.c
+++ b/net/sctp/associola.c
@@ -1321,15 +1321,15 @@ void sctp_assoc_update_retran_path(struct 
sctp_association *asoc)
 		}
 	}

-	if (t)
+	if (t) {
 		asoc->peer.retran_path = t;
-
-	SCTP_DEBUG_PRINTK_IPADDR("sctp_assoc_update_retran_path:association"
-				 " %p addr: ",
-				 " port: %d\n",
-				 asoc,
-				 (&t->ipaddr),
-				 ntohs(t->ipaddr.v4.sin_port));
+		SCTP_DEBUG_PRINTK_IPADDR("sctp_assoc_update_retran_path:association"
+					 " %p addr: ",
+					 " port: %d\n",
+					 asoc,
+					 (&t->ipaddr),
+					 ntohs(t->ipaddr.v4.sin_port));
+	}
 }

 /* Choose the transport for sending retransmit packet.  */
