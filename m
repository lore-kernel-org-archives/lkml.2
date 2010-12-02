Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757281Ab0LBHeo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Dec 2010 02:34:44 -0500
Received: from canuck.infradead.org ([134.117.69.58]:50863 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753596Ab0LBHen convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Dec 2010 02:34:43 -0500
Subject: Re: perf hw  in kexeced kernel broken in tip
From: Peter Zijlstra <peterz@infradead.org>
To: Don Zickus <dzickus@redhat.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        Vivek Goyal <vgoyal@redhat.com>, Yinghai Lu <yinghai@kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Jason Wessel <jason.wessel@windriver.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Haren Myneni <hbabu@us.ibm.com>
In-Reply-To: <20101202052321.GH18100@redhat.com>
References: <1291202867.4023.3.camel@twins>
	 <20101201160640.GA2511@redhat.com> <1291219906.32004.1671.camel@laptop>
	 <20101201162335.GB2511@redhat.com> <1291232292.32004.1969.camel@laptop>
	 <20101201194644.GD2511@redhat.com> <1291232989.32004.1987.camel@laptop>
	 <20101201195835.GE2511@redhat.com> <1291234036.32004.2008.camel@laptop>
	 <m162vdp3l4.fsf@fess.ebiederm.org>  <20101202052321.GH18100@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 02 Dec 2010 08:34:30 +0100
Message-ID: <1291275270.4023.20.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-12-02 at 00:23 -0500, Don Zickus wrote:
> On Wed, Dec 01, 2010 at 01:48:07PM -0800, Eric W. Biederman wrote:
> > >
> > > Oh, but I'm not a device or sysdev thing, I'll never get something like
> > > that.
> > 
> > There is also the reboot notifier, if the NMI needs to be controlled
> > outside of device model.  Sigh. The NMI handling is such a special case.
> 
> I tried reboot notifiers with the nmi_watchdog and acheived some success
> (on a Westmere box, a P4 still failed).  Kdump is still screwed, but maybe
> we don't care for now.
> 
> Here is the quick and dirty patch I used.

> diff --git a/kernel/watchdog.c b/kernel/watchdog.c
> index 792a4ed..3455cf9 100644
> --- a/kernel/watchdog.c
> +++ b/kernel/watchdog.c
> @@ -23,6 +23,7 @@
>  #include <linux/notifier.h>
>  #include <linux/module.h>
>  #include <linux/sysctl.h>
> +#include <linux/reboot.h>
>  
>  #include <asm/irq_regs.h>
>  #include <linux/perf_event.h>
> @@ -550,6 +551,18 @@ static struct notifier_block __cpuinitdata cpu_nfb = {
>  	.notifier_call = cpu_callback
>  };
>  
> +static int __cpuinit
> +reboot_callback(struct notifier_block *nfb, unsigned long action, void *unused)
> +{
> +	watchdog_disable_all_cpus();
> +
> +	return notifier_from_errno(0);
> +}
> +
> +static struct notifier_block __cpuinitdata reboot_nfb = {
> +	.notifier_call = reboot_callback
> +};
> +
>  void __init lockup_detector_init(void)
>  {
>  	void *cpu = (void *)(long)smp_processor_id();
> @@ -563,6 +576,7 @@ void __init lockup_detector_init(void)
>  
>  	cpu_callback(&cpu_nfb, CPU_ONLINE, cpu);
>  	register_cpu_notifier(&cpu_nfb);
> +	register_reboot_notifier(&reboot_nfb);
>  
>  	return;
>  }

We'd really want a perf_event.c callback there to do as the hot-unplug
code does and detach all running counters from the cpu.


