Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758651Ab2I1Uus (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 16:50:48 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:35060 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1161027Ab2I1Uss (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 16:48:48 -0400
X-Sasl-enc: S2f3+lQ523YfJCrOcYJgo5Q0BrTJEt9MIDN/QRuBw4f4 1348865327
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Neil Horman <nhorman@tuxdriver.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        David Miller <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: [ 108/127] drop_monitor: Make updating data->skb smp safe
Date: Fri, 28 Sep 2012 13:34:41 -0700
Message-Id: <20120928203058.504518566@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.1.428.g652398a
In-Reply-To: <20120928203045.835238916@linuxfoundation.org>
References: <20120928203045.835238916@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Neil Horman <nhorman@tuxdriver.com>

commit 3885ca785a3618593226687ced84f3f336dc3860 upstream.

Eric Dumazet pointed out to me that the drop_monitor protocol has some holes in
its smp protections.  Specifically, its possible to replace data->skb while its
being written.  This patch corrects that by making data->skb an rcu protected
variable.  That will prevent it from being overwritten while a tracepoint is
modifying it.

Signed-off-by: Neil Horman <nhorman@tuxdriver.com>
Reported-by: Eric Dumazet <eric.dumazet@gmail.com>
CC: David Miller <davem@davemloft.net>
Acked-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Cc: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/core/drop_monitor.c |   70 +++++++++++++++++++++++++++++++++++++-----------
 1 file changed, 54 insertions(+), 16 deletions(-)

--- a/net/core/drop_monitor.c
+++ b/net/core/drop_monitor.c
@@ -46,7 +46,7 @@ static DEFINE_MUTEX(trace_state_mutex);
 
 struct per_cpu_dm_data {
 	struct work_struct dm_alert_work;
-	struct sk_buff *skb;
+	struct sk_buff __rcu *skb;
 	atomic_t dm_hit_count;
 	struct timer_list send_timer;
 };
@@ -73,35 +73,58 @@ static int dm_hit_limit = 64;
 static int dm_delay = 1;
 static unsigned long dm_hw_check_delta = 2*HZ;
 static LIST_HEAD(hw_stats_list);
+static int initialized = 0;
 
 static void reset_per_cpu_data(struct per_cpu_dm_data *data)
 {
 	size_t al;
 	struct net_dm_alert_msg *msg;
 	struct nlattr *nla;
+	struct sk_buff *skb;
+	struct sk_buff *oskb = rcu_dereference_protected(data->skb, 1);
 
 	al = sizeof(struct net_dm_alert_msg);
 	al += dm_hit_limit * sizeof(struct net_dm_drop_point);
 	al += sizeof(struct nlattr);
 
-	data->skb = genlmsg_new(al, GFP_KERNEL);
-	genlmsg_put(data->skb, 0, 0, &net_drop_monitor_family,
-			0, NET_DM_CMD_ALERT);
-	nla = nla_reserve(data->skb, NLA_UNSPEC, sizeof(struct net_dm_alert_msg));
-	msg = nla_data(nla);
-	memset(msg, 0, al);
-	atomic_set(&data->dm_hit_count, dm_hit_limit);
+	skb = genlmsg_new(al, GFP_KERNEL);
+
+	if (skb) {
+		genlmsg_put(skb, 0, 0, &net_drop_monitor_family,
+				0, NET_DM_CMD_ALERT);
+		nla = nla_reserve(skb, NLA_UNSPEC,
+				  sizeof(struct net_dm_alert_msg));
+		msg = nla_data(nla);
+		memset(msg, 0, al);
+	} else if (initialized)
+		schedule_work_on(smp_processor_id(), &data->dm_alert_work);
+
+	/*
+	 * Don't need to lock this, since we are guaranteed to only
+	 * run this on a single cpu at a time.
+	 * Note also that we only update data->skb if the old and new skb
+	 * pointers don't match.  This ensures that we don't continually call
+	 * synchornize_rcu if we repeatedly fail to alloc a new netlink message.
+	 */
+	if (skb != oskb) {
+		rcu_assign_pointer(data->skb, skb);
+
+		synchronize_rcu();
+
+		atomic_set(&data->dm_hit_count, dm_hit_limit);
+	}
+
 }
 
 static void send_dm_alert(struct work_struct *unused)
 {
 	struct sk_buff *skb;
-	struct per_cpu_dm_data *data = &__get_cpu_var(dm_cpu_data);
+	struct per_cpu_dm_data *data = &get_cpu_var(dm_cpu_data);
 
 	/*
 	 * Grab the skb we're about to send
 	 */
-	skb = data->skb;
+	skb = rcu_dereference_protected(data->skb, 1);
 
 	/*
 	 * Replace it with a new one
@@ -111,8 +134,10 @@ static void send_dm_alert(struct work_st
 	/*
 	 * Ship it!
 	 */
-	genlmsg_multicast(skb, 0, NET_DM_GRP_ALERT, GFP_KERNEL);
+	if (skb)
+		genlmsg_multicast(skb, 0, NET_DM_GRP_ALERT, GFP_KERNEL);
 
+	put_cpu_var(dm_cpu_data);
 }
 
 /*
@@ -123,9 +148,11 @@ static void send_dm_alert(struct work_st
  */
 static void sched_send_work(unsigned long unused)
 {
-	struct per_cpu_dm_data *data =  &__get_cpu_var(dm_cpu_data);
+	struct per_cpu_dm_data *data =  &get_cpu_var(dm_cpu_data);
+
+	schedule_work_on(smp_processor_id(), &data->dm_alert_work);
 
-	schedule_work(&data->dm_alert_work);
+	put_cpu_var(dm_cpu_data);
 }
 
 static void trace_drop_common(struct sk_buff *skb, void *location)
@@ -134,9 +161,16 @@ static void trace_drop_common(struct sk_
 	struct nlmsghdr *nlh;
 	struct nlattr *nla;
 	int i;
-	struct per_cpu_dm_data *data = &__get_cpu_var(dm_cpu_data);
+	struct sk_buff *dskb;
+	struct per_cpu_dm_data *data = &get_cpu_var(dm_cpu_data);
 
 
+	rcu_read_lock();
+	dskb = rcu_dereference(data->skb);
+
+	if (!dskb)
+		goto out;
+
 	if (!atomic_add_unless(&data->dm_hit_count, -1, 0)) {
 		/*
 		 * we're already at zero, discard this hit
@@ -144,7 +178,7 @@ static void trace_drop_common(struct sk_
 		goto out;
 	}
 
-	nlh = (struct nlmsghdr *)data->skb->data;
+	nlh = (struct nlmsghdr *)dskb->data;
 	nla = genlmsg_data(nlmsg_data(nlh));
 	msg = nla_data(nla);
 	for (i = 0; i < msg->entries; i++) {
@@ -157,7 +191,7 @@ static void trace_drop_common(struct sk_
 	/*
 	 * We need to create a new entry
 	 */
-	__nla_reserve_nohdr(data->skb, sizeof(struct net_dm_drop_point));
+	__nla_reserve_nohdr(dskb, sizeof(struct net_dm_drop_point));
 	nla->nla_len += NLA_ALIGN(sizeof(struct net_dm_drop_point));
 	memcpy(msg->points[msg->entries].pc, &location, sizeof(void *));
 	msg->points[msg->entries].count = 1;
@@ -169,6 +203,8 @@ static void trace_drop_common(struct sk_
 	}
 
 out:
+	rcu_read_unlock();
+	put_cpu_var(dm_cpu_data);
 	return;
 }
 
@@ -374,6 +410,8 @@ static int __init init_net_drop_monitor(
 		data->send_timer.function = sched_send_work;
 	}
 
+	initialized = 1;
+
 	goto out;
 
 out_unreg:


