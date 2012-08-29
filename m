Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753960Ab2H2PO4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2012 11:14:56 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:12859 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753913Ab2H2POy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2012 11:14:54 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Wed, 29 Aug 2012 08:08:30 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <lrg@ti.com>, <broonie@opensource.wolfsonmicro.com>,
        <rabin.vincent@gmail.com>
CC: <linux-kernel@vger.kernel.org>, Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH V2] regulator: disable supply regulator if it is enabled for boot-on
Date: Wed, 29 Aug 2012 20:23:09 +0530
Message-ID: <1346251989-26537-1-git-send-email-ldewangan@nvidia.com>
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
Changes from V1:
Rabin reported that the nested locking trace is getting generated.
This is because the regulator lock mutex and disable himself and then
call for supply disable which again lock the regulator lock.
Probably because both lock is taken from regulator structure in nested
manner, the trace is getting generated.
Rewritten patch to avoid nested locking.

 drivers/regulator/core.c |   10 +++++++++-
 1 files changed, 9 insertions(+), 1 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index 06186ba..e54537f 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -3606,6 +3606,7 @@ static int __init regulator_init_complete(void)
 	 * default behaviour in the future.
 	 */
 	list_for_each_entry(rdev, &regulator_list, list) {
+		bool supply_disable = false;
 		ops = rdev->desc->ops;
 		c = rdev->constraints;
 
@@ -3614,8 +3615,11 @@ static int __init regulator_init_complete(void)
 
 		mutex_lock(&rdev->mutex);
 
-		if (rdev->use_count)
+		if (rdev->use_count) {
+			if (rdev->supply && c->boot_on)
+				supply_disable = true;
 			goto unlock;
+		}
 
 		/* If we can't read the status assume it's on. */
 		if (ops->is_enabled)
@@ -3634,6 +3638,8 @@ static int __init regulator_init_complete(void)
 			if (ret != 0) {
 				rdev_err(rdev, "couldn't disable: %d\n", ret);
 			}
+			if (rdev->supply)
+				supply_disable = true;
 		} else {
 			/* The intention is that in future we will
 			 * assume that full constraints are provided
@@ -3645,6 +3651,8 @@ static int __init regulator_init_complete(void)
 
 unlock:
 		mutex_unlock(&rdev->mutex);
+		if (supply_disable)
+			regulator_disable(rdev->supply);
 	}
 
 	mutex_unlock(&regulator_list_mutex);
-- 
1.7.1.1

