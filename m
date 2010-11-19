Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757689Ab0KSV7K (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 16:59:10 -0500
Received: from kroah.org ([198.145.64.141]:45362 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757368Ab0KSV7D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 16:59:03 -0500
X-Mailbox-Line: From gregkh@clark.site Fri Nov 19 13:56:44 2010
Message-Id: <20101119215644.745223293@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 19 Nov 2010 13:56:34 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Neil Horman <nhorman@tuxdriver.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [73/82] Revert c6537d6742985da1fbf12ae26cde6a096fd35b5c
In-Reply-To: <20101119215658.GA7804@kroah.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------


From: Neil Horman <nhorman@tuxdriver.com>

[ Upstream commit 8c974438085d2c81b006daeaab8801eedbd19758 ]

Backout the tipc changes to the flags int he subscription message.  These
changees, while reasonable on the surface, interefere with user space ABI
compatibility which is a no-no.  This was part of the changes to fix the
endianess issues in the TIPC protocol, which would be really nice to do but we
need to do so in a way that is backwards compatible with user space.

Signed-off-by: Neil Horman <nhorman@tuxdriver.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 include/linux/tipc.h |   30 ++++++++++++++++++------------
 net/tipc/subscr.c    |   15 +++++----------
 2 files changed, 23 insertions(+), 22 deletions(-)

--- a/include/linux/tipc.h
+++ b/include/linux/tipc.h
@@ -127,17 +127,23 @@ static inline unsigned int tipc_node(__u
  * TIPC topology subscription service definitions
  */
 
-#define TIPC_SUB_SERVICE     	0x00  	/* Filter for service availability    */
-#define TIPC_SUB_PORTS     	0x01  	/* Filter for port availability  */
-#define TIPC_SUB_CANCEL         0x04    /* Cancel a subscription         */
+#define TIPC_SUB_PORTS     	0x01  	/* filter for port availability */
+#define TIPC_SUB_SERVICE     	0x02  	/* filter for service availability */
+#define TIPC_SUB_CANCEL         0x04    /* cancel a subscription */
+#if 0
+/* The following filter options are not currently implemented */
+#define TIPC_SUB_NO_BIND_EVTS	0x04	/* filter out "publish" events */
+#define TIPC_SUB_NO_UNBIND_EVTS	0x08	/* filter out "withdraw" events */
+#define TIPC_SUB_SINGLE_EVT	0x10	/* expire after first event */
+#endif
 
 #define TIPC_WAIT_FOREVER	~0	/* timeout for permanent subscription */
 
 struct tipc_subscr {
-	struct tipc_name_seq seq;	/* NBO. Name sequence of interest */
-	__u32 timeout;			/* NBO. Subscription duration (in ms) */
-        __u32 filter;   		/* NBO. Bitmask of filter options */
-	char usr_handle[8];		/* Opaque. Available for subscriber use */
+	struct tipc_name_seq seq;	/* name sequence of interest */
+	__u32 timeout;			/* subscription duration (in ms) */
+        __u32 filter;   		/* bitmask of filter options */
+	char usr_handle[8];		/* available for subscriber use */
 };
 
 #define TIPC_PUBLISHED		1	/* publication event */
@@ -145,11 +151,11 @@ struct tipc_subscr {
 #define TIPC_SUBSCR_TIMEOUT	3	/* subscription timeout event */
 
 struct tipc_event {
-	__u32 event;			/* NBO. Event type, as defined above */
-	__u32 found_lower;		/* NBO. Matching name seq instances  */
-	__u32 found_upper;		/*  "      "       "   "    "        */
-	struct tipc_portid port;	/* NBO. Associated port              */
-	struct tipc_subscr s;		/* Original, associated subscription */
+	__u32 event;			/* event type */
+	__u32 found_lower;		/* matching name seq instances */
+	__u32 found_upper;		/*    "      "    "     "      */
+	struct tipc_portid port;	/* associated port */
+	struct tipc_subscr s;		/* associated subscription */
 };
 
 /*
--- a/net/tipc/subscr.c
+++ b/net/tipc/subscr.c
@@ -274,7 +274,7 @@ static void subscr_cancel(struct tipc_su
 {
 	struct subscription *sub;
 	struct subscription *sub_temp;
-	__u32 type, lower, upper, timeout, filter;
+	__u32 type, lower, upper;
 	int found = 0;
 
 	/* Find first matching subscription, exit if not found */
@@ -282,18 +282,12 @@ static void subscr_cancel(struct tipc_su
 	type = ntohl(s->seq.type);
 	lower = ntohl(s->seq.lower);
 	upper = ntohl(s->seq.upper);
-	timeout = ntohl(s->timeout);
-	filter = ntohl(s->filter) & ~TIPC_SUB_CANCEL;
 
 	list_for_each_entry_safe(sub, sub_temp, &subscriber->subscription_list,
 				 subscription_list) {
 			if ((type == sub->seq.type) &&
 			    (lower == sub->seq.lower) &&
-			    (upper == sub->seq.upper) &&
-			    (timeout == sub->timeout) &&
-                            (filter == sub->filter) &&
-                             !memcmp(s->usr_handle,sub->evt.s.usr_handle,
-				     sizeof(s->usr_handle)) ){
+			    (upper == sub->seq.upper)) {
 				found = 1;
 				break;
 			}
@@ -310,7 +304,7 @@ static void subscr_cancel(struct tipc_su
 		k_term_timer(&sub->timer);
 		spin_lock_bh(subscriber->lock);
 	}
-	dbg("Cancel: removing sub %u,%u,%u from subscriber %p list\n",
+	dbg("Cancel: removing sub %u,%u,%u from subscriber %x list\n",
 	    sub->seq.type, sub->seq.lower, sub->seq.upper, subscriber);
 	subscr_del(sub);
 }
@@ -358,7 +352,8 @@ static struct subscription *subscr_subsc
 	sub->seq.upper = ntohl(s->seq.upper);
 	sub->timeout = ntohl(s->timeout);
 	sub->filter = ntohl(s->filter);
-	if ((sub->filter && (sub->filter != TIPC_SUB_PORTS)) ||
+	if ((!(sub->filter & TIPC_SUB_PORTS) ==
+	     !(sub->filter & TIPC_SUB_SERVICE)) ||
 	    (sub->seq.lower > sub->seq.upper)) {
 		warn("Subscription rejected, illegal request\n");
 		kfree(sub);


