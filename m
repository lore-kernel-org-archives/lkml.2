Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754783Ab0INPDZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 11:03:25 -0400
Received: from mxout1.idt.com ([157.165.5.25]:56630 "EHLO mxout1.idt.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754653Ab0INPDX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 11:03:23 -0400
From: Alexandre Bounine <alexandre.bounine@idt.com>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
Cc: Alexandre Bounine <alexandre.bounine@idt.com>,
        Thomas Moll <thomas.moll@sysgo.com>,
        Matt Porter <mporter@kernel.crashing.org>,
        Li Yang <leoli@freescale.com>, Kumar Gala <galak@kernel.crashing.org>,
        Micha Nelissen <micha@neli.hopto.org>
Subject: [PATCH v2 08/10] RapidIO: Add device access check into the enumeration
Date: Tue, 14 Sep 2010 10:59:21 -0400
Message-Id: <1284476363-1677-9-git-send-email-alexandre.bounine@idt.com>
X-Mailer: git-send-email 1.7.0.5
In-Reply-To: <1284476363-1677-1-git-send-email-alexandre.bounine@idt.com>
References: <1284476363-1677-1-git-send-email-alexandre.bounine@idt.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add explicit device access check before performing device enumeration.
This gives a chance to clear possible link error conditions by issuing safe
maintenance read request(s).

Signed-off-by: Alexandre Bounine <alexandre.bounine@idt.com>
Cc: Thomas Moll <thomas.moll@sysgo.com>
Cc: Matt Porter <mporter@kernel.crashing.org>
Cc: Li Yang <leoli@freescale.com>
Cc: Kumar Gala <galak@kernel.crashing.org>
Cc: Micha Nelissen <micha@neli.hopto.org>
---
 drivers/rapidio/rio-scan.c |    6 ++++++
 drivers/rapidio/rio.c      |    2 +-
 drivers/rapidio/rio.h      |    2 ++
 3 files changed, 9 insertions(+), 1 deletions(-)

diff --git a/drivers/rapidio/rio-scan.c b/drivers/rapidio/rio-scan.c
index d2ea018..e3efdf9 100644
--- a/drivers/rapidio/rio-scan.c
+++ b/drivers/rapidio/rio-scan.c
@@ -762,6 +762,12 @@ static int __devinit rio_enum_peer(struct rio_net *net, struct rio_mport *port,
 	u16 destid;
 	int tmp;
 
+	if (rio_mport_chk_dev_access(port,
+			RIO_ANY_DESTID(port->sys_size), hopcount)) {
+		pr_debug("RIO: device access check failed\n");
+		return -1;
+	}
+
 	if (rio_get_host_deviceid_lock(port, hopcount) == port->host_deviceid) {
 		pr_debug("RIO: PE already discovered by this host\n");
 		/*
diff --git a/drivers/rapidio/rio.c b/drivers/rapidio/rio.c
index aefc2a0..fa5e3cb 100644
--- a/drivers/rapidio/rio.c
+++ b/drivers/rapidio/rio.c
@@ -546,7 +546,7 @@ err_out:
  * @destid: Device destination ID in network
  * @hopcount: Number of hops into the network
  */
-static int
+int
 rio_mport_chk_dev_access(struct rio_mport *mport, u16 destid, u8 hopcount)
 {
 	int i = 0;
diff --git a/drivers/rapidio/rio.h b/drivers/rapidio/rio.h
index bc71ba1..d249a12 100644
--- a/drivers/rapidio/rio.h
+++ b/drivers/rapidio/rio.h
@@ -24,6 +24,8 @@ extern u32 rio_mport_get_physefb(struct rio_mport *port, int local,
 				 u16 destid, u8 hopcount);
 extern u32 rio_mport_get_efb(struct rio_mport *port, int local, u16 destid,
 			     u8 hopcount, u32 from);
+extern int rio_mport_chk_dev_access(struct rio_mport *mport, u16 destid,
+				    u8 hopcount);
 extern int rio_create_sysfs_dev_files(struct rio_dev *rdev);
 extern int rio_enum_mport(struct rio_mport *mport);
 extern int rio_disc_mport(struct rio_mport *mport);
-- 
1.7.0.5

