Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758250Ab0ELVgk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 17:36:40 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:48414 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758085Ab0ELVd5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 17:33:57 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
       akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
       josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
       tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com, eric.dumazet@gmail.com,
       Arnd Bergmann <arnd@relay.de.ibm.com>, Arnd Bergmann <arnd@arndb.de>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       "David S. Miller" <davem@davemloft.net>
Subject: [PATCH RFC tip/core/rcu 21/23] net: __rcu annotations
Date: Wed, 12 May 2010 14:33:40 -0700
Message-Id: <1273700022-16523-21-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.0.6
In-Reply-To: <20100512213317.GA15085@linux.vnet.ibm.com>
References: <20100512213317.GA15085@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnd Bergmann <arnd@relay.de.ibm.com>

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
---
 include/linux/igmp.h               |    4 ++--
 include/linux/netdevice.h          |   12 ++++++------
 include/net/dst.h                  |    2 +-
 include/net/fib_rules.h            |    2 +-
 include/net/garp.h                 |    2 +-
 include/net/inet_sock.h            |    2 +-
 include/net/ip6_tunnel.h           |    2 +-
 include/net/ipip.h                 |    6 +++---
 include/net/net_namespace.h        |    2 +-
 include/net/netns/xfrm.h           |    2 +-
 include/net/sock.h                 |    4 ++--
 kernel/sched.c                     |    2 +-
 net/802/stp.c                      |    4 ++--
 net/ipv4/ip_gre.c                  |    2 +-
 net/ipv4/ipip.c                    |   10 +++++-----
 net/ipv4/protocol.c                |    2 +-
 net/ipv4/route.c                   |    2 +-
 net/ipv4/tcp.c                     |    4 ++--
 net/ipv6/ip6_tunnel.c              |    6 +++---
 net/ipv6/protocol.c                |    2 +-
 net/ipv6/sit.c                     |   10 +++++-----
 net/mac80211/ieee80211_i.h         |   15 ++++++++-------
 net/mac80211/sta_info.h            |    4 ++--
 net/netlabel/netlabel_domainhash.c |    4 ++--
 net/netlabel/netlabel_unlabeled.c  |    4 ++--
 net/netlink/af_netlink.c           |    2 +-
 net/phonet/af_phonet.c             |    2 +-
 net/phonet/pn_dev.c                |    2 +-
 net/socket.c                       |    2 +-
 29 files changed, 60 insertions(+), 59 deletions(-)

diff --git a/include/linux/igmp.h b/include/linux/igmp.h
index 93fc244..39dd315 100644
--- a/include/linux/igmp.h
+++ b/include/linux/igmp.h
@@ -167,10 +167,10 @@ struct ip_sf_socklist {
  */
 
 struct ip_mc_socklist {
-	struct ip_mc_socklist	*next;
+	struct ip_mc_socklist __rcu *next;
 	struct ip_mreqn		multi;
 	unsigned int		sfmode;		/* MCAST_{INCLUDE,EXCLUDE} */
-	struct ip_sf_socklist	*sflist;
+	struct ip_sf_socklist __rcu *sflist;
 	struct rcu_head		rcu;
 };
 
diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index fa8b476..425be97 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -855,10 +855,10 @@ struct net_device {
 #ifdef CONFIG_NET_DSA
 	void			*dsa_ptr;	/* dsa specific data */
 #endif
-	void 			*atalk_ptr;	/* AppleTalk link 	*/
-	void			*ip_ptr;	/* IPv4 specific data	*/
+	void			*atalk_ptr;	/* AppleTalk link	*/
+	void __rcu		*ip_ptr;	/* IPv4 specific data	*/
 	void                    *dn_ptr;        /* DECnet specific data */
-	void                    *ip6_ptr;       /* IPv6 specific data */
+	void __rcu              *ip6_ptr;       /* IPv6 specific data */
 	void			*ec_ptr;	/* Econet specific data	*/
 	void			*ax25_ptr;	/* AX.25 specific data */
 	struct wireless_dev	*ieee80211_ptr;	/* IEEE 802.11 specific data,
@@ -947,11 +947,11 @@ struct net_device {
 	void			*ml_priv;
 
 	/* bridge stuff */
-	struct net_bridge_port	*br_port;
+	void __rcu		*br_port;
 	/* macvlan */
-	struct macvlan_port	*macvlan_port;
+	struct macvlan_port __rcu *macvlan_port;
 	/* GARP */
-	struct garp_port	*garp_port;
+	struct garp_port __rcu	*garp_port;
 
 	/* class/net/name entry */
 	struct device		dev;
diff --git a/include/net/dst.h b/include/net/dst.h
index ce078cd..5f839aa 100644
--- a/include/net/dst.h
+++ b/include/net/dst.h
@@ -94,7 +94,7 @@ struct dst_entry {
 	unsigned long		lastuse;
 	union {
 		struct dst_entry *next;
-		struct rtable    *rt_next;
+		struct rtable   __rcu *rt_next;
 		struct rt6_info   *rt6_next;
 		struct dn_route  *dn_next;
 	};
diff --git a/include/net/fib_rules.h b/include/net/fib_rules.h
index c49086d..e88dc69 100644
--- a/include/net/fib_rules.h
+++ b/include/net/fib_rules.h
@@ -20,7 +20,7 @@ struct fib_rule {
 	u32			table;
 	u8			action;
 	u32			target;
-	struct fib_rule *	ctarget;
+	struct fib_rule __rcu  *ctarget;
 	char			iifname[IFNAMSIZ];
 	char			oifname[IFNAMSIZ];
 	struct rcu_head		rcu;
diff --git a/include/net/garp.h b/include/net/garp.h
index 825f172..15b30ba 100644
--- a/include/net/garp.h
+++ b/include/net/garp.h
@@ -107,7 +107,7 @@ struct garp_applicant {
 };
 
 struct garp_port {
-	struct garp_applicant	*applicants[GARP_APPLICATION_MAX + 1];
+	struct garp_applicant __rcu *applicants[GARP_APPLICATION_MAX + 1];
 };
 
 extern int	garp_register_application(struct garp_application *app);
diff --git a/include/net/inet_sock.h b/include/net/inet_sock.h
index 83fd344..b16192f 100644
--- a/include/net/inet_sock.h
+++ b/include/net/inet_sock.h
@@ -139,7 +139,7 @@ struct inet_sock {
 				mc_all:1;
 	int			mc_index;
 	__be32			mc_addr;
-	struct ip_mc_socklist	*mc_list;
+	struct ip_mc_socklist __rcu *mc_list;
 	struct {
 		unsigned int		flags;
 		unsigned int		fragsize;
diff --git a/include/net/ip6_tunnel.h b/include/net/ip6_tunnel.h
index fbf9d1c..94fa2cc 100644
--- a/include/net/ip6_tunnel.h
+++ b/include/net/ip6_tunnel.h
@@ -13,7 +13,7 @@
 /* IPv6 tunnel */
 
 struct ip6_tnl {
-	struct ip6_tnl *next;	/* next tunnel in list */
+	struct ip6_tnl __rcu *next;	/* next tunnel in list */
 	struct net_device *dev;	/* virtual device associated with tunnel */
 	struct ip6_tnl_parm parms;	/* tunnel configuration parameters */
 	struct flowi fl;	/* flowi template for xmit */
diff --git a/include/net/ipip.h b/include/net/ipip.h
index 11e8513..ea186ab 100644
--- a/include/net/ipip.h
+++ b/include/net/ipip.h
@@ -16,7 +16,7 @@ struct ip_tunnel_6rd_parm {
 };
 
 struct ip_tunnel {
-	struct ip_tunnel	*next;
+	struct ip_tunnel __rcu	*next;
 	struct net_device	*dev;
 
 	int			err_count;	/* Number of arrived ICMP errors */
@@ -34,12 +34,12 @@ struct ip_tunnel {
 #ifdef CONFIG_IPV6_SIT_6RD
 	struct ip_tunnel_6rd_parm	ip6rd;
 #endif
-	struct ip_tunnel_prl_entry	*prl;		/* potential router list */
+	struct ip_tunnel_prl_entry __rcu *prl;		/* potential router list */
 	unsigned int			prl_count;	/* # of entries in PRL */
 };
 
 struct ip_tunnel_prl_entry {
-	struct ip_tunnel_prl_entry	*next;
+	struct ip_tunnel_prl_entry __rcu *next;
 	__be32				addr;
 	u16				flags;
 	struct rcu_head			rcu_head;
diff --git a/include/net/net_namespace.h b/include/net/net_namespace.h
index bd10a79..573d100 100644
--- a/include/net/net_namespace.h
+++ b/include/net/net_namespace.h
@@ -90,7 +90,7 @@ struct net {
 #ifdef CONFIG_WEXT_CORE
 	struct sk_buff_head	wext_nlevents;
 #endif
-	struct net_generic	*gen;
+	struct net_generic __rcu *gen;
 };
 
 
diff --git a/include/net/netns/xfrm.h b/include/net/netns/xfrm.h
index 74f119a..9e0915d 100644
--- a/include/net/netns/xfrm.h
+++ b/include/net/netns/xfrm.h
@@ -48,7 +48,7 @@ struct netns_xfrm {
 	struct dst_ops		xfrm6_dst_ops;
 #endif
 
-	struct sock		*nlsk;
+	struct sock __rcu	*nlsk;
 	struct sock		*nlsk_stash;
 
 	u32			sysctl_aevent_etime;
diff --git a/include/net/sock.h b/include/net/sock.h
index 1ad6435..a1d5a76 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -148,7 +148,7 @@ struct sock_common {
 	};
 	struct proto		*skc_prot;
 #ifdef CONFIG_NET_NS
-	struct net	 	*skc_net;
+	struct net __rcu	*skc_net;
 #endif
 };
 
@@ -293,7 +293,7 @@ struct sock {
 	struct ucred		sk_peercred;
 	long			sk_rcvtimeo;
 	long			sk_sndtimeo;
-	struct sk_filter      	*sk_filter;
+	struct sk_filter __rcu	*sk_filter;
 	void			*sk_protinfo;
 	struct timer_list	sk_timer;
 	ktime_t			sk_stamp;
diff --git a/kernel/sched.c b/kernel/sched.c
index d8a213c..53e1670 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -539,7 +539,7 @@ struct rq {
 
 #ifdef CONFIG_SMP
 	struct root_domain *rd;
-	struct sched_domain *sd;
+	struct sched_domain __rcu *sd;
 
 	unsigned char idle_at_tick;
 	/* For active balancing */
diff --git a/net/802/stp.c b/net/802/stp.c
index 53c8f77..978c30b 100644
--- a/net/802/stp.c
+++ b/net/802/stp.c
@@ -21,8 +21,8 @@
 #define GARP_ADDR_MAX	0x2F
 #define GARP_ADDR_RANGE	(GARP_ADDR_MAX - GARP_ADDR_MIN)
 
-static const struct stp_proto *garp_protos[GARP_ADDR_RANGE + 1] __read_mostly;
-static const struct stp_proto *stp_proto __read_mostly;
+static const struct stp_proto __rcu *garp_protos[GARP_ADDR_RANGE + 1] __read_mostly;
+static const struct stp_proto __rcu *stp_proto __read_mostly;
 
 static struct llc_sap *sap __read_mostly;
 static unsigned int sap_registered;
diff --git a/net/ipv4/ip_gre.c b/net/ipv4/ip_gre.c
index fe381d1..7d065cb 100644
--- a/net/ipv4/ip_gre.c
+++ b/net/ipv4/ip_gre.c
@@ -128,7 +128,7 @@ static int ipgre_tunnel_bind_dev(struct net_device *dev);
 
 static int ipgre_net_id __read_mostly;
 struct ipgre_net {
-	struct ip_tunnel *tunnels[4][HASH_SIZE];
+	struct ip_tunnel __rcu *tunnels[4][HASH_SIZE];
 
 	struct net_device *fb_tunnel_dev;
 };
diff --git a/net/ipv4/ipip.c b/net/ipv4/ipip.c
index 0b27b14..7b5bc05 100644
--- a/net/ipv4/ipip.c
+++ b/net/ipv4/ipip.c
@@ -122,11 +122,11 @@
 
 static int ipip_net_id __read_mostly;
 struct ipip_net {
-	struct ip_tunnel *tunnels_r_l[HASH_SIZE];
-	struct ip_tunnel *tunnels_r[HASH_SIZE];
-	struct ip_tunnel *tunnels_l[HASH_SIZE];
-	struct ip_tunnel *tunnels_wc[1];
-	struct ip_tunnel **tunnels[4];
+	struct ip_tunnel __rcu *tunnels_r_l[HASH_SIZE];
+	struct ip_tunnel __rcu *tunnels_r[HASH_SIZE];
+	struct ip_tunnel __rcu *tunnels_l[HASH_SIZE];
+	struct ip_tunnel __rcu *tunnels_wc[1];
+	struct ip_tunnel __rcu **tunnels[4];
 
 	struct net_device *fb_tunnel_dev;
 };
diff --git a/net/ipv4/protocol.c b/net/ipv4/protocol.c
index 542f22f..ac2cf39 100644
--- a/net/ipv4/protocol.c
+++ b/net/ipv4/protocol.c
@@ -28,7 +28,7 @@
 #include <linux/spinlock.h>
 #include <net/protocol.h>
 
-const struct net_protocol *inet_protos[MAX_INET_PROTOS] ____cacheline_aligned_in_smp;
+const struct net_protocol __rcu *inet_protos[MAX_INET_PROTOS] ____cacheline_aligned_in_smp;
 static DEFINE_SPINLOCK(inet_proto_lock);
 
 /*
diff --git a/net/ipv4/route.c b/net/ipv4/route.c
index cb562fd..c204b6e 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -200,7 +200,7 @@ const __u8 ip_tos2prio[16] = {
  */
 
 struct rt_hash_bucket {
-	struct rtable	*chain;
+	struct rtable __rcu *chain;
 };
 
 #if defined(CONFIG_SMP) || defined(CONFIG_DEBUG_SPINLOCK) || \
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 0f8caf6..2cb54fa 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -3057,9 +3057,9 @@ static struct tcp_cookie_secret tcp_secret_one;
 static struct tcp_cookie_secret tcp_secret_two;
 
 /* Essentially a circular list, without dynamic allocation. */
-static struct tcp_cookie_secret *tcp_secret_generating;
+static struct tcp_cookie_secret __rcu *tcp_secret_generating;
 static struct tcp_cookie_secret *tcp_secret_primary;
-static struct tcp_cookie_secret *tcp_secret_retiring;
+static struct tcp_cookie_secret __rcu *tcp_secret_retiring;
 static struct tcp_cookie_secret *tcp_secret_secondary;
 
 static DEFINE_SPINLOCK(tcp_secret_locker);
diff --git a/net/ipv6/ip6_tunnel.c b/net/ipv6/ip6_tunnel.c
index 2599870..981ed03 100644
--- a/net/ipv6/ip6_tunnel.c
+++ b/net/ipv6/ip6_tunnel.c
@@ -83,9 +83,9 @@ struct ip6_tnl_net {
 	/* the IPv6 tunnel fallback device */
 	struct net_device *fb_tnl_dev;
 	/* lists for storing tunnels in use */
-	struct ip6_tnl *tnls_r_l[HASH_SIZE];
-	struct ip6_tnl *tnls_wc[1];
-	struct ip6_tnl **tnls[2];
+	struct ip6_tnl __rcu *tnls_r_l[HASH_SIZE];
+	struct ip6_tnl __rcu *tnls_wc[1];
+	struct ip6_tnl __rcu **tnls[2];
 };
 
 /*
diff --git a/net/ipv6/protocol.c b/net/ipv6/protocol.c
index 1fa3468..dee7e9d 100644
--- a/net/ipv6/protocol.c
+++ b/net/ipv6/protocol.c
@@ -25,7 +25,7 @@
 #include <linux/spinlock.h>
 #include <net/protocol.h>
 
-const struct inet6_protocol *inet6_protos[MAX_INET_PROTOS];
+const struct inet6_protocol __rcu *inet6_protos[MAX_INET_PROTOS];
 static DEFINE_SPINLOCK(inet6_proto_lock);
 
 
diff --git a/net/ipv6/sit.c b/net/ipv6/sit.c
index 5abae10..dc77b54 100644
--- a/net/ipv6/sit.c
+++ b/net/ipv6/sit.c
@@ -68,11 +68,11 @@ static void ipip6_tunnel_setup(struct net_device *dev);
 
 static int sit_net_id __read_mostly;
 struct sit_net {
-	struct ip_tunnel *tunnels_r_l[HASH_SIZE];
-	struct ip_tunnel *tunnels_r[HASH_SIZE];
-	struct ip_tunnel *tunnels_l[HASH_SIZE];
-	struct ip_tunnel *tunnels_wc[1];
-	struct ip_tunnel **tunnels[4];
+	struct ip_tunnel __rcu *tunnels_r_l[HASH_SIZE];
+	struct ip_tunnel __rcu *tunnels_r[HASH_SIZE];
+	struct ip_tunnel __rcu *tunnels_l[HASH_SIZE];
+	struct ip_tunnel __rcu *tunnels_wc[1];
+	struct ip_tunnel __rcu **tunnels[4];
 
 	struct net_device *fb_tunnel_dev;
 };
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 241533e..08476d2 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -192,7 +192,7 @@ struct beacon_data {
 };
 
 struct ieee80211_if_ap {
-	struct beacon_data *beacon;
+	struct beacon_data __rcu *beacon;
 
 	struct list_head vlans;
 
@@ -214,7 +214,7 @@ struct ieee80211_if_vlan {
 	struct list_head list;
 
 	/* used for all tx if the VLAN is configured to 4-addr mode */
-	struct sta_info *sta;
+	struct sta_info __rcu *sta;
 };
 
 struct mesh_stats {
@@ -388,7 +388,8 @@ struct ieee80211_if_ibss {
 
 	unsigned long ibss_join_req;
 	/* probe response/beacon for IBSS */
-	struct sk_buff *presp, *skb;
+	struct sk_buff __rcu *presp;
+	struct sk_buff *skb;
 
 	enum {
 		IEEE80211_IBSS_MLME_SEARCH,
@@ -492,9 +493,9 @@ struct ieee80211_sub_if_data {
 
 #define NUM_DEFAULT_KEYS 4
 #define NUM_DEFAULT_MGMT_KEYS 2
-	struct ieee80211_key *keys[NUM_DEFAULT_KEYS + NUM_DEFAULT_MGMT_KEYS];
-	struct ieee80211_key *default_key;
-	struct ieee80211_key *default_mgmt_key;
+	struct ieee80211_key __rcu *keys[NUM_DEFAULT_KEYS + NUM_DEFAULT_MGMT_KEYS];
+	struct ieee80211_key __rcu *default_key;
+	struct ieee80211_key __rcu *default_mgmt_key;
 
 	u16 sequence_number;
 
@@ -698,7 +699,7 @@ struct ieee80211_local {
 	spinlock_t sta_lock;
 	unsigned long num_sta;
 	struct list_head sta_list, sta_pending_list;
-	struct sta_info *sta_hash[STA_HASH_SIZE];
+	struct sta_info __rcu *sta_hash[STA_HASH_SIZE];
 	struct timer_list sta_cleanup;
 	struct work_struct sta_finish_work;
 	int sta_generation;
diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
index 822d845..8034e8d 100644
--- a/net/mac80211/sta_info.h
+++ b/net/mac80211/sta_info.h
@@ -229,10 +229,10 @@ struct sta_ampdu_mlme {
 struct sta_info {
 	/* General information, mostly static */
 	struct list_head list;
-	struct sta_info *hnext;
+	struct sta_info __rcu *hnext;
 	struct ieee80211_local *local;
 	struct ieee80211_sub_if_data *sdata;
-	struct ieee80211_key *key;
+	struct ieee80211_key __rcu *key;
 	struct rate_control_ref *rate_ctrl;
 	void *rate_ctrl_priv;
 	spinlock_t lock;
diff --git a/net/netlabel/netlabel_domainhash.c b/net/netlabel/netlabel_domainhash.c
index d37b7f8..f6803cf 100644
--- a/net/netlabel/netlabel_domainhash.c
+++ b/net/netlabel/netlabel_domainhash.c
@@ -57,8 +57,8 @@ static DEFINE_SPINLOCK(netlbl_domhsh_lock);
 #define netlbl_domhsh_rcu_deref(p) \
 	rcu_dereference_check(p, rcu_read_lock_held() || \
 				 lockdep_is_held(&netlbl_domhsh_lock))
-static struct netlbl_domhsh_tbl *netlbl_domhsh = NULL;
-static struct netlbl_dom_map *netlbl_domhsh_def = NULL;
+static struct netlbl_domhsh_tbl __rcu *netlbl_domhsh = NULL;
+static struct netlbl_dom_map __rcu *netlbl_domhsh_def = NULL;
 
 /*
  * Domain Hash Table Helper Functions
diff --git a/net/netlabel/netlabel_unlabeled.c b/net/netlabel/netlabel_unlabeled.c
index a3d64aa..9c5bc42 100644
--- a/net/netlabel/netlabel_unlabeled.c
+++ b/net/netlabel/netlabel_unlabeled.c
@@ -118,8 +118,8 @@ static DEFINE_SPINLOCK(netlbl_unlhsh_lock);
 #define netlbl_unlhsh_rcu_deref(p) \
 	rcu_dereference_check(p, rcu_read_lock_held() || \
 				 lockdep_is_held(&netlbl_unlhsh_lock))
-static struct netlbl_unlhsh_tbl *netlbl_unlhsh = NULL;
-static struct netlbl_unlhsh_iface *netlbl_unlhsh_def = NULL;
+static struct netlbl_unlhsh_tbl __rcu *netlbl_unlhsh = NULL;
+static struct netlbl_unlhsh_iface __rcu *netlbl_unlhsh_def = NULL;
 
 /* Accept unlabeled packets flag */
 static u8 netlabel_unlabel_acceptflg = 0;
diff --git a/net/netlink/af_netlink.c b/net/netlink/af_netlink.c
index 7954243..b917d4a 100644
--- a/net/netlink/af_netlink.c
+++ b/net/netlink/af_netlink.c
@@ -119,7 +119,7 @@ struct nl_pid_hash {
 struct netlink_table {
 	struct nl_pid_hash hash;
 	struct hlist_head mc_list;
-	unsigned long *listeners;
+	unsigned long __rcu *listeners;
 	unsigned int nl_nonroot;
 	unsigned int groups;
 	struct mutex *cb_mutex;
diff --git a/net/phonet/af_phonet.c b/net/phonet/af_phonet.c
index 73aee7f..e3baaa1 100644
--- a/net/phonet/af_phonet.c
+++ b/net/phonet/af_phonet.c
@@ -35,7 +35,7 @@
 #include <net/phonet/pn_dev.h>
 
 /* Transport protocol registration */
-static struct phonet_protocol *proto_tab[PHONET_NPROTO] __read_mostly;
+static struct phonet_protocol __rcu *proto_tab[PHONET_NPROTO] __read_mostly;
 
 static struct phonet_protocol *phonet_proto_get(int protocol)
 {
diff --git a/net/phonet/pn_dev.c b/net/phonet/pn_dev.c
index 9b4ced6..d15b97e 100644
--- a/net/phonet/pn_dev.c
+++ b/net/phonet/pn_dev.c
@@ -36,7 +36,7 @@
 
 struct phonet_routes {
 	struct mutex		lock;
-	struct net_device	*table[64];
+	struct net_device __rcu	*table[64];
 };
 
 struct phonet_net {
diff --git a/net/socket.c b/net/socket.c
index 5e8d0af..18b3427 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -155,7 +155,7 @@ static const struct file_operations socket_file_ops = {
  */
 
 static DEFINE_SPINLOCK(net_family_lock);
-static const struct net_proto_family *net_families[NPROTO] __read_mostly;
+static const struct net_proto_family __rcu *net_families[NPROTO] __read_mostly;
 
 /*
  *	Statistics counters of the socket lists
-- 
1.7.0.6

