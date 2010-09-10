Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756636Ab0IJCv6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 22:51:58 -0400
Received: from mga02.intel.com ([134.134.136.20]:56172 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753711Ab0IJCvK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 22:51:10 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.56,344,1280732400"; 
   d="scan'208";a="655886345"
From: Huang Ying <ying.huang@intel.com>
To: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
        Huang Ying <ying.huang@intel.com>
Subject: [RFC 2/6] x86, NMI, Add touch_nmi_watchdog to io_check_error delay
Date: Fri, 10 Sep 2010 10:51:01 +0800
Message-Id: <1284087065-32722-2-git-send-email-ying.huang@intel.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1284087065-32722-1-git-send-email-ying.huang@intel.com>
References: <1284087065-32722-1-git-send-email-ying.huang@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Prevent the long delay in io_check_error make NMI watchdog timeout.

Signed-off-by: Huang Ying <ying.huang@intel.com>
---
 arch/x86/kernel/traps.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -342,9 +342,11 @@ io_check_error(unsigned char reason, str
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
