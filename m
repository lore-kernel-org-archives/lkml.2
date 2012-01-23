Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756403Ab2AWXwv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 18:52:51 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:64967 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932379Ab2AWXwY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 18:52:24 -0500
Message-ID: <1327362739.2587.15.camel@edumazet-laptop>
Subject: Re: [patch v2, kernel version 3.2.1] Source mode for macvlan
 interface
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Stefan Gula <steweg@ynet.sk>
Cc: Patrick McHardy <kaber@trash.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Tue, 24 Jan 2012 00:52:19 +0100
In-Reply-To: <29378065.3471327360294412.JavaMail.root@5-MeO-DMT.ynet.sk>
References: <29378065.3471327360294412.JavaMail.root@5-MeO-DMT.ynet.sk>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mardi 24 janvier 2012 à 00:11 +0100, Stefan Gula a écrit :
> From: Stefan Gula <steweg@gmail.com>
> 
> New mode of macvlan interface called "source" allows one to specify,
> which  frames are allowed to be received by given macvlan interface.
> This logic is used only on received frames on underlying interface.
> The ability to send frames from macvlan interface through underlying
> interface is not modified. This feature allows one to simulate 802.1x
> mac based VLAN behavior by using proper netlink message to configure
> this behavior with utility such as "ip link" from iproute2 suite.
> This feature allows to create MAC based VLAN associations instead of
> standard port or tag based, to be able to associate several different
> clients/users behind one common port based on their MAC addresses.
> 

Still obscure changelog...

> Signed-off-by: Stefan Gula <steweg@gmail.com>
> 

Please include next time

V3: list of changes 

> +
> +static void macvlan_hash_add_sources(struct macvlan_dev *vlan,
> +				const unsigned char *addr)
> +{
> +	struct macvlan_port *port = vlan->port;
> +	struct macvlan_source_list *list;
> +
> +	list = macvlan_hash_lookup_sources_list(vlan, addr);
> +	if (!list) {
> +		list = kmalloc(sizeof(*list), GFP_ATOMIC);


Why GFP_ATOMIC here ?

> +		if (list) {
> +			memcpy(list->addr, addr, ETH_ALEN);
> +			list->vlan = vlan;
> +			hlist_add_head_rcu(&list->hlist,
> +				&port->vlan_source_hash[addr[5]]);
> +		}
> +	}
> +}
> +

...

>  
> +
> +static int macvlan_fill_nested(struct sk_buff *skb, const char *addr)
> +{
> +	struct nlattr *nested;
> +
> +	nested = nla_nest_start(skb, IFLA_MACVLAN_MACADDR_DATA);
> +	if (!nested)
> +		return -EMSGSIZE;
> +	NLA_PUT(skb, IFLA_MACVLAN_MACADDR, ETH_ALEN, addr);
> +	nla_nest_end(skb, nested);
> +
> +	return 0;
> +
> +nla_put_failure:
> +	nla_nest_cancel(skb, nested);
> +
> +	return 0;
> +}
> +
>  static int macvlan_fill_info(struct sk_buff *skb,
>  				const struct net_device *dev)
>  {
>  	struct macvlan_dev *vlan = netdev_priv(dev);
> +	struct nlattr *adt;
>  
>  	NLA_PUT_U32(skb, IFLA_MACVLAN_MODE, vlan->mode);
> +
> +	if (vlan->mode == MACVLAN_MODE_SOURCE) {
> +		int i;
> +
> +		adt = nla_nest_start(skb, IFLA_MACVLAN_MACADDR_ADT);
> +		if (!adt)
> +			goto nla_put_failure;
> +
> +		for (i = 0; i < MACVLAN_HASH_SIZE; i++) {
> +			struct hlist_node *n;
> +			struct macvlan_source_list *list;
> +
> +			hlist_for_each_entry_rcu(list, n,
> +				&vlan->port->vlan_source_hash[i], hlist) {
> +				if (list->vlan == vlan)
> +					if (macvlan_fill_nested(skb,
> +						list->addr))
> +						goto nla_nested_failure;
> +			}
> +		}
> +		nla_nest_end(skb, adt);
> +	}
> +

How many 'sources' are expected per port ?

Above a certain (small) threshold, macvlan_fill_info() will 'overflow'
skb capacity and return an error.

Take a look at macvlan_get_size() ?



