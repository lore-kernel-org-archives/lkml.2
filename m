Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752370Ab2HNWdy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 18:33:54 -0400
Received: from webmail.solarflare.com ([12.187.104.25]:63158 "EHLO
	ocex02.SolarFlarecom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750968Ab2HNWdw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 18:33:52 -0400
Message-ID: <1344983624.2690.77.camel@bwh-desktop.uk.solarflarecom.com>
Subject: Re: [patch net-next v2 01/15] net: introduce upper device lists
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
Date: Tue, 14 Aug 2012 23:33:44 +0100
In-Reply-To: <1344956748-2099-2-git-send-email-jiri@resnulli.us>
References: <1344956748-2099-1-git-send-email-jiri@resnulli.us>
	 <1344956748-2099-2-git-send-email-jiri@resnulli.us>
Organization: Solarflare Communications
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
X-Originating-IP: [10.17.20.137]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-08-14 at 17:05 +0200, Jiri Pirko wrote:
> This lists are supposed to serve for storing pointers to all upper devices.
> Eventually it will replace dev->master pointer which is used for
> bonding, bridge, team but it cannot be used for vlan, macvlan where
> there might be multiple upper present. In case the upper link is
> replacement for dev->master, it is marked with "master" flag.

Something I found interesting is that the dev->master pointer and now
netdev_master_upper_dev_get{,_rcu}() are hardly used by the stackled
drivers that set the master.  They also have to set an rx_handler on the
lower device (which is itself mutually exclusive) which gets its own
context pointer (rx_handler_data).

Instead, the master pointer is mostly used by device drivers to find out
about a bridge or bonding device above *their* devices.  And that seems
to work only for those specific device drivers, not e.g. openvswitch or
team.  I wonder if we could find a better way to encapsulate the things
they want do do, in a later step (not holding up this change!).

[...]
> +static int __netdev_upper_dev_link(struct net_device *dev,
> +                                  struct net_device *upper_dev, bool master)
> +{
> +       struct netdev_upper *upper;
> +
> +       ASSERT_RTNL();
> +
> +       if (dev == upper_dev)
> +               return -EBUSY;
> +       /*
> +        * To prevent loops, check if dev is not upper device to upper_dev.
> +        */
> +       if (__netdev_has_upper_dev(upper_dev, dev, true))
> +               return -EBUSY;
[...]

I think we will also need to limit the depth of the device stack so we
don't run out of stack space here.  __netif_receive() implements a kind
of tail recursion whenever a packet is passed up, but
__netdev_has_upper_dev() can't avoid doing real recursion (without the
addition of a flag to net_device so it can mark its progress).

Ben.

-- 
Ben Hutchings, Staff Engineer, Solarflare
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.

