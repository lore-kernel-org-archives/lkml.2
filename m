Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753898Ab1DRIvx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 04:51:53 -0400
Received: from mtaout02-winn.ispmail.ntl.com ([81.103.221.48]:36576 "EHLO
	mtaout02-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752096Ab1DRIvq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 04:51:46 -0400
From: Ian Campbell <ijc@hellion.org.uk>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: LKML <linux-kernel@vger.kernel.org>, Greg KH <gregkh@suse.de>,
        Kay Sievers <kay.sievers@suse.de>,
        Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        Russell King <linux@arm.linux.org.uk>, linux-omap@vger.kernel.org,
        Kevin Hilman <khilman@ti.com>, linux-arm-kernel@lists.infradead.org,
        Ben Dooks <ben-linux@fluff.org>, Mike Frysinger <vapier@gentoo.org>,
        Ralf Baechle <ralf@linux-mips.org>,
        Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>,
        Guan Xuetao <gxt@mprc.pku.edu.cn>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linuxppc-dev@lists.ozlabs.org, Jiri Kosina <jkosina@suse.cz>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
In-Reply-To: <201104172306.49462.rjw@sisk.pl>
References: <201103280125.11750.rjw@sisk.pl>
	 <201104172301.54115.rjw@sisk.pl>  <201104172306.49462.rjw@sisk.pl>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 18 Apr 2011 09:51:27 +0100
Message-ID: <1303116687.5997.109.camel@zakaz.uk.xensource.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 62.200.22.2
X-SA-Exim-Mail-From: ijc@hellion.org.uk
Subject: Re: [PATCH 2/14] PM: Add missing syscore_suspend() and
 syscore_resume() calls
X-SA-Exim-Version: 4.2.1 (built Mon, 22 Mar 2010 06:51:10 +0000)
X-SA-Exim-Scanned: Yes (on hopkins.hellion.org.uk)
X-Cloudmark-Analysis: v=1.1 cv=JvdXmxIgLJv2/GthKqHpGJEEHukvLcvELVXUanXFreg= c=1 sm=0 a=UnCrkxnOnX4A:10 a=IkcTkHD0fZMA:10 a=tHz9FfFoAAAA:8 a=VwQbUJbxAAAA:8 a=W0vUJOdyAAAA:8 a=QHgM23Dl1ZiutEmO-qoA:9 a=W3O3tAaNJTkJ4LdsXjIA:7 a=QEXdDO2ut3YA:10 a=x8gzFH9gYPwA:10 a=6O0IECtVFhoA:10 a=HpAAvcLHHh0Zw7uRqdWCyQ==:117
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2011-04-17 at 23:06 +0200, Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki <rjw@sisk.pl>
> 
> Device suspend/resume infrastructure is used not only by the suspend
> and hibernate code in kernel/power, but also by , APM, Xen and the
> kexec jump feature.  However, commit 40dc166cb5dddbd36aa4ad11c03915ea
> (PM / Core: Introduce struct syscore_ops for core subsystems PM)
> failed to add syscore_suspend() and syscore_resume() calls to that
> code, which generally leads to breakage when the features in question
> are used.
> 
> To fix this problem, add the missing syscore_suspend() and
> syscore_resume() calls to arch/x86/kernel/apm_32.c, kernel/kexec.c
> and drivers/xen/manage.c.

Xen bit looks ok to me:
Acked-by: Ian Campbell <ian.campbell@citrix.com>

> 
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> ---
>  arch/x86/kernel/apm_32.c |    5 +++++
>  drivers/xen/manage.c     |    9 ++++++++-
>  kernel/kexec.c           |    7 +++++++
>  3 files changed, 20 insertions(+), 1 deletion(-)
> 
> Index: linux-2.6/kernel/kexec.c
> ===================================================================
> --- linux-2.6.orig/kernel/kexec.c
> +++ linux-2.6/kernel/kexec.c
> @@ -33,6 +33,7 @@
>  #include <linux/vmalloc.h>
>  #include <linux/swap.h>
>  #include <linux/kmsg_dump.h>
> +#include <linux/syscore_ops.h>
>  
>  #include <asm/page.h>
>  #include <asm/uaccess.h>
> @@ -1532,6 +1533,11 @@ int kernel_kexec(void)
>  		local_irq_disable();
>  		/* Suspend system devices */
>  		error = sysdev_suspend(PMSG_FREEZE);
> +		if (!error) {
> +			error = syscore_suspend();
> +			if (error)
> +				sysdev_resume();
> +		}
>  		if (error)
>  			goto Enable_irqs;
>  	} else
> @@ -1546,6 +1552,7 @@ int kernel_kexec(void)
>  
>  #ifdef CONFIG_KEXEC_JUMP
>  	if (kexec_image->preserve_context) {
> +		syscore_resume();
>  		sysdev_resume();
>   Enable_irqs:
>  		local_irq_enable();
> Index: linux-2.6/drivers/xen/manage.c
> ===================================================================
> --- linux-2.6.orig/drivers/xen/manage.c
> +++ linux-2.6/drivers/xen/manage.c
> @@ -8,6 +8,7 @@
>  #include <linux/sysrq.h>
>  #include <linux/stop_machine.h>
>  #include <linux/freezer.h>
> +#include <linux/syscore_ops.h>
>  
>  #include <xen/xen.h>
>  #include <xen/xenbus.h>
> @@ -70,8 +71,13 @@ static int xen_suspend(void *data)
>  	BUG_ON(!irqs_disabled());
>  
>  	err = sysdev_suspend(PMSG_FREEZE);
> +	if (!err) {
> +		err = syscore_suspend();
> +		if (err)
> +			sysdev_resume();
> +	}
>  	if (err) {
> -		printk(KERN_ERR "xen_suspend: sysdev_suspend failed: %d\n",
> +		printk(KERN_ERR "xen_suspend: system core suspend failed: %d\n",
>  			err);
>  		return err;
>  	}
> @@ -95,6 +101,7 @@ static int xen_suspend(void *data)
>  		xen_timer_resume();
>  	}
>  
> +	syscore_resume();
>  	sysdev_resume();
>  
>  	return 0;
> Index: linux-2.6/arch/x86/kernel/apm_32.c
> ===================================================================
> --- linux-2.6.orig/arch/x86/kernel/apm_32.c
> +++ linux-2.6/arch/x86/kernel/apm_32.c
> @@ -228,6 +228,7 @@
>  #include <linux/kthread.h>
>  #include <linux/jiffies.h>
>  #include <linux/acpi.h>
> +#include <linux/syscore_ops.h>
>  
>  #include <asm/system.h>
>  #include <asm/uaccess.h>
> @@ -1238,6 +1239,7 @@ static int suspend(int vetoable)
>  
>  	local_irq_disable();
>  	sysdev_suspend(PMSG_SUSPEND);
> +	syscore_suspend();
>  
>  	local_irq_enable();
>  
> @@ -1255,6 +1257,7 @@ static int suspend(int vetoable)
>  		apm_error("suspend", err);
>  	err = (err == APM_SUCCESS) ? 0 : -EIO;
>  
> +	syscore_resume();
>  	sysdev_resume();
>  	local_irq_enable();
>  
> @@ -1280,6 +1283,7 @@ static void standby(void)
>  
>  	local_irq_disable();
>  	sysdev_suspend(PMSG_SUSPEND);
> +	syscore_suspend();
>  	local_irq_enable();
>  
>  	err = set_system_power_state(APM_STATE_STANDBY);
> @@ -1287,6 +1291,7 @@ static void standby(void)
>  		apm_error("standby", err);
>  
>  	local_irq_disable();
> +	syscore_resume();
>  	sysdev_resume();
>  	local_irq_enable();
>  
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

-- 
Ian Campbell

Tact in audacity is knowing how far you can go without going too far.
		-- Jean Cocteau

