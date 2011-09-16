Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753557Ab1IPMY1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Sep 2011 08:24:27 -0400
Received: from mail-wy0-f180.google.com ([74.125.82.180]:42906 "EHLO
	mail-wy0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752529Ab1IPMY0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Sep 2011 08:24:26 -0400
Date: Fri, 16 Sep 2011 14:24:17 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        Valdis.Kletnieks@vt.edu, dhowells@redhat.com, eric.dumazet@gmail.com,
        darren@dvhart.com, patches@linaro.org, anton@samba.org,
        paulus@samba.org
Subject: Re: [PATCH tip/core/rcu 55/55] powerpc: Work around tracing from
 dyntick-idle mode
Message-ID: <20110916122220.GA5089@somewhere.redhat.com>
References: <20110906180015.GA2560@linux.vnet.ibm.com>
 <1315332049-2604-55-git-send-email-paulmck@linux.vnet.ibm.com>
 <1315389622.26118.17.camel@pasglop>
 <20110907134400.GJ3610@linux.vnet.ibm.com>
 <20110913191319.GF23424@somewhere>
 <20110913195033.GB3301@linux.vnet.ibm.com>
 <1315946993.455.158.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1315946993.455.158.camel@pasglop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 13, 2011 at 05:49:53PM -0300, Benjamin Herrenschmidt wrote:
> 
> > As I understand it, cede_processor()'s call to plpar_hcall_norets()
> > results in the hypervisor being invoked, and could give up the CPU.
> > And yes, in this case, RCU needs to stop paying attention to this CPU.
> > And pseries_shared_idle_sleep() also invokes cede_proceessor().
> > 
> > Gah...  And there also appear to be some assembly-language functions
> > that can be invoked via the ppc_md.power_save() call from cpu_idle():
> > ppc6xx_idle(), power4_idle(), idle_spin(), idle_doze(), and book3e_idle().
> > There is also a power7_idle(), but it does not appear to be used anywhere.
> > 
> > Plus there are the C-language ppc44x_idle(), beat_power_save(),
> > cbe_power_save(), ps3_power_save(), and cpm_idle().
> > 
> > > > The same thing would be needed for tick_nohz_exit_idle() and
> > > > rcu_exit_nohz(): powerpc would need to invoke rcu_exit_nohz() after
> > > > gaining control from the hypervisor but before doing its first tracing,
> > > > and then it would need the idle loop to to tick_nohz_exit_idle(false).
> > > > Again, if pseries is the only powerpc architecture requiring this,
> > > > the argument to tick_nohz_exit_idle() could depend on the architecture.
> > > > 
> > > > Would this approach work?
> > > 
> > > Sounds like we really need that.
> > 
> > Sounds like an arch-dependent config symbol that is defined for the
> > pseries targets, but not for the other powerpc architectures.
> > 
> > Not clear to me what to do about power4_idle(), though.
> 
> I don't totally follow, too many things to deal with right now, but keep
> in mind that we build multiplatform kernels, so you can have powermac,
> cell, pseries, etc... all in one kernel binary (including power7 idle).
> 
> Shouldn't we instead change the plpar trace call to skip the tracing
> when not safe to do so ?

So perhaps something like this could help? AFAIK the only place
where the calls to trace_hcall_entry/exit are unsafe is on
cede_processor().

(I don't know powerpc asm so that patch is only made on guesses
from similarities with ARM asm that I know better).

Only compile tested.


Not-yet-signed-off-by: Me
---
diff --git a/arch/powerpc/include/asm/hvcall.h b/arch/powerpc/include/asm/hvcall.h
index fd8201d..37818d3 100644
--- a/arch/powerpc/include/asm/hvcall.h
+++ b/arch/powerpc/include/asm/hvcall.h
@@ -250,6 +250,8 @@
  */
 long plpar_hcall_norets(unsigned long opcode, ...);
 
+long plpar_hcall_norets_notrace(unsigned long opcode, ...);
+
 /**
  * plpar_hcall: - Make a pseries hypervisor call
  * @opcode: The hypervisor call to make.
diff --git a/arch/powerpc/platforms/pseries/hvCall.S b/arch/powerpc/platforms/pseries/hvCall.S
index fd05fde..302fc7a 100644
--- a/arch/powerpc/platforms/pseries/hvCall.S
+++ b/arch/powerpc/platforms/pseries/hvCall.S
@@ -107,6 +107,18 @@ END_FTR_SECTION(0, 1);						\
 
 	.text
 
+_GLOBAL(plpar_hcall_norets_notrace)
+	HMT_MEDIUM
+
+	mfcr	r0
+	stw	r0,8(r1)
+
+	HVSC				/* invoke the hypervisor */
+
+	lwz	r0,8(r1)
+	mtcrf	0xff,r0
+	blr				/* return r3 = status */
+
 _GLOBAL(plpar_hcall_norets)
 	HMT_MEDIUM
 
diff --git a/arch/powerpc/platforms/pseries/plpar_wrappers.h b/arch/powerpc/platforms/pseries/plpar_wrappers.h
index 4bf2120..30f3d64 100644
--- a/arch/powerpc/platforms/pseries/plpar_wrappers.h
+++ b/arch/powerpc/platforms/pseries/plpar_wrappers.h
@@ -29,7 +29,7 @@ static inline void set_cede_latency_hint(u8 latency_hint)
 
 static inline long cede_processor(void)
 {
-	return plpar_hcall_norets(H_CEDE);
+	return plpar_hcall_norets_notrace(H_CEDE);
 }
 
 static inline long extended_cede_processor(unsigned long latency_hint)

