Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752985Ab1AXVLp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 16:11:45 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:55586 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751878Ab1AXVLo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 16:11:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=L9RMvwAIiIEKG+xLQ+yo5QyuYpxMuctjp8+HgmX1WcMcpKteJnidjcI+hP8ZOpU4FS
         jL+UthpD6XBkPjP6ksTdWYiqKhuox86lFQywxkwPrgbSGbOgz6q/FRWTV3iWvZ7vrUCV
         rdRwjWX9xDvXfHc/KtNEw2OUejIirVXAgvcno=
Subject: Re: 2.6.38-rc1: arp triggers RTNL assertion
From: Eric Dumazet <eric.dumazet@gmail.com>
To: David Miller <davem@davemloft.net>
Cc: jamie@audible.transient.net, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
In-Reply-To: <20110121.130657.106806953.davem@davemloft.net>
References: <20110121061758.GA2247@fifty-fifty.audible.transient.net>
	 <1295593946.2613.52.camel@edumazet-laptop>
	 <1295635976.2609.23.camel@edumazet-laptop>
	 <20110121.130657.106806953.davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 24 Jan 2011 22:11:38 +0100
Message-ID: <1295903498.2924.17.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le vendredi 21 janvier 2011 à 13:06 -0800, David Miller a écrit :
> From: Eric Dumazet <eric.dumazet@gmail.com>
> Date: Fri, 21 Jan 2011 19:52:56 +0100
> 
> > Here is how I fixed this, thanks again Jamie !
> > 
> > [PATCH] net: neighbour: pneigh_lookup() doesnt need RTNL
> 
> Eric, I don't think we can do this.
> 
> Fundamentally, any time a user operation changes the configuration
> of the networking, we must hold the RTNL.
> 
> Eliding the RTNL for lookups is fine, but for things that change
> state it is not.
> 
> I therefore think you'll need to rework the arp_ioctl() portions
> of the commit that introduced this regression.
> 

Here is a second try of the fix, thanks !

Note : Tested with CONFIG_PROVE_RCU=y

[PATCH] net: arp_ioctl() must hold RTNL

Commit 941666c2e3e0 "net: RCU conversion of dev_getbyhwaddr() and
arp_ioctl()" introduced a regression, reported by Jamie Heilman.
"arp -Ds 192.168.2.41 eth0 pub" triggered the ASSERT_RTNL() assert
in pneigh_lookup()

Removing RTNL requirement from arp_ioctl() was a mistake, just revert
that part.

Reported-by: Jamie Heilman <jamie@audible.transient.net>
Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
---
 net/core/dev.c |    3 ++-
 net/ipv4/arp.c |   11 +++++------
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index 7c6a46f..24ea2d7 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -749,7 +749,8 @@ EXPORT_SYMBOL(dev_get_by_index);
  *	@ha: hardware address
  *
  *	Search for an interface by MAC address. Returns NULL if the device
- *	is not found or a pointer to the device. The caller must hold RCU
+ *	is not found or a pointer to the device.
+ *	The caller must hold RCU or RTNL.
  *	The returned device has not had its ref count increased
  *	and the caller must therefore be careful about locking
  *
diff --git a/net/ipv4/arp.c b/net/ipv4/arp.c
index 04c8b69..7927589 100644
--- a/net/ipv4/arp.c
+++ b/net/ipv4/arp.c
@@ -1017,14 +1017,13 @@ static int arp_req_set_proxy(struct net *net, struct net_device *dev, int on)
 		IPV4_DEVCONF_ALL(net, PROXY_ARP) = on;
 		return 0;
 	}
-	if (__in_dev_get_rcu(dev)) {
-		IN_DEV_CONF_SET(__in_dev_get_rcu(dev), PROXY_ARP, on);
+	if (__in_dev_get_rtnl(dev)) {
+		IN_DEV_CONF_SET(__in_dev_get_rtnl(dev), PROXY_ARP, on);
 		return 0;
 	}
 	return -ENXIO;
 }
 
-/* must be called with rcu_read_lock() */
 static int arp_req_set_public(struct net *net, struct arpreq *r,
 		struct net_device *dev)
 {
@@ -1233,10 +1232,10 @@ int arp_ioctl(struct net *net, unsigned int cmd, void __user *arg)
 	if (!(r.arp_flags & ATF_NETMASK))
 		((struct sockaddr_in *)&r.arp_netmask)->sin_addr.s_addr =
 							   htonl(0xFFFFFFFFUL);
-	rcu_read_lock();
+	rtnl_lock();
 	if (r.arp_dev[0]) {
 		err = -ENODEV;
-		dev = dev_get_by_name_rcu(net, r.arp_dev);
+		dev = __dev_get_by_name(net, r.arp_dev);
 		if (dev == NULL)
 			goto out;
 
@@ -1263,7 +1262,7 @@ int arp_ioctl(struct net *net, unsigned int cmd, void __user *arg)
 		break;
 	}
 out:
-	rcu_read_unlock();
+	rtnl_unlock();
 	if (cmd == SIOCGARP && !err && copy_to_user(arg, &r, sizeof(r)))
 		err = -EFAULT;
 	return err;


