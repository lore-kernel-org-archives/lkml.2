Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756515Ab0LBFXo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Dec 2010 00:23:44 -0500
Received: from mx1.redhat.com ([209.132.183.28]:36652 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751901Ab0LBFXn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Dec 2010 00:23:43 -0500
Date: Thu, 2 Dec 2010 00:23:21 -0500
From: Don Zickus <dzickus@redhat.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Vivek Goyal <vgoyal@redhat.com>,
        Yinghai Lu <yinghai@kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Jason Wessel <jason.wessel@windriver.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Haren Myneni <hbabu@us.ibm.com>
Subject: Re: perf hw  in kexeced kernel broken in tip
Message-ID: <20101202052321.GH18100@redhat.com>
References: <1291202867.4023.3.camel@twins>
 <20101201160640.GA2511@redhat.com>
 <1291219906.32004.1671.camel@laptop>
 <20101201162335.GB2511@redhat.com>
 <1291232292.32004.1969.camel@laptop>
 <20101201194644.GD2511@redhat.com>
 <1291232989.32004.1987.camel@laptop>
 <20101201195835.GE2511@redhat.com>
 <1291234036.32004.2008.camel@laptop>
 <m162vdp3l4.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m162vdp3l4.fsf@fess.ebiederm.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 01, 2010 at 01:48:07PM -0800, Eric W. Biederman wrote:
> >
> > Oh, but I'm not a device or sysdev thing, I'll never get something like
> > that.
> 
> There is also the reboot notifier, if the NMI needs to be controlled
> outside of device model.  Sigh. The NMI handling is such a special case.

I tried reboot notifiers with the nmi_watchdog and acheived some success
(on a Westmere box, a P4 still failed).  Kdump is still screwed, but maybe
we don't care for now.

Here is the quick and dirty patch I used.

Cheers,
Don


diff --git a/kernel/watchdog.c b/kernel/watchdog.c
index 792a4ed..3455cf9 100644
--- a/kernel/watchdog.c
+++ b/kernel/watchdog.c
@@ -23,6 +23,7 @@
 #include <linux/notifier.h>
 #include <linux/module.h>
 #include <linux/sysctl.h>
+#include <linux/reboot.h>
 
 #include <asm/irq_regs.h>
 #include <linux/perf_event.h>
@@ -550,6 +551,18 @@ static struct notifier_block __cpuinitdata cpu_nfb = {
 	.notifier_call = cpu_callback
 };
 
+static int __cpuinit
+reboot_callback(struct notifier_block *nfb, unsigned long action, void *unused)
+{
+	watchdog_disable_all_cpus();
+
+	return notifier_from_errno(0);
+}
+
+static struct notifier_block __cpuinitdata reboot_nfb = {
+	.notifier_call = reboot_callback
+};
+
 void __init lockup_detector_init(void)
 {
 	void *cpu = (void *)(long)smp_processor_id();
@@ -563,6 +576,7 @@ void __init lockup_detector_init(void)
 
 	cpu_callback(&cpu_nfb, CPU_ONLINE, cpu);
 	register_cpu_notifier(&cpu_nfb);
+	register_reboot_notifier(&reboot_nfb);
 
 	return;
 }
