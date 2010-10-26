Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758914Ab0JZCxp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 22:53:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7537 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758895Ab0JZCxn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 22:53:43 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH 06/43] Typedef SMP call function pointer
To: linux-am33-list@redhat.com
From: David Howells <dhowells@redhat.com>
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Tue, 26 Oct 2010 03:53:34 +0100
Message-ID: <20101026025333.23512.76163.stgit@warthog.procyon.org.uk>
In-Reply-To: <20101026025301.23512.24525.stgit@warthog.procyon.org.uk>
References: <20101026025301.23512.24525.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.15-97-g9680-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Typedef the pointer to the function to be called by smp_call_function() and
friends:

	typedef void (*smp_call_func_t)(void *info);

as it is used in a fair number of places.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: linux-arch@vger.kernel.org
---

 include/linux/smp.h |   19 ++++++++++---------
 kernel/smp.c        |    8 ++++----
 2 files changed, 14 insertions(+), 13 deletions(-)


diff --git a/include/linux/smp.h b/include/linux/smp.h
index cfa2d20..6dc95ca 100644
--- a/include/linux/smp.h
+++ b/include/linux/smp.h
@@ -13,9 +13,10 @@
 
 extern void cpu_idle(void);
 
+typedef void (*smp_call_func_t)(void *info);
 struct call_single_data {
 	struct list_head list;
-	void (*func) (void *info);
+	smp_call_func_t func;
 	void *info;
 	u16 flags;
 	u16 priv;
@@ -24,8 +25,8 @@ struct call_single_data {
 /* total number of cpus in this system (may exceed NR_CPUS) */
 extern unsigned int total_cpus;
 
-int smp_call_function_single(int cpuid, void (*func) (void *info), void *info,
-				int wait);
+int smp_call_function_single(int cpuid, smp_call_func_t func, void *info,
+			     int wait);
 
 #ifdef CONFIG_SMP
 
@@ -69,15 +70,15 @@ extern void smp_cpus_done(unsigned int max_cpus);
 /*
  * Call a function on all other processors
  */
-int smp_call_function(void(*func)(void *info), void *info, int wait);
+int smp_call_function(smp_call_func_t func, void *info, int wait);
 void smp_call_function_many(const struct cpumask *mask,
-			    void (*func)(void *info), void *info, bool wait);
+			    smp_call_func_t func, void *info, bool wait);
 
 void __smp_call_function_single(int cpuid, struct call_single_data *data,
 				int wait);
 
 int smp_call_function_any(const struct cpumask *mask,
-			  void (*func)(void *info), void *info, int wait);
+			  smp_call_func_t func, void *info, int wait);
 
 /*
  * Generic and arch helpers
@@ -94,7 +95,7 @@ void ipi_call_unlock_irq(void);
 /*
  * Call a function on all processors
  */
-int on_each_cpu(void (*func) (void *info), void *info, int wait);
+int on_each_cpu(smp_call_func_t func, void *info, int wait);
 
 #define MSG_ALL_BUT_SELF	0x8000	/* Assume <32768 CPU's */
 #define MSG_ALL			0x8001
@@ -122,7 +123,7 @@ static inline void smp_send_stop(void) { }
  *	These macros fold the SMP functionality into a single CPU system
  */
 #define raw_smp_processor_id()			0
-static inline int up_smp_call_function(void (*func)(void *), void *info)
+static inline int up_smp_call_function(smp_call_func_t func, void *info)
 {
 	return 0;
 }
@@ -143,7 +144,7 @@ static inline void smp_send_reschedule(int cpu) { }
 static inline void init_call_single_data(void) { }
 
 static inline int
-smp_call_function_any(const struct cpumask *mask, void (*func)(void *info),
+smp_call_function_any(const struct cpumask *mask, smp_call_func_t func,
 		      void *info, int wait)
 {
 	return smp_call_function_single(0, func, info, wait);
diff --git a/kernel/smp.c b/kernel/smp.c
index ed6aacf..12ed8b0 100644
--- a/kernel/smp.c
+++ b/kernel/smp.c
@@ -267,7 +267,7 @@ static DEFINE_PER_CPU_SHARED_ALIGNED(struct call_single_data, csd_data);
  *
  * Returns 0 on success, else a negative status code.
  */
-int smp_call_function_single(int cpu, void (*func) (void *info), void *info,
+int smp_call_function_single(int cpu, smp_call_func_t func, void *info,
 			     int wait)
 {
 	struct call_single_data d = {
@@ -336,7 +336,7 @@ EXPORT_SYMBOL(smp_call_function_single);
  *	3) any other online cpu in @mask
  */
 int smp_call_function_any(const struct cpumask *mask,
-			  void (*func)(void *info), void *info, int wait)
+			  smp_call_func_t func, void *info, int wait)
 {
 	unsigned int cpu;
 	const struct cpumask *nodemask;
@@ -416,7 +416,7 @@ void __smp_call_function_single(int cpu, struct call_single_data *data,
  * must be disabled when calling this function.
  */
 void smp_call_function_many(const struct cpumask *mask,
-			    void (*func)(void *), void *info, bool wait)
+			    smp_call_func_t func, void *info, bool wait)
 {
 	struct call_function_data *data;
 	unsigned long flags;
@@ -500,7 +500,7 @@ EXPORT_SYMBOL(smp_call_function_many);
  * You must not call this function with disabled interrupts or from a
  * hardware interrupt handler or from a bottom half handler.
  */
-int smp_call_function(void (*func)(void *), void *info, int wait)
+int smp_call_function(smp_call_func_t func, void *info, int wait)
 {
 	preempt_disable();
 	smp_call_function_many(cpu_online_mask, func, info, wait);

