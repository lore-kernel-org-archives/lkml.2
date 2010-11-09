Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755532Ab0KILtL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 06:49:11 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:48528 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754265Ab0KILtJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 06:49:09 -0500
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH] x86/mrst: parse SFI timer table for all timer configs
To: x86@kernel.org, linux-kernel@vger.kernel.org
Date: Tue, 09 Nov 2010 11:28:43 +0000
Message-ID: <20101109112800.20591.10802.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Rebased for the move of mrst.c into platform/mrst)

From: Jacob Pan <jacob.jun.pan@linux.intel.com>

Penwell has APB timer based watchdog timers, it requires platform code to parse
SFI MTMR tables in order to claim its timer.

This patch will always parse SFI MTMR regardless of system timer configuration
choices. Otherwise, SFI MTMR table may not get parsed if running on Medfield
with always-on local APIC timers and constant TSC. Watchdog timer driver will
then not get a timer to use.

Signed-off-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 arch/x86/platform/mrst/mrst.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)


diff --git a/arch/x86/platform/mrst/mrst.c b/arch/x86/platform/mrst/mrst.c
index 192399d..8705f6b 100644
--- a/arch/x86/platform/mrst/mrst.c
+++ b/arch/x86/platform/mrst/mrst.c
@@ -221,6 +221,7 @@ static unsigned long __init mrst_calibrate_tsc(void)
 
 void __init mrst_time_init(void)
 {
+	sfi_table_parse(SFI_SIG_MTMR, NULL, NULL, sfi_parse_mtmr);
 	switch (mrst_timer_options) {
 	case MRST_TIMER_APBT_ONLY:
 		break;
@@ -236,7 +237,6 @@ void __init mrst_time_init(void)
 		return;
 	}
 	/* we need at least one APB timer */
-	sfi_table_parse(SFI_SIG_MTMR, NULL, NULL, sfi_parse_mtmr);
 	pre_init_apic_IRQ0();
 	apbt_time_init();
 }
