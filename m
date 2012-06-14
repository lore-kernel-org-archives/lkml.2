Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756033Ab2FNOoS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 10:44:18 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35385 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753985Ab2FNOoR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 10:44:17 -0400
Date: Thu, 14 Jun 2012 07:43:52 -0700
From: tip-bot for Ido Yariv <ido@wizery.com>
Message-ID: <tip-c35f77417ebfc7c21c02aa9c8c30aa4cecf331d6@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, torvalds@linux-foundation.org,
        vlad@scalemp.com, shai@scalemp.com, akpm@linux-foundation.org,
        tglx@linutronix.de, ido@wizery.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, a.p.zijlstra@chello.nl,
        vlad@scalemp.com, shai@scalemp.com, akpm@linux-foundation.org,
        ido@wizery.com, tglx@linutronix.de
In-Reply-To: <46188571.ddB8aVQYWo@vlad>
References: <46188571.ddB8aVQYWo@vlad>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mm] x86: Define early read-mostly per-cpu macros
Git-Commit-ID: c35f77417ebfc7c21c02aa9c8c30aa4cecf331d6
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Thu, 14 Jun 2012 07:43:59 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c35f77417ebfc7c21c02aa9c8c30aa4cecf331d6
Gitweb:     http://git.kernel.org/tip/c35f77417ebfc7c21c02aa9c8c30aa4cecf331d6
Author:     Ido Yariv <ido@wizery.com>
AuthorDate: Mon, 11 Jun 2012 12:56:45 +0300
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 14 Jun 2012 12:42:10 +0200

x86: Define early read-mostly per-cpu macros

Some read-mostly per-cpu data may need to be declared or defined
early, so it can be initialized and accessed before per_cpu
areas are allocated.

Only the data that resides in the per_cpu areas should be
read-mostly, as there is little benefit in optimizing cache
lines on initialization.

Signed-off-by: Ido Yariv <ido@wizery.com>
[ Added the missing declarations in !SMP code. ]
Signed-off-by: Vlad Zolotarov <vlad@scalemp.com>
Acked-by: Shai Fultheim <shai@scalemp.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/46188571.ddB8aVQYWo@vlad
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/include/asm/percpu.h |   17 +++++++++++++++++
 1 files changed, 17 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/percpu.h b/arch/x86/include/asm/percpu.h
index d9b8e3f..1104afa 100644
--- a/arch/x86/include/asm/percpu.h
+++ b/arch/x86/include/asm/percpu.h
@@ -551,6 +551,12 @@ DECLARE_PER_CPU(unsigned long, this_cpu_off);
 				{ [0 ... NR_CPUS-1] = _initvalue };	\
 	__typeof__(_type) *_name##_early_ptr __refdata = _name##_early_map
 
+#define DEFINE_EARLY_PER_CPU_READ_MOSTLY(_type, _name, _initvalue)	\
+	DEFINE_PER_CPU_READ_MOSTLY(_type, _name) = _initvalue;		\
+	__typeof__(_type) _name##_early_map[NR_CPUS] __initdata =	\
+				{ [0 ... NR_CPUS-1] = _initvalue };	\
+	__typeof__(_type) *_name##_early_ptr __refdata = _name##_early_map
+
 #define EXPORT_EARLY_PER_CPU_SYMBOL(_name)			\
 	EXPORT_PER_CPU_SYMBOL(_name)
 
@@ -559,6 +565,11 @@ DECLARE_PER_CPU(unsigned long, this_cpu_off);
 	extern __typeof__(_type) *_name##_early_ptr;		\
 	extern __typeof__(_type)  _name##_early_map[]
 
+#define DECLARE_EARLY_PER_CPU_READ_MOSTLY(_type, _name)		\
+	DECLARE_PER_CPU_READ_MOSTLY(_type, _name);		\
+	extern __typeof__(_type) *_name##_early_ptr;		\
+	extern __typeof__(_type)  _name##_early_map[]
+
 #define	early_per_cpu_ptr(_name) (_name##_early_ptr)
 #define	early_per_cpu_map(_name, _idx) (_name##_early_map[_idx])
 #define	early_per_cpu(_name, _cpu) 				\
@@ -570,12 +581,18 @@ DECLARE_PER_CPU(unsigned long, this_cpu_off);
 #define	DEFINE_EARLY_PER_CPU(_type, _name, _initvalue)		\
 	DEFINE_PER_CPU(_type, _name) = _initvalue
 
+#define DEFINE_EARLY_PER_CPU_READ_MOSTLY(_type, _name, _initvalue)	\
+	DEFINE_PER_CPU_READ_MOSTLY(_type, _name) = _initvalue
+
 #define EXPORT_EARLY_PER_CPU_SYMBOL(_name)			\
 	EXPORT_PER_CPU_SYMBOL(_name)
 
 #define DECLARE_EARLY_PER_CPU(_type, _name)			\
 	DECLARE_PER_CPU(_type, _name)
 
+#define DECLARE_EARLY_PER_CPU_READ_MOSTLY(_type, _name)		\
+	DECLARE_PER_CPU_READ_MOSTLY(_type, _name)
+
 #define	early_per_cpu(_name, _cpu) per_cpu(_name, _cpu)
 #define	early_per_cpu_ptr(_name) NULL
 /* no early_per_cpu_map() */
