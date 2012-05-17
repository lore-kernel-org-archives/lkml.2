Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761309Ab2EQHqd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 03:46:33 -0400
Received: from mga03.intel.com ([143.182.124.21]:59203 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760743Ab2EQHqa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 03:46:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="144279499"
From: "Liu, Chuansheng" <chuansheng.liu@intel.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "peterz@infradead.org" <peterz@infradead.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "Yanmin Zhang <yanmin_zhang@linux.intel.com>
	(yanmin_zhang@linux.intel.com)" <yanmin_zhang@linux.intel.com>
Subject: [PATCH] printk: do not flush the logbuf into console driver in
 interrupt
Thread-Topic: [PATCH] printk: do not flush the logbuf into console driver in
 interrupt
Thread-Index: Ac00ARpSE+MXP3zWS6qzsAtmUEu7zA==
Date: Thu, 17 May 2012 07:46:10 +0000
Message-ID: <27240C0AC20F114CBF8149A2696CBE4A0B1F0B@SHSMSX101.ccr.corp.intel.com>
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
Subject: [PATCH] printk: do not flush the logbuf into console driver in interrupt

When irq handle tried to call printk, and it also has the chance to obtain the console sem,
then flush the log buf to console driver,but the console driver often give several ms latency
or more when much data in log buf existed, it will delay the irq handle.

The solution is when calling the printk in interrupt, just write the chars into log buf,
and expect other threads to flush it into console driver.

Signed-off-by: liu chuansheng <chuansheng.liu@intel.com>

diff --git a/kernel/printk.c b/kernel/printk.c index b663c2c..99959e1 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -804,7 +804,8 @@ static int console_trylock_for_printk(unsigned int cpu)
                 * the buffer. We need to hold the console semaphore
                 * in order to do this test safely.
                 */
-               if (!can_use_console(cpu)) {
+               if (!can_use_console(cpu) ||
+                       (in_interrupt() && (!oops_in_progress))) {
                        console_locked = 0;
                        wake = 1;
                        retval = 0;
