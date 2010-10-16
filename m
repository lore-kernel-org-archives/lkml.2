Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753208Ab0JPKLb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Oct 2010 06:11:31 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:34135 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751266Ab0JPKLa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Oct 2010 06:11:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=U2fMV8bY/hZXZdpXl3wDg5JbyjQq7vHFVBQ//vOlTLhbH7C7lzgNc573YNzquouMd0
         f7qu3Ti/IK1HNqPszrH4tS6vftA2lidtWUast2T8C+Ayqk7S00tZup3PNq8zdLvq7UN3
         ZZo8M45LULB/oEGZmi6ey+vo93uY5NwJHhJis=
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
        Andy Shevchenko <andy.shevchenko@gmail.com>
Subject: [PATCH 1/3] staging: batman-adv: remove useless addr_to_string()
Date: Sat, 16 Oct 2010 13:11:10 +0300
Message-Id: <11c47095d961ba40ad95ecf995094e78e4d96fdf.1287223789.git.andy.shevchenko@gmail.com>
X-Mailer: git-send-email 1.7.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since all *printf() methods in the kernel understand '%pM' modifier the
conversion to the string is useless beforehand.

Additionally this patch decreases batman_if structure by 20 bytes.

Signed-off-by: Andy Shevchenko <andy.shevchenko@gmail.com>
---
 drivers/staging/batman-adv/hard-interface.c |    2 --
 drivers/staging/batman-adv/main.c           |    5 -----
 drivers/staging/batman-adv/main.h           |    2 --
 drivers/staging/batman-adv/originator.c     |   16 ++++++----------
 drivers/staging/batman-adv/routing.c        |    4 ++--
 drivers/staging/batman-adv/send.c           |    8 ++++----
 drivers/staging/batman-adv/types.h          |    1 -
 drivers/staging/batman-adv/vis.c            |   15 ++++-----------
 8 files changed, 16 insertions(+), 37 deletions(-)

diff --git a/drivers/staging/batman-adv/hard-interface.c b/drivers/staging/batman-adv/hard-interface.c
index 7b77cf2..80cfa86 100644
--- a/drivers/staging/batman-adv/hard-interface.c
+++ b/drivers/staging/batman-adv/hard-interface.c
@@ -159,8 +159,6 @@ static bool hardif_is_iface_up(struct batman_if *batman_if)
 
 static void update_mac_addresses(struct batman_if *batman_if)
 {
-	addr_to_string(batman_if->addr_str, batman_if->net_dev->dev_addr);
-
 	memcpy(((struct batman_packet *)(batman_if->packet_buff))->orig,
 	       batman_if->net_dev->dev_addr, ETH_ALEN);
 	memcpy(((struct batman_packet *)(batman_if->packet_buff))->prev_sender,
diff --git a/drivers/staging/batman-adv/main.c b/drivers/staging/batman-adv/main.c
index 580ca02..0587940 100644
--- a/drivers/staging/batman-adv/main.c
+++ b/drivers/staging/batman-adv/main.c
@@ -145,11 +145,6 @@ void dec_module_count(void)
 	module_put(THIS_MODULE);
 }
 
-int addr_to_string(char *buff, uint8_t *addr)
-{
-	return sprintf(buff, "%pM", addr);
-}
-
 /* returns 1 if they are the same originator */
 
 int compare_orig(void *data1, void *data2)
diff --git a/drivers/staging/batman-adv/main.h b/drivers/staging/batman-adv/main.h
index ca97589..5e3f516 100644
--- a/drivers/staging/batman-adv/main.h
+++ b/drivers/staging/batman-adv/main.h
@@ -58,7 +58,6 @@
 
 #define PACKBUFF_SIZE 2000
 #define LOG_BUF_LEN 8192	  /* has to be a power of 2 */
-#define ETH_STR_LEN 20
 
 #define VIS_INTERVAL 5000	/* 5 seconds */
 
@@ -136,7 +135,6 @@ int mesh_init(struct net_device *soft_iface);
 void mesh_free(struct net_device *soft_iface);
 void inc_module_count(void);
 void dec_module_count(void);
-int addr_to_string(char *buff, uint8_t *addr);
 int compare_orig(void *data1, void *data2);
 int choose_orig(void *data, int32_t size);
 int is_my_mac(uint8_t *addr);
diff --git a/drivers/staging/batman-adv/originator.c b/drivers/staging/batman-adv/originator.c
index c530df1..dd98f58 100644
--- a/drivers/staging/batman-adv/originator.c
+++ b/drivers/staging/batman-adv/originator.c
@@ -315,7 +315,6 @@ int orig_seq_print_text(struct seq_file *seq, void *offset)
 	int last_seen_secs;
 	int last_seen_msecs;
 	unsigned long flags;
-	char orig_str[ETH_STR_LEN], router_str[ETH_STR_LEN];
 
 	if ((!bat_priv->primary_if) ||
 	    (bat_priv->primary_if->if_status != IF_ACTIVE)) {
@@ -329,10 +328,10 @@ int orig_seq_print_text(struct seq_file *seq, void *offset)
 				  net_dev->name);
 	}
 
-	seq_printf(seq, "[B.A.T.M.A.N. adv %s%s, MainIF/MAC: %s/%s (%s)]\n",
+	seq_printf(seq, "[B.A.T.M.A.N. adv %s%s, MainIF/MAC: %s/%pM (%s)]\n",
 		   SOURCE_VERSION, REVISION_VERSION_STR,
 		   bat_priv->primary_if->net_dev->name,
-		   bat_priv->primary_if->addr_str, net_dev->name);
+		   bat_priv->primary_if->net_dev->dev_addr, net_dev->name);
 	seq_printf(seq, "  %-15s %s (%s/%i) %17s [%10s]: %20s ...\n",
 		   "Originator", "last-seen", "#", TQ_MAX_VALUE, "Nexthop",
 		   "outgoingIF", "Potential nexthops");
@@ -349,21 +348,18 @@ int orig_seq_print_text(struct seq_file *seq, void *offset)
 		if (orig_node->router->tq_avg == 0)
 			continue;
 
-		addr_to_string(orig_str, orig_node->orig);
-		addr_to_string(router_str, orig_node->router->addr);
 		last_seen_secs = jiffies_to_msecs(jiffies -
 						orig_node->last_valid) / 1000;
 		last_seen_msecs = jiffies_to_msecs(jiffies -
 						orig_node->last_valid) % 1000;
 
-		seq_printf(seq, "%-17s %4i.%03is   (%3i) %17s [%10s]:",
-			   orig_str, last_seen_secs, last_seen_msecs,
-			   orig_node->router->tq_avg, router_str,
+		seq_printf(seq, "%pM %4i.%03is   (%3i) %pM [%10s]:",
+			   orig_node->orig, last_seen_secs, last_seen_msecs,
+			   orig_node->router->tq_avg, orig_node->router->addr,
 			   orig_node->router->if_incoming->net_dev->name);
 
 		list_for_each_entry(neigh_node, &orig_node->neigh_list, list) {
-			addr_to_string(orig_str, neigh_node->addr);
-			seq_printf(seq, " %17s (%3i)", orig_str,
+			seq_printf(seq, " %pM (%3i)", neigh_node->addr,
 					   neigh_node->tq_avg);
 		}
 
diff --git a/drivers/staging/batman-adv/routing.c b/drivers/staging/batman-adv/routing.c
index 58aa99e..9010263 100644
--- a/drivers/staging/batman-adv/routing.c
+++ b/drivers/staging/batman-adv/routing.c
@@ -554,11 +554,11 @@ void receive_bat_packet(struct ethhdr *ethhdr,
 					    batman_packet->orig) ? 1 : 0);
 
 	bat_dbg(DBG_BATMAN, bat_priv,
-		"Received BATMAN packet via NB: %pM, IF: %s [%s] "
+		"Received BATMAN packet via NB: %pM, IF: %s [%pM] "
 		"(from OG: %pM, via prev OG: %pM, seqno %d, tq %d, "
 		"TTL %d, V %d, IDF %d)\n",
 		ethhdr->h_source, if_incoming->net_dev->name,
-		if_incoming->addr_str, batman_packet->orig,
+		if_incoming->net_dev->dev_addr, batman_packet->orig,
 		batman_packet->prev_sender, batman_packet->seqno,
 		batman_packet->tq, batman_packet->ttl, batman_packet->version,
 		has_directlink_flag);
diff --git a/drivers/staging/batman-adv/send.c b/drivers/staging/batman-adv/send.c
index 5d57ef5..1d78bc5 100644
--- a/drivers/staging/batman-adv/send.c
+++ b/drivers/staging/batman-adv/send.c
@@ -135,13 +135,13 @@ static void send_packet_to_if(struct forw_packet *forw_packet,
 							    "Forwarding"));
 		bat_dbg(DBG_BATMAN, bat_priv,
 			"%s %spacket (originator %pM, seqno %d, TQ %d, TTL %d,"
-			" IDF %s) on interface %s [%s]\n",
+			" IDF %s) on interface %s [%pM]\n",
 			fwd_str, (packet_num > 0 ? "aggregated " : ""),
 			batman_packet->orig, ntohl(batman_packet->seqno),
 			batman_packet->tq, batman_packet->ttl,
 			(batman_packet->flags & DIRECTLINK ?
 			 "on" : "off"),
-			batman_if->net_dev->name, batman_if->addr_str);
+			batman_if->net_dev->name, batman_if->net_dev->dev_addr);
 
 		buff_pos += sizeof(struct batman_packet) +
 			(batman_packet->num_hna * ETH_ALEN);
@@ -183,12 +183,12 @@ static void send_packet(struct forw_packet *forw_packet)
 		/* FIXME: what about aggregated packets ? */
 		bat_dbg(DBG_BATMAN, bat_priv,
 			"%s packet (originator %pM, seqno %d, TTL %d) "
-			"on interface %s [%s]\n",
+			"on interface %s [%pM]\n",
 			(forw_packet->own ? "Sending own" : "Forwarding"),
 			batman_packet->orig, ntohl(batman_packet->seqno),
 			batman_packet->ttl,
 			forw_packet->if_incoming->net_dev->name,
-			forw_packet->if_incoming->addr_str);
+			forw_packet->if_incoming->net_dev->dev_addr);
 
 		/* skb is only used once and than forw_packet is free'd */
 		send_skb_packet(forw_packet->skb, forw_packet->if_incoming,
diff --git a/drivers/staging/batman-adv/types.h b/drivers/staging/batman-adv/types.h
index bb5827f..f3f7366 100644
--- a/drivers/staging/batman-adv/types.h
+++ b/drivers/staging/batman-adv/types.h
@@ -37,7 +37,6 @@ struct batman_if {
 	struct list_head list;
 	int16_t if_num;
 	char if_status;
-	char addr_str[ETH_STR_LEN];
 	struct net_device *net_dev;
 	atomic_t seqno;
 	atomic_t frag_seqno;
diff --git a/drivers/staging/batman-adv/vis.c b/drivers/staging/batman-adv/vis.c
index 6b102a3..8f21649 100644
--- a/drivers/staging/batman-adv/vis.c
+++ b/drivers/staging/batman-adv/vis.c
@@ -130,15 +130,13 @@ static ssize_t vis_data_read_prim_sec(char *buff, struct hlist_head *if_list)
 {
 	struct if_list_entry *entry;
 	struct hlist_node *pos;
-	char tmp_addr_str[ETH_STR_LEN];
 	size_t len = 0;
 
 	hlist_for_each_entry(entry, pos, if_list, list) {
 		if (entry->primary)
 			len += sprintf(buff + len, "PRIMARY, ");
 		else {
-			addr_to_string(tmp_addr_str, entry->addr);
-			len += sprintf(buff + len,  "SEC %s, ", tmp_addr_str);
+			len += sprintf(buff + len,  "SEC %pM, ", entry->addr);
 		}
 	}
 
@@ -165,12 +163,9 @@ static size_t vis_data_count_prim_sec(struct hlist_head *if_list)
 static ssize_t vis_data_read_entry(char *buff, struct vis_info_entry *entry,
 				   uint8_t *src, bool primary)
 {
-	char to[18];
-
 	/* maximal length: max(4+17+2, 3+17+1+3+2) == 26 */
-	addr_to_string(to, entry->dest);
 	if (primary && entry->quality == 0)
-		return sprintf(buff, "HNA %s, ", to);
+		return sprintf(buff, "HNA %pM, ", entry->dest);
 	else if (compare_orig(entry->src, src))
 		return sprintf(buff, "TQ %s %d, ", to, entry->quality);
 
@@ -190,7 +185,6 @@ int vis_seq_print_text(struct seq_file *seq, void *offset)
 	struct if_list_entry *entry;
 	struct hlist_node *pos, *n;
 	int i;
-	char tmp_addr_str[ETH_STR_LEN];
 	unsigned long flags;
 	int vis_server = atomic_read(&bat_priv->vis_mode);
 	size_t buff_pos, buf_size;
@@ -255,9 +249,8 @@ int vis_seq_print_text(struct seq_file *seq, void *offset)
 		}
 
 		hlist_for_each_entry(entry, pos, &vis_if_list, list) {
-			addr_to_string(tmp_addr_str, entry->addr);
-			buff_pos += sprintf(buff + buff_pos, "%s,",
-					    tmp_addr_str);
+			buff_pos += sprintf(buff + buff_pos, "%pM,",
+					    entry->addr);
 
 			for (i = 0; i < packet->entries; i++)
 				buff_pos += vis_data_read_entry(buff + buff_pos,
-- 
1.7.2.3

