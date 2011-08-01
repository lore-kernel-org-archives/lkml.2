Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753324Ab1HAQTA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Aug 2011 12:19:00 -0400
Received: from mail.vyatta.com ([76.74.103.46]:41603 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753291Ab1HAQSw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Aug 2011 12:18:52 -0400
Date: Mon, 1 Aug 2011 09:19:00 -0700
From: Stephen Hemminger <shemminger@vyatta.com>
To: Eric Dumazet <eric.dumazet@gmail.com>, paulmck@linux.vnet.ibm.com
Cc: David Miller <davem@davemloft.net>, mchan@broadcom.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH] rcu: convert uses of rcu_assign_pointer(x, NULL) to
 RCU_INIT_POINTER
Message-ID: <20110801091900.1027396f@nehalam.ftrdhcpuser.net>
In-Reply-To: <1312188453.2719.1.camel@edumazet-laptop>
References: <20110729003843.GA2373@linux.vnet.ibm.com>
	<20110729105058.2cb9fa86@nehalam.ftrdhcpuser.net>
	<1312028225.2873.104.camel@edumazet-laptop>
	<20110730.201609.2157787571393748046.davem@davemloft.net>
	<20110801052342.GD2307@linux.vnet.ibm.com>
	<1312188453.2719.1.camel@edumazet-laptop>
Organization: Vyatta
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.4; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When assigning a NULL value to an RCU protected pointer, no barrier
is needed. The rcu_assign_pointer, used to handle that but will soon
change to not handle the special case.

Convert all rcu_assign_pointer of NULL value.

//smpl
@@ expression P; @@

- rcu_assign_pointer(P, NULL)
+ RCU_INIT_POINTER(P, NULL)

// </smpl>


Signed-off-by: Stephen Hemminger <shemminger@vyatta.com>

---
Patch against net-next

--- a/net/802/garp.c	2011-08-01 08:56:30.356752933 -0700
+++ b/net/802/garp.c	2011-08-01 08:57:55.968753003 -0700
@@ -553,7 +553,7 @@ static void garp_release_port(struct net
 		if (rtnl_dereference(port->applicants[i]))
 			return;
 	}
-	rcu_assign_pointer(dev->garp_port, NULL);
+	RCU_INIT_POINTER(dev->garp_port, NULL);
 	kfree_rcu(port, rcu);
 }
 
@@ -605,7 +605,7 @@ void garp_uninit_applicant(struct net_de
 
 	ASSERT_RTNL();
 
-	rcu_assign_pointer(port->applicants[appl->type], NULL);
+	RCU_INIT_POINTER(port->applicants[appl->type], NULL);
 
 	/* Delete timer and generate a final TRANSMIT_PDU event to flush out
 	 * all pending messages before the applicant is gone. */
--- a/net/802/stp.c	2011-08-01 08:56:30.416752933 -0700
+++ b/net/802/stp.c	2011-08-01 08:57:55.972752996 -0700
@@ -88,9 +88,9 @@ void stp_proto_unregister(const struct s
 {
 	mutex_lock(&stp_proto_mutex);
 	if (is_zero_ether_addr(proto->group_address))
-		rcu_assign_pointer(stp_proto, NULL);
+		RCU_INIT_POINTER(stp_proto, NULL);
 	else
-		rcu_assign_pointer(garp_protos[proto->group_address[5] -
+		RCU_INIT_POINTER(garp_protos[proto->group_address[5] -
 					       GARP_ADDR_MIN], NULL);
 	synchronize_rcu();
 
--- a/net/8021q/vlan.c	2011-08-01 08:56:30.444752934 -0700
+++ b/net/8021q/vlan.c	2011-08-01 08:57:55.972752996 -0700
@@ -133,7 +133,7 @@ void unregister_vlan_dev(struct net_devi
 	if (grp->nr_vlans == 0) {
 		vlan_gvrp_uninit_applicant(real_dev);
 
-		rcu_assign_pointer(real_dev->vlgrp, NULL);
+		RCU_INIT_POINTER(real_dev->vlgrp, NULL);
 
 		/* Free the group, after all cpu's are done. */
 		call_rcu(&grp->rcu, vlan_rcu_free);
--- a/net/bridge/netfilter/ebtable_broute.c	2011-08-01 08:56:30.484752933 -0700
+++ b/net/bridge/netfilter/ebtable_broute.c	2011-08-01 08:57:55.976752984 -0700
@@ -87,14 +87,14 @@ static int __init ebtable_broute_init(vo
 	if (ret < 0)
 		return ret;
 	/* see br_input.c */
-	rcu_assign_pointer(br_should_route_hook,
+	RCU_INIT_POINTER(br_should_route_hook,
 			   (br_should_route_hook_t *)ebt_broute);
 	return 0;
 }
 
 static void __exit ebtable_broute_fini(void)
 {
-	rcu_assign_pointer(br_should_route_hook, NULL);
+	RCU_INIT_POINTER(br_should_route_hook, NULL);
 	synchronize_net();
 	unregister_pernet_subsys(&broute_net_ops);
 }
--- a/net/caif/cfmuxl.c	2011-08-01 08:56:30.520752933 -0700
+++ b/net/caif/cfmuxl.c	2011-08-01 08:57:55.980752974 -0700
@@ -108,7 +108,7 @@ struct cflayer *cfmuxl_remove_dnlayer(st
 	int idx = phyid % DN_CACHE_SIZE;
 
 	spin_lock_bh(&muxl->transmit_lock);
-	rcu_assign_pointer(muxl->dn_cache[idx], NULL);
+	RCU_INIT_POINTER(muxl->dn_cache[idx], NULL);
 	dn = get_from_id(&muxl->frml_list, phyid);
 	if (dn == NULL)
 		goto out;
@@ -164,7 +164,7 @@ struct cflayer *cfmuxl_remove_uplayer(st
 	if (up == NULL)
 		goto out;
 
-	rcu_assign_pointer(muxl->up_cache[idx], NULL);
+	RCU_INIT_POINTER(muxl->up_cache[idx], NULL);
 	list_del_rcu(&up->node);
 out:
 	spin_unlock_bh(&muxl->receive_lock);
@@ -261,7 +261,7 @@ static void cfmuxl_ctrlcmd(struct cflaye
 
 				idx = layer->id % UP_CACHE_SIZE;
 				spin_lock_bh(&muxl->receive_lock);
-				rcu_assign_pointer(muxl->up_cache[idx], NULL);
+				RCU_INIT_POINTER(muxl->up_cache[idx], NULL);
 				list_del_rcu(&layer->node);
 				spin_unlock_bh(&muxl->receive_lock);
 			}
--- a/net/can/af_can.c	2011-08-01 08:56:30.600752932 -0700
+++ b/net/can/af_can.c	2011-08-01 08:57:55.984752965 -0700
@@ -719,7 +719,7 @@ int can_proto_register(const struct can_
 		       proto);
 		err = -EBUSY;
 	} else
-		rcu_assign_pointer(proto_tab[proto], cp);
+		RCU_INIT_POINTER(proto_tab[proto], cp);
 
 	mutex_unlock(&proto_tab_lock);
 
@@ -740,7 +740,7 @@ void can_proto_unregister(const struct c
 
 	mutex_lock(&proto_tab_lock);
 	BUG_ON(proto_tab[proto] != cp);
-	rcu_assign_pointer(proto_tab[proto], NULL);
+	RCU_INIT_POINTER(proto_tab[proto], NULL);
 	mutex_unlock(&proto_tab_lock);
 
 	synchronize_rcu();
--- a/net/core/dev.c	2011-08-01 08:56:30.632752934 -0700
+++ b/net/core/dev.c	2011-08-01 08:57:56.008752971 -0700
@@ -3094,8 +3094,8 @@ void netdev_rx_handler_unregister(struct
 {
 
 	ASSERT_RTNL();
-	rcu_assign_pointer(dev->rx_handler, NULL);
-	rcu_assign_pointer(dev->rx_handler_data, NULL);
+	RCU_INIT_POINTER(dev->rx_handler, NULL);
+	RCU_INIT_POINTER(dev->rx_handler_data, NULL);
 }
 EXPORT_SYMBOL_GPL(netdev_rx_handler_unregister);
 
--- a/net/core/fib_rules.c	2011-08-01 08:56:30.688752933 -0700
+++ b/net/core/fib_rules.c	2011-08-01 08:57:56.008752971 -0700
@@ -487,7 +487,7 @@ static int fib_nl_delrule(struct sk_buff
 		if (ops->nr_goto_rules > 0) {
 			list_for_each_entry(tmp, &ops->rules_list, list) {
 				if (rtnl_dereference(tmp->ctarget) == rule) {
-					rcu_assign_pointer(tmp->ctarget, NULL);
+					RCU_INIT_POINTER(tmp->ctarget, NULL);
 					ops->unresolved_rules++;
 				}
 			}
--- a/net/core/filter.c	2011-08-01 08:56:30.724752934 -0700
+++ b/net/core/filter.c	2011-08-01 08:57:56.012752968 -0700
@@ -645,7 +645,7 @@ int sk_detach_filter(struct sock *sk)
 	filter = rcu_dereference_protected(sk->sk_filter,
 					   sock_owned_by_user(sk));
 	if (filter) {
-		rcu_assign_pointer(sk->sk_filter, NULL);
+		RCU_INIT_POINTER(sk->sk_filter, NULL);
 		sk_filter_uncharge(sk, filter);
 		ret = 0;
 	}
--- a/net/core/net-sysfs.c	2011-08-01 08:56:30.760752934 -0700
+++ b/net/core/net-sysfs.c	2011-08-01 08:57:56.016752967 -0700
@@ -987,10 +987,10 @@ static ssize_t store_xps_map(struct netd
 	}
 
 	if (nonempty)
-		rcu_assign_pointer(dev->xps_maps, new_dev_maps);
+		RCU_INIT_POINTER(dev->xps_maps, new_dev_maps);
 	else {
 		kfree(new_dev_maps);
-		rcu_assign_pointer(dev->xps_maps, NULL);
+		RCU_INIT_POINTER(dev->xps_maps, NULL);
 	}
 
 	if (dev_maps)
--- a/net/core/netpoll.c	2011-08-01 08:56:30.800752932 -0700
+++ b/net/core/netpoll.c	2011-08-01 08:57:56.016752967 -0700
@@ -760,7 +760,7 @@ int __netpoll_setup(struct netpoll *np)
 	}
 
 	/* last thing to do is link it to the net device structure */
-	rcu_assign_pointer(ndev->npinfo, npinfo);
+	RCU_INIT_POINTER(ndev->npinfo, npinfo);
 
 	return 0;
 
@@ -901,7 +901,7 @@ void __netpoll_cleanup(struct netpoll *n
 		if (ops->ndo_netpoll_cleanup)
 			ops->ndo_netpoll_cleanup(np->dev);
 
-		rcu_assign_pointer(np->dev->npinfo, NULL);
+		RCU_INIT_POINTER(np->dev->npinfo, NULL);
 
 		/* avoid racing with NAPI reading npinfo */
 		synchronize_rcu_bh();
--- a/net/core/sock.c	2011-08-01 08:56:30.840752934 -0700
+++ b/net/core/sock.c	2011-08-01 08:57:56.028752963 -0700
@@ -387,7 +387,7 @@ struct dst_entry *__sk_dst_check(struct
 
 	if (dst && dst->obsolete && dst->ops->check(dst, cookie) == NULL) {
 		sk_tx_queue_clear(sk);
-		rcu_assign_pointer(sk->sk_dst_cache, NULL);
+		RCU_INIT_POINTER(sk->sk_dst_cache, NULL);
 		dst_release(dst);
 		return NULL;
 	}
@@ -1158,7 +1158,7 @@ static void __sk_free(struct sock *sk)
 				       atomic_read(&sk->sk_wmem_alloc) == 0);
 	if (filter) {
 		sk_filter_uncharge(sk, filter);
-		rcu_assign_pointer(sk->sk_filter, NULL);
+		RCU_INIT_POINTER(sk->sk_filter, NULL);
 	}
 
 	sock_disable_timestamp(sk, SOCK_TIMESTAMP);
--- a/net/decnet/dn_dev.c	2011-08-01 08:56:30.892752934 -0700
+++ b/net/decnet/dn_dev.c	2011-08-01 08:57:56.032752964 -0700
@@ -388,7 +388,7 @@ static int dn_dev_insert_ifa(struct dn_d
 	}
 
 	ifa->ifa_next = dn_db->ifa_list;
-	rcu_assign_pointer(dn_db->ifa_list, ifa);
+	RCU_INIT_POINTER(dn_db->ifa_list, ifa);
 
 	dn_ifaddr_notify(RTM_NEWADDR, ifa);
 	blocking_notifier_call_chain(&dnaddr_chain, NETDEV_UP, ifa);
@@ -1093,7 +1093,7 @@ static struct dn_dev *dn_dev_create(stru
 
 	memcpy(&dn_db->parms, p, sizeof(struct dn_dev_parms));
 
-	rcu_assign_pointer(dev->dn_ptr, dn_db);
+	RCU_INIT_POINTER(dev->dn_ptr, dn_db);
 	dn_db->dev = dev;
 	init_timer(&dn_db->timer);
 
@@ -1101,7 +1101,7 @@ static struct dn_dev *dn_dev_create(stru
 
 	dn_db->neigh_parms = neigh_parms_alloc(dev, &dn_neigh_table);
 	if (!dn_db->neigh_parms) {
-		rcu_assign_pointer(dev->dn_ptr, NULL);
+		RCU_INIT_POINTER(dev->dn_ptr, NULL);
 		kfree(dn_db);
 		return NULL;
 	}
--- a/net/ipv4/devinet.c	2011-08-01 08:56:30.928752934 -0700
+++ b/net/ipv4/devinet.c	2011-08-01 08:57:56.044752967 -0700
@@ -258,7 +258,7 @@ static struct in_device *inetdev_init(st
 		ip_mc_up(in_dev);
 
 	/* we can receive as soon as ip_ptr is set -- do this last */
-	rcu_assign_pointer(dev->ip_ptr, in_dev);
+	RCU_INIT_POINTER(dev->ip_ptr, in_dev);
 out:
 	return in_dev;
 out_kfree:
@@ -291,7 +291,7 @@ static void inetdev_destroy(struct in_de
 		inet_free_ifa(ifa);
 	}
 
-	rcu_assign_pointer(dev->ip_ptr, NULL);
+	RCU_INIT_POINTER(dev->ip_ptr, NULL);
 
 	devinet_sysctl_unregister(in_dev);
 	neigh_parms_release(&arp_tbl, in_dev->arp_parms);
@@ -1175,7 +1175,7 @@ static int inetdev_event(struct notifier
 	switch (event) {
 	case NETDEV_REGISTER:
 		printk(KERN_DEBUG "inetdev_event: bug\n");
-		rcu_assign_pointer(dev->ip_ptr, NULL);
+		RCU_INIT_POINTER(dev->ip_ptr, NULL);
 		break;
 	case NETDEV_UP:
 		if (!inetdev_valid_mtu(dev->mtu))
--- a/net/ipv4/fib_trie.c	2011-08-01 08:56:30.988752933 -0700
+++ b/net/ipv4/fib_trie.c	2011-08-01 08:57:56.048752966 -0700
@@ -204,7 +204,7 @@ static inline struct tnode *node_parent_
 	return (struct tnode *)(parent & ~NODE_TYPE_MASK);
 }
 
-/* Same as rcu_assign_pointer
+/* Same as RCU_INIT_POINTER
  * but that macro() assumes that value is a pointer.
  */
 static inline void node_set_parent(struct rt_trie_node *node, struct tnode *ptr)
@@ -528,7 +528,7 @@ static void tnode_put_child_reorg(struct
 	if (n)
 		node_set_parent(n, tn);
 
-	rcu_assign_pointer(tn->child[i], n);
+	RCU_INIT_POINTER(tn->child[i], n);
 }
 
 #define MAX_WORK 10
@@ -1014,7 +1014,7 @@ static void trie_rebalance(struct trie *
 
 		tp = node_parent((struct rt_trie_node *) tn);
 		if (!tp)
-			rcu_assign_pointer(t->trie, (struct rt_trie_node *)tn);
+			RCU_INIT_POINTER(t->trie, (struct rt_trie_node *)tn);
 
 		tnode_free_flush();
 		if (!tp)
@@ -1026,7 +1026,7 @@ static void trie_rebalance(struct trie *
 	if (IS_TNODE(tn))
 		tn = (struct tnode *)resize(t, (struct tnode *)tn);
 
-	rcu_assign_pointer(t->trie, (struct rt_trie_node *)tn);
+	RCU_INIT_POINTER(t->trie, (struct rt_trie_node *)tn);
 	tnode_free_flush();
 }
 
@@ -1163,7 +1163,7 @@ static struct list_head *fib_insert_node
 			put_child(t, (struct tnode *)tp, cindex,
 				  (struct rt_trie_node *)tn);
 		} else {
-			rcu_assign_pointer(t->trie, (struct rt_trie_node *)tn);
+			RCU_INIT_POINTER(t->trie, (struct rt_trie_node *)tn);
 			tp = tn;
 		}
 	}
@@ -1621,7 +1621,7 @@ static void trie_leaf_remove(struct trie
 		put_child(t, (struct tnode *)tp, cindex, NULL);
 		trie_rebalance(t, tp);
 	} else
-		rcu_assign_pointer(t->trie, NULL);
+		RCU_INIT_POINTER(t->trie, NULL);
 
 	free_leaf(l);
 }
--- a/net/ipv4/gre.c	2011-08-01 08:56:31.020752934 -0700
+++ b/net/ipv4/gre.c	2011-08-01 08:57:56.048752966 -0700
@@ -34,7 +34,7 @@ int gre_add_protocol(const struct gre_pr
 	if (gre_proto[version])
 		goto err_out_unlock;
 
-	rcu_assign_pointer(gre_proto[version], proto);
+	RCU_INIT_POINTER(gre_proto[version], proto);
 	spin_unlock(&gre_proto_lock);
 	return 0;
 
@@ -54,7 +54,7 @@ int gre_del_protocol(const struct gre_pr
 	if (rcu_dereference_protected(gre_proto[version],
 			lockdep_is_held(&gre_proto_lock)) != proto)
 		goto err_out_unlock;
-	rcu_assign_pointer(gre_proto[version], NULL);
+	RCU_INIT_POINTER(gre_proto[version], NULL);
 	spin_unlock(&gre_proto_lock);
 	synchronize_rcu();
 	return 0;
--- a/net/ipv4/igmp.c	2011-08-01 08:56:31.056752933 -0700
+++ b/net/ipv4/igmp.c	2011-08-01 08:57:56.056752964 -0700
@@ -1242,7 +1242,7 @@ void ip_mc_inc_group(struct in_device *i
 
 	im->next_rcu = in_dev->mc_list;
 	in_dev->mc_count++;
-	rcu_assign_pointer(in_dev->mc_list, im);
+	RCU_INIT_POINTER(in_dev->mc_list, im);
 
 #ifdef CONFIG_IP_MULTICAST
 	igmpv3_del_delrec(in_dev, im->multiaddr);
@@ -1813,7 +1813,7 @@ int ip_mc_join_group(struct sock *sk , s
 	iml->next_rcu = inet->mc_list;
 	iml->sflist = NULL;
 	iml->sfmode = MCAST_EXCLUDE;
-	rcu_assign_pointer(inet->mc_list, iml);
+	RCU_INIT_POINTER(inet->mc_list, iml);
 	ip_mc_inc_group(in_dev, addr);
 	err = 0;
 done:
@@ -1835,7 +1835,7 @@ static int ip_mc_leave_src(struct sock *
 	}
 	err = ip_mc_del_src(in_dev, &iml->multi.imr_multiaddr.s_addr,
 			iml->sfmode, psf->sl_count, psf->sl_addr, 0);
-	rcu_assign_pointer(iml->sflist, NULL);
+	RCU_INIT_POINTER(iml->sflist, NULL);
 	/* decrease mem now to avoid the memleak warning */
 	atomic_sub(IP_SFLSIZE(psf->sl_max), &sk->sk_omem_alloc);
 	kfree_rcu(psf, rcu);
@@ -2000,7 +2000,7 @@ int ip_mc_source(int add, int omode, str
 			atomic_sub(IP_SFLSIZE(psl->sl_max), &sk->sk_omem_alloc);
 			kfree_rcu(psl, rcu);
 		}
-		rcu_assign_pointer(pmc->sflist, newpsl);
+		RCU_INIT_POINTER(pmc->sflist, newpsl);
 		psl = newpsl;
 	}
 	rv = 1;	/* > 0 for insert logic below if sl_count is 0 */
@@ -2103,7 +2103,7 @@ int ip_mc_msfilter(struct sock *sk, stru
 	} else
 		(void) ip_mc_del_src(in_dev, &msf->imsf_multiaddr, pmc->sfmode,
 			0, NULL, 0);
-	rcu_assign_pointer(pmc->sflist, newpsl);
+	RCU_INIT_POINTER(pmc->sflist, newpsl);
 	pmc->sfmode = msf->imsf_fmode;
 	err = 0;
 done:
--- a/net/ipv4/ipip.c	2011-08-01 08:56:31.096752932 -0700
+++ b/net/ipv4/ipip.c	2011-08-01 08:57:56.060752965 -0700
@@ -231,7 +231,7 @@ static void ipip_tunnel_unlink(struct ip
 	     (iter = rtnl_dereference(*tp)) != NULL;
 	     tp = &iter->next) {
 		if (t == iter) {
-			rcu_assign_pointer(*tp, t->next);
+			RCU_INIT_POINTER(*tp, t->next);
 			break;
 		}
 	}
@@ -241,8 +241,8 @@ static void ipip_tunnel_link(struct ipip
 {
 	struct ip_tunnel __rcu **tp = ipip_bucket(ipn, t);
 
-	rcu_assign_pointer(t->next, rtnl_dereference(*tp));
-	rcu_assign_pointer(*tp, t);
+	RCU_INIT_POINTER(t->next, rtnl_dereference(*tp));
+	RCU_INIT_POINTER(*tp, t);
 }
 
 static struct ip_tunnel * ipip_tunnel_locate(struct net *net,
@@ -301,7 +301,7 @@ static void ipip_tunnel_uninit(struct ne
 	struct ipip_net *ipn = net_generic(net, ipip_net_id);
 
 	if (dev == ipn->fb_tunnel_dev)
-		rcu_assign_pointer(ipn->tunnels_wc[0], NULL);
+		RCU_INIT_POINTER(ipn->tunnels_wc[0], NULL);
 	else
 		ipip_tunnel_unlink(ipn, netdev_priv(dev));
 	dev_put(dev);
@@ -791,7 +791,7 @@ static int __net_init ipip_fb_tunnel_ini
 		return -ENOMEM;
 
 	dev_hold(dev);
-	rcu_assign_pointer(ipn->tunnels_wc[0], tunnel);
+	RCU_INIT_POINTER(ipn->tunnels_wc[0], tunnel);
 	return 0;
 }
 
--- a/net/ipv4/ipmr.c	2011-08-01 08:56:31.132752933 -0700
+++ b/net/ipv4/ipmr.c	2011-08-01 08:57:56.064752966 -0700
@@ -1176,7 +1176,7 @@ static void mrtsock_destruct(struct sock
 	ipmr_for_each_table(mrt, net) {
 		if (sk == rtnl_dereference(mrt->mroute_sk)) {
 			IPV4_DEVCONF_ALL(net, MC_FORWARDING)--;
-			rcu_assign_pointer(mrt->mroute_sk, NULL);
+			RCU_INIT_POINTER(mrt->mroute_sk, NULL);
 			mroute_clean_tables(mrt);
 		}
 	}
@@ -1224,7 +1224,7 @@ int ip_mroute_setsockopt(struct sock *sk
 
 		ret = ip_ra_control(sk, 1, mrtsock_destruct);
 		if (ret == 0) {
-			rcu_assign_pointer(mrt->mroute_sk, sk);
+			RCU_INIT_POINTER(mrt->mroute_sk, sk);
 			IPV4_DEVCONF_ALL(net, MC_FORWARDING)++;
 		}
 		rtnl_unlock();
--- a/net/ipv4/netfilter/nf_nat_amanda.c	2011-08-01 08:56:31.168752933 -0700
+++ b/net/ipv4/netfilter/nf_nat_amanda.c	2011-08-01 08:57:56.064752966 -0700
@@ -70,14 +70,14 @@ static unsigned int help(struct sk_buff
 
 static void __exit nf_nat_amanda_fini(void)
 {
-	rcu_assign_pointer(nf_nat_amanda_hook, NULL);
+	RCU_INIT_POINTER(nf_nat_amanda_hook, NULL);
 	synchronize_rcu();
 }
 
 static int __init nf_nat_amanda_init(void)
 {
 	BUG_ON(nf_nat_amanda_hook != NULL);
-	rcu_assign_pointer(nf_nat_amanda_hook, help);
+	RCU_INIT_POINTER(nf_nat_amanda_hook, help);
 	return 0;
 }
 
--- a/net/ipv4/netfilter/nf_nat_core.c	2011-08-01 08:56:31.204752934 -0700
+++ b/net/ipv4/netfilter/nf_nat_core.c	2011-08-01 08:57:56.072752966 -0700
@@ -514,7 +514,7 @@ int nf_nat_protocol_register(const struc
 		ret = -EBUSY;
 		goto out;
 	}
-	rcu_assign_pointer(nf_nat_protos[proto->protonum], proto);
+	RCU_INIT_POINTER(nf_nat_protos[proto->protonum], proto);
  out:
 	spin_unlock_bh(&nf_nat_lock);
 	return ret;
@@ -525,7 +525,7 @@ EXPORT_SYMBOL(nf_nat_protocol_register);
 void nf_nat_protocol_unregister(const struct nf_nat_protocol *proto)
 {
 	spin_lock_bh(&nf_nat_lock);
-	rcu_assign_pointer(nf_nat_protos[proto->protonum],
+	RCU_INIT_POINTER(nf_nat_protos[proto->protonum],
 			   &nf_nat_unknown_protocol);
 	spin_unlock_bh(&nf_nat_lock);
 	synchronize_rcu();
@@ -736,10 +736,10 @@ static int __init nf_nat_init(void)
 	/* Sew in builtin protocols. */
 	spin_lock_bh(&nf_nat_lock);
 	for (i = 0; i < MAX_IP_NAT_PROTO; i++)
-		rcu_assign_pointer(nf_nat_protos[i], &nf_nat_unknown_protocol);
-	rcu_assign_pointer(nf_nat_protos[IPPROTO_TCP], &nf_nat_protocol_tcp);
-	rcu_assign_pointer(nf_nat_protos[IPPROTO_UDP], &nf_nat_protocol_udp);
-	rcu_assign_pointer(nf_nat_protos[IPPROTO_ICMP], &nf_nat_protocol_icmp);
+		RCU_INIT_POINTER(nf_nat_protos[i], &nf_nat_unknown_protocol);
+	RCU_INIT_POINTER(nf_nat_protos[IPPROTO_TCP], &nf_nat_protocol_tcp);
+	RCU_INIT_POINTER(nf_nat_protos[IPPROTO_UDP], &nf_nat_protocol_udp);
+	RCU_INIT_POINTER(nf_nat_protos[IPPROTO_ICMP], &nf_nat_protocol_icmp);
 	spin_unlock_bh(&nf_nat_lock);
 
 	/* Initialize fake conntrack so that NAT will skip it */
@@ -748,12 +748,12 @@ static int __init nf_nat_init(void)
 	l3proto = nf_ct_l3proto_find_get((u_int16_t)AF_INET);
 
 	BUG_ON(nf_nat_seq_adjust_hook != NULL);
-	rcu_assign_pointer(nf_nat_seq_adjust_hook, nf_nat_seq_adjust);
+	RCU_INIT_POINTER(nf_nat_seq_adjust_hook, nf_nat_seq_adjust);
 	BUG_ON(nfnetlink_parse_nat_setup_hook != NULL);
-	rcu_assign_pointer(nfnetlink_parse_nat_setup_hook,
+	RCU_INIT_POINTER(nfnetlink_parse_nat_setup_hook,
 			   nfnetlink_parse_nat_setup);
 	BUG_ON(nf_ct_nat_offset != NULL);
-	rcu_assign_pointer(nf_ct_nat_offset, nf_nat_get_offset);
+	RCU_INIT_POINTER(nf_ct_nat_offset, nf_nat_get_offset);
 	return 0;
 
  cleanup_extend:
@@ -766,9 +766,9 @@ static void __exit nf_nat_cleanup(void)
 	unregister_pernet_subsys(&nf_nat_net_ops);
 	nf_ct_l3proto_put(l3proto);
 	nf_ct_extend_unregister(&nat_extend);
-	rcu_assign_pointer(nf_nat_seq_adjust_hook, NULL);
-	rcu_assign_pointer(nfnetlink_parse_nat_setup_hook, NULL);
-	rcu_assign_pointer(nf_ct_nat_offset, NULL);
+	RCU_INIT_POINTER(nf_nat_seq_adjust_hook, NULL);
+	RCU_INIT_POINTER(nfnetlink_parse_nat_setup_hook, NULL);
+	RCU_INIT_POINTER(nf_ct_nat_offset, NULL);
 	synchronize_net();
 }
 
--- a/net/ipv4/netfilter/nf_nat_ftp.c	2011-08-01 08:56:31.284752932 -0700
+++ b/net/ipv4/netfilter/nf_nat_ftp.c	2011-08-01 08:57:56.076752966 -0700
@@ -113,14 +113,14 @@ out:
 
 static void __exit nf_nat_ftp_fini(void)
 {
-	rcu_assign_pointer(nf_nat_ftp_hook, NULL);
+	RCU_INIT_POINTER(nf_nat_ftp_hook, NULL);
 	synchronize_rcu();
 }
 
 static int __init nf_nat_ftp_init(void)
 {
 	BUG_ON(nf_nat_ftp_hook != NULL);
-	rcu_assign_pointer(nf_nat_ftp_hook, nf_nat_ftp);
+	RCU_INIT_POINTER(nf_nat_ftp_hook, nf_nat_ftp);
 	return 0;
 }
 
--- a/net/ipv4/netfilter/nf_nat_h323.c	2011-08-01 08:56:31.316752933 -0700
+++ b/net/ipv4/netfilter/nf_nat_h323.c	2011-08-01 08:57:56.096752967 -0700
@@ -581,30 +581,30 @@ static int __init init(void)
 	BUG_ON(nat_callforwarding_hook != NULL);
 	BUG_ON(nat_q931_hook != NULL);
 
-	rcu_assign_pointer(set_h245_addr_hook, set_h245_addr);
-	rcu_assign_pointer(set_h225_addr_hook, set_h225_addr);
-	rcu_assign_pointer(set_sig_addr_hook, set_sig_addr);
-	rcu_assign_pointer(set_ras_addr_hook, set_ras_addr);
-	rcu_assign_pointer(nat_rtp_rtcp_hook, nat_rtp_rtcp);
-	rcu_assign_pointer(nat_t120_hook, nat_t120);
-	rcu_assign_pointer(nat_h245_hook, nat_h245);
-	rcu_assign_pointer(nat_callforwarding_hook, nat_callforwarding);
-	rcu_assign_pointer(nat_q931_hook, nat_q931);
+	RCU_INIT_POINTER(set_h245_addr_hook, set_h245_addr);
+	RCU_INIT_POINTER(set_h225_addr_hook, set_h225_addr);
+	RCU_INIT_POINTER(set_sig_addr_hook, set_sig_addr);
+	RCU_INIT_POINTER(set_ras_addr_hook, set_ras_addr);
+	RCU_INIT_POINTER(nat_rtp_rtcp_hook, nat_rtp_rtcp);
+	RCU_INIT_POINTER(nat_t120_hook, nat_t120);
+	RCU_INIT_POINTER(nat_h245_hook, nat_h245);
+	RCU_INIT_POINTER(nat_callforwarding_hook, nat_callforwarding);
+	RCU_INIT_POINTER(nat_q931_hook, nat_q931);
 	return 0;
 }
 
 /****************************************************************************/
 static void __exit fini(void)
 {
-	rcu_assign_pointer(set_h245_addr_hook, NULL);
-	rcu_assign_pointer(set_h225_addr_hook, NULL);
-	rcu_assign_pointer(set_sig_addr_hook, NULL);
-	rcu_assign_pointer(set_ras_addr_hook, NULL);
-	rcu_assign_pointer(nat_rtp_rtcp_hook, NULL);
-	rcu_assign_pointer(nat_t120_hook, NULL);
-	rcu_assign_pointer(nat_h245_hook, NULL);
-	rcu_assign_pointer(nat_callforwarding_hook, NULL);
-	rcu_assign_pointer(nat_q931_hook, NULL);
+	RCU_INIT_POINTER(set_h245_addr_hook, NULL);
+	RCU_INIT_POINTER(set_h225_addr_hook, NULL);
+	RCU_INIT_POINTER(set_sig_addr_hook, NULL);
+	RCU_INIT_POINTER(set_ras_addr_hook, NULL);
+	RCU_INIT_POINTER(nat_rtp_rtcp_hook, NULL);
+	RCU_INIT_POINTER(nat_t120_hook, NULL);
+	RCU_INIT_POINTER(nat_h245_hook, NULL);
+	RCU_INIT_POINTER(nat_callforwarding_hook, NULL);
+	RCU_INIT_POINTER(nat_q931_hook, NULL);
 	synchronize_rcu();
 }
 
--- a/net/ipv4/netfilter/nf_nat_irc.c	2011-08-01 08:56:31.528752932 -0700
+++ b/net/ipv4/netfilter/nf_nat_irc.c	2011-08-01 08:57:56.096752967 -0700
@@ -75,14 +75,14 @@ static unsigned int help(struct sk_buff
 
 static void __exit nf_nat_irc_fini(void)
 {
-	rcu_assign_pointer(nf_nat_irc_hook, NULL);
+	RCU_INIT_POINTER(nf_nat_irc_hook, NULL);
 	synchronize_rcu();
 }
 
 static int __init nf_nat_irc_init(void)
 {
 	BUG_ON(nf_nat_irc_hook != NULL);
-	rcu_assign_pointer(nf_nat_irc_hook, help);
+	RCU_INIT_POINTER(nf_nat_irc_hook, help);
 	return 0;
 }
 
--- a/net/ipv4/netfilter/nf_nat_pptp.c	2011-08-01 08:56:31.564752934 -0700
+++ b/net/ipv4/netfilter/nf_nat_pptp.c	2011-08-01 08:57:56.104752965 -0700
@@ -282,25 +282,25 @@ static int __init nf_nat_helper_pptp_ini
 	nf_nat_need_gre();
 
 	BUG_ON(nf_nat_pptp_hook_outbound != NULL);
-	rcu_assign_pointer(nf_nat_pptp_hook_outbound, pptp_outbound_pkt);
+	RCU_INIT_POINTER(nf_nat_pptp_hook_outbound, pptp_outbound_pkt);
 
 	BUG_ON(nf_nat_pptp_hook_inbound != NULL);
-	rcu_assign_pointer(nf_nat_pptp_hook_inbound, pptp_inbound_pkt);
+	RCU_INIT_POINTER(nf_nat_pptp_hook_inbound, pptp_inbound_pkt);
 
 	BUG_ON(nf_nat_pptp_hook_exp_gre != NULL);
-	rcu_assign_pointer(nf_nat_pptp_hook_exp_gre, pptp_exp_gre);
+	RCU_INIT_POINTER(nf_nat_pptp_hook_exp_gre, pptp_exp_gre);
 
 	BUG_ON(nf_nat_pptp_hook_expectfn != NULL);
-	rcu_assign_pointer(nf_nat_pptp_hook_expectfn, pptp_nat_expected);
+	RCU_INIT_POINTER(nf_nat_pptp_hook_expectfn, pptp_nat_expected);
 	return 0;
 }
 
 static void __exit nf_nat_helper_pptp_fini(void)
 {
-	rcu_assign_pointer(nf_nat_pptp_hook_expectfn, NULL);
-	rcu_assign_pointer(nf_nat_pptp_hook_exp_gre, NULL);
-	rcu_assign_pointer(nf_nat_pptp_hook_inbound, NULL);
-	rcu_assign_pointer(nf_nat_pptp_hook_outbound, NULL);
+	RCU_INIT_POINTER(nf_nat_pptp_hook_expectfn, NULL);
+	RCU_INIT_POINTER(nf_nat_pptp_hook_exp_gre, NULL);
+	RCU_INIT_POINTER(nf_nat_pptp_hook_inbound, NULL);
+	RCU_INIT_POINTER(nf_nat_pptp_hook_outbound, NULL);
 	synchronize_rcu();
 }
 
--- a/net/ipv4/netfilter/nf_nat_sip.c	2011-08-01 08:56:31.664752933 -0700
+++ b/net/ipv4/netfilter/nf_nat_sip.c	2011-08-01 08:57:56.124752965 -0700
@@ -528,13 +528,13 @@ err1:
 
 static void __exit nf_nat_sip_fini(void)
 {
-	rcu_assign_pointer(nf_nat_sip_hook, NULL);
-	rcu_assign_pointer(nf_nat_sip_seq_adjust_hook, NULL);
-	rcu_assign_pointer(nf_nat_sip_expect_hook, NULL);
-	rcu_assign_pointer(nf_nat_sdp_addr_hook, NULL);
-	rcu_assign_pointer(nf_nat_sdp_port_hook, NULL);
-	rcu_assign_pointer(nf_nat_sdp_session_hook, NULL);
-	rcu_assign_pointer(nf_nat_sdp_media_hook, NULL);
+	RCU_INIT_POINTER(nf_nat_sip_hook, NULL);
+	RCU_INIT_POINTER(nf_nat_sip_seq_adjust_hook, NULL);
+	RCU_INIT_POINTER(nf_nat_sip_expect_hook, NULL);
+	RCU_INIT_POINTER(nf_nat_sdp_addr_hook, NULL);
+	RCU_INIT_POINTER(nf_nat_sdp_port_hook, NULL);
+	RCU_INIT_POINTER(nf_nat_sdp_session_hook, NULL);
+	RCU_INIT_POINTER(nf_nat_sdp_media_hook, NULL);
 	synchronize_rcu();
 }
 
@@ -547,13 +547,13 @@ static int __init nf_nat_sip_init(void)
 	BUG_ON(nf_nat_sdp_port_hook != NULL);
 	BUG_ON(nf_nat_sdp_session_hook != NULL);
 	BUG_ON(nf_nat_sdp_media_hook != NULL);
-	rcu_assign_pointer(nf_nat_sip_hook, ip_nat_sip);
-	rcu_assign_pointer(nf_nat_sip_seq_adjust_hook, ip_nat_sip_seq_adjust);
-	rcu_assign_pointer(nf_nat_sip_expect_hook, ip_nat_sip_expect);
-	rcu_assign_pointer(nf_nat_sdp_addr_hook, ip_nat_sdp_addr);
-	rcu_assign_pointer(nf_nat_sdp_port_hook, ip_nat_sdp_port);
-	rcu_assign_pointer(nf_nat_sdp_session_hook, ip_nat_sdp_session);
-	rcu_assign_pointer(nf_nat_sdp_media_hook, ip_nat_sdp_media);
+	RCU_INIT_POINTER(nf_nat_sip_hook, ip_nat_sip);
+	RCU_INIT_POINTER(nf_nat_sip_seq_adjust_hook, ip_nat_sip_seq_adjust);
+	RCU_INIT_POINTER(nf_nat_sip_expect_hook, ip_nat_sip_expect);
+	RCU_INIT_POINTER(nf_nat_sdp_addr_hook, ip_nat_sdp_addr);
+	RCU_INIT_POINTER(nf_nat_sdp_port_hook, ip_nat_sdp_port);
+	RCU_INIT_POINTER(nf_nat_sdp_session_hook, ip_nat_sdp_session);
+	RCU_INIT_POINTER(nf_nat_sdp_media_hook, ip_nat_sdp_media);
 	return 0;
 }
 
--- a/net/ipv4/netfilter/nf_nat_snmp_basic.c	2011-08-01 08:56:31.832752932 -0700
+++ b/net/ipv4/netfilter/nf_nat_snmp_basic.c	2011-08-01 08:57:56.128752964 -0700
@@ -1310,7 +1310,7 @@ static int __init nf_nat_snmp_basic_init
 	int ret = 0;
 
 	BUG_ON(nf_nat_snmp_hook != NULL);
-	rcu_assign_pointer(nf_nat_snmp_hook, help);
+	RCU_INIT_POINTER(nf_nat_snmp_hook, help);
 
 	ret = nf_conntrack_helper_register(&snmp_trap_helper);
 	if (ret < 0) {
@@ -1322,7 +1322,7 @@ static int __init nf_nat_snmp_basic_init
 
 static void __exit nf_nat_snmp_basic_fini(void)
 {
-	rcu_assign_pointer(nf_nat_snmp_hook, NULL);
+	RCU_INIT_POINTER(nf_nat_snmp_hook, NULL);
 	nf_conntrack_helper_unregister(&snmp_trap_helper);
 }
 
--- a/net/ipv4/netfilter/nf_nat_standalone.c	2011-08-01 08:56:31.868752934 -0700
+++ b/net/ipv4/netfilter/nf_nat_standalone.c	2011-08-01 08:57:56.132752965 -0700
@@ -284,7 +284,7 @@ static int __init nf_nat_standalone_init
 
 #ifdef CONFIG_XFRM
 	BUG_ON(ip_nat_decode_session != NULL);
-	rcu_assign_pointer(ip_nat_decode_session, nat_decode_session);
+	RCU_INIT_POINTER(ip_nat_decode_session, nat_decode_session);
 #endif
 	ret = nf_nat_rule_init();
 	if (ret < 0) {
@@ -302,7 +302,7 @@ static int __init nf_nat_standalone_init
 	nf_nat_rule_cleanup();
  cleanup_decode_session:
 #ifdef CONFIG_XFRM
-	rcu_assign_pointer(ip_nat_decode_session, NULL);
+	RCU_INIT_POINTER(ip_nat_decode_session, NULL);
 	synchronize_net();
 #endif
 	return ret;
@@ -313,7 +313,7 @@ static void __exit nf_nat_standalone_fin
 	nf_unregister_hooks(nf_nat_ops, ARRAY_SIZE(nf_nat_ops));
 	nf_nat_rule_cleanup();
 #ifdef CONFIG_XFRM
-	rcu_assign_pointer(ip_nat_decode_session, NULL);
+	RCU_INIT_POINTER(ip_nat_decode_session, NULL);
 	synchronize_net();
 #endif
 	/* Conntrack caches are unregistered in nf_conntrack_cleanup */
--- a/net/ipv4/netfilter/nf_nat_tftp.c	2011-08-01 08:56:31.924752932 -0700
+++ b/net/ipv4/netfilter/nf_nat_tftp.c	2011-08-01 08:57:56.132752965 -0700
@@ -36,14 +36,14 @@ static unsigned int help(struct sk_buff
 
 static void __exit nf_nat_tftp_fini(void)
 {
-	rcu_assign_pointer(nf_nat_tftp_hook, NULL);
+	RCU_INIT_POINTER(nf_nat_tftp_hook, NULL);
 	synchronize_rcu();
 }
 
 static int __init nf_nat_tftp_init(void)
 {
 	BUG_ON(nf_nat_tftp_hook != NULL);
-	rcu_assign_pointer(nf_nat_tftp_hook, help);
+	RCU_INIT_POINTER(nf_nat_tftp_hook, help);
 	return 0;
 }
 
--- a/net/ipv6/addrconf.c	2011-08-01 08:56:31.960752934 -0700
+++ b/net/ipv6/addrconf.c	2011-08-01 08:57:56.144752965 -0700
@@ -428,7 +428,7 @@ static struct inet6_dev * ipv6_add_dev(s
 	ndev->tstamp = jiffies;
 	addrconf_sysctl_register(ndev);
 	/* protected by rtnl_lock */
-	rcu_assign_pointer(dev->ip6_ptr, ndev);
+	RCU_INIT_POINTER(dev->ip6_ptr, ndev);
 
 	/* Join all-node multicast group */
 	ipv6_dev_mc_inc(dev, &in6addr_linklocal_allnodes);
@@ -2706,7 +2706,7 @@ static int addrconf_ifdown(struct net_de
 		idev->dead = 1;
 
 		/* protected by rtnl_lock */
-		rcu_assign_pointer(dev->ip6_ptr, NULL);
+		RCU_INIT_POINTER(dev->ip6_ptr, NULL);
 
 		/* Step 1.5: remove snmp6 entry */
 		snmp6_unregister_dev(idev);
--- a/net/ipv6/ip6_tunnel.c	2011-08-01 08:56:31.996752934 -0700
+++ b/net/ipv6/ip6_tunnel.c	2011-08-01 08:57:56.152752965 -0700
@@ -218,8 +218,8 @@ ip6_tnl_link(struct ip6_tnl_net *ip6n, s
 {
 	struct ip6_tnl __rcu **tp = ip6_tnl_bucket(ip6n, &t->parms);
 
-	rcu_assign_pointer(t->next , rtnl_dereference(*tp));
-	rcu_assign_pointer(*tp, t);
+	RCU_INIT_POINTER(t->next , rtnl_dereference(*tp));
+	RCU_INIT_POINTER(*tp, t);
 }
 
 /**
@@ -237,7 +237,7 @@ ip6_tnl_unlink(struct ip6_tnl_net *ip6n,
 	     (iter = rtnl_dereference(*tp)) != NULL;
 	     tp = &iter->next) {
 		if (t == iter) {
-			rcu_assign_pointer(*tp, t->next);
+			RCU_INIT_POINTER(*tp, t->next);
 			break;
 		}
 	}
@@ -350,7 +350,7 @@ ip6_tnl_dev_uninit(struct net_device *de
 	struct ip6_tnl_net *ip6n = net_generic(net, ip6_tnl_net_id);
 
 	if (dev == ip6n->fb_tnl_dev)
-		rcu_assign_pointer(ip6n->tnls_wc[0], NULL);
+		RCU_INIT_POINTER(ip6n->tnls_wc[0], NULL);
 	else
 		ip6_tnl_unlink(ip6n, t);
 	ip6_tnl_dst_reset(t);
@@ -1439,7 +1439,7 @@ static int __net_init ip6_fb_tnl_dev_ini
 
 	t->parms.proto = IPPROTO_IPV6;
 	dev_hold(dev);
-	rcu_assign_pointer(ip6n->tnls_wc[0], t);
+	RCU_INIT_POINTER(ip6n->tnls_wc[0], t);
 	return 0;
 }
 
--- a/net/ipv6/raw.c	2011-08-01 08:56:32.032752933 -0700
+++ b/net/ipv6/raw.c	2011-08-01 08:57:56.152752965 -0700
@@ -130,14 +130,14 @@ static mh_filter_t __rcu *mh_filter __re
 
 int rawv6_mh_filter_register(mh_filter_t filter)
 {
-	rcu_assign_pointer(mh_filter, filter);
+	RCU_INIT_POINTER(mh_filter, filter);
 	return 0;
 }
 EXPORT_SYMBOL(rawv6_mh_filter_register);
 
 int rawv6_mh_filter_unregister(mh_filter_t filter)
 {
-	rcu_assign_pointer(mh_filter, NULL);
+	RCU_INIT_POINTER(mh_filter, NULL);
 	synchronize_rcu();
 	return 0;
 }
--- a/net/ipv6/sit.c	2011-08-01 08:56:32.064752933 -0700
+++ b/net/ipv6/sit.c	2011-08-01 08:57:56.156752966 -0700
@@ -182,7 +182,7 @@ static void ipip6_tunnel_unlink(struct s
 	     (iter = rtnl_dereference(*tp)) != NULL;
 	     tp = &iter->next) {
 		if (t == iter) {
-			rcu_assign_pointer(*tp, t->next);
+			RCU_INIT_POINTER(*tp, t->next);
 			break;
 		}
 	}
@@ -192,8 +192,8 @@ static void ipip6_tunnel_link(struct sit
 {
 	struct ip_tunnel __rcu **tp = ipip6_bucket(sitn, t);
 
-	rcu_assign_pointer(t->next, rtnl_dereference(*tp));
-	rcu_assign_pointer(*tp, t);
+	RCU_INIT_POINTER(t->next, rtnl_dereference(*tp));
+	RCU_INIT_POINTER(*tp, t);
 }
 
 static void ipip6_tunnel_clone_6rd(struct net_device *dev, struct sit_net *sitn)
@@ -391,7 +391,7 @@ ipip6_tunnel_add_prl(struct ip_tunnel *t
 	p->addr = a->addr;
 	p->flags = a->flags;
 	t->prl_count++;
-	rcu_assign_pointer(t->prl, p);
+	RCU_INIT_POINTER(t->prl, p);
 out:
 	return err;
 }
@@ -474,7 +474,7 @@ static void ipip6_tunnel_uninit(struct n
 	struct sit_net *sitn = net_generic(net, sit_net_id);
 
 	if (dev == sitn->fb_tunnel_dev) {
-		rcu_assign_pointer(sitn->tunnels_wc[0], NULL);
+		RCU_INIT_POINTER(sitn->tunnels_wc[0], NULL);
 	} else {
 		ipip6_tunnel_unlink(sitn, netdev_priv(dev));
 		ipip6_tunnel_del_prl(netdev_priv(dev), NULL);
@@ -1173,7 +1173,7 @@ static int __net_init ipip6_fb_tunnel_in
 	if (!dev->tstats)
 		return -ENOMEM;
 	dev_hold(dev);
-	rcu_assign_pointer(sitn->tunnels_wc[0], tunnel);
+	RCU_INIT_POINTER(sitn->tunnels_wc[0], tunnel);
 	return 0;
 }
 
--- a/net/mac80211/agg-rx.c	2011-08-01 08:56:32.104752933 -0700
+++ b/net/mac80211/agg-rx.c	2011-08-01 08:57:56.160752966 -0700
@@ -69,7 +69,7 @@ void ___ieee80211_stop_rx_ba_session(str
 	if (!tid_rx)
 		return;
 
-	rcu_assign_pointer(sta->ampdu_mlme.tid_rx[tid], NULL);
+	RCU_INIT_POINTER(sta->ampdu_mlme.tid_rx[tid], NULL);
 
 #ifdef CONFIG_MAC80211_HT_DEBUG
 	printk(KERN_DEBUG "Rx BA session stop requested for %pM tid %u\n",
@@ -340,7 +340,7 @@ void ieee80211_process_addba_request(str
 	status = WLAN_STATUS_SUCCESS;
 
 	/* activate it for RX */
-	rcu_assign_pointer(sta->ampdu_mlme.tid_rx[tid], tid_agg_rx);
+	RCU_INIT_POINTER(sta->ampdu_mlme.tid_rx[tid], tid_agg_rx);
 
 	if (timeout)
 		mod_timer(&tid_agg_rx->session_timer, TU_TO_EXP_TIME(timeout));
--- a/net/mac80211/cfg.c	2011-08-01 08:56:32.136752932 -0700
+++ b/net/mac80211/cfg.c	2011-08-01 08:57:56.168752964 -0700
@@ -62,7 +62,7 @@ static int ieee80211_change_iface(struct
 
 	if (type == NL80211_IFTYPE_AP_VLAN &&
 	    params && params->use_4addr == 0)
-		rcu_assign_pointer(sdata->u.vlan.sta, NULL);
+		RCU_INIT_POINTER(sdata->u.vlan.sta, NULL);
 	else if (type == NL80211_IFTYPE_STATION &&
 		 params && params->use_4addr >= 0)
 		sdata->u.mgd.use_4addr = params->use_4addr;
@@ -542,7 +542,7 @@ static int ieee80211_config_beacon(struc
 
 	sdata->vif.bss_conf.dtim_period = new->dtim_period;
 
-	rcu_assign_pointer(sdata->u.ap.beacon, new);
+	RCU_INIT_POINTER(sdata->u.ap.beacon, new);
 
 	synchronize_rcu();
 
@@ -594,7 +594,7 @@ static int ieee80211_del_beacon(struct w
 	if (!old)
 		return -ENOENT;
 
-	rcu_assign_pointer(sdata->u.ap.beacon, NULL);
+	RCU_INIT_POINTER(sdata->u.ap.beacon, NULL);
 	synchronize_rcu();
 	kfree(old);
 
@@ -857,7 +857,7 @@ static int ieee80211_change_station(stru
 				return -EBUSY;
 			}
 
-			rcu_assign_pointer(vlansdata->u.vlan.sta, sta);
+			RCU_INIT_POINTER(vlansdata->u.vlan.sta, sta);
 		}
 
 		sta->sdata = vlansdata;
--- a/net/mac80211/ibss.c	2011-08-01 08:56:32.196752932 -0700
+++ b/net/mac80211/ibss.c	2011-08-01 08:57:56.172752965 -0700
@@ -84,7 +84,7 @@ static void __ieee80211_sta_join_ibss(st
 	drv_reset_tsf(local);
 
 	skb = ifibss->skb;
-	rcu_assign_pointer(ifibss->presp, NULL);
+	RCU_INIT_POINTER(ifibss->presp, NULL);
 	synchronize_rcu();
 	skb->data = skb->head;
 	skb->len = 0;
@@ -184,7 +184,7 @@ static void __ieee80211_sta_join_ibss(st
 		*pos++ = 0; /* U-APSD no in use */
 	}
 
-	rcu_assign_pointer(ifibss->presp, skb);
+	RCU_INIT_POINTER(ifibss->presp, skb);
 
 	sdata->vif.bss_conf.beacon_int = beacon_int;
 	sdata->vif.bss_conf.basic_rates = basic_rates;
@@ -995,7 +995,7 @@ int ieee80211_ibss_leave(struct ieee8021
 	kfree(sdata->u.ibss.ie);
 	skb = rcu_dereference_protected(sdata->u.ibss.presp,
 					lockdep_is_held(&sdata->u.ibss.mtx));
-	rcu_assign_pointer(sdata->u.ibss.presp, NULL);
+	RCU_INIT_POINTER(sdata->u.ibss.presp, NULL);
 	sdata->vif.bss_conf.ibss_joined = false;
 	ieee80211_bss_info_change_notify(sdata, BSS_CHANGED_BEACON_ENABLED |
 						BSS_CHANGED_IBSS);
--- a/net/mac80211/iface.c	2011-08-01 08:56:32.248752935 -0700
+++ b/net/mac80211/iface.c	2011-08-01 08:57:56.176752966 -0700
@@ -456,7 +456,7 @@ static void ieee80211_do_stop(struct iee
 						 BSS_CHANGED_BEACON_ENABLED);
 
 		/* remove beacon */
-		rcu_assign_pointer(sdata->u.ap.beacon, NULL);
+		RCU_INIT_POINTER(sdata->u.ap.beacon, NULL);
 		synchronize_rcu();
 		kfree(old_beacon);
 
--- a/net/mac80211/sta_info.c	2011-08-01 08:56:32.288752933 -0700
+++ b/net/mac80211/sta_info.c	2011-08-01 08:57:56.180752966 -0700
@@ -72,7 +72,7 @@ static int sta_info_hash_del(struct ieee
 	if (!s)
 		return -ENOENT;
 	if (s == sta) {
-		rcu_assign_pointer(local->sta_hash[STA_HASH(sta->sta.addr)],
+		RCU_INIT_POINTER(local->sta_hash[STA_HASH(sta->sta.addr)],
 				   s->hnext);
 		return 0;
 	}
@@ -82,7 +82,7 @@ static int sta_info_hash_del(struct ieee
 		s = rcu_dereference_protected(s->hnext,
 					lockdep_is_held(&local->sta_lock));
 	if (rcu_access_pointer(s->hnext)) {
-		rcu_assign_pointer(s->hnext, sta->hnext);
+		RCU_INIT_POINTER(s->hnext, sta->hnext);
 		return 0;
 	}
 
@@ -184,7 +184,7 @@ static void sta_info_hash_add(struct iee
 			      struct sta_info *sta)
 {
 	sta->hnext = local->sta_hash[STA_HASH(sta->sta.addr)];
-	rcu_assign_pointer(local->sta_hash[STA_HASH(sta->sta.addr)], sta);
+	RCU_INIT_POINTER(local->sta_hash[STA_HASH(sta->sta.addr)], sta);
 }
 
 static void sta_unblock(struct work_struct *wk)
@@ -672,7 +672,7 @@ static int __must_check __sta_info_destr
 	local->sta_generation++;
 
 	if (sdata->vif.type == NL80211_IFTYPE_AP_VLAN)
-		rcu_assign_pointer(sdata->u.vlan.sta, NULL);
+		RCU_INIT_POINTER(sdata->u.vlan.sta, NULL);
 
 	if (sta->uploaded) {
 		if (sdata->vif.type == NL80211_IFTYPE_AP_VLAN)
--- a/net/netfilter/core.c	2011-08-01 08:56:32.324752933 -0700
+++ b/net/netfilter/core.c	2011-08-01 08:57:56.180752966 -0700
@@ -37,7 +37,7 @@ int nf_register_afinfo(const struct nf_a
 	err = mutex_lock_interruptible(&afinfo_mutex);
 	if (err < 0)
 		return err;
-	rcu_assign_pointer(nf_afinfo[afinfo->family], afinfo);
+	RCU_INIT_POINTER(nf_afinfo[afinfo->family], afinfo);
 	mutex_unlock(&afinfo_mutex);
 	return 0;
 }
@@ -46,7 +46,7 @@ EXPORT_SYMBOL_GPL(nf_register_afinfo);
 void nf_unregister_afinfo(const struct nf_afinfo *afinfo)
 {
 	mutex_lock(&afinfo_mutex);
-	rcu_assign_pointer(nf_afinfo[afinfo->family], NULL);
+	RCU_INIT_POINTER(nf_afinfo[afinfo->family], NULL);
 	mutex_unlock(&afinfo_mutex);
 	synchronize_rcu();
 }
--- a/net/netfilter/nf_conntrack_core.c	2011-08-01 08:56:32.356752934 -0700
+++ b/net/netfilter/nf_conntrack_core.c	2011-08-01 08:57:56.192752965 -0700
@@ -779,7 +779,7 @@ init_conntrack(struct net *net, struct n
 		if (exp->helper) {
 			help = nf_ct_helper_ext_add(ct, GFP_ATOMIC);
 			if (help)
-				rcu_assign_pointer(help->helper, exp->helper);
+				RCU_INIT_POINTER(help->helper, exp->helper);
 		}
 
 #ifdef CONFIG_NF_CONNTRACK_MARK
@@ -1317,7 +1317,7 @@ static void nf_conntrack_cleanup_net(str
 void nf_conntrack_cleanup(struct net *net)
 {
 	if (net_eq(net, &init_net))
-		rcu_assign_pointer(ip_ct_attach, NULL);
+		RCU_INIT_POINTER(ip_ct_attach, NULL);
 
 	/* This makes sure all current packets have passed through
 	   netfilter framework.  Roll on, two-stage module
@@ -1327,7 +1327,7 @@ void nf_conntrack_cleanup(struct net *ne
 	nf_conntrack_cleanup_net(net);
 
 	if (net_eq(net, &init_net)) {
-		rcu_assign_pointer(nf_ct_destroy, NULL);
+		RCU_INIT_POINTER(nf_ct_destroy, NULL);
 		nf_conntrack_cleanup_init_net();
 	}
 }
@@ -1576,11 +1576,11 @@ int nf_conntrack_init(struct net *net)
 
 	if (net_eq(net, &init_net)) {
 		/* For use by REJECT target */
-		rcu_assign_pointer(ip_ct_attach, nf_conntrack_attach);
-		rcu_assign_pointer(nf_ct_destroy, destroy_conntrack);
+		RCU_INIT_POINTER(ip_ct_attach, nf_conntrack_attach);
+		RCU_INIT_POINTER(nf_ct_destroy, destroy_conntrack);
 
 		/* Howto get NAT offsets */
-		rcu_assign_pointer(nf_ct_nat_offset, NULL);
+		RCU_INIT_POINTER(nf_ct_nat_offset, NULL);
 	}
 	return 0;
 
--- a/net/netfilter/nf_conntrack_ecache.c	2011-08-01 08:56:32.432752934 -0700
+++ b/net/netfilter/nf_conntrack_ecache.c	2011-08-01 08:57:56.196752966 -0700
@@ -94,7 +94,7 @@ int nf_conntrack_register_notifier(struc
 		ret = -EBUSY;
 		goto out_unlock;
 	}
-	rcu_assign_pointer(nf_conntrack_event_cb, new);
+	RCU_INIT_POINTER(nf_conntrack_event_cb, new);
 	mutex_unlock(&nf_ct_ecache_mutex);
 	return ret;
 
@@ -112,7 +112,7 @@ void nf_conntrack_unregister_notifier(st
 	notify = rcu_dereference_protected(nf_conntrack_event_cb,
 					   lockdep_is_held(&nf_ct_ecache_mutex));
 	BUG_ON(notify != new);
-	rcu_assign_pointer(nf_conntrack_event_cb, NULL);
+	RCU_INIT_POINTER(nf_conntrack_event_cb, NULL);
 	mutex_unlock(&nf_ct_ecache_mutex);
 }
 EXPORT_SYMBOL_GPL(nf_conntrack_unregister_notifier);
@@ -129,7 +129,7 @@ int nf_ct_expect_register_notifier(struc
 		ret = -EBUSY;
 		goto out_unlock;
 	}
-	rcu_assign_pointer(nf_expect_event_cb, new);
+	RCU_INIT_POINTER(nf_expect_event_cb, new);
 	mutex_unlock(&nf_ct_ecache_mutex);
 	return ret;
 
@@ -147,7 +147,7 @@ void nf_ct_expect_unregister_notifier(st
 	notify = rcu_dereference_protected(nf_expect_event_cb,
 					   lockdep_is_held(&nf_ct_ecache_mutex));
 	BUG_ON(notify != new);
-	rcu_assign_pointer(nf_expect_event_cb, NULL);
+	RCU_INIT_POINTER(nf_expect_event_cb, NULL);
 	mutex_unlock(&nf_ct_ecache_mutex);
 }
 EXPORT_SYMBOL_GPL(nf_ct_expect_unregister_notifier);
--- a/net/netfilter/nf_conntrack_extend.c	2011-08-01 08:56:32.492752934 -0700
+++ b/net/netfilter/nf_conntrack_extend.c	2011-08-01 08:57:56.196752966 -0700
@@ -169,7 +169,7 @@ int nf_ct_extend_register(struct nf_ct_e
 	   before updating alloc_size */
 	type->alloc_size = ALIGN(sizeof(struct nf_ct_ext), type->align)
 			   + type->len;
-	rcu_assign_pointer(nf_ct_ext_types[type->id], type);
+	RCU_INIT_POINTER(nf_ct_ext_types[type->id], type);
 	update_alloc_size(type);
 out:
 	mutex_unlock(&nf_ct_ext_type_mutex);
@@ -181,7 +181,7 @@ EXPORT_SYMBOL_GPL(nf_ct_extend_register)
 void nf_ct_extend_unregister(struct nf_ct_ext_type *type)
 {
 	mutex_lock(&nf_ct_ext_type_mutex);
-	rcu_assign_pointer(nf_ct_ext_types[type->id], NULL);
+	RCU_INIT_POINTER(nf_ct_ext_types[type->id], NULL);
 	update_alloc_size(type);
 	mutex_unlock(&nf_ct_ext_type_mutex);
 	rcu_barrier(); /* Wait for completion of call_rcu()'s */
--- a/net/netfilter/nf_conntrack_helper.c	2011-08-01 08:56:32.524752934 -0700
+++ b/net/netfilter/nf_conntrack_helper.c	2011-08-01 08:57:56.200752966 -0700
@@ -131,7 +131,7 @@ int __nf_ct_try_assign_helper(struct nf_
 		helper = __nf_ct_helper_find(&ct->tuplehash[IP_CT_DIR_REPLY].tuple);
 	if (helper == NULL) {
 		if (help)
-			rcu_assign_pointer(help->helper, NULL);
+			RCU_INIT_POINTER(help->helper, NULL);
 		goto out;
 	}
 
@@ -145,7 +145,7 @@ int __nf_ct_try_assign_helper(struct nf_
 		memset(&help->help, 0, sizeof(help->help));
 	}
 
-	rcu_assign_pointer(help->helper, helper);
+	RCU_INIT_POINTER(help->helper, helper);
 out:
 	return ret;
 }
@@ -162,7 +162,7 @@ static inline int unhelp(struct nf_connt
 			lockdep_is_held(&nf_conntrack_lock)
 			) == me) {
 		nf_conntrack_event(IPCT_HELPER, ct);
-		rcu_assign_pointer(help->helper, NULL);
+		RCU_INIT_POINTER(help->helper, NULL);
 	}
 	return 0;
 }
--- a/net/netfilter/nf_conntrack_netlink.c	2011-08-01 08:56:32.584752934 -0700
+++ b/net/netfilter/nf_conntrack_netlink.c	2011-08-01 08:57:56.204752965 -0700
@@ -1125,7 +1125,7 @@ ctnetlink_change_helper(struct nf_conn *
 		if (help && help->helper) {
 			/* we had a helper before ... */
 			nf_ct_remove_expectations(ct);
-			rcu_assign_pointer(help->helper, NULL);
+			RCU_INIT_POINTER(help->helper, NULL);
 		}
 
 		return 0;
@@ -1163,7 +1163,7 @@ ctnetlink_change_helper(struct nf_conn *
 		return -EOPNOTSUPP;
 	}
 
-	rcu_assign_pointer(help->helper, helper);
+	RCU_INIT_POINTER(help->helper, helper);
 
 	return 0;
 }
@@ -1386,7 +1386,7 @@ ctnetlink_create_conntrack(struct net *n
 			}
 
 			/* not in hash table yet so not strictly necessary */
-			rcu_assign_pointer(help->helper, helper);
+			RCU_INIT_POINTER(help->helper, helper);
 		}
 	} else {
 		/* try an implicit helper assignation */
--- a/net/netfilter/nf_log.c	2011-08-01 08:56:32.616752934 -0700
+++ b/net/netfilter/nf_log.c	2011-08-01 08:57:56.208752964 -0700
@@ -55,7 +55,7 @@ int nf_log_register(u_int8_t pf, struct
 		llog = rcu_dereference_protected(nf_loggers[pf],
 						 lockdep_is_held(&nf_log_mutex));
 		if (llog == NULL)
-			rcu_assign_pointer(nf_loggers[pf], logger);
+			RCU_INIT_POINTER(nf_loggers[pf], logger);
 	}
 
 	mutex_unlock(&nf_log_mutex);
@@ -74,7 +74,7 @@ void nf_log_unregister(struct nf_logger
 		c_logger = rcu_dereference_protected(nf_loggers[i],
 						     lockdep_is_held(&nf_log_mutex));
 		if (c_logger == logger)
-			rcu_assign_pointer(nf_loggers[i], NULL);
+			RCU_INIT_POINTER(nf_loggers[i], NULL);
 		list_del(&logger->list[i]);
 	}
 	mutex_unlock(&nf_log_mutex);
@@ -92,7 +92,7 @@ int nf_log_bind_pf(u_int8_t pf, const st
 		mutex_unlock(&nf_log_mutex);
 		return -ENOENT;
 	}
-	rcu_assign_pointer(nf_loggers[pf], logger);
+	RCU_INIT_POINTER(nf_loggers[pf], logger);
 	mutex_unlock(&nf_log_mutex);
 	return 0;
 }
@@ -103,7 +103,7 @@ void nf_log_unbind_pf(u_int8_t pf)
 	if (pf >= ARRAY_SIZE(nf_loggers))
 		return;
 	mutex_lock(&nf_log_mutex);
-	rcu_assign_pointer(nf_loggers[pf], NULL);
+	RCU_INIT_POINTER(nf_loggers[pf], NULL);
 	mutex_unlock(&nf_log_mutex);
 }
 EXPORT_SYMBOL(nf_log_unbind_pf);
@@ -250,7 +250,7 @@ static int nf_log_proc_dostring(ctl_tabl
 			mutex_unlock(&nf_log_mutex);
 			return -ENOENT;
 		}
-		rcu_assign_pointer(nf_loggers[tindex], logger);
+		RCU_INIT_POINTER(nf_loggers[tindex], logger);
 		mutex_unlock(&nf_log_mutex);
 	} else {
 		mutex_lock(&nf_log_mutex);
--- a/net/netfilter/nf_queue.c	2011-08-01 08:56:32.668752935 -0700
+++ b/net/netfilter/nf_queue.c	2011-08-01 08:57:56.212752965 -0700
@@ -40,7 +40,7 @@ int nf_register_queue_handler(u_int8_t p
 	else if (old)
 		ret = -EBUSY;
 	else {
-		rcu_assign_pointer(queue_handler[pf], qh);
+		RCU_INIT_POINTER(queue_handler[pf], qh);
 		ret = 0;
 	}
 	mutex_unlock(&queue_handler_mutex);
@@ -65,7 +65,7 @@ int nf_unregister_queue_handler(u_int8_t
 		return -EINVAL;
 	}
 
-	rcu_assign_pointer(queue_handler[pf], NULL);
+	RCU_INIT_POINTER(queue_handler[pf], NULL);
 	mutex_unlock(&queue_handler_mutex);
 
 	synchronize_rcu();
@@ -84,7 +84,7 @@ void nf_unregister_queue_handlers(const
 				queue_handler[pf],
 				lockdep_is_held(&queue_handler_mutex)
 				) == qh)
-			rcu_assign_pointer(queue_handler[pf], NULL);
+			RCU_INIT_POINTER(queue_handler[pf], NULL);
 	}
 	mutex_unlock(&queue_handler_mutex);
 
--- a/net/netfilter/nfnetlink.c	2011-08-01 08:56:32.716752934 -0700
+++ b/net/netfilter/nfnetlink.c	2011-08-01 08:57:56.212752965 -0700
@@ -59,7 +59,7 @@ int nfnetlink_subsys_register(const stru
 		nfnl_unlock();
 		return -EBUSY;
 	}
-	rcu_assign_pointer(subsys_table[n->subsys_id], n);
+	RCU_INIT_POINTER(subsys_table[n->subsys_id], n);
 	nfnl_unlock();
 
 	return 0;
@@ -210,7 +210,7 @@ static int __net_init nfnetlink_net_init
 	if (!nfnl)
 		return -ENOMEM;
 	net->nfnl_stash = nfnl;
-	rcu_assign_pointer(net->nfnl, nfnl);
+	RCU_INIT_POINTER(net->nfnl, nfnl);
 	return 0;
 }
 
@@ -219,7 +219,7 @@ static void __net_exit nfnetlink_net_exi
 	struct net *net;
 
 	list_for_each_entry(net, net_exit_list, exit_list)
-		rcu_assign_pointer(net->nfnl, NULL);
+		RCU_INIT_POINTER(net->nfnl, NULL);
 	synchronize_net();
 	list_for_each_entry(net, net_exit_list, exit_list)
 		netlink_kernel_release(net->nfnl_stash);
--- a/net/netlabel/netlabel_domainhash.c	2011-08-01 08:56:32.756752934 -0700
+++ b/net/netlabel/netlabel_domainhash.c	2011-08-01 08:57:56.216752966 -0700
@@ -282,7 +282,7 @@ int __init netlbl_domhsh_init(u32 size)
 		INIT_LIST_HEAD(&hsh_tbl->tbl[iter]);
 
 	spin_lock(&netlbl_domhsh_lock);
-	rcu_assign_pointer(netlbl_domhsh, hsh_tbl);
+	RCU_INIT_POINTER(netlbl_domhsh, hsh_tbl);
 	spin_unlock(&netlbl_domhsh_lock);
 
 	return 0;
@@ -330,7 +330,7 @@ int netlbl_domhsh_add(struct netlbl_dom_
 				    &rcu_dereference(netlbl_domhsh)->tbl[bkt]);
 		} else {
 			INIT_LIST_HEAD(&entry->list);
-			rcu_assign_pointer(netlbl_domhsh_def, entry);
+			RCU_INIT_POINTER(netlbl_domhsh_def, entry);
 		}
 
 		if (entry->type == NETLBL_NLTYPE_ADDRSELECT) {
@@ -451,7 +451,7 @@ int netlbl_domhsh_remove_entry(struct ne
 		if (entry != rcu_dereference(netlbl_domhsh_def))
 			list_del_rcu(&entry->list);
 		else
-			rcu_assign_pointer(netlbl_domhsh_def, NULL);
+			RCU_INIT_POINTER(netlbl_domhsh_def, NULL);
 	} else
 		ret_val = -ENOENT;
 	spin_unlock(&netlbl_domhsh_lock);
--- a/net/netlabel/netlabel_unlabeled.c	2011-08-01 08:56:32.788752934 -0700
+++ b/net/netlabel/netlabel_unlabeled.c	2011-08-01 08:57:56.220752966 -0700
@@ -354,7 +354,7 @@ static struct netlbl_unlhsh_iface *netlb
 		INIT_LIST_HEAD(&iface->list);
 		if (netlbl_unlhsh_rcu_deref(netlbl_unlhsh_def) != NULL)
 			goto add_iface_failure;
-		rcu_assign_pointer(netlbl_unlhsh_def, iface);
+		RCU_INIT_POINTER(netlbl_unlhsh_def, iface);
 	}
 	spin_unlock(&netlbl_unlhsh_lock);
 
@@ -621,7 +621,7 @@ static void netlbl_unlhsh_condremove_ifa
 	if (iface->ifindex > 0)
 		list_del_rcu(&iface->list);
 	else
-		rcu_assign_pointer(netlbl_unlhsh_def, NULL);
+		RCU_INIT_POINTER(netlbl_unlhsh_def, NULL);
 	spin_unlock(&netlbl_unlhsh_lock);
 
 	call_rcu(&iface->rcu, netlbl_unlhsh_free_iface);
@@ -1449,7 +1449,7 @@ int __init netlbl_unlabel_init(u32 size)
 
 	rcu_read_lock();
 	spin_lock(&netlbl_unlhsh_lock);
-	rcu_assign_pointer(netlbl_unlhsh, hsh_tbl);
+	RCU_INIT_POINTER(netlbl_unlhsh, hsh_tbl);
 	spin_unlock(&netlbl_unlhsh_lock);
 	rcu_read_unlock();
 
--- a/net/phonet/af_phonet.c	2011-08-01 08:56:32.824752934 -0700
+++ b/net/phonet/af_phonet.c	2011-08-01 08:57:56.220752966 -0700
@@ -480,7 +480,7 @@ int __init_or_module phonet_proto_regist
 	if (proto_tab[protocol])
 		err = -EBUSY;
 	else
-		rcu_assign_pointer(proto_tab[protocol], pp);
+		RCU_INIT_POINTER(proto_tab[protocol], pp);
 	mutex_unlock(&proto_tab_lock);
 
 	return err;
@@ -491,7 +491,7 @@ void phonet_proto_unregister(unsigned in
 {
 	mutex_lock(&proto_tab_lock);
 	BUG_ON(proto_tab[protocol] != pp);
-	rcu_assign_pointer(proto_tab[protocol], NULL);
+	RCU_INIT_POINTER(proto_tab[protocol], NULL);
 	mutex_unlock(&proto_tab_lock);
 	synchronize_rcu();
 	proto_unregister(pp->prot);
--- a/net/phonet/pn_dev.c	2011-08-01 08:56:32.856752934 -0700
+++ b/net/phonet/pn_dev.c	2011-08-01 08:57:56.224752965 -0700
@@ -276,7 +276,7 @@ static void phonet_route_autodel(struct
 	mutex_lock(&pnn->routes.lock);
 	for (i = 0; i < 64; i++)
 		if (dev == pnn->routes.table[i]) {
-			rcu_assign_pointer(pnn->routes.table[i], NULL);
+			RCU_INIT_POINTER(pnn->routes.table[i], NULL);
 			set_bit(i, deleted);
 		}
 	mutex_unlock(&pnn->routes.lock);
@@ -390,7 +390,7 @@ int phonet_route_add(struct net_device *
 	daddr = daddr >> 2;
 	mutex_lock(&routes->lock);
 	if (routes->table[daddr] == NULL) {
-		rcu_assign_pointer(routes->table[daddr], dev);
+		RCU_INIT_POINTER(routes->table[daddr], dev);
 		dev_hold(dev);
 		err = 0;
 	}
@@ -406,7 +406,7 @@ int phonet_route_del(struct net_device *
 	daddr = daddr >> 2;
 	mutex_lock(&routes->lock);
 	if (dev == routes->table[daddr])
-		rcu_assign_pointer(routes->table[daddr], NULL);
+		RCU_INIT_POINTER(routes->table[daddr], NULL);
 	else
 		dev = NULL;
 	mutex_unlock(&routes->lock);
--- a/net/phonet/socket.c	2011-08-01 08:56:32.916752934 -0700
+++ b/net/phonet/socket.c	2011-08-01 08:57:56.232752965 -0700
@@ -679,7 +679,7 @@ int pn_sock_bind_res(struct sock *sk, u8
 	mutex_lock(&resource_mutex);
 	if (pnres.sk[res] == NULL) {
 		sock_hold(sk);
-		rcu_assign_pointer(pnres.sk[res], sk);
+		RCU_INIT_POINTER(pnres.sk[res], sk);
 		ret = 0;
 	}
 	mutex_unlock(&resource_mutex);
@@ -695,7 +695,7 @@ int pn_sock_unbind_res(struct sock *sk,
 
 	mutex_lock(&resource_mutex);
 	if (pnres.sk[res] == sk) {
-		rcu_assign_pointer(pnres.sk[res], NULL);
+		RCU_INIT_POINTER(pnres.sk[res], NULL);
 		ret = 0;
 	}
 	mutex_unlock(&resource_mutex);
@@ -714,7 +714,7 @@ void pn_sock_unbind_all_res(struct sock
 	mutex_lock(&resource_mutex);
 	for (res = 0; res < 256; res++) {
 		if (pnres.sk[res] == sk) {
-			rcu_assign_pointer(pnres.sk[res], NULL);
+			RCU_INIT_POINTER(pnres.sk[res], NULL);
 			match++;
 		}
 	}
--- a/net/socket.c	2011-08-01 08:56:32.972752934 -0700
+++ b/net/socket.c	2011-08-01 08:57:56.240752966 -0700
@@ -2463,7 +2463,7 @@ int sock_register(const struct net_proto
 				      lockdep_is_held(&net_family_lock)))
 		err = -EEXIST;
 	else {
-		rcu_assign_pointer(net_families[ops->family], ops);
+		RCU_INIT_POINTER(net_families[ops->family], ops);
 		err = 0;
 	}
 	spin_unlock(&net_family_lock);
@@ -2491,7 +2491,7 @@ void sock_unregister(int family)
 	BUG_ON(family < 0 || family >= NPROTO);
 
 	spin_lock(&net_family_lock);
-	rcu_assign_pointer(net_families[family], NULL);
+	RCU_INIT_POINTER(net_families[family], NULL);
 	spin_unlock(&net_family_lock);
 
 	synchronize_rcu();
--- a/net/sunrpc/auth_gss/auth_gss.c	2011-08-01 08:56:33.008752934 -0700
+++ b/net/sunrpc/auth_gss/auth_gss.c	2011-08-01 08:57:56.244752965 -0700
@@ -122,7 +122,7 @@ gss_cred_set_ctx(struct rpc_cred *cred,
 	if (!test_bit(RPCAUTH_CRED_NEW, &cred->cr_flags))
 		return;
 	gss_get_ctx(ctx);
-	rcu_assign_pointer(gss_cred->gc_ctx, ctx);
+	RCU_INIT_POINTER(gss_cred->gc_ctx, ctx);
 	set_bit(RPCAUTH_CRED_UPTODATE, &cred->cr_flags);
 	smp_mb__before_clear_bit();
 	clear_bit(RPCAUTH_CRED_NEW, &cred->cr_flags);
@@ -970,7 +970,7 @@ gss_destroy_nullcred(struct rpc_cred *cr
 	struct gss_auth *gss_auth = container_of(cred->cr_auth, struct gss_auth, rpc_auth);
 	struct gss_cl_ctx *ctx = gss_cred->gc_ctx;
 
-	rcu_assign_pointer(gss_cred->gc_ctx, NULL);
+	RCU_INIT_POINTER(gss_cred->gc_ctx, NULL);
 	call_rcu(&cred->cr_rcu, gss_free_cred_callback);
 	if (ctx)
 		gss_put_ctx(ctx);
--- a/net/xfrm/xfrm_user.c	2011-08-01 08:56:33.040752934 -0700
+++ b/net/xfrm/xfrm_user.c	2011-08-01 08:57:56.252752965 -0700
@@ -2927,7 +2927,7 @@ static int __net_init xfrm_user_net_init
 	if (nlsk == NULL)
 		return -ENOMEM;
 	net->xfrm.nlsk_stash = nlsk; /* Don't set to NULL */
-	rcu_assign_pointer(net->xfrm.nlsk, nlsk);
+	RCU_INIT_POINTER(net->xfrm.nlsk, nlsk);
 	return 0;
 }
 
@@ -2935,7 +2935,7 @@ static void __net_exit xfrm_user_net_exi
 {
 	struct net *net;
 	list_for_each_entry(net, net_exit_list, exit_list)
-		rcu_assign_pointer(net->xfrm.nlsk, NULL);
+		RCU_INIT_POINTER(net->xfrm.nlsk, NULL);
 	synchronize_net();
 	list_for_each_entry(net, net_exit_list, exit_list)
 		netlink_kernel_release(net->xfrm.nlsk_stash);
