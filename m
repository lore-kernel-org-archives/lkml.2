Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755899Ab2HNKYh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 06:24:37 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:8555 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755675Ab2HNKYf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 06:24:35 -0400
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Tue, 14 Aug 2012 03:24:30 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <broonie@opensource.wolfsonmicro.com>, <lrg@ti.com>
CC: <linux-kernel@vger.kernel.org>, <rabin.vincent@gmail.com>,
        Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH] regulator: disable supply regulator if it is enabled for boot-on
Date: Tue, 14 Aug 2012 15:37:28 +0530
Message-ID: <1344938848-29606-1-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If supply regulator is enabled because of boot-on (not always-on)
then disable regulator need to be call if regulator have some
user or full constraint has been enabled.
This will make sure that reference count of supply regulator
is in sync with child regulator's state.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
Reported-by: Rabin Vincent <rabin.vincent@gmail.com>
---
 drivers/regulator/core.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index 0fffeae..4632909 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -3614,8 +3614,11 @@ static int __init regulator_init_complete(void)
 
 		mutex_lock(&rdev->mutex);
 
-		if (rdev->use_count)
+		if (rdev->use_count) {
+			if (rdev->supply && c->boot_on)
+				regulator_disable(rdev->supply);
 			goto unlock;
+		}
 
 		/* If we can't read the status assume it's on. */
 		if (ops->is_enabled)
@@ -3634,6 +3637,8 @@ static int __init regulator_init_complete(void)
 			if (ret != 0) {
 				rdev_err(rdev, "couldn't disable: %d\n", ret);
 			}
+			if (rdev->supply)
+				regulator_disable(rdev->supply);
 		} else {
 			/* The intention is that in future we will
 			 * assume that full constraints are provided
-- 
1.7.1.1

