Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753324Ab0JPQgx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Oct 2010 12:36:53 -0400
Received: from hera.kernel.org ([140.211.167.34]:53207 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751714Ab0JPQgw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Oct 2010 12:36:52 -0400
Date: Sat, 16 Oct 2010 16:36:26 GMT
From: tip-bot for Huang Ying <ying.huang@intel.com>
Cc: linux-kernel@vger.kernel.org, ying.huang@intel.com, hpa@zytor.com,
        mingo@redhat.com, tglx@linutronix.de, mingo@elte.hu,
        dzickus@redhat.com
Reply-To: mingo@redhat.com, hpa@zytor.com, ying.huang@intel.com,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, dzickus@redhat.com,
        mingo@elte.hu
In-Reply-To: <1287195738-3136-3-git-send-email-dzickus@redhat.com>
References: <1287195738-3136-3-git-send-email-dzickus@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] x86, NMI: Add touch_nmi_watchdog to io_check_error delay
Message-ID: <tip-3ef3df20bcfa7d271b40ec79ea6db9534ecd1322@git.kernel.org>
Git-Commit-ID: 3ef3df20bcfa7d271b40ec79ea6db9534ecd1322
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sat, 16 Oct 2010 16:36:27 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  3ef3df20bcfa7d271b40ec79ea6db9534ecd1322
Gitweb:     http://git.kernel.org/tip/3ef3df20bcfa7d271b40ec79ea6db9534ecd1322
Author:     Huang Ying <ying.huang@intel.com>
AuthorDate: Fri, 15 Oct 2010 22:22:15 -0400
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sat, 16 Oct 2010 15:01:27 +0200

x86, NMI: Add touch_nmi_watchdog to io_check_error delay

Prevent the long delay in io_check_error triggering a NMI watchdog
timeout.

Signed-off-by: Huang Ying <ying.huang@intel.com>
Signed-off-by: Don Zickus <dzickus@redhat.com>
Cc: andi@firstfloor.org
Cc: robert.richter@amd.com
Cc: peterz@infradead.org
LKML-Reference: <1287195738-3136-3-git-send-email-dzickus@redhat.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
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
