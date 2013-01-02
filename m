Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752673Ab3ABS5i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2013 13:57:38 -0500
Received: from webmail.solarflare.com ([12.187.104.25]:25549 "EHLO
	webmail.solarflare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752416Ab3ABS5g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2013 13:57:36 -0500
Message-ID: <1357153046.3652.11.camel@bwh-desktop.uk.solarflarecom.com>
Subject: Re: [patch net-next V5 01/15] net: introduce upper device lists
From: Ben Hutchings <bhutchings@solarflare.com>
To: Jiri Pirko <jiri@resnulli.us>
CC: <netdev@vger.kernel.org>, <davem@davemloft.net>, <edumazet@google.com>,
        <faisal.latif@intel.com>, <roland@kernel.org>, <sean.hefty@intel.com>,
        <hal.rosenstock@gmail.com>, <fubar@us.ibm.com>, <andy@greyhouse.net>,
        <divy@chelsio.com>, <jitendra.kalsaria@qlogic.com>,
        <sony.chacko@qlogic.com>, <linux-driver@qlogic.com>, <kaber@trash.net>,
        <ursula.braun@de.ibm.com>, <blaschka@linux.vnet.ibm.com>,
        <linux390@de.ibm.com>, <shemminger@vyatta.com>, <therbert@google.com>,
        <xiyou.wangcong@gmail.com>, <joe@perches.com>,
        <gregory.v.rose@intel.com>, <john.r.fastabend@intel.com>,
        <linux-rdma@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-s390@vger.kernel.org>, <bridge@lists.linux-foundation.org>,
        <fbl@redhat.com>
Date: Wed, 2 Jan 2013 18:57:26 +0000
In-Reply-To: <1357129716-2450-2-git-send-email-jiri@resnulli.us>
References: <1357129716-2450-1-git-send-email-jiri@resnulli.us>
	 <1357129716-2450-2-git-send-email-jiri@resnulli.us>
Organization: Solarflare
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
X-Originating-IP: [10.17.20.137]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-01-02 at 13:28 +0100, Jiri Pirko wrote:
> This lists are supposed to serve for storing pointers to all upper devices.
> Eventually it will replace dev->master pointer which is used for
> bonding, bridge, team but it cannot be used for vlan, macvlan where
> there might be multiple upper present. In case the upper link is
> replacement for dev->master, it is marked with "master" flag.
> 
> New upper device list resolves this limitation. Also, the information
> stored in lists is used for preventing looping setups like
> "bond->somethingelse->samebond"

Thanks for continuing with this, Jiri.  I just see some
cosmetic/documentation issues:

[...]
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
[...]
> +static bool __netdev_has_upper_dev(struct net_device *dev,
> +				   struct net_device *upper_dev)
> +{
> +	LIST_HEAD(search_list);
> +	struct netdev_upper *upper;
> +	struct netdev_upper *tmp;
> +	bool ret = false;
> +
> +	__append_search_uppers(&search_list, dev);
> +	list_for_each_entry(upper, &search_list, search_list) {
> +		if (upper->dev == upper_dev) {
> +			ret = true;
> +			break;
> +		}
> +		__append_search_uppers(&search_list, upper->dev);
> +	}
> +	list_for_each_entry_safe(upper, tmp, &search_list, search_list)
> +		INIT_LIST_HEAD(&upper->search_list);
> +	return ret;
> +}
> +
> +static struct netdev_upper *__netdev_find_upper(struct net_device *dev,
> +						struct net_device *upper_dev)
> +{
> +	struct netdev_upper *upper;
> +
> +	list_for_each_entry(upper, &dev->upper_dev_list, list) {
> +		if (upper->dev == upper_dev)
> +			return upper;
> +	}
> +	return NULL;
> +}
> +
> +/**
> + * netdev_has_upper_dev - Check if device is linked to an upper device

Please clarify that this (and other functions) only checks for an
immediate upper device and not through a complete stack of devices.

> + * @dev: device
> + * @upper_dev: upper device to check
> + *
> + * Find out if a device is linked to specified upper device and return true
> + * in case it is. The caller must hold the RTNL semaphore.

It is no longer a semaphore, even if some kernel-doc in this file calls
it that.  'RTNL lock' would be better as it matches the function naming:
rtnl_lock() etc.

> + */
> +bool netdev_has_upper_dev(struct net_device *dev,
> +			  struct net_device *upper_dev)

The '__' prefix normally implies doing less work than the un-prefixed
function but __netdev_has_upper_dev() checks all devices stacked above
dev whereas this only checks a single level.  Therefore I think one or
both should be renamed.

> +{
> +	ASSERT_RTNL();
> +
> +	return __netdev_find_upper(dev, upper_dev);
> +}
> +EXPORT_SYMBOL(netdev_has_upper_dev);
[...]
> +static int __netdev_upper_dev_link(struct net_device *dev,
> +				   struct net_device *upper_dev, bool master)
> +{
[...]
> +}
> +/**
> + * netdev_upper_dev_link - Add a link to the upper device
[...] 

There should be a blank line between the closing brace and the comment
for the next function.

Ben.

-- 
Ben Hutchings, Staff Engineer, Solarflare
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.

