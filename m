Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753024Ab2FKJ4o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 05:56:44 -0400
Received: from orion.tchmachines.com ([208.76.84.200]:44173 "EHLO
	orion.tchmachines.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752733Ab2FKJ4m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 05:56:42 -0400
From: Vlad Zolotarov <vlad@scalemp.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Shai Fultheim (Shai@ScaleMP.com)" <Shai@scalemp.com>,
        Ido Yariv <ido@wizery.com>
Subject: [PATCH v5 1/2] x86: Define early read-mostly per-cpu macros
Date: Mon, 11 Jun 2012 12:56:45 +0300
Message-ID: <46188571.ddB8aVQYWo@vlad>
Organization: ScaleMP Ltd.
User-Agent: KMail/4.8.3 (Linux/3.2.0-24-generic; KDE/4.8.3; i686; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - orion.tchmachines.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - scalemp.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ido Yariv <ido@wizery.com>

Some read-mostly per-cpu data may need to be declared or defined early,
so it can be initialized and accessed before per_cpu areas are
allocated.

Only the data that resides in the per_cpu areas should be read-mostly,
as there is little benefit in optimizing cache lines on initialization.

Signed-off-by: Ido Yariv <ido@wizery.com>
[ added the missing declarations in a !SMP code ]
Signed-off-by: Vlad Zolotarov <vlad@scalemp.com>
Acked-by: Shai Fultheim <shai@scalemp.com>
---
 arch/x86/include/asm/percpu.h |   17 +++++++++++++++++
 1 files changed, 17 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/percpu.h b/arch/x86/include/asm/percpu.h
index 7a11910..8b5c8e0 100644
--- a/arch/x86/include/asm/percpu.h
+++ b/arch/x86/include/asm/percpu.h
@@ -555,6 +555,12 @@ DECLARE_PER_CPU(unsigned long, this_cpu_off);
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
 
@@ -563,6 +569,11 @@ DECLARE_PER_CPU(unsigned long, this_cpu_off);
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
@@ -574,12 +585,18 @@ DECLARE_PER_CPU(unsigned long, this_cpu_off);
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
-- 
1.7.5.4


