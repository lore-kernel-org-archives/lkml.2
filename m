Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755022Ab2FAJMK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2012 05:12:10 -0400
Received: from e28smtp08.in.ibm.com ([122.248.162.8]:43518 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750742Ab2FAJMH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2012 05:12:07 -0400
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: [PATCH 04/27] smpboot, x86,
 xen: Determine smp booting implementations at run-time
To: tglx@linutronix.de, peterz@infradead.org, paulmck@linux.vnet.ibm.com
Cc: rusty@rustcorp.com.au, mingo@kernel.org, yong.zhang0@gmail.com,
        akpm@linux-foundation.org, vatsa@linux.vnet.ibm.com, rjw@sisk.pl,
        linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        srivatsa.bhat@linux.vnet.ibm.com, nikunj@linux.vnet.ibm.com,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>
Date: Fri, 01 Jun 2012 14:41:19 +0530
Message-ID: <20120601091056.31979.80669.stgit@srivatsabhat.in.ibm.com>
In-Reply-To: <20120601090952.31979.24799.stgit@srivatsabhat.in.ibm.com>
References: <20120601090952.31979.24799.stgit@srivatsabhat.in.ibm.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
x-cbid: 12060109-2000-0000-0000-000007C516ED
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

x86 and xen use the smp_ops structure to determine their respective
implementations of common functions at run-time, by registering appropriate
function pointers at early boot. Hook on to this mechanism for generic smp
booting implementation as well.

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: x86@kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>
Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
---

 arch/x86/include/asm/smp.h |   22 ++++++++++++++++++++++
 1 files changed, 22 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/smp.h b/arch/x86/include/asm/smp.h
index f483945..ac1f3eb 100644
--- a/arch/x86/include/asm/smp.h
+++ b/arch/x86/include/asm/smp.h
@@ -72,6 +72,10 @@ struct smp_ops {
 	void (*stop_other_cpus)(int wait);
 	void (*smp_send_reschedule)(int cpu);
 
+	void (*cpu_pre_starting)(void *arg);
+	void (*cpu_pre_online)(void *arg);
+	void (*cpu_post_online)(void *arg);
+
 	int (*cpu_up)(unsigned cpu, struct task_struct *tidle);
 	int (*cpu_disable)(void);
 	void (*cpu_die)(unsigned int cpu);
@@ -115,6 +119,24 @@ static inline void smp_cpus_done(unsigned int max_cpus)
 	smp_ops.smp_cpus_done(max_cpus);
 }
 
+static inline void __cpu_pre_starting(void *arg)
+{
+	smp_ops.cpu_pre_starting(arg);
+}
+#define __cpu_pre_starting	__cpu_pre_starting
+
+static inline void __cpu_pre_online(void *arg)
+{
+	smp_ops.cpu_pre_online(arg);
+}
+#define __cpu_pre_online	__cpu_pre_online
+
+static inline void __cpu_post_online(void *arg)
+{
+	smp_ops.cpu_post_online(arg);
+}
+#define __cpu_post_online	__cpu_post_online
+
 static inline int __cpu_up(unsigned int cpu, struct task_struct *tidle)
 {
 	return smp_ops.cpu_up(cpu, tidle);

