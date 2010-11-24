Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756477Ab0KXXMT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 18:12:19 -0500
Received: from mail-ew0-f46.google.com ([209.85.215.46]:56670 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754905Ab0KXXMP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 18:12:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=c3bEy5j25LLrNnSjNf3FMzSiVdaMg401KSev5I3PYxHAFWrhCRLKHCv8Fv316Y5jZ9
         ncuZRZL0ciYyXUfMfCQgESjQ0wOmUibOM6W+GYjDTh6J+B7aoaHKfCabN67dc2udu9DJ
         0z5tqBmJ+W9EmPCt/ItGwHl7qHCPa0lYc40b0=
MIME-Version: 1.0
Date: Wed, 24 Nov 2010 15:12:14 -0800
Message-ID: <AANLkTinpO=FmoecfV8epubXU4OrhFsXJ7-Kc68yNhMEs@mail.gmail.com>
Subject: [PATCH] bonding: check for assigned mac before adopting the slaves
 mac address
From: David Strand <dpstrand@gmail.com>
To: netdev@vger.kernel.org
Cc: Jay Vosburgh <fubar@us.ibm.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Restore the check for a missing mac address before adopting the first
slaves as it's own. This regression was introduced in:
http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.36.y.git;a=commit;h=c20811a79e671a6a1fe86a8c1afe04aca8a7f085

Signed-off-by: David Strand dpstrand@gmail.com
---
diff -uprN a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
--- a/drivers/net/bonding/bond_main.c	2010-11-24 11:36:58.125640000 -0800
+++ b/drivers/net/bonding/bond_main.c	2010-11-24 11:40:58.175640000 -0800
@@ -1577,8 +1577,9 @@ int bond_enslave(struct net_device *bond
 	/* If this is the first slave, then we need to set the master's hardware
 	 * address to be the same as the slave's. */
 	if (bond->slave_cnt == 0)
-		memcpy(bond->dev->dev_addr, slave_dev->dev_addr,
-		       slave_dev->addr_len);
+		if (is_zero_ether_addr(bond->dev->dev_addr))
+			memcpy(bond->dev->dev_addr, slave_dev->dev_addr,
+			       slave_dev->addr_len);


 	new_slave = kzalloc(sizeof(struct slave), GFP_KERNEL);
