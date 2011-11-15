Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755996Ab1KOOk4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Nov 2011 09:40:56 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:38459 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755254Ab1KOOkz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Nov 2011 09:40:55 -0500
Date: Tue, 15 Nov 2011 09:40:04 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Deepthi Dharwar <deepthi@linux.vnet.ibm.com>
Cc: len.brown@intel.com, jeremy@goop.org, xen-devel@lists.xensource.com,
        x86@kernel.org, linux-kernel@vger.kernel.org, stable@kernel.org,
        mingo@redhat.com, bp@alien8.de, hpa@zytor.com, tj@kernel.org,
        tglx@linutronix.de, trenn@suse.de
Subject: Re: [Xen-devel] Re: [PATCH 1/3] cpuidle: If disable_cpuidle() is
 called, set pm_idle to default_idle.
Message-ID: <20111115144004.GE22675@phenom.dumpdata.com>
References: <1320786914-10541-1-git-send-email-konrad.wilk@oracle.com>
 <1320786914-10541-2-git-send-email-konrad.wilk@oracle.com>
 <4EBA53C5.9040603@linux.vnet.ibm.com>
 <20111109144440.GB8410@phenom.dumpdata.com>
 <4EBD09FF.4030002@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EBD09FF.4030002@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
X-CT-RefId: str=0001.0A090205.4EC279D4.00F3,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Well I was with a view that if cpuidle is disabled, mwait and arm_e400
> would take precedence over default_idle. But if is ok to have default_idle instead,
> then go ahead. 
> 
> > Perhaps there is another way do this is:
> > 
> > diff --git a/drivers/cpuidle/cpuidle.c b/drivers/cpuidle/cpuidle.c
> > index becd6d9..04b10a4 100644
> > --- a/drivers/cpuidle/cpuidle.c
> > +++ b/drivers/cpuidle/cpuidle.c
> > @@ -38,6 +38,7 @@ int cpuidle_disabled(void)
> >  void disable_cpuidle(void)
> >  {
> >  	off = 1;
> > +	pm_idle = default_idle;
> >  }
> > 
> Brining pm_idle pointer back to cpuidle code is going a step back coz
> we wanted to complete remove using pm_idle going forward. As having 
> a pointer exported into various files is not a good thing. That's the 
> reason we started the clean up in the first place :) 

Perhaps then something along these lines, where we still set default_idle
but don't fiddle with the pm_idle (and can still rip out the
EXPORT_SYMBOL_GPL(default_idle) in 2012):

(Hadn't tested this yet).

diff --git a/arch/x86/include/asm/system.h b/arch/x86/include/asm/system.h
index c2ff2a1..2d2f01c 100644
--- a/arch/x86/include/asm/system.h
+++ b/arch/x86/include/asm/system.h
@@ -401,6 +401,7 @@ extern unsigned long arch_align_stack(unsigned long sp);
 extern void free_init_pages(char *what, unsigned long begin, unsigned long end);
 
 void default_idle(void);
+bool set_pm_idle_to_default(void);
 
 void stop_this_cpu(void *dummy);
 
diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index e7e3b01..bfb113f 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -403,6 +403,14 @@ void default_idle(void)
 EXPORT_SYMBOL(default_idle);
 #endif
 
+bool set_pm_idle_to_default()
+{
+	if (!pm_idle) {
+		pm_idle = default_idle;
+		return true;
+	}
+	return false;
+}
 void stop_this_cpu(void *dummy)
 {
 	local_irq_disable();
diff --git a/arch/x86/xen/setup.c b/arch/x86/xen/setup.c
index 46d6d21..7506181 100644
--- a/arch/x86/xen/setup.c
+++ b/arch/x86/xen/setup.c
@@ -448,6 +448,6 @@ void __init xen_arch_setup(void)
 #endif
 	disable_cpuidle();
 	boot_option_idle_override = IDLE_HALT;
-
+	WARN_ON(!set_pm_idle_to_default());
 	fiddle_vdso();
 }
