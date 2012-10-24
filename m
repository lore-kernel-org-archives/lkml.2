Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758150Ab2JXKMo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 06:12:44 -0400
Received: from terminus.zytor.com ([198.137.202.10]:55323 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758099Ab2JXKMm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 06:12:42 -0400
Date: Wed, 24 Oct 2012 03:11:31 -0700
From: "tip-bot for Yan, Zheng" <zheng.z.yan@intel.com>
Message-ID: <tip-032c3851f51141e30de02ed0bc50a7743dfd776d@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        zheng.z.yan@intel.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        zheng.z.yan@intel.com, tglx@linutronix.de
In-Reply-To: <1351068140-13456-1-git-send-email-zheng.z.yan@intel.com>
References: <1351068140-13456-1-git-send-email-zheng.z.yan@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf/x86/uncore: Handle pci_read_config_dword()
  errors
Git-Commit-ID: 032c3851f51141e30de02ed0bc50a7743dfd776d
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 24 Oct 2012 03:11:37 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  032c3851f51141e30de02ed0bc50a7743dfd776d
Gitweb:     http://git.kernel.org/tip/032c3851f51141e30de02ed0bc50a7743dfd776d
Author:     Yan, Zheng <zheng.z.yan@intel.com>
AuthorDate: Wed, 24 Oct 2012 16:42:20 +0800
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 24 Oct 2012 10:57:03 +0200

perf/x86/uncore: Handle pci_read_config_dword() errors

This, beyond handling corner cases, also fixes some build warnings:

 arch/x86/kernel/cpu/perf_event_intel_uncore.c: In function ‘snbep_uncore_pci_disable_box’:
 arch/x86/kernel/cpu/perf_event_intel_uncore.c:124:9: warning: ‘config’ is used uninitialized in this function [-Wuninitialized]
 arch/x86/kernel/cpu/perf_event_intel_uncore.c: In function ‘snbep_uncore_pci_enable_box’:
 arch/x86/kernel/cpu/perf_event_intel_uncore.c:135:9: warning: ‘config’ is used uninitialized in this function [-Wuninitialized]
 arch/x86/kernel/cpu/perf_event_intel_uncore.c: In function ‘snbep_uncore_pci_read_counter’:
 arch/x86/kernel/cpu/perf_event_intel_uncore.c:164:2: warning: ‘count’ is used uninitialized in this function [-Wuninitialized]

Signed-off-by: Yan, Zheng <zheng.z.yan@intel.com>
Cc: a.p.zijlstra@chello.nl
Link: http://lkml.kernel.org/r/1351068140-13456-1-git-send-email-zheng.z.yan@intel.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/cpu/perf_event_intel_uncore.c |   43 ++++++++++++++++---------
 1 files changed, 28 insertions(+), 15 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel_uncore.c b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
index 5df8d32..6f87477 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_uncore.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
@@ -118,22 +118,24 @@ static void snbep_uncore_pci_disable_box(struct intel_uncore_box *box)
 {
 	struct pci_dev *pdev = box->pci_dev;
 	int box_ctl = uncore_pci_box_ctl(box);
-	u32 config;
+	u32 config = 0;
 
-	pci_read_config_dword(pdev, box_ctl, &config);
-	config |= SNBEP_PMON_BOX_CTL_FRZ;
-	pci_write_config_dword(pdev, box_ctl, config);
+	if (!pci_read_config_dword(pdev, box_ctl, &config)) {
+		config |= SNBEP_PMON_BOX_CTL_FRZ;
+		pci_write_config_dword(pdev, box_ctl, config);
+	}
 }
 
 static void snbep_uncore_pci_enable_box(struct intel_uncore_box *box)
 {
 	struct pci_dev *pdev = box->pci_dev;
 	int box_ctl = uncore_pci_box_ctl(box);
-	u32 config;
+	u32 config = 0;
 
-	pci_read_config_dword(pdev, box_ctl, &config);
-	config &= ~SNBEP_PMON_BOX_CTL_FRZ;
-	pci_write_config_dword(pdev, box_ctl, config);
+	if (!pci_read_config_dword(pdev, box_ctl, &config)) {
+		config &= ~SNBEP_PMON_BOX_CTL_FRZ;
+		pci_write_config_dword(pdev, box_ctl, config);
+	}
 }
 
 static void snbep_uncore_pci_enable_event(struct intel_uncore_box *box, struct perf_event *event)
@@ -156,7 +158,7 @@ static u64 snbep_uncore_pci_read_counter(struct intel_uncore_box *box, struct pe
 {
 	struct pci_dev *pdev = box->pci_dev;
 	struct hw_perf_event *hwc = &event->hw;
-	u64 count;
+	u64 count = 0;
 
 	pci_read_config_dword(pdev, hwc->event_base, (u32 *)&count);
 	pci_read_config_dword(pdev, hwc->event_base + 4, (u32 *)&count + 1);
@@ -603,11 +605,12 @@ static struct pci_driver snbep_uncore_pci_driver = {
 /*
  * build pci bus to socket mapping
  */
-static void snbep_pci2phy_map_init(void)
+static int snbep_pci2phy_map_init(void)
 {
 	struct pci_dev *ubox_dev = NULL;
 	int i, bus, nodeid;
-	u32 config;
+	int err = 0;
+	u32 config = 0;
 
 	while (1) {
 		/* find the UBOX device */
@@ -618,10 +621,14 @@ static void snbep_pci2phy_map_init(void)
 			break;
 		bus = ubox_dev->bus->number;
 		/* get the Node ID of the local register */
-		pci_read_config_dword(ubox_dev, 0x40, &config);
+		err = pci_read_config_dword(ubox_dev, 0x40, &config);
+		if (err)
+			break;
 		nodeid = config;
 		/* get the Node ID mapping */
-		pci_read_config_dword(ubox_dev, 0x54, &config);
+		err = pci_read_config_dword(ubox_dev, 0x54, &config);
+		if (err)
+			break;
 		/*
 		 * every three bits in the Node ID mapping register maps
 		 * to a particular node.
@@ -633,7 +640,11 @@ static void snbep_pci2phy_map_init(void)
 			}
 		}
 	};
-	return;
+
+	if (ubox_dev)
+		pci_dev_put(ubox_dev);
+
+	return err ? pcibios_err_to_errno(err) : 0;
 }
 /* end of Sandy Bridge-EP uncore support */
 
@@ -2578,9 +2589,11 @@ static int __init uncore_pci_init(void)
 
 	switch (boot_cpu_data.x86_model) {
 	case 45: /* Sandy Bridge-EP */
+		ret = snbep_pci2phy_map_init();
+		if (ret)
+			return ret;
 		pci_uncores = snbep_pci_uncores;
 		uncore_pci_driver = &snbep_uncore_pci_driver;
-		snbep_pci2phy_map_init();
 		break;
 	default:
 		return 0;
