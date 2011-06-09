Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756277Ab1FIVam (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 17:30:42 -0400
Received: from mga02.intel.com ([134.134.136.20]:17230 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754073Ab1FIVam (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 17:30:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,343,1304319600"; 
   d="scan'208";a="12185683"
From: "Luck, Tony" <tony.luck@intel.com>
To: "Ingo Molnar" <mingo@elte.hu>, "Borislav Petkov" <bp@amd64.org>
Cc: linux-kernel@vger.kernel.org, "Huang, Ying" <ying.huang@intel.com>,
        "Hidetoshi Seto" <seto.hidetoshi@jp.fujitsu.com>,
        "Avi Kivity" <avi@redhat.com>
In-Reply-To: <4df13a522720782e51@agluck-desktop.sc.intel.com>
Subject: [PATCH 02/10] MCE: save most severe error information
Date: Thu, 09 Jun 2011 14:30:41 -0700
Message-Id: <4df13b81272475cf94@agluck-desktop.sc.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tony Luck <tony.luck@intel.com>

monarch clears all of the per cpu "mces_seen", so we must keep a copy
to use after mce_end()

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 arch/x86/kernel/cpu/mcheck/mce.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index 3385ea2..ed1542a 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -1046,6 +1046,9 @@ void do_machine_check(struct pt_regs *regs, long error_code)
 		}
 	}
 
+	/* Save our worst error locally, monarch will clear mces_seen */
+	m = *final;
+
 	if (!no_way_out)
 		mce_clear_state(toclear);
 
@@ -1064,7 +1067,7 @@ void do_machine_check(struct pt_regs *regs, long error_code)
 	 * support MCE broadcasting or it has been disabled.
 	 */
 	if (no_way_out && tolerant < 3)
-		mce_panic("Fatal machine check on current CPU", final, msg);
+		mce_panic("Fatal machine check on current CPU", &m, msg);
 
 	/*
 	 * If the error seems to be unrecoverable, something should be
-- 
1.7.3.1

