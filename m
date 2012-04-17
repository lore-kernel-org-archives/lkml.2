Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932229Ab2DQLTb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 07:19:31 -0400
Received: from orion.tchmachines.com ([208.76.84.200]:41603 "EHLO
	orion.tchmachines.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755822Ab2DQLT0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 07:19:26 -0400
From: Vlad Zolotarov <vlad@scalemp.com>
Organization: ScaleMP Ltd.
To: "linux-kernel" <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH 1/2] x86: Define early read-mostly per-cpu macros
Date: Tue, 17 Apr 2012 14:16:01 +0300
User-Agent: KMail/1.13.5 (Linux/2.6.32-40-generic; KDE/4.4.5; i686; ; )
Cc: "Shai Fultheim (Shai@ScaleMP.com)" <Shai@scalemp.com>, ido@wizery.com
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201204171416.01682.vlad@scalemp.com>
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
Signed-off-by: Shai Fultheim <shai@scalemp.com>
Signed-off-by: Vlad Zolotarov <vlad@scalemp.com>
---
 arch/x86/include/asm/percpu.h |   11 +++++++++++
 1 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/percpu.h b/arch/x86/include/asm/percpu.h
index 7a11910..6568662 100644
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
-- 
1.7.7.6

