Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757270Ab2LNW2Z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 17:28:25 -0500
Received: from mail.kernel.org ([198.145.19.201]:38411 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757232Ab2LNW2U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 17:28:20 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Anton Blanchard <anton@samba.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Haren Myneni <haren@us.ibm.com>
Subject: [ 22/22] powerpc: Keep thread.dscr and thread.dscr_inherit in sync
Date: Fri, 14 Dec 2012 14:26:07 -0800
Message-Id: <20121214222254.945238804@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20121214222249.889051473@linuxfoundation.org>
References: <20121214222249.889051473@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Haren Myneni <haren@us.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

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
@@ -935,8 +935,9 @@ static int emulate_instruction(struct pt
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


