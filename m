Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754492Ab2HNMTh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 08:19:37 -0400
Received: from queue01.mail.zen.net.uk ([212.23.3.234]:42987 "EHLO
	queue01.mail.zen.net.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752233Ab2HNMTg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 08:19:36 -0400
X-Greylist: delayed 1555 seconds by postgrey-1.27 at vger.kernel.org; Tue, 14 Aug 2012 08:19:36 EDT
Message-ID: <1344945151.2674.56.camel@linaro1.home>
Subject: [PATCH] cpuidle: Prevent null pointer dereference in
 cpuidle_coupled_cpu_notify
From: "Jon Medhurst (Tixy)" <tixy@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: Colin Cross <ccross@android.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Len Brown <len.brown@intel.com>, linux-pm@lists.linux-foundation.org,
        linux-arm-kernel@lists.infradead.org
Date: Tue, 14 Aug 2012 12:52:31 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-Smarthost04-IP: [82.69.122.217]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When a kernel is built to support multiple hardware types it's possible
that CONFIG_ARCH_NEEDS_CPU_IDLE_COUPLED is set but the hardware the
kernel is run on doesn't support cpuidle and therefore doesn't load a
driver for it. In this case, when the system is shut down,
cpuidle_coupled_cpu_notify() gets called with cpuidle_devices set to
NULL. There are quite possibly other circumstances where this
situation can also occur and we should check for it.

Signed-off-by: Jon Medhurst <tixy@linaro.org>
---

Would a better fix be to delay registering the notifier until
cpuidle_coupled_register_device() is called? Though following through
with that logic would require unregistering the notifier when cpuidle
driver is unregistered and it still seems possible that there would
still be a window of opportunity for things to go wrong.


 drivers/cpuidle/coupled.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/cpuidle/coupled.c b/drivers/cpuidle/coupled.c
index 2c9bf26..c78a5ff 100644
--- a/drivers/cpuidle/coupled.c
+++ b/drivers/cpuidle/coupled.c
@@ -681,7 +681,7 @@ static int cpuidle_coupled_cpu_notify(struct notifier_block *nb,
 	mutex_lock(&cpuidle_lock);
 
 	dev = per_cpu(cpuidle_devices, cpu);
-	if (!dev->coupled)
+	if (!dev || !dev->coupled)
 		goto out;
 
 	switch (action & ~CPU_TASKS_FROZEN) {
-- 
1.7.10.4




