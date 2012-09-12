Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756318Ab2IMA1l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 20:27:41 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:50843 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756144Ab2ILXe2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 19:34:28 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, Anton Blanchard <anton@samba.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [ 079/108] powerpc: Keep thread.dscr and thread.dscr_inherit in sync
Date: Wed, 12 Sep 2012 16:29:17 -0700
Message-Id: <20120912232458.784224566@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120912232450.500619493@linuxfoundation.org>
References: <20120912232816.GA1655@kroah.com>
 <20120912232450.500619493@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.5-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/kernel/sysfs.c |    4 +++-
 arch/powerpc/kernel/traps.c |    3 ++-
 2 files changed, 5 insertions(+), 2 deletions(-)

--- a/arch/powerpc/kernel/sysfs.c
+++ b/arch/powerpc/kernel/sysfs.c
@@ -196,8 +196,10 @@ static ssize_t show_dscr_default(struct
 
 static void update_dscr(void *dummy)
 {
-	if (!current->thread.dscr_inherit)
+	if (!current->thread.dscr_inherit) {
+		current->thread.dscr = dscr_default;
 		mtspr(SPRN_DSCR, dscr_default);
+	}
 }
 
 static ssize_t __used store_dscr_default(struct device *dev,
--- a/arch/powerpc/kernel/traps.c
+++ b/arch/powerpc/kernel/traps.c
@@ -972,8 +972,9 @@ static int emulate_instruction(struct pt
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


