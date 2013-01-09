Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934043Ab3AIUlO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 15:41:14 -0500
Received: from mail.kernel.org ([198.145.19.201]:43763 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933823Ab3AIUlB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 15:41:01 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Will Deacon <will.deacon@arm.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>
Subject: [ 099/123] ARM: 7606/1: cache: flush to LoUU instead of LoUIS on uniprocessor CPUs
Date: Wed,  9 Jan 2013 12:35:38 -0800
Message-Id: <20130109201511.290756698@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130109201458.392601412@linuxfoundation.org>
References: <20130109201458.392601412@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Will Deacon <will.deacon@arm.com>

commit d056a699dd3d9366dd3b4d9996e7848209199cda upstream.

flush_cache_louis flushes the D-side caches to the point of unification
inner-shareable. On uniprocessor CPUs, this is defined as zero and
therefore no flushing will take place. Rather than invent a new interface
for UP systems, instead use our SMP_ON_UP patching code to read the
LoUU from the CLIDR instead.

Cc: Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>
Tested-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/mm/cache-v7.S |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/arch/arm/mm/cache-v7.S
+++ b/arch/arm/mm/cache-v7.S
@@ -44,8 +44,10 @@ ENDPROC(v7_flush_icache_all)
 ENTRY(v7_flush_dcache_louis)
 	dmb					@ ensure ordering with previous memory accesses
 	mrc	p15, 1, r0, c0, c0, 1		@ read clidr, r0 = clidr
-	ands	r3, r0, #0xe00000		@ extract LoUIS from clidr
-	mov	r3, r3, lsr #20			@ r3 = LoUIS * 2
+	ALT_SMP(ands	r3, r0, #(7 << 21))	@ extract LoUIS from clidr
+	ALT_UP(ands	r3, r0, #(7 << 27))	@ extract LoUU from clidr
+	ALT_SMP(mov	r3, r3, lsr #20)	@ r3 = LoUIS * 2
+	ALT_UP(mov	r3, r3, lsr #26)	@ r3 = LoUU * 2
 	moveq	pc, lr				@ return if level == 0
 	mov	r10, #0				@ r10 (starting level) = 0
 	b	flush_levels			@ start flushing cache levels


