Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757707Ab0KSV7M (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 16:59:12 -0500
Received: from kroah.org ([198.145.64.141]:45370 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757632Ab0KSV7E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 16:59:04 -0500
X-Mailbox-Line: From gregkh@clark.site Fri Nov 19 13:56:44 2010
Message-Id: <20101119215644.826835718@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 19 Nov 2010 13:56:35 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Neil Horman <nhorman@tuxdriver.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [74/82] Revert d88dca79d3852a3623f606f781e013d61486828a
In-Reply-To: <20101119215658.GA7804@kroah.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------


From: Neil Horman <nhorman@tuxdriver.com>

[ Upstream commit db5a753bf198ef7a50e17d2ff358adf37efe8648 ]

TIPC needs to have its endianess issues fixed.  Unfortunately, the format of a
subscriber message is passed in directly from user space, so requiring this
message to be in network byte order breaks user space ABI.  Revert this change
until such time as we can determine how to do this in a backwards compatible
manner.

Signed-off-by: Neil Horman <nhorman@tuxdriver.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 net/tipc/subscr.c |   57 +++++++++++++++++++++++++++++++++---------------------
 net/tipc/subscr.h |    2 +
 2 files changed, 37 insertions(+), 22 deletions(-)

--- a/net/tipc/subscr.c
+++ b/net/tipc/subscr.c
@@ -76,6 +76,19 @@ struct top_srv {
 static struct top_srv topsrv = { 0 };
 
 /**
+ * htohl - convert value to endianness used by destination
+ * @in: value to convert
+ * @swap: non-zero if endianness must be reversed
+ *
+ * Returns converted value
+ */
+
+static u32 htohl(u32 in, int swap)
+{
+	return swap ? swab32(in) : in;
+}
+
+/**
  * subscr_send_event - send a message containing a tipc_event to the subscriber
  *
  * Note: Must not hold subscriber's server port lock, since tipc_send() will
@@ -94,11 +107,11 @@ static void subscr_send_event(struct sub
 	msg_sect.iov_base = (void *)&sub->evt;
 	msg_sect.iov_len = sizeof(struct tipc_event);
 
-	sub->evt.event = htonl(event);
-	sub->evt.found_lower = htonl(found_lower);
-	sub->evt.found_upper = htonl(found_upper);
-	sub->evt.port.ref = htonl(port_ref);
-	sub->evt.port.node = htonl(node);
+	sub->evt.event = htohl(event, sub->swap);
+	sub->evt.found_lower = htohl(found_lower, sub->swap);
+	sub->evt.found_upper = htohl(found_upper, sub->swap);
+	sub->evt.port.ref = htohl(port_ref, sub->swap);
+	sub->evt.port.node = htohl(node, sub->swap);
 	tipc_send(sub->server_ref, 1, &msg_sect);
 }
 
@@ -274,23 +287,16 @@ static void subscr_cancel(struct tipc_su
 {
 	struct subscription *sub;
 	struct subscription *sub_temp;
-	__u32 type, lower, upper;
 	int found = 0;
 
 	/* Find first matching subscription, exit if not found */
 
-	type = ntohl(s->seq.type);
-	lower = ntohl(s->seq.lower);
-	upper = ntohl(s->seq.upper);
-
 	list_for_each_entry_safe(sub, sub_temp, &subscriber->subscription_list,
 				 subscription_list) {
-			if ((type == sub->seq.type) &&
-			    (lower == sub->seq.lower) &&
-			    (upper == sub->seq.upper)) {
-				found = 1;
-				break;
-			}
+		if (!memcmp(s, &sub->evt.s, sizeof(struct tipc_subscr))) {
+			found = 1;
+			break;
+		}
 	}
 	if (!found)
 		return;
@@ -319,10 +325,16 @@ static struct subscription *subscr_subsc
 					     struct subscriber *subscriber)
 {
 	struct subscription *sub;
+	int swap;
+
+	/* Determine subscriber's endianness */
+
+	swap = !(s->filter & (TIPC_SUB_PORTS | TIPC_SUB_SERVICE));
 
 	/* Detect & process a subscription cancellation request */
 
-	if (ntohl(s->filter) & TIPC_SUB_CANCEL) {
+	if (s->filter & htohl(TIPC_SUB_CANCEL, swap)) {
+		s->filter &= ~htohl(TIPC_SUB_CANCEL, swap);
 		subscr_cancel(s, subscriber);
 		return NULL;
 	}
@@ -347,11 +359,11 @@ static struct subscription *subscr_subsc
 
 	/* Initialize subscription object */
 
-	sub->seq.type = ntohl(s->seq.type);
-	sub->seq.lower = ntohl(s->seq.lower);
-	sub->seq.upper = ntohl(s->seq.upper);
-	sub->timeout = ntohl(s->timeout);
-	sub->filter = ntohl(s->filter);
+	sub->seq.type = htohl(s->seq.type, swap);
+	sub->seq.lower = htohl(s->seq.lower, swap);
+	sub->seq.upper = htohl(s->seq.upper, swap);
+	sub->timeout = htohl(s->timeout, swap);
+	sub->filter = htohl(s->filter, swap);
 	if ((!(sub->filter & TIPC_SUB_PORTS) ==
 	     !(sub->filter & TIPC_SUB_SERVICE)) ||
 	    (sub->seq.lower > sub->seq.upper)) {
@@ -364,6 +376,7 @@ static struct subscription *subscr_subsc
 	INIT_LIST_HEAD(&sub->nameseq_list);
 	list_add(&sub->subscription_list, &subscriber->subscription_list);
 	sub->server_ref = subscriber->port_ref;
+	sub->swap = swap;
 	memcpy(&sub->evt.s, s, sizeof(struct tipc_subscr));
 	atomic_inc(&topsrv.subscription_count);
 	if (sub->timeout != TIPC_WAIT_FOREVER) {
--- a/net/tipc/subscr.h
+++ b/net/tipc/subscr.h
@@ -53,6 +53,7 @@ typedef void (*tipc_subscr_event) (struc
  * @nameseq_list: adjacent subscriptions in name sequence's subscription list
  * @subscription_list: adjacent subscriptions in subscriber's subscription list
  * @server_ref: object reference of server port associated with subscription
+ * @swap: indicates if subscriber uses opposite endianness in its messages
  * @evt: template for events generated by subscription
  */
 
@@ -65,6 +66,7 @@ struct subscription {
 	struct list_head nameseq_list;
 	struct list_head subscription_list;
 	u32 server_ref;
+	int swap;
 	struct tipc_event evt;
 };
 


