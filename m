Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932861Ab2EDUtb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 16:49:31 -0400
Received: from mail-pz0-f45.google.com ([209.85.210.45]:45099 "EHLO
	mail-pz0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932903Ab2EDUt2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 16:49:28 -0400
Message-Id: <20120504204247.454102356@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 04 May 2012 13:43:14 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Will Deacon <will.deacon@arm.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>
Subject: [ 30/47] ARM: 7403/1: tls: remove covert channel via TPIDRURW
In-Reply-To: <20120504204307.GA13761@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/include/asm/tls.h |    4 ++++
 1 file changed, 4 insertions(+)

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
 


