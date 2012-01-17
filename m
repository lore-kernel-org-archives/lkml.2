Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753419Ab2AQLA4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 06:00:56 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:47745 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753261Ab2AQLAy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 06:00:54 -0500
MIME-Version: 1.0
In-Reply-To: <1326797276.2259.3.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
References: <CAGsizz+x1GVNR9Pz=b7wO0ELx29=FMosfvhQWL5K26EpkwsUCg@mail.gmail.com>
 <1326745733.2564.14.camel@edumazet-laptop> <CAGsizz+2nH+Sx+7TjZwEeKBiHbio0BxoN7CgT4Sspp0EzRN6Ug@mail.gmail.com>
 <1326775643.2564.36.camel@edumazet-laptop> <CAGsizz+kgBB9APmU9dPExkGQvPUVa3m6qz3NvSguPYNuJQQ_7Q@mail.gmail.com>
 <1326788970.2564.52.camel@edumazet-laptop> <CAGsizzLwCTpuZsZyx24T9WZy1DSJo+rfhDxLsE8UmeZOSxw+mA@mail.gmail.com>
 <1326797276.2259.3.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
From: =?ISO-8859-2?Q?=A9tefan_Gula?= <steweg@ynet.sk>
Date: Tue, 17 Jan 2012 12:00:33 +0100
X-Google-Sender-Auth: QvvuQ2LJOksDCGGCn10AISnWJ9Q
Message-ID: <CAGsizz+WG=NEc7kj7WoZP0Z-KgGwwiJS7kycHW6cxPeo9h88zA@mail.gmail.com>
Subject: Re: [patch v2, kernel version 3.2.1] net/ipv4/ip_gre: Ethernet
 multipoint GRE over IP
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        "David S. Miller" <davem@davemloft.net>,
        James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Patrick McHardy <kaber@trash.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q0HB17YV016826

Dňa 17. januára 2012 11:47, Eric Dumazet <eric.dumazet@gmail.com> napísal/a:
> Le mardi 17 janvier 2012 à 11:43 +0100, Štefan Gula a écrit :
>
>> ok maybe I am getting it wrong, but I am little bit stuck here. I
>> recheck the original bridge code. The difference I recognize is that
>> in bridge code function:
>> br_fdb_init() and br_fdb_fini()
>> are called from module init and module exit functions:
>> br_init and br_deinit
>>
>> in my code they are called from functions:
>> ipgre_init_net and ipgre_exit_net
>> instead of:
>> ipgre_init and ipgre_fini
>>
>> To be honest I am not so familiar enough with kernel structure that I
>> see the difference on the first time. But I think that with your help
>> it can be done easily. The main idea was to create hash-table that is
>> used to determine the destination IPv4 address (part of the entry
>> structure). That hash-table should be different per each gretap
>> interface - I think that's the reason why I put those init and fini
>> inside ipgre_init_net and ipgre_exit_net. Am I right that the
>> placement of this calls is correct or not? If not where those calls
>> should be placed?
>>
>> On the other hand I have no idea how to substitute those two function
>> with a code that you are suggesting kmalloc()/kfree(). I would be glad
>> if you can help me here by providing me example how to substitute
>> those two functions with kmalloc/kfree for the future usage (I am more
>> reverse engineer learner type of person than manuals reading one)
>
> Something like the following ?
>
>
> Note : I also put the "orig_source = iph->saddr;"
> _after_ "iph = ip_hdr(skb);"
>
>                        iph = ip_hdr(skb);
> #ifdef CONFIG_NET_IPGRE_BRIDGE
>                        orig_source = iph->saddr;
> #endif
>
>
>
> diff --git a/include/net/ipip.h b/include/net/ipip.h
> index a32654d..6a06fc2 100644
> --- a/include/net/ipip.h
> +++ b/include/net/ipip.h
> @@ -27,6 +27,14 @@ struct ip_tunnel {
>        __u32                   o_seqno;        /* The last output seqno */
>        int                     hlen;           /* Precalculated GRE header length */
>        int                     mlink;
> +#ifdef CONFIG_NET_IPGRE_BRIDGE
> +#define GRETAP_BR_HASH_BITS 8
> +#define GRETAP_BR_HASH_SIZE (1 << GRETAP_BR_HASH_BITS)
> +       struct hlist_head       hash[GRETAP_BR_HASH_SIZE];
> +       spinlock_t              hash_lock;
> +       unsigned long           ageing_time;
> +       struct timer_list       gc_timer;
> +#endif
>
>        struct ip_tunnel_parm   parms;
>
> diff --git a/net/ipv4/Kconfig b/net/ipv4/Kconfig
> index 1a8f93b..5b320a3 100644
> --- a/net/ipv4/Kconfig
> +++ b/net/ipv4/Kconfig
> @@ -211,6 +211,15 @@ config NET_IPGRE_BROADCAST
>          Network), but can be distributed all over the Internet. If you want
>          to do that, say Y here and to "IP multicast routing" below.
>
> +config NET_IPGRE_BRIDGE
> +       bool "IP: Ethernet over multipoint GRE over IP"
> +       depends on IP_MULTICAST && NET_IPGRE && NET_IPGRE_BROADCAST
> +       help
> +         Allows you to use multipoint GRE VPN as virtual switch and interconnect
> +         several L2 endpoints over L3 routed infrastructure. It is useful for
> +         creating multipoint L2 VPNs which can be later used inside bridge
> +         interfaces If you want to use. GRE multipoint L2 VPN feature say Y.
> +
>  config IP_MROUTE
>        bool "IP: multicast routing"
>        depends on IP_MULTICAST
> diff --git a/net/ipv4/ip_gre.c b/net/ipv4/ip_gre.c
> index 2b53a1f..df22565 100644
> --- a/net/ipv4/ip_gre.c
> +++ b/net/ipv4/ip_gre.c
> @@ -52,6 +52,11 @@
>  #include <net/ip6_route.h>
>  #endif
>
> +#ifdef CONFIG_NET_IPGRE_BRIDGE
> +#include <linux/jhash.h>
> +#include <asm/unaligned.h>
> +#endif
> +
>  /*
>    Problems & solutions
>    --------------------
> @@ -134,6 +139,172 @@ struct ipgre_net {
>        struct net_device *fb_tunnel_dev;
>  };
>
> +#ifdef CONFIG_NET_IPGRE_BRIDGE
> +       /*
> +        * This part of code includes codes to enable L2 ethernet
> +        * switch virtualization over IP routed infrastructure with
> +        * utilization of multicast capable endpoint using Ethernet
> +        * over GRE
> +        *
> +        * Author: Stefan Gula
> +        * Signed-off-by: Stefan Gula <steweg@gmail.com>
> +        */
> +struct ipgre_tap_bridge_entry {
> +       struct hlist_node       hlist;
> +       __be32                  raddr;
> +       unsigned char           addr[ETH_ALEN];
> +       unsigned long           updated;
> +       struct rcu_head         rcu;
> +};
> +
> +static u32 ipgre_salt __read_mostly;
> +
> +static inline int ipgre_tap_bridge_hash(const unsigned char *mac)
> +{
> +       u32 key = get_unaligned((u32 *)(mac + 2));
> +
> +       return jhash_1word(key, ipgre_salt) & (GRETAP_BR_HASH_SIZE - 1);
> +}
> +
> +static inline int ipgre_tap_bridge_has_expired(const struct ip_tunnel *tunnel,
> +                               const struct ipgre_tap_bridge_entry *entry)
> +{
> +       return time_before_eq(entry->updated + tunnel->ageing_time,
> +                             jiffies);
> +}
> +
> +static inline void ipgre_tap_bridge_delete(struct ipgre_tap_bridge_entry *entry)
> +{
> +       hlist_del_rcu(&entry->hlist);
> +       kfree_rcu(entry, rcu);
> +}
> +
> +static void ipgre_tap_bridge_cleanup(unsigned long _data)
> +{
> +       struct ip_tunnel *tunnel = (struct ip_tunnel *)_data;
> +       unsigned long delay = tunnel->ageing_time;
> +       unsigned long next_timer = jiffies + tunnel->ageing_time;
> +       int i;
> +
> +       spin_lock(&tunnel->hash_lock);
> +       for (i = 0; i < GRETAP_BR_HASH_SIZE; i++) {
> +               struct ipgre_tap_bridge_entry *entry;
> +               struct hlist_node *h, *n;
> +
> +               hlist_for_each_entry_safe(entry, h, n,
> +                       &tunnel->hash[i], hlist)
> +               {
> +                       unsigned long this_timer;
> +                       this_timer = entry->updated + delay;
> +                       if (time_before_eq(this_timer, jiffies))
> +                               ipgre_tap_bridge_delete(entry);
> +                       else if (time_before(this_timer, next_timer))
> +                               next_timer = this_timer;
> +               }
> +       }
> +       spin_unlock(&tunnel->hash_lock);
> +       mod_timer(&tunnel->gc_timer, round_jiffies_up(next_timer));
> +}
> +
> +static void ipgre_tap_bridge_flush(struct ip_tunnel *tunnel)
> +{
> +       int i;
> +
> +       spin_lock_bh(&tunnel->hash_lock);
> +       for (i = 0; i < GRETAP_BR_HASH_SIZE; i++) {
> +               struct ipgre_tap_bridge_entry *entry;
> +               struct hlist_node *h, *n;
> +
> +               hlist_for_each_entry_safe(entry, h, n,
> +                       &tunnel->hash[i], hlist)
> +               {
> +                       ipgre_tap_bridge_delete(entry);
> +               }
> +       }
> +       spin_unlock_bh(&tunnel->hash_lock);
> +}
> +
> +static struct ipgre_tap_bridge_entry *__ipgre_tap_bridge_get(
> +       struct ip_tunnel *tunnel, const unsigned char *addr)
> +{
> +       struct hlist_node *h;
> +       struct ipgre_tap_bridge_entry *entry;
> +
> +       hlist_for_each_entry_rcu(entry, h,
> +                       &tunnel->hash[ipgre_tap_bridge_hash(addr)], hlist) {
> +               if (!compare_ether_addr(entry->addr, addr)) {
> +                       if (unlikely(ipgre_tap_bridge_has_expired(tunnel,
> +                               entry)))
> +                               break;
> +                       return entry;
> +               }
> +       }
> +
> +       return NULL;
> +}
> +
> +static struct ipgre_tap_bridge_entry *ipgre_tap_bridge_find(
> +       struct hlist_head *head,
> +       const unsigned char *addr)
> +{
> +       struct hlist_node *h;
> +       struct ipgre_tap_bridge_entry *entry;
> +
> +       hlist_for_each_entry(entry, h, head, hlist) {
> +               if (!compare_ether_addr(entry->addr, addr))
> +                       return entry;
> +       }
> +       return NULL;
> +}
> +
> +
> +static struct ipgre_tap_bridge_entry *ipgre_tap_bridge_find_rcu(
> +       struct hlist_head *head,
> +       const unsigned char *addr)
> +{
> +       struct hlist_node *h;
> +       struct ipgre_tap_bridge_entry *entry;
> +
> +       hlist_for_each_entry_rcu(entry, h, head, hlist) {
> +               if (!compare_ether_addr(entry->addr, addr))
> +                       return entry;
> +       }
> +       return NULL;
> +}
> +
> +static struct ipgre_tap_bridge_entry *ipgre_tap_bridge_create(
> +       struct hlist_head *head,
> +       u32 source,
> +       const unsigned char *addr)
> +{
> +       struct ipgre_tap_bridge_entry *entry;
> +
> +       entry = kmalloc(sizeof(*entry), GFP_ATOMIC);
> +       if (entry) {
> +               memcpy(entry->addr, addr, ETH_ALEN);
> +               entry->raddr = source;
> +               entry->updated = jiffies;
> +               hlist_add_head_rcu(&entry->hlist, head);
> +       }
> +       return entry;
> +}
> +
> +static __be32 ipgre_tap_bridge_get_raddr(struct ip_tunnel *tunnel,
> +       const unsigned char *addr)
> +{
> +       __be32 raddr = 0;
> +       struct ipgre_tap_bridge_entry *entry;
> +
> +       rcu_read_lock();
> +       entry = __ipgre_tap_bridge_get(tunnel, addr);
> +       if (entry)
> +               raddr = entry->raddr;
> +       rcu_read_unlock();
> +
> +       return raddr;
> +}
> +
> +#endif
>  /* Tunnel hash table */
>
>  /*
> @@ -562,6 +733,12 @@ static int ipgre_rcv(struct sk_buff *skb)
>        struct ip_tunnel *tunnel;
>        int    offset = 4;
>        __be16 gre_proto;
> +#ifdef CONFIG_NET_IPGRE_BRIDGE
> +       __be32 orig_source;
> +       struct hlist_head *head;
> +       struct ipgre_tap_bridge_entry *entry;
> +       const struct ethhdr *tethhdr;
> +#endif
>
>        if (!pskb_may_pull(skb, 16))
>                goto drop_nolock;
> @@ -659,10 +836,38 @@ static int ipgre_rcv(struct sk_buff *skb)
>                                tunnel->dev->stats.rx_errors++;
>                                goto drop;
>                        }
> -
>                        iph = ip_hdr(skb);
> +#ifdef CONFIG_NET_IPGRE_BRIDGE
> +                       orig_source = iph->saddr;
> +#endif
>                        skb->protocol = eth_type_trans(skb, tunnel->dev);
>                        skb_postpull_rcsum(skb, eth_hdr(skb), ETH_HLEN);
> +#ifdef CONFIG_NET_IPGRE_BRIDGE
> +                       if (ipv4_is_multicast(tunnel->parms.iph.daddr)) {
> +                               tethhdr = eth_hdr(skb);
> +                               if (!is_multicast_ether_addr(
> +                                       tethhdr->h_source)) {
> +                                       head = &tunnel->hash[
> +                                               ipgre_tap_bridge_hash(
> +                                                       tethhdr->h_source)];
> +                                       entry = ipgre_tap_bridge_find_rcu(head,
> +                                               tethhdr->h_source);
> +                                       if (likely(entry)) {
> +                                               entry->raddr = orig_source;
> +                                               entry->updated = jiffies;
> +                                       } else {
> +                                         spin_lock(&tunnel->hash_lock);
> +                                         if (!ipgre_tap_bridge_find(head,
> +                                               tethhdr->h_source))
> +                                               ipgre_tap_bridge_create(
> +                                                       head,
> +                                                       orig_source,
> +                                                       tethhdr->h_source);
> +                                         spin_unlock(&tunnel->hash_lock);
> +                                       }
> +                               }
> +                       }
> +#endif
>                }
>
>                tstats = this_cpu_ptr(tunnel->dev->tstats);
> @@ -702,7 +907,7 @@ static netdev_tx_t ipgre_tunnel_xmit(struct sk_buff *skb, struct net_device *dev
>        struct iphdr  *iph;                     /* Our new IP header */
>        unsigned int max_headroom;              /* The extra header space needed */
>        int    gre_hlen;
> -       __be32 dst;
> +       __be32 dst = 0;
>        int    mtu;
>
>        if (dev->type == ARPHRD_ETHER)
> @@ -716,7 +921,15 @@ static netdev_tx_t ipgre_tunnel_xmit(struct sk_buff *skb, struct net_device *dev
>                tiph = &tunnel->parms.iph;
>        }
>
> -       if ((dst = tiph->daddr) == 0) {
> +#ifdef CONFIG_NET_IPGRE_BRIDGE
> +       if ((dev->type == ARPHRD_ETHER) &&
> +               ipv4_is_multicast(tunnel->parms.iph.daddr))
> +               dst = ipgre_tap_bridge_get_raddr(tunnel,
> +                       ((struct ethhdr *)skb->data)->h_dest);
> +#endif
> +       if (dst == 0)
> +               dst = tiph->daddr;
> +       if (dst == 0) {
>                /* NBMA tunnel */
>
>                if (skb_dst(skb) == NULL) {
> @@ -1211,6 +1424,16 @@ static int ipgre_open(struct net_device *dev)
>                        return -EADDRNOTAVAIL;
>                t->mlink = dev->ifindex;
>                ip_mc_inc_group(__in_dev_get_rtnl(dev), t->parms.iph.daddr);
> +#ifdef CONFIG_NET_IPGRE_BRIDGE
> +               if (t->dev->type == ARPHRD_ETHER) {
> +                       INIT_HLIST_HEAD(t->hash);
> +                       spin_lock_init(&t->hash_lock);
> +                       t->ageing_time = 300 * HZ;
> +                       setup_timer(&t->gc_timer, ipgre_tap_bridge_cleanup,
> +                               (unsigned long) t);
> +                       mod_timer(&t->gc_timer, jiffies + t->ageing_time);
> +               }
> +#endif
>        }
>        return 0;
>  }
> @@ -1221,6 +1444,12 @@ static int ipgre_close(struct net_device *dev)
>
>        if (ipv4_is_multicast(t->parms.iph.daddr) && t->mlink) {
>                struct in_device *in_dev;
> +#ifdef CONFIG_NET_IPGRE_BRIDGE
> +               if (t->dev->type == ARPHRD_ETHER) {
> +                       ipgre_tap_bridge_flush(t);
> +                       del_timer_sync(&t->gc_timer);
> +               }
> +#endif
>                in_dev = inetdev_by_index(dev_net(dev), t->mlink);
>                if (in_dev)
>                        ip_mc_dec_group(in_dev, t->parms.iph.daddr);
> @@ -1707,6 +1936,9 @@ static int __init ipgre_init(void)
>
>        printk(KERN_INFO "GRE over IPv4 tunneling driver\n");
>
> +#ifdef CONFIG_NET_IPGRE_BRIDGE
> +       get_random_bytes(&ipgre_salt, sizeof(ipgre_salt));
> +#endif
>        err = register_pernet_device(&ipgre_net_ops);
>        if (err < 0)
>                return err;
>
>
looks good... I am just wondering whether my previous question about
the placement of calls for ipgre_tap_bridge_init and
ipgre_tap_bridge_fini? Would it be also possible to have this
done/fixed when I migrate those inside the ipgre_init and ipgre_fini ?
I would like to have much rather identical parts of code with standard
bridge code just in case somebody would start doing generalization of
bridge code which can be then reused anywhere inside the kernel space
- simpler migration process later.
���{.n�+�������+%�����ݶ��w��{.n�+����{��G�����{ay�ʇڙ�,j��f���h��������z_�(�階�ݢj"���m������G������?����&���~��iO��z��v�^�m����������?�I�
