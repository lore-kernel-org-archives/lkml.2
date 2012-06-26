Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758140Ab2FZO3S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 10:29:18 -0400
Received: from mga03.intel.com ([143.182.124.21]:17917 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757907Ab2FZO3Q convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 10:29:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="116164557"
From: "Liu, Chuansheng" <chuansheng.liu@intel.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>
CC: "khali@linux-fr.org" <khali@linux-fr.org>,
        "ben-linux@fluff.org" <ben-linux@fluff.org>,
        "Yanmin Zhang <yanmin_zhang@linux.intel.com>
	(yanmin_zhang@linux.intel.com)" <yanmin_zhang@linux.intel.com>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        "Tu, Xiaobing" <xiaobing.tu@intel.com>
Subject: [PATCH] i2c_dw: deadlock happening when system is trying to suspend
Thread-Topic: [PATCH] i2c_dw: deadlock happening when system is trying to
 suspend
Thread-Index: Ac1TqAs88tDkH1x9TJStda6PpccI5Q==
Date: Tue, 26 Jun 2012 14:29:13 +0000
Message-ID: <27240C0AC20F114CBF8149A2696CBE4A0EE76A@SHSMSX101.ccr.corp.intel.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: liu chuansheng <chuansheng.liu@intel.com>
Subject: [PATCH] i2c_dw: deadlock happening when system is trying to suspend

In i2c_dw code, there is a race condition that causes pm suspend
thread blocking there always. The scenerio is as below:

PM thread:
suspend -->
pm_suspend -->
enter_state -->
dpm_suspend_start(will call i2c_dw_pci_suspend(),
and the dw_i2c_dev->lock is hold)
...
suspend_enter -->
dpm_suspend_noirq -->
suspend_device_irqs -->
synchronize_irq()

synchronize_irq will wait for any pending irq is handled, and
the correpsonding irq thread is finished.

In this case, there is a i2c device interrupt is pending, the irq
thread do the below things:
IRQ thread:
i2c_smbus_read_byte_data -->
i2c_smbus_xfer -->
i2c_transfer -->
i2c_dw_xfer -->
down()

The irq thread blocked at down dw_i2c_dev->lock, because in PM thread,
it has been hold after calling i2c_dw_pci_suspend(), but PM thread is
waiting for IRQ thread, then deadlock happened.

The solution is moving the down() action after pm_runtime_get_sync().

Signed-off-by: liu chuansheng <chuansheng.liu@intel.com>
---
 drivers/i2c/busses/i2c-designware-core.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/i2c/busses/i2c-designware-core.c b/drivers/i2c/busses/i2c-designware-core.c
index 1e48bec..748ecb1 100644
--- a/drivers/i2c/busses/i2c-designware-core.c
+++ b/drivers/i2c/busses/i2c-designware-core.c
@@ -512,8 +512,8 @@ i2c_dw_xfer(struct i2c_adapter *adap, struct i2c_msg msgs[], int num)
 
        dev_dbg(dev->dev, "%s: msgs: %d\n", __func__, num);
 
-       mutex_lock(&dev->lock);
        pm_runtime_get_sync(dev->dev);
+       mutex_lock(&dev->lock);
 
        INIT_COMPLETION(dev->cmd_complete);
        dev->msgs = msgs;
-- 
1.7.0.4
