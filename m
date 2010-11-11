Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757211Ab0KKWyt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 17:54:49 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:25284 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755378Ab0KKWyr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 17:54:47 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6164"; a="61552919"
From: David Brown <davidb@codeaurora.org>
To: linux-arm-msm@vger.kernel.org, Daniel Walker <dwalker@codeaurora.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        David Brown <davidb@codeaurora.org>,
        Brian Swetland <swetland@google.com>,
        =?UTF-8?q?Arve=20Hj=C3=B8nnev=C3=A5g?= <arve@android.com>
Subject: [PATCH v4] msm: smd: Reduce driver log chatter
Date: Thu, 11 Nov 2010 14:54:39 -0800
Message-Id: <1289516079-24632-1-git-send-email-davidb@codeaurora.org>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <1289349036-16941-1-git-send-email-davidb@codeaurora.org>
References: <1289349036-16941-1-git-send-email-davidb@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The MSM smd driver logs numerous messages during startup that are
useful for debug purposes.  Change some of these to pr_debug() to
match their purpose, and remove others that aren't really useful.

Cc: Brian Swetland <swetland@google.com>
Cc: Arve Hjønnevåg <arve@android.com>
Signed-off-by: David Brown <davidb@codeaurora.org>
---
 arch/arm/mach-msm/smd.c |   17 +++++++----------
 1 files changed, 7 insertions(+), 10 deletions(-)

diff --git a/arch/arm/mach-msm/smd.c b/arch/arm/mach-msm/smd.c
index f07dc7c..eec464f 100644
--- a/arch/arm/mach-msm/smd.c
+++ b/arch/arm/mach-msm/smd.c
@@ -14,6 +14,8 @@
  *
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/platform_device.h>
 #include <linux/module.h>
 #include <linux/fs.h>
@@ -89,7 +91,7 @@ static void smd_diag(void)
 	x = smem_find(ID_DIAG_ERR_MSG, SZ_DIAG_ERR_MSG);
 	if (x != 0) {
 		x[SZ_DIAG_ERR_MSG - 1] = 0;
-		pr_info("smem: DIAG '%s'\n", x);
+		pr_debug("DIAG '%s'\n", x);
 	}
 }
 
@@ -312,7 +314,7 @@ static void smd_state_change(struct smd_channel *ch,
 {
 	ch->last_state = next;
 
-	pr_info("SMD: ch %d %d -> %d\n", ch->n, last, next);
+	pr_debug("ch %d %d -> %d\n", ch->n, last, next);
 
 	switch (next) {
 	case SMD_SS_OPENING:
@@ -601,7 +603,7 @@ static int smd_alloc_channel(const char *name, uint32_t cid, uint32_t type)
 	ch->pdev.name = ch->name;
 	ch->pdev.id = -1;
 
-	pr_info("smd_alloc_channel() cid=%02d size=%05d '%s'\n",
+	pr_debug("smd_alloc_channel() cid=%02d size=%05d '%s'\n",
 		ch->n, ch->fifo_size, ch->name);
 
 	mutex_lock(&smd_creation_mutex);
@@ -621,7 +623,7 @@ static void smd_channel_probe_worker(struct work_struct *work)
 
 	shared = smem_find(ID_CH_ALLOC_TBL, sizeof(*shared) * 64);
 	if (!shared) {
-		pr_err("smd: cannot find allocation table\n");
+		pr_err("cannot find allocation table\n");
 		return;
 	}
 	for (n = 0; n < 64; n++) {
@@ -725,7 +727,7 @@ int smd_close(smd_channel_t *ch)
 {
 	unsigned long flags;
 
-	pr_info("smd_close(%p)\n", ch);
+	pr_debug("smd_close(%p)\n", ch);
 
 	if (ch == 0)
 		return -1;
@@ -939,7 +941,6 @@ int smsm_set_sleep_duration(uint32_t delay)
 int smd_core_init(void)
 {
 	int r;
-	pr_info("smd_core_init()\n");
 
 	/* wait for essential items to be initialized */
 	for (;;) {
@@ -992,15 +993,11 @@ int smd_core_init(void)
 	smsm_change_state(SMSM_STATE_APPS_DEM, ~0, 0);
 #endif
 
-	pr_info("smd_core_init() done\n");
-
 	return 0;
 }
 
 static int __devinit msm_smd_probe(struct platform_device *pdev)
 {
-	pr_info("smd_init()\n");
-
 	/*
 	 * If we haven't waited for the ARM9 to boot up till now,
 	 * then we need to wait here. Otherwise this should just
-- 
1.7.3.2

Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
