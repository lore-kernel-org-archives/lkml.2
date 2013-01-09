Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932683Ab3AIUg3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 15:36:29 -0500
Received: from mail.kernel.org ([198.145.19.201]:40863 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932395Ab3AIUgX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 15:36:23 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Nikolay Aleksandrov <nikolay@redhat.com>,
        Jay Vosburgh <fubar@us.ibm.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 02/47] bonding: fix race condition in bonding_store_slaves_active
Date: Wed,  9 Jan 2013 12:34:57 -0800
Message-Id: <20130109201729.739090097@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130109201729.435233560@linuxfoundation.org>
References: <20130109201729.435233560@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/bonding/bond_sysfs.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/net/bonding/bond_sysfs.c
+++ b/drivers/net/bonding/bond_sysfs.c
@@ -1524,6 +1524,7 @@ static ssize_t bonding_store_slaves_acti
 		goto out;
 	}
 
+	read_lock(&bond->lock);
 	bond_for_each_slave(bond, slave, i) {
 		if (!bond_is_active_slave(slave)) {
 			if (new_value)
@@ -1532,6 +1533,7 @@ static ssize_t bonding_store_slaves_acti
 				slave->inactive = 1;
 		}
 	}
+	read_unlock(&bond->lock);
 out:
 	return ret;
 }


