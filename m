Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932818Ab2GYDma (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 23:42:30 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:46154 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932714Ab2GYDm0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 23:42:26 -0400
From: Len Brown <lenb@kernel.org>
To: linux-acpi@vger.kernel.org, linux-pm@lists.linux-foundation.org
Cc: linux-kernel@vger.kernel.org,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Len Brown <len.brown@intel.com>
Subject: [PATCH 13/52] cpuidle: add checks to avoid NULL pointer dereference
Date: Tue, 24 Jul 2012 23:41:09 -0400
Message-Id: <1b0a0e9a15b976d91f3b5ae619c6a8964c2818eb.1343187617.git.len.brown@intel.com>
X-Mailer: git-send-email 1.7.12.rc0
In-Reply-To: <1343187708-19532-1-git-send-email-lenb@kernel.org>
References: <1343187708-19532-1-git-send-email-lenb@kernel.org>
In-Reply-To: <6af1c4fc5227af65092ebc848989693562bfa3e8.1343187617.git.len.brown@intel.com>
References: <6af1c4fc5227af65092ebc848989693562bfa3e8.1343187617.git.len.brown@intel.com>
Reply-To: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>

The existing check for dev == NULL in __cpuidle_register_device() is
rendered useless because dev is dereferenced before the check itself.
Moreover, correctly speaking, it is the job of the callers of this
function, i.e., cpuidle_register_device() & cpuidle_enable_device() (which
also happen to be exported functions) to ensure that
__cpuidle_register_device() is called with a non-NULL dev.

So add the necessary dev == NULL checks in the two callers and remove the
(useless) check from __cpuidle_register_device().

Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
Acked-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Len Brown <len.brown@intel.com>
---
 drivers/cpuidle/cpuidle.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/cpuidle/cpuidle.c b/drivers/cpuidle/cpuidle.c
index 588b44a..8ffef26 100644
--- a/drivers/cpuidle/cpuidle.c
+++ b/drivers/cpuidle/cpuidle.c
@@ -285,6 +285,9 @@ int cpuidle_enable_device(struct cpuidle_device *dev)
 	int ret, i;
 	struct cpuidle_driver *drv = cpuidle_get_driver();
 
+	if (!dev)
+		return -EINVAL;
+
 	if (dev->enabled)
 		return 0;
 	if (!drv || !cpuidle_curr_governor)
@@ -369,8 +372,6 @@ static int __cpuidle_register_device(struct cpuidle_device *dev)
 	struct device *cpu_dev = get_cpu_device((unsigned long)dev->cpu);
 	struct cpuidle_driver *cpuidle_driver = cpuidle_get_driver();
 
-	if (!dev)
-		return -EINVAL;
 	if (!try_module_get(cpuidle_driver->owner))
 		return -EINVAL;
 
@@ -395,6 +396,9 @@ int cpuidle_register_device(struct cpuidle_device *dev)
 {
 	int ret;
 
+	if (!dev)
+		return -EINVAL;
+
 	mutex_lock(&cpuidle_lock);
 
 	if ((ret = __cpuidle_register_device(dev))) {
-- 
1.7.12.rc0

