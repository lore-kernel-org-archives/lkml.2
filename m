Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751385Ab1AEDii (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 22:38:38 -0500
Received: from mx1.redhat.com ([209.132.183.28]:8257 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751089Ab1AEDiS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 22:38:18 -0500
From: Don Zickus <dzickus@redhat.com>
To: x86@kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>, Huang Ying <ying.huang@intel.com>,
        Don Zickus <dzickus@redhat.com>
Subject: [PATCH 3/3] x86, NMI: Add touch_nmi_watchdog to io_check_error delay
Date: Tue,  4 Jan 2011 22:38:09 -0500
Message-Id: <1294198689-15447-3-git-send-email-dzickus@redhat.com>
In-Reply-To: <1294198689-15447-1-git-send-email-dzickus@redhat.com>
References: <1294198689-15447-1-git-send-email-dzickus@redhat.com>
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
index bb6f041..c76aaca 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -351,9 +351,11 @@ io_check_error(unsigned char reason, struct pt_regs *regs)
 	reason = (reason & 0xf) | 8;
 	outb(reason, 0x61);
 
-	i = 2000;
-	while (--i)
-		udelay(1000);
+	i = 20000;
+	while (--i) {
+		touch_nmi_watchdog();
+		udelay(100);
+	}
 
 	reason &= ~8;
 	outb(reason, 0x61);
-- 
1.7.3.4

