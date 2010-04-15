Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752955Ab0DOLPA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Apr 2010 07:15:00 -0400
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:36530 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752320Ab0DOLO7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Apr 2010 07:14:59 -0400
Date: Thu, 15 Apr 2010 16:40:41 +0530
From: Arun R Bharadwaj <arun@linux.vnet.ibm.com>
To: peterz@infradead.org
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Ingo Molnar <mingo@elte.hu>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Dipankar Sarma <dipankar@in.ibm.com>, Balbir Singh <balbir@in.ibm.com>,
       Arun Bharadwaj <arun@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org
Subject: [v12 PATCH 6/8]: POWER: add a default_idle idle loop for POWER
Message-ID: <20100415111041.GG16760@linux.vnet.ibm.com>
Reply-To: arun@linux.vnet.ibm.com
References: <20100415110046.GA16760@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20100415110046.GA16760@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Arun R Bharadwaj <arun@linux.vnet.ibm.com> [2010-04-15 16:30:46]:

In arch/powerpc/kernel/idle.c create a default_idle() routine by moving
the failover condition of the cpu_idle() idle loop. This is needed by
cpuidle infrastructure to call default_idle when other idle routines
are not yet registered. Functionality remains the same, but the code is
slightly moved around.


Signed-off-by: Arun R Bharadwaj <arun@linux.vnet.ibm.com>
---
 arch/powerpc/Kconfig              |    3 +++
 arch/powerpc/include/asm/system.h |    1 +
 arch/powerpc/kernel/idle.c        |    6 ++++++
 3 files changed, 10 insertions(+)

Index: linux.trees.git/arch/powerpc/Kconfig
===================================================================
--- linux.trees.git.orig/arch/powerpc/Kconfig
+++ linux.trees.git/arch/powerpc/Kconfig
@@ -104,6 +104,9 @@ config ARCH_HAS_ILOG2_U64
 config ARCH_HAS_CPU_IDLE_WAIT
 	def_bool y
 
+config ARCH_HAS_DEFAULT_IDLE
+	def_bool y
+
 config GENERIC_HWEIGHT
 	bool
 	default y
Index: linux.trees.git/arch/powerpc/include/asm/system.h
===================================================================
--- linux.trees.git.orig/arch/powerpc/include/asm/system.h
+++ linux.trees.git/arch/powerpc/include/asm/system.h
@@ -223,6 +223,7 @@ extern unsigned long klimit;
 extern void *alloc_maybe_bootmem(size_t size, gfp_t mask);
 extern void *zalloc_maybe_bootmem(size_t size, gfp_t mask);
 
+extern void default_idle(void);
 extern int powersave_nap;	/* set if nap mode can be used in idle loop */
 
 /*
Index: linux.trees.git/arch/powerpc/kernel/idle.c
===================================================================
--- linux.trees.git.orig/arch/powerpc/kernel/idle.c
+++ linux.trees.git/arch/powerpc/kernel/idle.c
@@ -121,6 +121,12 @@ void cpu_idle_wait(void)
 }
 EXPORT_SYMBOL_GPL(cpu_idle_wait);
 
+void default_idle(void)
+{
+	HMT_low();
+	HMT_very_low();
+}
+
 int powersave_nap;
 
 #ifdef CONFIG_SYSCTL
