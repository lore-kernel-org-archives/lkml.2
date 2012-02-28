Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965231Ab2B1BSg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 20:18:36 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:33164 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965196Ab2B1BMD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 20:12:03 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of gregkh@linuxfoundation.org designates 10.68.228.135 as permitted sender) smtp.mail=gregkh@linuxfoundation.org
MIME-Version: 1.0
Message-Id: <20120228010431.941362439@linuxfoundation.org>
User-Agent: quilt/0.51-17.1
Date: Mon, 27 Feb 2012 17:04:58 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, "David S. Miller" <davem@davemloft.net>
Subject: [ 29/72] net: Make qdisc_skb_cb upper size bound explicit.
In-Reply-To: <20120228010511.GA8453@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------


From: "David S. Miller" <davem@davemloft.net>

[ Upstream commit 16bda13d90c8d5da243e2cfa1677e62ecce26860 ]

Just like skb->cb[], so that qdisc_skb_cb can be encapsulated inside
of other data structures.

This is intended to be used by IPoIB so that it can remember
addressing information stored at hard_header_ops->create() time that
it can fetch when the packet gets to the transmit routine.

Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/sch_generic.h |    9 ++++++++-
 net/sched/sch_choke.c     |    3 +--
 net/sched/sch_netem.c     |    3 +--
 net/sched/sch_sfb.c       |    3 +--
 4 files changed, 11 insertions(+), 7 deletions(-)

--- a/include/net/sch_generic.h
+++ b/include/net/sch_generic.h
@@ -220,9 +220,16 @@ struct tcf_proto {
 
 struct qdisc_skb_cb {
 	unsigned int		pkt_len;
-	long			data[];
+	unsigned char		data[24];
 };
 
+static inline void qdisc_cb_private_validate(const struct sk_buff *skb, int sz)
+{
+	struct qdisc_skb_cb *qcb;
+	BUILD_BUG_ON(sizeof(skb->cb) < sizeof(unsigned int) + sz);
+	BUILD_BUG_ON(sizeof(qcb->data) < sz);
+}
+
 static inline int qdisc_qlen(const struct Qdisc *q)
 {
 	return q->q.qlen;
--- a/net/sched/sch_choke.c
+++ b/net/sched/sch_choke.c
@@ -225,8 +225,7 @@ struct choke_skb_cb {
 
 static inline struct choke_skb_cb *choke_skb_cb(const struct sk_buff *skb)
 {
-	BUILD_BUG_ON(sizeof(skb->cb) <
-		sizeof(struct qdisc_skb_cb) + sizeof(struct choke_skb_cb));
+	qdisc_cb_private_validate(skb, sizeof(struct choke_skb_cb));
 	return (struct choke_skb_cb *)qdisc_skb_cb(skb)->data;
 }
 
--- a/net/sched/sch_netem.c
+++ b/net/sched/sch_netem.c
@@ -118,8 +118,7 @@ struct netem_skb_cb {
 
 static inline struct netem_skb_cb *netem_skb_cb(struct sk_buff *skb)
 {
-	BUILD_BUG_ON(sizeof(skb->cb) <
-		sizeof(struct qdisc_skb_cb) + sizeof(struct netem_skb_cb));
+	qdisc_cb_private_validate(skb, sizeof(struct netem_skb_cb));
 	return (struct netem_skb_cb *)qdisc_skb_cb(skb)->data;
 }
 
--- a/net/sched/sch_sfb.c
+++ b/net/sched/sch_sfb.c
@@ -93,8 +93,7 @@ struct sfb_skb_cb {
 
 static inline struct sfb_skb_cb *sfb_skb_cb(const struct sk_buff *skb)
 {
-	BUILD_BUG_ON(sizeof(skb->cb) <
-		sizeof(struct qdisc_skb_cb) + sizeof(struct sfb_skb_cb));
+	qdisc_cb_private_validate(skb, sizeof(struct sfb_skb_cb));
 	return (struct sfb_skb_cb *)qdisc_skb_cb(skb)->data;
 }
 


