Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751361Ab2KPDwe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 22:52:34 -0500
Received: from mga14.intel.com ([143.182.124.37]:12869 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750960Ab2KPDwd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 22:52:33 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.83,261,1352102400"; 
   d="scan'208";a="169042910"
Subject: [PATCH] mmc,sdio: Fix the panic due to devname NULL when calling
 pm_runtime_set_active()
From: Chuansheng Liu <chuansheng.liu@intel.com>
To: cjb@laptop.org, ohad@wizery.com, linux-mmc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 16 Nov 2012 20:54:07 +0800
Message-ID: <1353070447.15558.1681.camel@cliu38-desktop-build>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: [PATCH] mmc,sdio: Fix the panic due to devname NULL when calling pm_runtime_set_active()

Meet one panic as the below:
<1>[   15.067350] BUG: unable to handle kernel NULL pointer dereference at   (null)
<1>[   15.074455] IP: [<c1496a42>] strlen+0x12/0x20
<4>[   15.078803] *pde = 00000000
<0>[   15.081674] Oops: 0000 [#1] PREEMPT SMP
<4>[   15.101676] Pid: 5, comm: kworker/u:0 Tainted: G         C  3.0.34-140729-g7f9d5c5 #1 Intel Corporation Medfield/BKB2
<4>[   15.112282] EIP: 0060:[<c1496a42>] EFLAGS: 00010046 CPU: 0
<4>[   15.117760] EIP is at strlen+0x12/0x20
<4>[   15.121496] EAX: 00000000 EBX: f344cc04 ECX: ffffffff EDX: f344cc04
<4>[   15.127754] ESI: c12bcee0 EDI: 00000000 EBP: f586fe74 ESP: f586fe70
<4>[   15.134013]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
<0>[   15.139406] Process kworker/u:0 (pid: 5, ti=f586e000 task=f585b440 task.ti=f586e000)
<0>[   15.147140] Stack:
<4>[   15.149141]  f344cc04 f586feb0 c12bcf12 00000000 f586fe9c 00000000 00000007 00000082
<4>[   15.156877]  00000092 00000002 c1b01ee4 f586feb8 c1635f31 f3b42330 c12bcee0 f344cc04
<4>[   15.164616]  f586fed0 c152f815 f3b42330 f3b42328 00000000 f344cc04 f589b804 00000000
<0>[   15.172351] Call Trace:
<4>[   15.174810]  [<c12bcf12>] ftrace_raw_event_runtime_pm_status+0x32/0x140
<4>[   15.181411]  [<c1635f31>] ? sdio_enable_wide.part.8+0x61/0x80
<4>[   15.187145]  [<c12bcee0>] ? perf_trace_runtime_pm_usage+0x1a0/0x1a0
<4>[   15.193407]  [<c152f815>] __update_runtime_status+0x65/0x90
<4>[   15.198968]  [<c1531170>] __pm_runtime_set_status+0xe0/0x1b0
<4>[   15.204621]  [<c1637366>] mmc_attach_sdio+0x2f6/0x410
<4>[   15.209666]  [<c162f520>] mmc_rescan+0x240/0x2b0
<4>[   15.214270]  [<c12643ce>] process_one_work+0xfe/0x3f0
<4>[   15.219311]  [<c1242754>] ? wake_up_process+0x14/0x20
<4>[   15.224357]  [<c162f2e0>] ? mmc_detect_card_removed+0x80/0x80
<4>[   15.230091]  [<c12649c1>] worker_thread+0x121/0x2f0
<4>[   15.234958]  [<c12648a0>] ? rescuer_thread+0x1e0/0x1e0
<4>[   15.240091]  [<c12684cd>] kthread+0x6d/0x80
<4>[   15.244264]  [<c1268460>] ? __init_kthread_worker+0x30/0x30
<4>[   15.245485]  [<c186dc3a>] kernel_thread_helper+0x6/0x10

The reason is pm_runtime_set_active() is called before the device name
is set, and the dev name setting is done at mmc_add_card() laterly.

So when calling pm_runtime_set_active(), it will hit the strlen(devname==0)
which trigger the panic.

Here before calling pm_runtime_set_active(), set the dev name, although
it is duplicated with mmc_add_card(), but it do not break the original
design(commit 81968561b).

Signed-off-by: liu chuansheng <chuansheng.liu@intel.com>
---
 drivers/mmc/core/sdio.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/drivers/mmc/core/sdio.c b/drivers/mmc/core/sdio.c
index 2273ce6..73746af 100644
--- a/drivers/mmc/core/sdio.c
+++ b/drivers/mmc/core/sdio.c
@@ -1104,6 +1104,15 @@ int mmc_attach_sdio(struct mmc_host *host)
 	 */
 	if (host->caps & MMC_CAP_POWER_OFF_CARD) {
 		/*
+		 * pm_runtime_set_active will use strlen(dev_name),
+		 * we must set it in advance to avoid crash,
+		 * although it is the duplication in mmc_add_card
+		 * laterly.
+		 */
+		dev_set_name(&card->dev, "%s:%04x", mmc_hostname(card->host),
+			card->rca);
+
+		/*
 		 * Let runtime PM core know our card is active
 		 */
 		err = pm_runtime_set_active(&card->dev);
-- 
1.7.0.4



