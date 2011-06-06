Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757119Ab1FFOrR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 10:47:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5414 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751164Ab1FFOrQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 10:47:16 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 1/3] MN10300: Fix one of the kernel debugger cacheflush
 variants
To: torvalds@osdl.org, akpm@linux-foundation.org
Cc: linux-am33-list@redhat.com, linux-kernel@vger.kernel.org,
        David Howells <dhowells@redhat.com>
Date: Mon, 06 Jun 2011 15:47:05 +0100
Message-ID: <20110606144705.19155.22278.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

One of the kernel debugger cacheflush variants escaped proper testing.  Two of
the labels are wrong, being derived from the code that was copied to construct
the variant.

The first label results in the following assembler message:

  AS      arch/mn10300/mm/cache-dbg-flush-by-reg.o
arch/mn10300/mm/cache-dbg-flush-by-reg.S: Assembler messages:
arch/mn10300/mm/cache-dbg-flush-by-reg.S:123: Error: symbol `debugger_local_cache_flushinv_no_dcache' is already defined

And the second label results in the following linker message:

arch/mn10300/mm/built-in.o:(.text+0x1d39): undefined reference to `mn10300_local_icache_inv_range_reg_end'
arch/mn10300/mm/built-in.o:(.text+0x1d39): relocation truncated to fit: R_MN10300_PCREL16 against undefined symbol `mn10300_local_icache_inv_range_reg_end'

To test this file the following configuration pieces must be set:

	CONFIG_AM34=y
	CONFIG_MN10300_CACHE_WBACK=y
	CONFIG_MN10300_DEBUGGER_CACHE_FLUSH_BY_REG=y
	CONFIG_MN10300_CACHE_MANAGE_BY_REG=y
	CONFIG_AM34_HAS_CACHE_SNOOP=n

Signed-off-by: David Howells <dhowells@redhat.com>
---

 arch/mn10300/mm/cache-dbg-flush-by-reg.S |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)


diff --git a/arch/mn10300/mm/cache-dbg-flush-by-reg.S b/arch/mn10300/mm/cache-dbg-flush-by-reg.S
index 665919f..a775ea5 100644
--- a/arch/mn10300/mm/cache-dbg-flush-by-reg.S
+++ b/arch/mn10300/mm/cache-dbg-flush-by-reg.S
@@ -120,14 +120,14 @@ debugger_local_cache_flushinv_one:
 	# conditionally purge this line in all ways
 	mov	d1,(L1_CACHE_WAYDISP*0,a0)
 
-debugger_local_cache_flushinv_no_dcache:
+debugger_local_cache_flushinv_one_no_dcache:
 	#
 	# now try to flush the icache
 	#
 	mov	CHCTR,a0
 	movhu	(a0),d0
 	btst	CHCTR_ICEN,d0
-	beq	mn10300_local_icache_inv_range_reg_end
+	beq	debugger_local_cache_flushinv_one_end
 
 	LOCAL_CLI_SAVE(d1)
 

