Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752037Ab1AEOIf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 09:08:35 -0500
Received: from hera.kernel.org ([140.211.167.34]:58370 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751745Ab1AEOId (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 09:08:33 -0500
Date: Wed, 5 Jan 2011 14:08:14 GMT
From: tip-bot for Huang Ying <ying.huang@intel.com>
Cc: linux-kernel@vger.kernel.org, ying.huang@intel.com, hpa@zytor.com,
        mingo@redhat.com, tglx@linutronix.de, mingo@elte.hu,
        dzickus@redhat.com
Reply-To: mingo@redhat.com, hpa@zytor.com, ying.huang@intel.com,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, dzickus@redhat.com,
        mingo@elte.hu
In-Reply-To: <1294198689-15447-3-git-send-email-dzickus@redhat.com>
References: <1294198689-15447-3-git-send-email-dzickus@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] x86, NMI: Add touch_nmi_watchdog to io_check_error delay
Message-ID: <tip-74d91e3c6a66359bb754fb5d8a5b54fb6ba2f9a6@git.kernel.org>
Git-Commit-ID: 74d91e3c6a66359bb754fb5d8a5b54fb6ba2f9a6
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 05 Jan 2011 14:08:15 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  74d91e3c6a66359bb754fb5d8a5b54fb6ba2f9a6
Gitweb:     http://git.kernel.org/tip/74d91e3c6a66359bb754fb5d8a5b54fb6ba2f9a6
Author:     Huang Ying <ying.huang@intel.com>
AuthorDate: Tue, 4 Jan 2011 22:38:09 -0500
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 5 Jan 2011 14:22:58 +0100

x86, NMI: Add touch_nmi_watchdog to io_check_error delay

Prevent the long delay in io_check_error making NMI watchdog
timeout.

Signed-off-by: Huang Ying <ying.huang@intel.com>
Signed-off-by: Don Zickus <dzickus@redhat.com>
LKML-Reference: <1294198689-15447-3-git-send-email-dzickus@redhat.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
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
