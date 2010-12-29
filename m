Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753204Ab0L2Nkj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Dec 2010 08:40:39 -0500
Received: from cantor.suse.de ([195.135.220.2]:50545 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752595Ab0L2Nkg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Dec 2010 08:40:36 -0500
From: David Sterba <dsterba@suse.cz>
To: mcarlson@broadcom.com
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        David Sterba <dsterba@suse.cz>, Michael Chan <mchan@broadcom.com>
Subject: [PATCH v2] tg3: fix return value check in tg3_read_vpd()
Date: Wed, 29 Dec 2010 14:40:31 +0100
Message-Id: <1293630031-27372-1-git-send-email-dsterba@suse.cz>
X-Mailer: git-send-email 1.7.4.rc0
In-Reply-To: <201012291417.24424.dsterba@suse.cz>
References: <201012291417.24424.dsterba@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Besides -ETIMEDOUT and -EINTR, pci_read_vpd may return other error
values like -ENODEV or -EINVAL which are ignored due to the buggy
check, but the data are not read from VPD anyway and this is checked
subsequently with at most 3 needless loop iterations. This does not
show up as a runtime bug.

CC: Matt Carlson <mcarlson@broadcom.com>
CC: Michael Chan <mchan@broadcom.com>
Signed-off-by: David Sterba <dsterba@suse.cz>
---
 drivers/net/tg3.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/tg3.c b/drivers/net/tg3.c
index 30ccbb6..6f97b7b 100644
--- a/drivers/net/tg3.c
+++ b/drivers/net/tg3.c
@@ -12658,7 +12658,7 @@ static void __devinit tg3_read_vpd(struct tg3 *tp)
 			cnt = pci_read_vpd(tp->pdev, pos,
 					   TG3_NVM_VPD_LEN - pos,
 					   &vpd_data[pos]);
-			if (cnt == -ETIMEDOUT || -EINTR)
+			if (cnt == -ETIMEDOUT || cnt == -EINTR)
 				cnt = 0;
 			else if (cnt < 0)
 				goto out_not_found;
-- 
1.7.4.rc0

