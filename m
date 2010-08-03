Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757613Ab0HCTPe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 15:15:34 -0400
Received: from mail3.microsoft.com ([131.107.115.214]:47020 "EHLO
	smtp.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756486Ab0HCTPd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 15:15:33 -0400
From: Haiyang Zhang <haiyangz@microsoft.com>
To: "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
        "'devel@driverdev.osuosl.org'" <devel@driverdev.osuosl.org>,
        "'virtualization@lists.osdl.org'" <virtualization@lists.osdl.org>,
        "'gregkh@suse.de'" <gregkh@suse.de>
CC: Hank Janssen <hjanssen@microsoft.com>
Subject: [PATCH 1/1] staging: hv: Fix missing functions for net_device_ops
 (with detailed comments)
Thread-Topic: [PATCH 1/1] staging: hv: Fix missing functions for
 net_device_ops (with detailed comments)
Thread-Index: AQHLM0A+deqJlZ0oK0OJRsT0SGQqJg==
Date: Tue, 3 Aug 2010 19:15:31 +0000
Message-ID: <1FB5E1D5CA062146B38059374562DF728380C37B@TK5EX14MBXC126.redmond.corp.microsoft.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.54.123.12]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Haiyang Zhang <haiyangz@microsoft.com>

Fix missing functions for net_device_ops.
It's a bug when porting Linux IC from 2.6.27 to 2.6.32. In 2.6.27,
the default functions for Ethernet, like eth_change_mtu(), were assigned
by ether_setup(). But in 2.6.32, these function pointers moved to
net_device_ops structure and no longer be assigned in ether_setup(). So we
need to set these functions in our driver code. It will ensure the MTU won't
be set beyond 1500. Otherwise, this can cause an error on the server side,
because the HyperV linux driver doesn't support jumbo frame yet.

Requesting it to be backported to kernel 2.6.32 and later, which are all
versions containing Hyper-V drivers.

Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>

---
 drivers/staging/hv/netvsc_drv.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/hv/netvsc_drv.c b/drivers/staging/hv/netvsc_drv.c
index 56e1157..64a0114 100644
--- a/drivers/staging/hv/netvsc_drv.c
+++ b/drivers/staging/hv/netvsc_drv.c
@@ -327,6 +327,9 @@ static const struct net_device_ops device_ops = {
 	.ndo_stop =			netvsc_close,
 	.ndo_start_xmit =		netvsc_start_xmit,
 	.ndo_set_multicast_list =	netvsc_set_multicast_list,
+	.ndo_change_mtu =		eth_change_mtu,
+	.ndo_validate_addr =		eth_validate_addr,
+	.ndo_set_mac_address =		eth_mac_addr,
 };
 
 static int netvsc_probe(struct device *device)
-- 
1.6.3.2

