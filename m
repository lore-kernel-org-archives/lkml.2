Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755892Ab0EaDT6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 May 2010 23:19:58 -0400
Received: from mga03.intel.com ([143.182.124.21]:47327 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755845Ab0EaDT5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 May 2010 23:19:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,330,1272870000"; 
   d="scan'208";a="283087551"
Date: Mon, 31 May 2010 11:19:53 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>, Andi Kleen <andi@firstfloor.org>
Subject: [PATCH] ipconfig: send host-name in DHCP requests
Message-ID: <20100531031953.GA10590@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Normally dhclient can be configured to send the "host-name" option
in DHCP requests to update the client's DNS record. However for an
NFSROOT system, dhclient shall never be called (which may change the
IP addr and therefore lose your root NFS mount connection).

So enable updating the DNS record with kernel parameter

	ip=::::$HOST_NAME::dhcp

Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 net/ipv4/ipconfig.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/net/ipv4/ipconfig.c b/net/ipv4/ipconfig.c
index 067ce9e..db54343 100644
--- a/net/ipv4/ipconfig.c
+++ b/net/ipv4/ipconfig.c
@@ -665,6 +665,13 @@ ic_dhcp_init_options(u8 *options)
 		memcpy(e, ic_req_params, sizeof(ic_req_params));
 		e += sizeof(ic_req_params);
 
+		if (ic_host_name_set) {
+			*e++ = 12;	/* host-name */
+			len = strlen(utsname()->nodename);
+			*e++ = len;
+			memcpy(e, utsname()->nodename, len);
+			e += len;
+		}
 		if (*vendor_class_identifier) {
 			printk(KERN_INFO "DHCP: sending class identifier \"%s\"\n",
 			       vendor_class_identifier);
-- 
1.6.6

