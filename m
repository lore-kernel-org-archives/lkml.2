Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755344Ab1HWQmy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 12:42:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39607 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754245Ab1HWQms (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 12:42:48 -0400
Date: Tue, 23 Aug 2011 12:42:41 -0400
From: Don Zickus <dzickus@redhat.com>
To: Dave Chinner <david@fromorbit.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org
Subject: Re: trigger_all_cpu_backtrace() has no generic implementation (was
 Re: [regression, 3.1, rcu] rcu_sched_state detected stall on CPU 8 (t=15000
 jiffies))
Message-ID: <20110823164241.GA2358@redhat.com>
References: <20110803022857.GH12870@dastard>
 <20110803025222.GI12870@dastard>
 <20110803063049.GD13065@linux.vnet.ibm.com>
 <20110805003316.GA3162@dastard>
 <20110805064119.GB13065@linux.vnet.ibm.com>
 <20110805084839.GB3162@dastard>
 <20110805112429.GM13065@linux.vnet.ibm.com>
 <20110806002056.GC3162@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110806002056.GC3162@dastard>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 06, 2011 at 10:20:56AM +1000, Dave Chinner wrote:
> > My ability to do so is quite limited, but you do have
> > CONFIG_X86_LOCAL_APIC=y.  I took a quick look but don't immediately
> > see why you would not be getting the NMI variant.
> 
> It would appear to be because include/linux/nmi.h does not do
> #include <asm/nmi.h> where arch_trigger_all_cpu_backtrace is
> defined.
> 
> I think this is the case from looking at the build deps for
> rcutree.h: I see include/linux/nmi.h but no asm/nmi.h. It appears
> that asm/nmi.h is only included if this config ifdef is true:

Hi Dave,

Does this patch solve your problem?

Cheers,
Don


diff --git a/arch/x86/include/asm/irq.h b/arch/x86/include/asm/irq.h
index ba870bb..ffa50f5 100644
--- a/arch/x86/include/asm/irq.h
+++ b/arch/x86/include/asm/irq.h
@@ -10,6 +10,8 @@
 #include <asm/apicdef.h>
 #include <asm/irq_vectors.h>
 
+#define ARCH_HAS_NMI_WATCHDOG
+
 static inline int irq_canonicalize(int irq)
 {
 	return ((irq == 2) ? 9 : irq);
diff --git a/arch/x86/include/asm/nmi.h b/arch/x86/include/asm/nmi.h
index a4f1945..74172ef 100644
--- a/arch/x86/include/asm/nmi.h
+++ b/arch/x86/include/asm/nmi.h
@@ -5,6 +5,13 @@
 #include <asm/irq.h>
 #include <asm/io.h>
 
+#if !defined (CONFIG_HARDLOCKUP_DETECTOR)
+#include <linux/sched.h>
+static inline void touch_nmi_watchdog(void)
+{
+	touch_softlockup_watchdog();
+}
+#endif
 #ifdef CONFIG_X86_LOCAL_APIC
 
 extern int avail_to_resrv_perfctr_nmi_bit(unsigned int);
diff --git a/include/linux/nmi.h b/include/linux/nmi.h
index 2d304ef..9aac41b 100644
--- a/include/linux/nmi.h
+++ b/include/linux/nmi.h
@@ -14,7 +14,7 @@
  * may be used to reset the timeout - for code which intentionally
  * disables interrupts for a long time. This call is stateless.
  */
-#if defined(ARCH_HAS_NMI_WATCHDOG) || defined(CONFIG_HARDLOCKUP_DETECTOR)
+#if defined(ARCH_HAS_NMI_WATCHDOG)
 #include <asm/nmi.h>
 extern void touch_nmi_watchdog(void);
 #else
