Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757509Ab2EYMRa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 08:17:30 -0400
Received: from www.linutronix.de ([62.245.132.108]:38405 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751715Ab2EYMR2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 08:17:28 -0400
Date: Fri, 25 May 2012 14:17:22 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Chen Gong <gong.chen@linux.intel.com>
cc: Borislav Petkov <bp@amd64.org>, LKML <linux-kernel@vger.kernel.org>,
        tony.luck@intel.com, x86@kernel.org,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [patch 2/2] x86: mce: Implement cmci poll mode for intel
 machines
In-Reply-To: <alpine.LFD.2.02.1205251119390.3231@ionos>
Message-ID: <alpine.LFD.2.02.1205251413310.3231@ionos>
References: <20120524174943.989990966@linutronix.de> <20120524175056.478167482@linutronix.de> <20120525062426.GB3179@aftab.osrc.amd.com> <4FBF3561.4040805@linux.intel.com> <alpine.LFD.2.02.1205251119390.3231@ionos>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-1145191777-1337948243=:3231"
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-1145191777-1337948243=:3231
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Fri, 25 May 2012, Thomas Gleixner wrote:
> On Fri, 25 May 2012, Chen Gong wrote:
> 
> > 于 2012/5/25 14:24, Borislav Petkov 写道:
> > > On Thu, May 24, 2012 at 05:54:52PM +0000, Thomas Gleixner wrote:
> > >> Intentionally left blank to be filled out by someone who wants
> > >> that and can explain the reason for this better than me.
> > > 
> > > That'll be Intel folk :)
> > > 
> > >> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> > > 
> > > Looks good to me too, thanks Thomas for doing this!
> > > 
> > > I'll run it next week just in case.
> > > 
> > > Acked-by: Borislav Petkov <borislav.petkov@amd.com>
> > > 
> > 
> > Oh, Oh, wait. First I need to thank Thomas to improve it. I don't
> > reply you at the first time because I have some thoughts and now
> > I'm testing it. The basic test shows it hangs the system after
> > sb_edac is removed and when error count increases to the threshold
> > it hangs again, and when trying to reboot the system no hang happnes
> > (not reach the threshold) the system oops. I need to time to debug
> > and give the valid feedback. Please be patient :-). Of course,
> 
> As I said it's completely untested. I just made sure it compiles :)

I just had a quick look again and noticed that nothing is polling the
cmci part in case of the storm mode.

Delta fix below.

Thanks,

	tglx

Index: linux-2.6/arch/x86/kernel/cpu/mcheck/mce-internal.h
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/mcheck/mce-internal.h
+++ linux-2.6/arch/x86/kernel/cpu/mcheck/mce-internal.h
@@ -30,8 +30,10 @@ extern struct mce_bank *mce_banks;
 
 #ifdef CONFIG_X86_MCE_INTEL
 unsigned long mce_intel_adjust_timer(unsigned long interval);
+void mce_intel_cmci_poll(void);
 #else
 # define mce_intel_adjust_timer mce_adjust_timer_default
+static inline void mce_intel_cmci_poll(void) { }
 #endif
 
 void mce_timer_kick(unsigned long interval);
Index: linux-2.6/arch/x86/kernel/cpu/mcheck/mce.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/mcheck/mce.c
+++ linux-2.6/arch/x86/kernel/cpu/mcheck/mce.c
@@ -1260,6 +1260,7 @@ static void mce_timer_fn(unsigned long d
 	if (mce_available(__this_cpu_ptr(&cpu_info))) {
 		machine_check_poll(MCP_TIMESTAMP,
 				&__get_cpu_var(mce_poll_banks));
+		mce_intel_cmci_poll();
 	}
 
 	/*
Index: linux-2.6/arch/x86/kernel/cpu/mcheck/mce_intel.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/mcheck/mce_intel.c
+++ linux-2.6/arch/x86/kernel/cpu/mcheck/mce_intel.c
@@ -70,6 +70,13 @@ static int cmci_supported(int *banks)
 	return !!(cap & MCG_CMCI_P);
 }
 
+void mce_intel_cmci_poll(void)
+{
+	if (__this_cpu_read(cmci_storm_state) == CMCI_STORM_NONE)
+		return;
+	machine_check_poll(MCP_TIMESTAMP, &__get_cpu_var(mce_banks_owned));
+}
+
 unsigned long mce_intel_adjust_timer(unsigned long interval)
 {
 	if (interval < CMCI_POLL_INTERVAL)
--8323328-1145191777-1337948243=:3231--
