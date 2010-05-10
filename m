Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932687Ab0EJWyW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 18:54:22 -0400
Received: from kroah.org ([198.145.64.141]:33316 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932499Ab0EJWwn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 18:52:43 -0400
X-Mailbox-Line: From gregkh@kvm.kroah.org Mon May 10 15:33:25 2010
Message-Id: <20100510223324.978467474@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Mon, 10 May 2010 15:32:55 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Stefan Schmidt <stefan@datenfreihafen.org>,
       Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
       "David S. Miller" <davem@davemloft.net>
Subject: [084/117] ieee802154: Fix oops during ieee802154_sock_ioctl
In-Reply-To: <20100510223700.GA18404@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let us know.

------------------


From: Stefan Schmidt <stefan@datenfreihafen.org>

[ Upstream commit 93c0c8b4a5a174645550d444bd5c3ff0cccf74cb ]

Trying to run izlisten (from lowpan-tools tests) on a device that does not
exists I got the oops below. The problem is that we are using get_dev_by_name
without checking if we really get a device back. We don't in this case and
writing to dev->type generates this oops.

[Oops code removed by Dmitry Eremin-Solenikov]

If possible this patch should be applied to the current -rc fixes branch.

Signed-off-by: Stefan Schmidt <stefan@datenfreihafen.org>
Signed-off-by: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 net/ieee802154/af_ieee802154.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/net/ieee802154/af_ieee802154.c
+++ b/net/ieee802154/af_ieee802154.c
@@ -147,6 +147,9 @@ static int ieee802154_dev_ioctl(struct s
 	dev_load(sock_net(sk), ifr.ifr_name);
 	dev = dev_get_by_name(sock_net(sk), ifr.ifr_name);
 
+	if (!dev)
+		return -ENODEV;
+
 	if (dev->type == ARPHRD_IEEE802154 && dev->netdev_ops->ndo_do_ioctl)
 		ret = dev->netdev_ops->ndo_do_ioctl(dev, &ifr, cmd);
 


