Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754694Ab2IQA6K (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2012 20:58:10 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:33923 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754263Ab2IQAvZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2012 20:51:25 -0400
Message-Id: <20120917003631.381716777@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 17 Sep 2012 01:37:02 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Anton Blanchard <anton@samba.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [ 037/135] powerpc: Keep thread.dscr and thread.dscr_inherit in sync
In-Reply-To: <20120917003625.784119135@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Anton Blanchard <anton@samba.org>

commit 00ca0de02f80924dfff6b4f630e1dff3db005e35 upstream.

When we update the DSCR either via emulation of mtspr(DSCR) or via
a change to dscr_default in sysfs we don't update thread.dscr.
We will eventually update it at context switch time but there is
a period where thread.dscr is incorrect.

If we fork at this point we will copy the old value of thread.dscr
into the child. To avoid this, always keep thread.dscr in sync with
reality.

This issue was found with the following testcase:

http://ozlabs.org/~anton/junkcode/dscr_inherit_test.c

Signed-off-by: Anton Blanchard <anton@samba.org>
Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/powerpc/kernel/sysfs.c |    4 +++-
 arch/powerpc/kernel/traps.c |    3 ++-
 2 files changed, 5 insertions(+), 2 deletions(-)

--- a/arch/powerpc/kernel/sysfs.c
+++ b/arch/powerpc/kernel/sysfs.c
@@ -194,8 +194,10 @@ static ssize_t show_dscr_default(struct
 
 static void update_dscr(void *dummy)
 {
-	if (!current->thread.dscr_inherit)
+	if (!current->thread.dscr_inherit) {
+		current->thread.dscr = dscr_default;
 		mtspr(SPRN_DSCR, dscr_default);
+	}
 }
 
 static ssize_t __used store_dscr_default(struct sysdev_class *class,
--- a/arch/powerpc/kernel/traps.c
+++ b/arch/powerpc/kernel/traps.c
@@ -942,8 +942,9 @@ static int emulate_instruction(struct pt
 			cpu_has_feature(CPU_FTR_DSCR)) {
 		PPC_WARN_EMULATED(mtdscr, regs);
 		rd = (instword >> 21) & 0x1f;
-		mtspr(SPRN_DSCR, regs->gpr[rd]);
+		current->thread.dscr = regs->gpr[rd];
 		current->thread.dscr_inherit = 1;
+		mtspr(SPRN_DSCR, current->thread.dscr);
 		return 0;
 	}
 #endif


