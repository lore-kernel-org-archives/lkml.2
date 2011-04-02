Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753770Ab1DBOI1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Apr 2011 10:08:27 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:63345 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752168Ab1DBOIZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Apr 2011 10:08:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:mime-version
         :content-type:content-transfer-encoding;
        b=JdYEOF5LS43j7LzfbUezvF5jXe6Npa34lUH+i9rnQajh+83hOqisCyYP+w+Noz/MmF
         5VMSlLB/cPWg3VEjcp6AkX4aW/xdCtqJhFkIuEJ2L0N7VLp4L13y+MtjY8sGGAnIYD7/
         NvF9TJIAhC0H5tcXXVFxcfWnzWJ0My4r6Ifjk=
From: =?UTF-8?q?Weiping=20Pan=28=E6=BD=98=E5=8D=AB=E5=B9=B3=29?= 
	<panweiping3@gmail.com>
Cc: =?UTF-8?q?Weiping=20Pan (=E6=BD=98=E5=8D=AB=E5=B9=B3) ?= 
	<panweiping3@gmail.com>,
        Jay Vosburgh <fubar@us.ibm.com> (supporter:BONDING DRIVER),
        Andy Gospodarek <andy@greyhouse.net> (supporter:BONDING DRIVER),
        netdev@vger.kernel.org (open list:BONDING DRIVER),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] bonding-tlb: better balance when choosing slaves
Date: Sat,  2 Apr 2011 22:09:54 +0800
Message-Id: <1301753395-1205-1-git-send-email-panweiping3@gmail.com>
X-Mailer: git-send-email 1.7.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

tlb_get_least_loaded_slave() always chooses slave from
bonding->first_slave, that gives the beginnig slaves more chances to be used.

Let tlb_get_least_loaded_slave() chooses slave from a random positon in the
slave list, make all slaves transmit packets more balanced.

Signed-off-by: Weiping Pan(潘卫平) <panweiping3@gmail.com>
---
 drivers/net/bonding/bond_alb.c |   17 +++++++++++++++--
 1 files changed, 15 insertions(+), 2 deletions(-)

diff --git a/drivers/net/bonding/bond_alb.c b/drivers/net/bonding/bond_alb.c
index 9bc5de3..9fa64b0 100644
--- a/drivers/net/bonding/bond_alb.c
+++ b/drivers/net/bonding/bond_alb.c
@@ -36,6 +36,7 @@
 #include <linux/if_bonding.h>
 #include <linux/if_vlan.h>
 #include <linux/in.h>
+#include <linux/random.h>
 #include <net/ipx.h>
 #include <net/arp.h>
 #include <net/ipv6.h>
@@ -206,15 +207,27 @@ static long long compute_gap(struct slave *slave)
 /* Caller must hold bond lock for read */
 static struct slave *tlb_get_least_loaded_slave(struct bonding *bond)
 {
-	struct slave *slave, *least_loaded;
+	struct slave *slave, *least_loaded, *start_slave;
 	long long max_gap;
 	int i;
+	u8 n;
 
 	least_loaded = NULL;
+	start_slave = bond->first_slave;
 	max_gap = LLONG_MIN;
+        
+	get_random_bytes(&n, 1);
+
+	if (bond->slave_cnt == 0)
+		return NULL;
+	n = n % bond->slave_cnt;
+
+	for (i=0; i<n; ++i) {
+		start_slave = start_slave->next;
+	}
 
 	/* Find the slave with the largest gap */
-	bond_for_each_slave(bond, slave, i) {
+	bond_for_each_slave_from(bond, slave, i, start_slave) {
 		if (SLAVE_IS_OK(slave)) {
 			long long gap = compute_gap(slave);
 
-- 
1.7.4

