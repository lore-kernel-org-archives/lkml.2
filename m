Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933115Ab1AMSBu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 13:01:50 -0500
Received: from e8.ny.us.ibm.com ([32.97.182.138]:32768 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756855Ab1AMSBr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 13:01:47 -0500
Subject: Re: [tip:x86/tsc] x86: Improve TSC calibration using a delayed
 workqueue
From: john stultz <johnstul@us.ibm.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Ian Campbell <Ian.Campbell@eu.citrix.com>,
        Thomas Gleixner <tglx@linutronix.de>, mingo@redhat.com, hpa@zytor.com,
        linux-kernel@vger.kernel.org, andi@firstfloor.org, williams@redhat.com,
        schwidefsky@de.ibm.com, mingo@elte.hu,
        linux-tip-commits@vger.kernel.org
In-Reply-To: <20110113174909.GA28738@dumpdata.com>
References: <1289003985-29060-1-git-send-email-johnstul@us.ibm.com>
	 <tip-08ec0c58fb8a05d3191d5cb6f5d6f81adb419798@git.kernel.org>
	 <20110111081352.GA22867@shutemov.name>
	 <alpine.LFD.2.00.1101110926040.12146@localhost6.localdomain6>
	 <20110111083054.GB22867@shutemov.name>
	 <alpine.LFD.2.00.1101110936291.12146@localhost6.localdomain6>
	 <20110111095640.GC22867@shutemov.name>
	 <20110113174909.GA28738@dumpdata.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 13 Jan 2011 10:01:38 -0800
Message-ID: <1294941698.5617.12.camel@work-vm>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-01-13 at 12:49 -0500, Konrad Rzeszutek Wilk wrote:
> On Tue, Jan 11, 2011 at 11:56:40AM +0200, Kirill A. Shutemov wrote:
> > On Tue, Jan 11, 2011 at 09:37:15AM +0100, Thomas Gleixner wrote:
> > > On Tue, 11 Jan 2011, Kirill A. Shutemov wrote:
> > > 
> > > > On Tue, Jan 11, 2011 at 09:26:48AM +0100, Thomas Gleixner wrote:
> > > > > On Tue, 11 Jan 2011, Kirill A. Shutemov wrote:
> > > > > 
> > > > > > On Sun, Dec 05, 2010 at 11:18:53AM +0000, tip-bot for John Stultz wrote:
> > > > > > > Commit-ID:  08ec0c58fb8a05d3191d5cb6f5d6f81adb419798
> > > > > > > Gitweb:     http://git.kernel.org/tip/08ec0c58fb8a05d3191d5cb6f5d6f81adb419798
> > > > > > > Author:     John Stultz <johnstul@us.ibm.com>
> > > > > > > AuthorDate: Tue, 27 Jul 2010 17:00:00 -0700
> > > > > > > Committer:  John Stultz <john.stultz@linaro.org>
> > > > > > > CommitDate: Thu, 2 Dec 2010 16:48:37 -0800
> > > > > > > 
> > > > > > > x86: Improve TSC calibration using a delayed workqueue
> > > > > > 
> > > > > > This commit breaks booting the kernel in qemu with enabled KVM on my machine.
> > > > > > .config attached.
> > > > > > 
> > > > > > [    0.424013] divide error: 0000 [#1] 
> > > > > 
> > > > > Got fixed by a8760ec (x86: Check tsc available/disabled in the delayed
> > > > > init function)
> > > > 
> > > > No, it didn't. :(
> > > > 
> > > > I am able to reproduce it on current Linus' tree (v2.6.37-4700-g8adbf8d).
> > > 
> > > Does the patch below fix it ? We can end up with tsc_khz=0 there :(
> > 
> > Yes, it does.
> 
> Interestingly enough, when you run Linux under Xen (as Domain 0) you
> get the same stack-trace. With both patches (a8760ec, and the patch
> posted earlier) I still get the failure.
> 
> I've traced it down to the fact that when we boot under Xen we do
> not have the HPET enabled nor the ACPI PM timer setup. The 
> hpet_enable() is never called (b/c xen_time_init is called), and
> for calibration of tsc_khz (calibrate_tsc == xen_tsc_khz) we
> get a valid value.
> 
> So 'tsc_read_refs' tries to read the ACPI PM timer (acpi_pm_read_early),
> however that is disabled under Xen:
> 
> [    1.099272] calling  init_acpi_pm_clocksource+0x0/0xdc @ 1
> [    1.140186] PM-Timer failed consistency check  (0x0xffffff) - aborting.
> 
> So the tsc_calibrate_check gets called, it can't do HPET, and reading
> from ACPI PM timer results in getting 0xffffff.. .. and
> (0xffff..-0xffff..)/some other value results in div_zero.
> 
> There is a check in 'tsc_refine_calibration_work' for invalid
> values:
> 
>    /* hpet or pmtimer available ? */
>          if (!hpet && !ref_start && !ref_stop)
>                   goto out;
> 
> But since ref_start and ref_stop have 0xffffff it does not trigger.

Oof. Thanks for hunting this down!

> This little fix does it however. Thought it will of course not
> recalibrate the tsc - is that a horrible thing? Should we look
> at making tsc_read_refs also use the pv-ops in case both hpet and
> acpi pm timer are disabled?

The recalibration is not a necessary thing. Its only an improvement over
what the standard calibration we have always done is. Since xen provides
its own xen_tsc_khz value, I suspect the timer based
calibration-refinement might not improve over what xen provides.


> Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>

Acked-by: John Stultz <johnstul@us.ibm.com>

> diff --git a/drivers/clocksource/acpi_pm.c b/drivers/clocksource/acpi_pm.c
> index cfb0f52..84ff897 100644
> --- a/drivers/clocksource/acpi_pm.c
> +++ b/drivers/clocksource/acpi_pm.c
> @@ -207,6 +208,7 @@ static int __init init_acpi_pm_clocksource(void)
>  		if (i == ACPI_PM_READ_CHECKS) {
>  			printk(KERN_INFO "PM-Timer failed consistency check "
>  			       " (0x%#llx) - aborting.\n", value1);
> +			pmtmr_ioport = 0;
>  			return -ENODEV;
>  		}
>  	}


