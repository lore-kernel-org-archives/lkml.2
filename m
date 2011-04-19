Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753790Ab1DSUYP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 16:24:15 -0400
Received: from kroah.org ([198.145.64.141]:35621 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754795Ab1DSUR1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 16:17:27 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Apr 19 13:10:47 2011
Message-Id: <20110419201047.857721020@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Tue, 19 Apr 2011 13:08:53 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Will Deacon <will.deacon@arm.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>
Subject: [44/70] ARM: 6864/1: hw_breakpoint: clear DBGVCR out of reset
In-Reply-To: <20110419201501.GA8865@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Will Deacon <will.deacon@arm.com>

commit e89c0d7090c54d7b11b9b091e495a1ae345dd3ff upstream.

The DBGVCR, used for configuring vector catch debug events, is UNKNOWN
out of reset on ARMv7. When enabling monitor mode, this must be zeroed
to avoid UNPREDICTABLE behaviour.

This patch adds the zeroing code to the debug reset path.

Reported-by: Stepan Moskovchenko <stepanm@codeaurora.org>
Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/arm/kernel/hw_breakpoint.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/arch/arm/kernel/hw_breakpoint.c
+++ b/arch/arm/kernel/hw_breakpoint.c
@@ -868,6 +868,13 @@ static void reset_ctrl_regs(void *info)
 		 */
 		asm volatile("mcr p14, 0, %0, c1, c0, 4" : : "r" (0));
 		isb();
+
+		/*
+		 * Clear any configured vector-catch events before
+		 * enabling monitor mode.
+		 */
+		asm volatile("mcr p14, 0, %0, c0, c7, 0" : : "r" (0));
+		isb();
 	}
 
 	if (enable_monitor_mode())


