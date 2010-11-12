Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932387Ab0KLOo6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 09:44:58 -0500
Received: from mx1.redhat.com ([209.132.183.28]:3362 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932347Ab0KLOor (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 09:44:47 -0500
From: Don Zickus <dzickus@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Robert Richter <robert.richter@amd.com>, ying.huang@intel.com,
        Andi Kleen <andi@firstfloor.org>, LKML <linux-kernel@vger.kernel.org>,
        Don Zickus <dzickus@redhat.com>
Subject: [PATCH 2/6] x86, NMI: Add touch_nmi_watchdog to io_check_error delay
Date: Fri, 12 Nov 2010 09:43:49 -0500
Message-Id: <1289573033-2889-3-git-send-email-dzickus@redhat.com>
In-Reply-To: <1289573033-2889-1-git-send-email-dzickus@redhat.com>
References: <1289573033-2889-1-git-send-email-dzickus@redhat.com>
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
index ecb2c97..0d75c6b 100644
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

