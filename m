Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934503Ab1KJDZK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 22:25:10 -0500
Received: from cantor2.suse.de ([195.135.220.15]:42117 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933981Ab1KJDZE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 22:25:04 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  9 13:27:07 2011
Message-Id: <20111109212707.341886033@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 09 Nov 2011 13:26:31 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, David Woodhouse <David.Woodhouse@intel.com>,
        =?ISO-8859-15?q?Sjur=20Br=C3=A6ndeland?= 
	<sjur.brandeland@stericsson.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [069/262] caif: Fix BUG() with network namespaces
In-Reply-To: <20111109212847.GA20838@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Woodhouse <dwmw2@infradead.org>

commit 08613e4626c06ca408fc55071f6aedee36986a87 upstream.

The caif code will register its own pernet_operations, and then register
a netdevice_notifier. Each time the netdevice_notifier is triggered,
it'll do some stuff... including a lookup of its own pernet stuff with
net_generic().

If the net_generic() call ever returns NULL, the caif code will BUG().
That doesn't seem *so* unreasonable, I suppose — it does seem like it
should never happen.

However, it *does* happen. When we clone a network namespace,
setup_net() runs through all the pernet_operations one at a time. It
gets to loopback before it gets to caif. And loopback_net_init()
registers a netdevice... while caif hasn't been initialised. So the caif
netdevice notifier triggers, and immediately goes BUG().

We could imagine a complex and overengineered solution to this generic
class of problems, but this patch takes the simple approach. It just
makes caif_device_notify() *not* go looking for its pernet data
structures if the device it's being notified about isn't a caif device
in the first place.

Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>
Acked-by: Sjur Brændeland <sjur.brandeland@stericsson.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/caif/caif_dev.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/net/caif/caif_dev.c
+++ b/net/caif/caif_dev.c
@@ -209,8 +209,7 @@ static int caif_device_notify(struct not
 	enum cfcnfg_phy_preference pref;
 	enum cfcnfg_phy_type phy_type;
 	struct cfcnfg *cfg;
-	struct caif_device_entry_list *caifdevs =
-	    caif_device_list(dev_net(dev));
+	struct caif_device_entry_list *caifdevs;
 
 	if (dev->type != ARPHRD_CAIF)
 		return 0;
@@ -219,6 +218,8 @@ static int caif_device_notify(struct not
 	if (cfg == NULL)
 		return 0;
 
+	caifdevs = caif_device_list(dev_net(dev));
+
 	switch (what) {
 	case NETDEV_REGISTER:
 		caifd = caif_device_alloc(dev);


