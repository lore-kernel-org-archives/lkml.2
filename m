Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756372Ab0JZCz2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 22:55:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1028 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757554Ab0JZCzZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 22:55:25 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH 25/43] MN10300: AM34 erratum requires MMUCTR read and write
 on exception entry
To: linux-am33-list@redhat.com
From: David Howells <dhowells@redhat.com>
Cc: linux-kernel@vger.kernel.org,
        Akira Takeuchi <takeuchi.akr@jp.panasonic.com>,
        Kiyoshi Owada <owada.kiyoshi@jp.panasonic.com>
Date: Tue, 26 Oct 2010 03:55:15 +0100
Message-ID: <20101026025515.23512.96853.stgit@warthog.procyon.org.uk>
In-Reply-To: <20101026025301.23512.24525.stgit@warthog.procyon.org.uk>
References: <20101026025301.23512.24525.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.15-97-g9680-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Akira Takeuchi <takeuchi.akr@jp.panasonic.com>

An AM34 erratum requires MMUCTR read and write on entry to certain exceptions,
prior to EPSW.NMID being cleared to allow NMIs to happen.

Signed-off-by: Akira Takeuchi <takeuchi.akr@jp.panasonic.com>
Signed-off-by: Kiyoshi Owada <owada.kiyoshi@jp.panasonic.com>
Signed-off-by: David Howells <dhowells@redhat.com>
---

 arch/mn10300/Kconfig          |    3 +++
 arch/mn10300/kernel/entry.S   |    8 ++++++++
 arch/mn10300/mm/tlb-mn10300.S |   32 ++++++++++++++++++++++++++------
 3 files changed, 37 insertions(+), 6 deletions(-)


diff --git a/arch/mn10300/Kconfig b/arch/mn10300/Kconfig
index 21e2a53..dd7b570 100644
--- a/arch/mn10300/Kconfig
+++ b/arch/mn10300/Kconfig
@@ -20,6 +20,9 @@ config AM34_2
 	select MN10300_HAS_ATOMIC_OPS_UNIT
 	select MN10300_HAS_CACHE_SNOOP
 
+config ERRATUM_NEED_TO_RELOAD_MMUCTR
+	def_bool y if AM33_3 || AM34_2
+
 config MMU
 	def_bool y
 
diff --git a/arch/mn10300/kernel/entry.S b/arch/mn10300/kernel/entry.S
index b82ce7b..355f681 100644
--- a/arch/mn10300/kernel/entry.S
+++ b/arch/mn10300/kernel/entry.S
@@ -251,6 +251,10 @@ double_fault_loop:
 ENTRY(raw_bus_error)
 	add	-4,sp
 	mov	d0,(sp)
+#if defined(CONFIG_ERRATUM_NEED_TO_RELOAD_MMUCTR)
+	mov	(MMUCTR),d0
+	mov	d0,(MMUCTR)
+#endif
 	mov	(BCBERR),d0		# what
 	btst	BCBERR_BEMR_DMA,d0	# see if it was an external bus error
 	beq	__common_exception_aux	# it wasn't
@@ -282,6 +286,10 @@ ENTRY(nmi_handler)
 ENTRY(__common_exception)
 	add	-4,sp
 	mov	d0,(sp)
+#if defined(CONFIG_ERRATUM_NEED_TO_RELOAD_MMUCTR)
+	mov	(MMUCTR),d0
+	mov	d0,(MMUCTR)
+#endif
 
 __common_exception_aux:
 	mov	(TBR),d0
diff --git a/arch/mn10300/mm/tlb-mn10300.S b/arch/mn10300/mm/tlb-mn10300.S
index 7095147..ccf6229 100644
--- a/arch/mn10300/mm/tlb-mn10300.S
+++ b/arch/mn10300/mm/tlb-mn10300.S
@@ -27,7 +27,6 @@
 ###############################################################################
 	.type	itlb_miss,@function
 ENTRY(itlb_miss)
-	and	~EPSW_NMID,epsw
 #ifdef CONFIG_GDBSTUB
 	movm	[d2,d3,a2],(sp)
 #else
@@ -38,6 +37,12 @@ ENTRY(itlb_miss)
 	nop
 #endif
 
+#if defined(CONFIG_ERRATUM_NEED_TO_RELOAD_MMUCTR)
+	mov	(MMUCTR),d2
+	mov	d2,(MMUCTR)
+#endif
+
+	and	~EPSW_NMID,epsw
 	mov	(IPTEU),d3
 	mov	(PTBR),a2
 	mov	d3,d2
@@ -79,7 +84,6 @@ itlb_miss_fault:
 ###############################################################################
 	.type	dtlb_miss,@function
 ENTRY(dtlb_miss)
-	and	~EPSW_NMID,epsw
 #ifdef CONFIG_GDBSTUB
 	movm	[d2,d3,a2],(sp)
 #else
@@ -90,6 +94,12 @@ ENTRY(dtlb_miss)
 	nop
 #endif
 
+#if defined(CONFIG_ERRATUM_NEED_TO_RELOAD_MMUCTR)
+	mov	(MMUCTR),d2
+	mov	d2,(MMUCTR)
+#endif
+
+	and	~EPSW_NMID,epsw
 	mov	(DPTEU),d3
 	mov	(PTBR),a2
 	mov	d3,d2
@@ -130,9 +140,15 @@ dtlb_miss_fault:
 ###############################################################################
 	.type	itlb_aerror,@function
 ENTRY(itlb_aerror)
-	and	~EPSW_NMID,epsw
 	add	-4,sp
 	SAVE_ALL
+
+#if defined(CONFIG_ERRATUM_NEED_TO_RELOAD_MMUCTR)
+	mov	(MMUCTR),d1
+	mov	d1,(MMUCTR)
+#endif
+
+	and	~EPSW_NMID,epsw
 	add	-4,sp				# need to pass three params
 
 	# calculate the fault code
@@ -148,7 +164,6 @@ ENTRY(itlb_aerror)
 	clr	d0
 	mov	d0,(IPTEL)
 
-	and	~EPSW_NMID,epsw
 	or	EPSW_IE,epsw
 	mov	fp,d0
 	call	do_page_fault[],0		# do_page_fault(regs,code,addr
@@ -163,10 +178,16 @@ ENTRY(itlb_aerror)
 ###############################################################################
 	.type	dtlb_aerror,@function
 ENTRY(dtlb_aerror)
-	and	~EPSW_NMID,epsw
 	add	-4,sp
 	SAVE_ALL
+
+#if defined(CONFIG_ERRATUM_NEED_TO_RELOAD_MMUCTR)
+	mov	(MMUCTR),d1
+	mov	d1,(MMUCTR)
+#endif
+
 	add	-4,sp				# need to pass three params
+	and	~EPSW_NMID,epsw
 
 	# calculate the fault code
 	movhu	(MMUFCR_DFC),d1
@@ -180,7 +201,6 @@ ENTRY(dtlb_aerror)
 	clr	d0
 	mov	d0,(DPTEL)
 
-	and	~EPSW_NMID,epsw
 	or	EPSW_IE,epsw
 	mov	fp,d0
 	call	do_page_fault[],0		# do_page_fault(regs,code,addr

