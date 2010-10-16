Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752703Ab0JPCXT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 22:23:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5559 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752601Ab0JPCXS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 22:23:18 -0400
From: Don Zickus <dzickus@redhat.com>
To: mingo@elte.hu
Cc: andi@firstfloor.org, robert.richter@amd.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, ying.huang@intel.com,
        Don Zickus <dzickus@redhat.com>
Subject: [PATCH 2/5] x86, NMI: Add touch_nmi_watchdog to io_check_error delay
Date: Fri, 15 Oct 2010 22:22:15 -0400
Message-Id: <1287195738-3136-3-git-send-email-dzickus@redhat.com>
In-Reply-To: <1287195738-3136-1-git-send-email-dzickus@redhat.com>
References: <1287195738-3136-1-git-send-email-dzickus@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Huang Ying <ying.huang@intel.com>

Prevent the long delay in io_check_error making NMI watchdog timeout.

Signed-off-by: Huang Ying <ying.huang@intel.com>
Signed-off-by: Don Zickus <dzickus@redhat.com>
---
 arch/x86/kernel/traps.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index e04e59b..bef859e 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -344,9 +344,11 @@ io_check_error(unsigned char reason, struct pt_regs *regs)
 	reason = (reason & NMI_REASON_CLEAR_MASK) | NMI_REASON_CLEAR_IOCHK;
 	outb(reason, NMI_REASON_PORT);
 
-	i = 2000;
-	while (--i)
-		udelay(1000);
+	i = 20000;
+	while (--i) {
+		touch_nmi_watchdog();
+		udelay(100);
+	}
 
 	reason &= ~NMI_REASON_CLEAR_IOCHK;
 	outb(reason, NMI_REASON_PORT);
-- 
1.7.2.3

