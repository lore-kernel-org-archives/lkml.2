Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753228Ab2D3HBd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2012 03:01:33 -0400
Received: from e28smtp03.in.ibm.com ([122.248.162.3]:45347 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751433Ab2D3HBb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2012 03:01:31 -0400
Message-ID: <4F9E38A7.9030209@linux.vnet.ibm.com>
Date: Mon, 30 Apr 2012 12:30:55 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: lenb@kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>
CC: Daniel Lezcano <daniel.lezcano@linaro.org>, khilman@ti.com,
        Deepthi Dharwar <deepthi@linux.vnet.ibm.com>, g.trinabh@gmail.com,
        Arjan van de Ven <arjan@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux PM mailing list <linux-pm@vger.kernel.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: [PATCH v2][RESEND] cpuidle: Add checks to avoid NULL pointer dereference
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 12043007-3864-0000-0000-0000027CAFD2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>

The existing check for dev == NULL in __cpuidle_register_device() is rendered
useless because dev is dereferenced before the check itself. Moreover,
correctly speaking, it is the job of the callers of this function, i.e.,
cpuidle_register_device() & cpuidle_enable_device() (which also happen to be
exported functions) to ensure that __cpuidle_register_device() is called with
a non-NULL dev.

So add the necessary dev == NULL checks in the two callers and remove the
(useless) check from __cpuidle_register_device().

Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
Acked-by: Daniel Lezcano <daniel.lezcano@linaro.org>
---

 drivers/cpuidle/cpuidle.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/cpuidle/cpuidle.c b/drivers/cpuidle/cpuidle.c
index 87411ce..eae2f11 100644
--- a/drivers/cpuidle/cpuidle.c
+++ b/drivers/cpuidle/cpuidle.c
@@ -291,6 +291,9 @@ int cpuidle_enable_device(struct cpuidle_device *dev)
 	int ret, i;
 	struct cpuidle_driver *drv = cpuidle_get_driver();

+	if (!dev)
+		return -EINVAL;
+
 	if (dev->enabled)
 		return 0;
 	if (!drv || !cpuidle_curr_governor)
@@ -375,8 +378,6 @@ static int __cpuidle_register_device(struct cpuidle_device *dev)
 	struct device *cpu_dev = get_cpu_device((unsigned long)dev->cpu);
 	struct cpuidle_driver *cpuidle_driver = cpuidle_get_driver();

-	if (!dev)
-		return -EINVAL;
 	if (!try_module_get(cpuidle_driver->owner))
 		return -EINVAL;

@@ -401,6 +402,9 @@ int cpuidle_register_device(struct cpuidle_device *dev)
 {
 	int ret;

+	if (!dev)
+		return -EINVAL;
+
 	mutex_lock(&cpuidle_lock);

 	if ((ret = __cpuidle_register_device(dev))) {


