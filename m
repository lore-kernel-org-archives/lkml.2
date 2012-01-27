Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754148Ab2A0Kir (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 05:38:47 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:51278 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753854Ab2A0Kip (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 05:38:45 -0500
Message-ID: <1327660721.2220.7.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
Subject: Re: [patch v5, kernel version 3.2.1] Source mode for macvlan
 interface
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Stefan Gula <steweg@ynet.sk>
Cc: Patrick McHardy <kaber@trash.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Fri, 27 Jan 2012 11:38:41 +0100
In-Reply-To: <21673653.551327658293199.JavaMail.root@5-MeO-DMT.ynet.sk>
References: <21673653.551327658293199.JavaMail.root@5-MeO-DMT.ynet.sk>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le vendredi 27 janvier 2012 à 10:58 +0100, Stefan Gula a écrit :
> From: Stefan Gula <steweg@gmail.com>
> 

...

> +static struct macvlan_source_list *macvlan_hash_lookup_sources_list(
> +	const struct macvlan_dev *vlan,
> +	const unsigned char *addr)
> +{
> +	struct macvlan_source_list *list;
> +	struct hlist_node *n;
> +	struct hlist_head *h = &vlan->port->vlan_source_hash[addr[5]];
> +
> +	hlist_for_each_entry_rcu(list, n, h, hlist) {

You dont hold rcu_read_lock() here, and dont need to, since you are in
the controler path, rtnl is locked :

	hlist_for_each_entry(...)

> +		if (!compare_ether_addr_64bits(list->addr, addr) &&
> +		    list->vlan == vlan)
> +			return list;
> +	}
> +	return NULL;
> +}
> +
> +static int macvlan_hash_add_sources(struct macvlan_dev *vlan,
> +				    const unsigned char *addr)
> +{
> +	struct macvlan_port *port = vlan->port;
> +	struct macvlan_source_list *list;
> +	struct hlist_head *h;
> +
> +	list = macvlan_hash_lookup_sources_list(vlan, addr);
> +	if (!list) {
> +		list = kmalloc(sizeof(*list), GFP_KERNEL);

By the way, use of GFP_KERNEL here is a proof you dont hold
rcu_read_lock().

(If you were, you would not be allowed to sleep in kmalloc())

> +		if (list) {
> +			memcpy(list->addr, addr, ETH_ALEN);
> +			list->vlan = vlan;
> +			h = &port->vlan_source_hash[addr[5]];
> +			hlist_add_head_rcu(&list->hlist, h);
> +		} else
> +			return -ENOMEM;

	if (cond) {
		foo;
		bar;
	} else {
		blip;
	}


> +	}
> +	return 0;
> +}
> +
> +static void macvlan_hash_del_sources(struct macvlan_source_list *list)
> +{
> +	hlist_del_rcu(&list->hlist);
> +	kfree_rcu(list, rcu);
> +}
> +

...

> +static int macvlan_changelink_sources(struct macvlan_dev *vlan, u32 mode,
> +				      unsigned char *addr)
> +{
> +	if (mode == MACVLAN_MACADDR_ADD)
> +		return macvlan_hash_add_sources(vlan, addr);
> +

Same codestyle here...

	if (cond) {
		foo;
	} else if (cond2) {
	} else {
		blip;
	}


> +	else if (mode == MACVLAN_MACADDR_DEL) {
> +		struct macvlan_source_list *list;
> +
> +		list = macvlan_hash_lookup_sources_list(vlan, addr);
> +		if (list)
> +			macvlan_hash_del_sources(list);
> +	} else
> +		return -EINVAL;
> +
> +	return 0;
> +}
> +


