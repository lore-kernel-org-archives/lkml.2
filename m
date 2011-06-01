Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161679Ab1FAJUG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 05:20:06 -0400
Received: from cantor.suse.de ([195.135.220.2]:43500 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161637Ab1FAIMD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 04:12:03 -0400
X-Mailbox-Line: From linux@blue.kroah.org Wed Jun  1 17:03:28 2011
Message-Id: <20110601080326.993812589@blue.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 01 Jun 2011 17:00:01 +0900
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Wei Yongjun <yjwei@cn.fujitsu.com>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [065/146] sctp: fix memory leak of the ASCONF queue when free asoc
In-Reply-To: <20110601080606.GA522@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

------------------


From: Wei Yongjun <yjwei@cn.fujitsu.com>

[ Upstream commit 8b4472cc13136d04727e399c6fdadf58d2218b0a ]

If an ASCONF chunk is outstanding, then the following ASCONF
chunk will be queued for later transmission. But when we free
the asoc, we forget to free the ASCONF queue at the same time,
this will cause memory leak.

Signed-off-by: Wei Yongjun <yjwei@cn.fujitsu.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 net/sctp/associola.c |   16 ++++++++++++++++
 1 file changed, 16 insertions(+)

--- a/net/sctp/associola.c
+++ b/net/sctp/associola.c
@@ -64,6 +64,7 @@
 /* Forward declarations for internal functions. */
 static void sctp_assoc_bh_rcv(struct work_struct *work);
 static void sctp_assoc_free_asconf_acks(struct sctp_association *asoc);
+static void sctp_assoc_free_asconf_queue(struct sctp_association *asoc);
 
 /* Keep track of the new idr low so that we don't re-use association id
  * numbers too fast.  It is protected by they idr spin lock is in the
@@ -446,6 +447,9 @@ void sctp_association_free(struct sctp_a
 	/* Free any cached ASCONF_ACK chunk. */
 	sctp_assoc_free_asconf_acks(asoc);
 
+	/* Free the ASCONF queue. */
+	sctp_assoc_free_asconf_queue(asoc);
+
 	/* Free any cached ASCONF chunk. */
 	if (asoc->addip_last_asconf)
 		sctp_chunk_free(asoc->addip_last_asconf);
@@ -1576,6 +1580,18 @@ retry:
 	return error;
 }
 
+/* Free the ASCONF queue */
+static void sctp_assoc_free_asconf_queue(struct sctp_association *asoc)
+{
+	struct sctp_chunk *asconf;
+	struct sctp_chunk *tmp;
+
+	list_for_each_entry_safe(asconf, tmp, &asoc->addip_chunk_list, list) {
+		list_del_init(&asconf->list);
+		sctp_chunk_free(asconf);
+	}
+}
+
 /* Free asconf_ack cache */
 static void sctp_assoc_free_asconf_acks(struct sctp_association *asoc)
 {


