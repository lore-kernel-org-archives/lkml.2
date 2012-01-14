Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750853Ab2ANFFM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jan 2012 00:05:12 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:48586 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750761Ab2ANFFK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jan 2012 00:05:10 -0500
MIME-Version: 1.0
Date: Sat, 14 Jan 2012 13:05:08 +0800
Message-ID: <CADxeRw=_Qx+dcZHJZnq1tAStvsuCWrsARgyxP=aKC0WfLWHZLw@mail.gmail.com>
Subject: [PATCH] mmc: fix deadlock from mmc core when suspend the device
From: Steven Liu <lingjiujianke@gmail.com>
To: cjb@laptop.org, linux-mmc@vger.kernel.org, liuqi@thundersoft.com,
        qinjian@thundersoft.com
Cc: linux-kernel@vger.kernel.org, Greg KH <greg@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Chris Ball & Greg KH,

This patch can fix the mmc deadlock when suspen the mmc devices.

when mmc_pm_notify to do the host->bus_ops->remove, there is deadlock,
because it was locked at mmc_claim_host, so it modify the mmc_claim_host
after the host->bus_ops->remove.
the problem can reproduce at lots of the emmc/sd devices when create
multi partitions,and I have tested this modify at lots of the platform.

Can this patch fixed?

Signed-off-by: LiuQi <liuqi@thundersoft.com>
Signed-off-by: Jack Qin <qinjian@thundersoft.com>

---
 drivers/mmc/core/core.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/mmc/core/core.c b/drivers/mmc/core/core.c
index 950b97d..e68a0e8 100644
--- a/drivers/mmc/core/core.c
+++ b/drivers/mmc/core/core.c
@@ -2431,11 +2431,10 @@ int mmc_pm_notify(struct notifier_block *notify_block,
                if (!host->bus_ops || host->bus_ops->suspend)
                        break;

-               mmc_claim_host(host);
-
                if (host->bus_ops->remove)
                        host->bus_ops->remove(host);

+               mmc_claim_host(host);
                mmc_detach_bus(host);
                mmc_power_off(host);
                mmc_release_host(host);
--
1.7.7




Thanks
