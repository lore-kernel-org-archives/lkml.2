Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754034Ab1KDMEz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Nov 2011 08:04:55 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:50741 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750814Ab1KDMEy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Nov 2011 08:04:54 -0400
Message-ID: <1320408281.28679.1.camel@phoenix>
Subject: [PATCH] [CPUFREQ] db8500: fix build error due to undeclared i
 variable
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Vincent Guittot <vincent.guittot@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Dave Jones <davej@redhat.com>, cpufreq@vger.kernel.org
Date: Fri, 04 Nov 2011 20:04:41 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.0- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The variable i is removed by commit ded8433
"[CPUFREQ] db8500: remove unneeded for loop iteration over freq_table",
but current code to print available frequencies still uses the i variable.
Thus add the i variable back to fix below buld error:

  CC      drivers/cpufreq/db8500-cpufreq.o
drivers/cpufreq/db8500-cpufreq.c: In function 'db8500_cpufreq_init':
drivers/cpufreq/db8500-cpufreq.c:123: error: 'i' undeclared (first use in this function)
drivers/cpufreq/db8500-cpufreq.c:123: error: (Each undeclared identifier is reported only once
drivers/cpufreq/db8500-cpufreq.c:123: error: for each function it appears in.)
make[2]: *** [drivers/cpufreq/db8500-cpufreq.o] Error 1
make[1]: *** [drivers/cpufreq] Error 2
make: *** [drivers] Error 2

This patch also fixes using uninitialized i variable as array index.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/cpufreq/db8500-cpufreq.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/cpufreq/db8500-cpufreq.c b/drivers/cpufreq/db8500-cpufreq.c
index edaa987..f500201 100644
--- a/drivers/cpufreq/db8500-cpufreq.c
+++ b/drivers/cpufreq/db8500-cpufreq.c
@@ -109,7 +109,7 @@ static unsigned int db8500_cpufreq_getspeed(unsigned int cpu)
 
 static int __cpuinit db8500_cpufreq_init(struct cpufreq_policy *policy)
 {
-	int res;
+	int i, res;
 
 	BUILD_BUG_ON(ARRAY_SIZE(idx2opp) + 1 != ARRAY_SIZE(freq_table));
 
@@ -120,8 +120,8 @@ static int __cpuinit db8500_cpufreq_init(struct cpufreq_policy *policy)
 			freq_table[3].frequency = 1000000;
 	}
 	pr_info("db8500-cpufreq : Available frequencies:\n");
-	while (freq_table[i].frequency != CPUFREQ_TABLE_END)
-		pr_info("  %d Mhz\n", freq_table[i++].frequency/1000);
+	for (i = 0; freq_table[i].frequency != CPUFREQ_TABLE_END; i++)
+		pr_info("  %d Mhz\n", freq_table[i].frequency/1000);
 
 	/* get policy fields based on the table */
 	res = cpufreq_frequency_table_cpuinfo(policy, freq_table);
-- 
1.7.5.4



