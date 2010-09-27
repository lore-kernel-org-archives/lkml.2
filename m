Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758699Ab0I0A6K (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Sep 2010 20:58:10 -0400
Received: from mga01.intel.com ([192.55.52.88]:7774 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758512Ab0I0A5d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Sep 2010 20:57:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.57,240,1283756400"; 
   d="scan'208";a="841121727"
From: Huang Ying <ying.huang@intel.com>
To: Don Zickus <dzickus@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
        Huang Ying <ying.huang@intel.com>
Subject: [PATCH -v2 2/7] x86, NMI, Add touch_nmi_watchdog to io_check_error delay
Date: Mon, 27 Sep 2010 08:57:01 +0800
Message-Id: <1285549026-5008-2-git-send-email-ying.huang@intel.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1285549026-5008-1-git-send-email-ying.huang@intel.com>
References: <1285549026-5008-1-git-send-email-ying.huang@intel.com>
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
