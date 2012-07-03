Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933337Ab2GCCVL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 22:21:11 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:51104 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932139Ab2GCCVJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 22:21:09 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6760"; a="206930594"
From: Stephen Boyd <sboyd@codeaurora.org>
To: Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] regulator: Fix recursive mutex lockdep warning
Date: Mon,  2 Jul 2012 19:21:06 -0700
Message-Id: <1341282066-15325-1-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.7.11.1.59.gbc9e7dd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A recursive lockdep warning occurs if you call
regulator_set_optimum_mode() on a regulator with a supply because
there is no nesting annotation for the rdev->mutex. To avoid this
warning, get the supply's load before locking the regulator's
mutex to avoid grabbing the same class of lock twice.

=============================================
[ INFO: possible recursive locking detected ]
3.4.0 #3257 Tainted: G        W
---------------------------------------------
swapper/0/1 is trying to acquire lock:
 (&rdev->mutex){+.+.+.}, at: [<c036e9e0>] regulator_get_voltage+0x18/0x38

but task is already holding lock:
 (&rdev->mutex){+.+.+.}, at: [<c036ef38>] regulator_set_optimum_mode+0x24/0x224

other info that might help us debug this:
 Possible unsafe locking scenario:

       CPU0
       ----
  lock(&rdev->mutex);
  lock(&rdev->mutex);

 *** DEADLOCK ***

 May be due to missing lock nesting notation

3 locks held by swapper/0/1:
 #0:  (&__lockdep_no_validate__){......}, at: [<c03dbb48>] __driver_attach+0x40/0x8c
 #1:  (&__lockdep_no_validate__){......}, at: [<c03dbb58>] __driver_attach+0x50/0x8c
 #2:  (&rdev->mutex){+.+.+.}, at: [<c036ef38>] regulator_set_optimum_mode+0x24/0x224

stack backtrace:
[<c001521c>] (unwind_backtrace+0x0/0x12c) from [<c00cc4d4>] (validate_chain+0x760/0x1080)
[<c00cc4d4>] (validate_chain+0x760/0x1080) from [<c00cd744>] (__lock_acquire+0x950/0xa10)
[<c00cd744>] (__lock_acquire+0x950/0xa10) from [<c00cd990>] (lock_acquire+0x18c/0x1e8)
[<c00cd990>] (lock_acquire+0x18c/0x1e8) from [<c080c248>] (mutex_lock_nested+0x68/0x3c4)
[<c080c248>] (mutex_lock_nested+0x68/0x3c4) from [<c036e9e0>] (regulator_get_voltage+0x18/0x38)
[<c036e9e0>] (regulator_get_voltage+0x18/0x38) from [<c036efb8>] (regulator_set_optimum_mode+0xa4/0x224)
...

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---

I'm not sure if this is the preferred solution. I also believe there is a
similar warning in regulator_enable()/disable() when drms_uA_update() is
called.

Is anything wrong with regulator_get_voltage() never taking the mutex?
If we did that then this lockdep warning would go away in addition to the
one in drms_uA_update().

 drivers/regulator/core.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index ef07b62..db119f3 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -2544,9 +2544,12 @@ int regulator_set_optimum_mode(struct regulator *regulator, int uA_load)
 {
 	struct regulator_dev *rdev = regulator->rdev;
 	struct regulator *consumer;
-	int ret, output_uV, input_uV, total_uA_load = 0;
+	int ret, output_uV, input_uV = 0, total_uA_load = 0;
 	unsigned int mode;
 
+	if (rdev->supply)
+		input_uV = regulator_get_voltage(rdev->supply);
+
 	mutex_lock(&rdev->mutex);
 
 	/*
@@ -2579,10 +2582,7 @@ int regulator_set_optimum_mode(struct regulator *regulator, int uA_load)
 		goto out;
 	}
 
-	/* get input voltage */
-	input_uV = 0;
-	if (rdev->supply)
-		input_uV = regulator_get_voltage(rdev->supply);
+	/* No supply? Use constraint voltage */
 	if (input_uV <= 0)
 		input_uV = rdev->constraints->input_uV;
 	if (input_uV <= 0) {
-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

