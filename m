Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754656Ab2L1Ttq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2012 14:49:46 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:55110 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754587Ab2L1TRr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2012 14:17:47 -0500
Message-Id: <20121228190400.145063929@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Fri, 28 Dec 2012 20:06:02 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        "nikolay@redhat.com" <nikolay@redhat.com>,
        Jay Vosburgh <fubar@us.ibm.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 152/173] bonding: fix race condition in  bonding_store_slaves_active
In-Reply-To: <20121228190330.025298996@decadent.org.uk>
X-SA-Exim-Connect-IP: 151.217.219.220
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "nikolay@redhat.com" <nikolay@redhat.com>

[ Upstream commit e196c0e579902f42cf72414461fb034e5a1ffbf7 ]

Race between bonding_store_slaves_active() and slave manipulation
 functions. The bond_for_each_slave use in bonding_store_slaves_active()
 is not protected by any synchronization mechanism.
 NULL pointer dereference is easy to reach.
 Fixed by acquiring the bond->lock for the slave walk.

 v2: Make description text < 75 columns

Signed-off-by: Nikolay Aleksandrov <nikolay@redhat.com>
Signed-off-by: Jay Vosburgh <fubar@us.ibm.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/bonding/bond_sysfs.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/bonding/bond_sysfs.c b/drivers/net/bonding/bond_sysfs.c
index 4ef7e2f..a03fde9 100644
--- a/drivers/net/bonding/bond_sysfs.c
+++ b/drivers/net/bonding/bond_sysfs.c
@@ -1579,6 +1579,7 @@ static ssize_t bonding_store_slaves_active(struct device *d,
 		goto out;
 	}
 
+	read_lock(&bond->lock);
 	bond_for_each_slave(bond, slave, i) {
 		if (!bond_is_active_slave(slave)) {
 			if (new_value)
@@ -1587,6 +1588,7 @@ static ssize_t bonding_store_slaves_active(struct device *d,
 				slave->inactive = 1;
 		}
 	}
+	read_unlock(&bond->lock);
 out:
 	return ret;
 }


