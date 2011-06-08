Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751682Ab1FHBza (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 21:55:30 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:39818 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751055Ab1FHBz3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 21:55:29 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4DEED679.9090503@jp.fujitsu.com>
Date: Wed, 08 Jun 2011 10:55:05 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.0; ja; rv:1.9.2.17) Gecko/20110414 Thunderbird/3.1.10
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: "x86@kernel.org" <x86@kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Borislav Petkov <bp@amd64.org>, Tony Luck <tony.luck@gmail.com>
Subject: [PATCH 04/12] mce-severity: trivial cleanups
References: <4DEED509.1040504@jp.fujitsu.com>
In-Reply-To: <4DEED509.1040504@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch does:
- sort bits in macro
- use BITCLR/BITSET
- coordinate message pattern
- use m for struct mce
- minor cleanup for severities_debugfs_init()

Logics are not changed.

v2:
  add sorting that was in previous patch

Signed-off-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
---
 arch/x86/kernel/cpu/mcheck/mce-severity.c |   39 ++++++++++++++---------------
 1 files changed, 19 insertions(+), 20 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce-severity.c b/arch/x86/kernel/cpu/mcheck/mce-severity.c
index 27e778e..7395d5f 100644
--- a/arch/x86/kernel/cpu/mcheck/mce-severity.c
+++ b/arch/x86/kernel/cpu/mcheck/mce-severity.c
@@ -99,41 +99,40 @@ static struct severity {
 		),
 	MCESEV(
 		KEEP, "Non signalled machine check",
-		SER, MASK(MCI_STATUS_S, 0)
+		SER, BITCLR(MCI_STATUS_S)
 		),
 
 	/* AR add known MCACODs here */
 	MCESEV(
 		PANIC, "Action required with lost events",
-		SER,
-		MASK(MCI_STATUS_OVER|MCI_UC_SAR, MCI_STATUS_OVER|MCI_UC_SAR)
+		SER, BITSET(MCI_STATUS_OVER|MCI_UC_SAR)
 		),
 	MCESEV(
-		PANIC, "Action required; unknown MCACOD",
+		PANIC, "Action required: unknown MCACOD",
 		SER, MASK(MCI_STATUS_OVER|MCI_UC_SAR, MCI_UC_SAR)
 		),
 
 	/* known AO MCACODs: */
 	MCESEV(
 		AO, "Action optional: memory scrubbing error",
-		SER, MASK(MCI_UC_SAR|MCI_STATUS_OVER|0xfff0, MCI_UC_S|0xc0)
+		SER, MASK(MCI_STATUS_OVER|MCI_UC_SAR|0xfff0, MCI_UC_S|0x00c0)
 		),
 	MCESEV(
 		AO, "Action optional: last level cache writeback error",
-		SER, MASK(MCI_UC_SAR|MCI_STATUS_OVER|MCACOD, MCI_UC_S|0x17a)
+		SER, MASK(MCI_STATUS_OVER|MCI_UC_SAR|MCACOD, MCI_UC_S|0x017a)
 		),
 	MCESEV(
-		SOME, "Action optional unknown MCACOD",
+		SOME, "Action optional: unknown MCACOD",
 		SER, MASK(MCI_STATUS_OVER|MCI_UC_SAR, MCI_UC_S)
 		),
 	MCESEV(
 		SOME, "Action optional with lost events",
-		SER, MASK(MCI_STATUS_OVER|MCI_UC_SAR, MCI_UC_S|MCI_STATUS_OVER)
+		SER, MASK(MCI_STATUS_OVER|MCI_UC_SAR, MCI_STATUS_OVER|MCI_UC_S)
 		),
 
 	MCESEV(
 		PANIC, "Overflowed uncorrected",
-		BITSET(MCI_STATUS_UC|MCI_STATUS_OVER)
+		BITSET(MCI_STATUS_OVER|MCI_STATUS_UC)
 		),
 	MCESEV(
 		UC, "Uncorrected",
@@ -157,15 +156,15 @@ static int error_context(struct mce *m)
 	return IN_KERNEL;
 }
 
-int mce_severity(struct mce *a, int tolerant, char **msg)
+int mce_severity(struct mce *m, int tolerant, char **msg)
 {
-	enum context ctx = error_context(a);
+	enum context ctx = error_context(m);
 	struct severity *s;
 
 	for (s = severities;; s++) {
-		if ((a->status & s->mask) != s->result)
+		if ((m->status & s->mask) != s->result)
 			continue;
-		if ((a->mcgstatus & s->mcgmask) != s->mcgres)
+		if ((m->mcgstatus & s->mcgmask) != s->mcgres)
 			continue;
 		if (s->ser == SER_REQUIRED && !mce_ser)
 			continue;
@@ -242,15 +241,15 @@ static const struct file_operations severities_coverage_fops = {
 
 static int __init severities_debugfs_init(void)
 {
-	struct dentry *dmce = NULL, *fseverities_coverage = NULL;
+	struct dentry *dmce, *fsev;
 
 	dmce = mce_get_debugfs_dir();
-	if (dmce == NULL)
+	if (!dmce)
 		goto err_out;
-	fseverities_coverage = debugfs_create_file("severities-coverage",
-						   0444, dmce, NULL,
-						   &severities_coverage_fops);
-	if (fseverities_coverage == NULL)
+
+	fsev = debugfs_create_file("severities-coverage", 0444, dmce, NULL,
+				   &severities_coverage_fops);
+	if (!fsev)
 		goto err_out;
 
 	return 0;
@@ -259,4 +258,4 @@ err_out:
 	return -ENOMEM;
 }
 late_initcall(severities_debugfs_init);
-#endif
+#endif /* CONFIG_DEBUG_FS */
-- 
1.7.1


