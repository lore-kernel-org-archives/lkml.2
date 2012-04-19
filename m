Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756586Ab2DSVd4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 17:33:56 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:65069 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933506Ab2DSVPM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 17:15:12 -0400
Message-Id: <20120419210819.452614770@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Thu, 19 Apr 2012 14:08:27 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Will Deacon <will.deacon@arm.com>,
        Jonathan Austin <jonathan.austin@arm.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>
Subject: [ 09/68] ARM: 7384/1: ThumbEE: Disable userspace TEEHBR access for !CONFIG_ARM_THUMBEE
In-Reply-To: <20120419210923.GA18589@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jonathan Austin <Jonathan.Austin@arm.com>

commit 078c04545ba56da21567728a909a496df5ff730d upstream.

Currently when ThumbEE is not enabled (!CONFIG_ARM_THUMBEE) the ThumbEE
register states are not saved/restored at context switch. The default state
of the ThumbEE Ctrl register (TEECR) allows userspace accesses to the
ThumbEE Base Handler register (TEEHBR). This can cause unexpected behaviour
when people use ThumbEE on !CONFIG_ARM_THUMBEE kernels, as well as allowing
covert communication - eg between userspace tasks running inside chroot
jails.

This patch sets up TEECR in order to prevent user-space access to TEEHBR
when !CONFIG_ARM_THUMBEE. In this case, tasks are sent SIGILL if they try to
access TEEHBR.

Reviewed-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Jonathan Austin <jonathan.austin@arm.com>
Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/mm/proc-v7.S |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- a/arch/arm/mm/proc-v7.S
+++ b/arch/arm/mm/proc-v7.S
@@ -382,6 +382,18 @@ __v7_setup:
 	mcr	p15, 0, r5, c10, c2, 0		@ write PRRR
 	mcr	p15, 0, r6, c10, c2, 1		@ write NMRR
 #endif
+#ifndef CONFIG_ARM_THUMBEE
+	mrc	p15, 0, r0, c0, c1, 0		@ read ID_PFR0 for ThumbEE
+	and	r0, r0, #(0xf << 12)		@ ThumbEE enabled field
+	teq	r0, #(1 << 12)			@ check if ThumbEE is present
+	bne	1f
+	mov	r5, #0
+	mcr	p14, 6, r5, c1, c0, 0		@ Initialize TEEHBR to 0
+	mrc	p14, 6, r0, c0, c0, 0		@ load TEECR
+	orr	r0, r0, #1			@ set the 1st bit in order to
+	mcr	p14, 6, r0, c0, c0, 0		@ stop userspace TEEHBR access
+1:
+#endif
 	adr	r5, v7_crval
 	ldmia	r5, {r5, r6}
 #ifdef CONFIG_CPU_ENDIAN_BE8


