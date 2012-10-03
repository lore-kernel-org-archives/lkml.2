Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756571Ab2JCVuz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 17:50:55 -0400
Received: from oproxy11-pub.bluehost.com ([173.254.64.10]:39589 "HELO
	oproxy11-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756434Ab2JCVux (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 17:50:53 -0400
Message-ID: <506CB331.8000101@xenotime.net>
Date: Wed, 03 Oct 2012 14:50:41 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Roland Dreier <roland@kernel.org>, Sean Hefty <sean.hefty@intel.com>,
        Hal Rosenstock <hal.rosenstock@gmail.com>, linux-rdma@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH -next] infiniband: fix ipoib build error when IPOIB_CM is
 not enabled
References: <20121003173007.c322d79c31676b9494a6bfd5@canb.auug.org.au>
In-Reply-To: <20121003173007.c322d79c31676b9494a6bfd5@canb.auug.org.au>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <rdunlap@xenotime.net>

Fix build error when INFINIBAND_IPOIB_CM is not enabled:

ERROR: "ipoib_set_mode" [drivers/infiniband/ulp/ipoib/ib_ipoib.ko] undefined!

Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
Cc:	Roland Dreier <roland@kernel.org>
Cc:	Sean Hefty <sean.hefty@intel.com>
Cc:	Hal Rosenstock <hal.rosenstock@gmail.com>
Cc:	linux-rdma@vger.kernel.org
---
 drivers/infiniband/ulp/ipoib/ipoib_netlink.c |    3 +++
 1 file changed, 3 insertions(+)

--- linux-next-20121003.orig/drivers/infiniband/ulp/ipoib/ipoib_netlink.c
+++ linux-next-20121003/drivers/infiniband/ulp/ipoib/ipoib_netlink.c
@@ -30,6 +30,7 @@
  * SOFTWARE.
  */
 
+#include <linux/kconfig.h>
 #include <linux/netdevice.h>
 #include <linux/module.h>
 #include <net/rtnetlink.h>
@@ -71,11 +72,13 @@ static int ipoib_changelink(struct net_d
 
 	if (data[IFLA_IPOIB_MODE]) {
 		mode  = nla_get_u16(data[IFLA_IPOIB_MODE]);
+#if IS_ENABLED(CONFIG_INFINIBAND_IPOIB_CM)
 		if (mode == IPOIB_MODE_DATAGRAM)
 			ret = ipoib_set_mode(dev, "datagram\n");
 		else if (mode == IPOIB_MODE_CONNECTED)
 			ret = ipoib_set_mode(dev, "connected\n");
 		else
+#endif
 			ret = -EINVAL;
 
 		if (ret < 0)
