Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752003Ab2LXFCZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Dec 2012 00:02:25 -0500
Received: from mga14.intel.com ([143.182.124.37]:63765 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750789Ab2LXFCW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Dec 2012 00:02:22 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,344,1355126400"; 
   d="scan'208";a="236061969"
Subject: [PATCH V2] output the cpu number  when printking.
From: "he, bo" <bo.he@intel.com>
To: Randy Dunlap <rdunlap@infradead.org>, akpm@linux-foundation.org,
        mingo@elte.hu, linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl
Cc: yanmin_zhang@linux.intel.com
In-Reply-To: <1356321255.2385.8.camel@hebo>
References: <1356316276.2385.7.camel@hebo>  <50D7CDED.4060308@infradead.org>
	 <1356321255.2385.8.camel@hebo>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 24 Dec 2012 13:01:55 +0800
Message-ID: <1356325315.2385.74.camel@hebo>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "he, bo" <bo.he@intel.com>

We often hit kernel panic issues on SMP machines because processes race
on multiple cpu. By adding a new parameter printk.cpu, kernel prints
cpu number at printk information line. It’s useful to debug what cpus
are racing.

Signed-off-by: he, bo <bo.he@intel.com>
---
 Documentation/kernel-parameters.txt |    4 ++++
 kernel/printk.c                     |   18 ++++++++++++++++--
 2 files changed, 20 insertions(+), 2 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index ddd84d6..3387a7f 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -2378,6 +2378,10 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 	printk.time=	Show timing data prefixed to each printk message line
 			Format: <bool>  (1/Y/y=enable, 0/N/n=disable)
 
+	printk.cpu=	Show cpu data prefixed to each printk message line
+			Format: <bool>  (1/Y/y=enable, 0/N/n=disable)
+			printk.cpu takes effect only when printk.time=y.
+
 	processor.max_cstate=	[HW,ACPI]
 			Limit processor to maximum C-state
 			max_cstate=9 overrides any DMI blacklist limit.
diff --git a/kernel/printk.c b/kernel/printk.c
index 19c0d7b..873a226 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -863,9 +863,14 @@ static bool printk_time;
 #endif
 module_param_named(time, printk_time, bool, S_IRUGO | S_IWUSR);
 
+static bool printk_cpu = 1;
+module_param_named(cpu, printk_cpu, bool, S_IRUGO | S_IWUSR);
+
 static size_t print_time(u64 ts, char *buf)
 {
 	unsigned long rem_nsec;
+	size_t len = 0;
+	int this_cpu;
 
 	if (!printk_time)
 		return 0;
@@ -874,8 +879,17 @@ static size_t print_time(u64 ts, char *buf)
 		return 15;
 
 	rem_nsec = do_div(ts, 1000000000);
-	return sprintf(buf, "[%5lu.%06lu] ",
-		       (unsigned long)ts, rem_nsec / 1000);
+
+	if (printk_cpu) {
+		this_cpu = raw_smp_processor_id();
+		len = sprintf(buf, "[%5lu.%06lu,%u] ",
+			       (unsigned long)ts, rem_nsec / 1000, this_cpu);
+	} else {
+		len = sprintf(buf, "[%5lu.%06lu] ",
+			       (unsigned long)ts, rem_nsec / 1000);
+	}
+
+	return len;
 }
 
 static size_t print_prefix(const struct log *msg, bool syslog, char *buf)
-- 
1.7.6



