Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757780Ab2EIGEv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 02:04:51 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:39000 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756301Ab2EIFxi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 01:53:38 -0400
Message-Id: <20120509055046.917110500@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Wed, 09 May 2012 06:52:34 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Will Deacon <will.deacon@arm.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>
Subject: [ 125/167] [PATCH] ARM: 7403/1: tls: remove covert channel via TPIDRURW
In-Reply-To: <20120509055029.588587017@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Will Deacon <will.deacon@arm.com>

commit 6a1c53124aa161eb624ce7b1e40ade728186d34c upstream.

TPIDRURW is a user read/write register forming part of the group of
thread registers in more recent versions of the ARM architecture (~v6+).

Currently, the kernel does not touch this register, which allows tasks
to communicate covertly by reading and writing to the register without
context-switching affecting its contents.

This patch clears TPIDRURW when TPIDRURO is updated via the set_tls
macro, which is called directly from __switch_to. Since the current
behaviour makes the register useless to userspace as far as thread
pointers are concerned, simply clearing the register (rather than saving
and restoring it) will not cause any problems to userspace.

Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/arm/include/asm/tls.h |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm/include/asm/tls.h b/arch/arm/include/asm/tls.h
index 60843eb..73409e6 100644
--- a/arch/arm/include/asm/tls.h
+++ b/arch/arm/include/asm/tls.h
@@ -7,6 +7,8 @@
 
 	.macro set_tls_v6k, tp, tmp1, tmp2
 	mcr	p15, 0, \tp, c13, c0, 3		@ set TLS register
+	mov	\tmp1, #0
+	mcr	p15, 0, \tmp1, c13, c0, 2	@ clear user r/w TLS register
 	.endm
 
 	.macro set_tls_v6, tp, tmp1, tmp2
@@ -15,6 +17,8 @@
 	mov	\tmp2, #0xffff0fff
 	tst	\tmp1, #HWCAP_TLS		@ hardware TLS available?
 	mcrne	p15, 0, \tp, c13, c0, 3		@ yes, set TLS register
+	movne	\tmp1, #0
+	mcrne	p15, 0, \tmp1, c13, c0, 2	@ clear user r/w TLS register
 	streq	\tp, [\tmp2, #-15]		@ set TLS value at 0xffff0ff0
 	.endm
 
-- 
1.7.10



