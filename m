Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030561Ab2CNCa6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 22:30:58 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:23031 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030457Ab2CNC3r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 22:29:47 -0400
X-Authority-Analysis: v=2.0 cv=d9t3OGfE c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=UBy9sU4F98IA:10 a=7iRz-qJHzJMA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=VwQbUJbxAAAA:8 a=meVymXHHAAAA:8 a=0oKUSnA67OczS7GyBKYA:9 a=Zh68SRI7RUMA:10 a=jeBq3FmKZ4MA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20120314022945.771027206@goodmis.org>
User-Agent: quilt/0.50-1
Date: Tue, 13 Mar 2012 22:27:04 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        John Kacur <jkacur@redhat.com>, stable-rt@vger.kernel.org
Subject: [PATCH RT 6/7] net: Use cpu_chill() instead of cpu_relax()
References: <20120314022658.783312660@goodmis.org>
Content-Disposition: inline; filename=0006-net-Use-cpu_chill-instead-of-cpu_relax.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

Retry loops on RT might loop forever when the modifying side was
preempted. Use cpu_chill() instead of cpu_relax() to let the system
make progress.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: stable-rt@vger.kernel.org
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 net/rds/ib_rdma.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/net/rds/ib_rdma.c b/net/rds/ib_rdma.c
index 819c35a..256ad87 100644
--- a/net/rds/ib_rdma.c
+++ b/net/rds/ib_rdma.c
@@ -33,6 +33,7 @@
 #include <linux/kernel.h>
 #include <linux/slab.h>
 #include <linux/rculist.h>
+#include <linux/delay.h>
 
 #include "rds.h"
 #include "ib.h"
@@ -294,7 +295,7 @@ static inline void wait_clean_list_grace(void)
 	for_each_online_cpu(cpu) {
 		flag = &per_cpu(clean_list_grace, cpu);
 		while (test_bit(CLEAN_LIST_BUSY_BIT, flag))
-			cpu_relax();
+			cpu_chill();
 	}
 }
 
-- 
1.7.8.3


