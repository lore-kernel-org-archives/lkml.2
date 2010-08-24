Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756295Ab0HXWrf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 18:47:35 -0400
Received: from kroah.org ([198.145.64.141]:59770 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755323Ab0HXWrd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 18:47:33 -0400
X-Mailbox-Line: From gregkh@clark.site Tue Aug 24 15:18:20 2010
Message-Id: <20100824221820.151700351@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 24 Aug 2010 15:16:54 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Dima Zavin <dima@android.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>
Subject: [1/8] ARM: Tighten check for allowable CPSR values
In-Reply-To: <20100824224631.GA5458@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------
Content-Length: 1312
Lines: 45

From: Russell King <rmk+kernel@arm.linux.org.uk>

commit 41e2e8fd34fff909a0e40129f6ac4233ecfa67a9 upstream.

Reviewed-by: Arve Hjønnevåg <arve@android.com>
Acked-by: Dima Zavin <dima@android.com>
Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/arm/include/asm/ptrace.h |   17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

--- a/arch/arm/include/asm/ptrace.h
+++ b/arch/arm/include/asm/ptrace.h
@@ -124,15 +124,24 @@ struct pt_regs {
  */
 static inline int valid_user_regs(struct pt_regs *regs)
 {
-	if (user_mode(regs) && (regs->ARM_cpsr & PSR_I_BIT) == 0) {
-		regs->ARM_cpsr &= ~(PSR_F_BIT | PSR_A_BIT);
-		return 1;
+	unsigned long mode = regs->ARM_cpsr & MODE_MASK;
+
+	/*
+	 * Always clear the F (FIQ) and A (delayed abort) bits
+	 */
+	regs->ARM_cpsr &= ~(PSR_F_BIT | PSR_A_BIT);
+
+	if ((regs->ARM_cpsr & PSR_I_BIT) == 0) {
+		if (mode == USR_MODE)
+			return 1;
+		if (elf_hwcap & HWCAP_26BIT && mode == USR26_MODE)
+			return 1;
 	}
 
 	/*
 	 * Force CPSR to something logical...
 	 */
-	regs->ARM_cpsr &= PSR_f | PSR_s | (PSR_x & ~PSR_A_BIT) | PSR_T_BIT | MODE32_BIT;
+	regs->ARM_cpsr &= PSR_f | PSR_s | PSR_x | PSR_T_BIT | MODE32_BIT;
 	if (!(elf_hwcap & HWCAP_26BIT))
 		regs->ARM_cpsr |= USR_MODE;
 


