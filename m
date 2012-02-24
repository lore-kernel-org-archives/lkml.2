Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756536Ab2BXLK3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 06:10:29 -0500
Received: from mail.pripojeni.net ([178.22.112.14]:44131 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751284Ab2BXLK0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 06:10:26 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: tony.luck@intel.com
Cc: fenghua.yu@intel.com, linux-ia64@vger.kernel.org,
        linux-kernel@vger.kernel.org, jirislaby@gmail.com
Subject: [PATCH 1/4] IA64: hpsim, fix SAL handling in fw-emu
Date: Fri, 24 Feb 2012 12:10:15 +0100
Message-Id: <1330081818-15517-1-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The switch-cases of SAL_FREQ_BASE generate non-relocatable code. The
same as for the ifs one level upper. This causes oopses early in boot
because the kernel jumps to the hell instead of the offset in sal
callback.

So use ifs here for SAL_FREQ_BASE decision too.

Isn't there any compiler directive or settings to solve that cleanly?

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 arch/ia64/hp/sim/boot/fw-emu.c |   17 ++++-------------
 1 files changed, 4 insertions(+), 13 deletions(-)

diff --git a/arch/ia64/hp/sim/boot/fw-emu.c b/arch/ia64/hp/sim/boot/fw-emu.c
index bf6d9d8..0216e28 100644
--- a/arch/ia64/hp/sim/boot/fw-emu.c
+++ b/arch/ia64/hp/sim/boot/fw-emu.c
@@ -160,28 +160,19 @@ sal_emulator (long index, unsigned long in1, unsigned long in2,
 	 */
 	status = 0;
 	if (index == SAL_FREQ_BASE) {
-		switch (in1) {
-		      case SAL_FREQ_BASE_PLATFORM:
+		if (in1 == SAL_FREQ_BASE_PLATFORM)
 			r9 = 200000000;
-			break;
-
-		      case SAL_FREQ_BASE_INTERVAL_TIMER:
+		else if (in1 == SAL_FREQ_BASE_INTERVAL_TIMER) {
 			/*
 			 * Is this supposed to be the cr.itc frequency
 			 * or something platform specific?  The SAL
 			 * doc ain't exactly clear on this...
 			 */
 			r9 = 700000000;
-			break;
-
-		      case SAL_FREQ_BASE_REALTIME_CLOCK:
+		} else if (in1 == SAL_FREQ_BASE_REALTIME_CLOCK)
 			r9 = 1;
-			break;
-
-		      default:
+		else
 			status = -1;
-			break;
-		}
 	} else if (index == SAL_SET_VECTORS) {
 		;
 	} else if (index == SAL_GET_STATE_INFO) {
-- 
1.7.9


