Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756525Ab1ANOLu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 09:11:50 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:39806 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751923Ab1ANOLn (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Fri, 14 Jan 2011 09:11:43 -0500
Date: Fri, 14 Jan 2011 09:09:41 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: john stultz <johnstul@us.ibm.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Ian Campbell <Ian.Campbell@eu.citrix.com>, mingo@redhat.com,
        hpa@zytor.com, linux-kernel@vger.kernel.org, andi@firstfloor.org,
        williams@redhat.com, schwidefsky@de.ibm.com, mingo@elte.hu,
        linux-tip-commits@vger.kernel.org
Subject: Re: [PATCH] acpi/pm: If failed at validating ACPI PM timer,
 inhibit future reads.
Message-ID: <20110114140941.GA3062@dumpdata.com>
References: <tip-08ec0c58fb8a05d3191d5cb6f5d6f81adb419798@git.kernel.org>
 <20110111081352.GA22867@shutemov.name>
 <alpine.LFD.2.00.1101110926040.12146@localhost6.localdomain6>
 <20110111083054.GB22867@shutemov.name>
 <alpine.LFD.2.00.1101110936291.12146@localhost6.localdomain6>
 <20110111095640.GC22867@shutemov.name>
 <20110113174909.GA28738@dumpdata.com>
 <1294941698.5617.12.camel@work-vm>
 <20110113214022.GA12097@dumpdata.com>
 <alpine.LFD.2.00.1101132301300.2678@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1101132301300.2678@localhost6.localdomain6>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 13, 2011 at 11:15:16PM +0100, Thomas Gleixner wrote:
> On Thu, 13 Jan 2011, Konrad Rzeszutek Wilk wrote:
> 
> > tgl, John,
> > 
> > Should I push this to Linus or are you guys going to push
> > this patch during this merge window?
> 
> Wait a moment. This patch is fresh of the press and not that urgent,
> really.

It is a regression compared to 2.6.37 kernel. I don't know the
urgency requirements for regressions but I figured the earlier the
better.

>  
> >     I've traced it down to the fact that when we boot under Xen we do
> >     not have the HPET enabled nor the ACPI PM timer setup. The
> 
> Crap. If Xen would not have setup the pm timer then it would not even
> reach the consistency check. It would simply bail out via

Keep in mind that Linux (under Xen) does see the ACPI PM-Timer at bootup
(it parses the ACPI tables), and when it tries to actually read the 
values, so past this point:

> 
>         if (!pmtmr_ioport)
>                 return -ENODEV;
> 

.. it fails at:
   if (i == ACPI_PM_READ_CHECKS) {

and returns -ENODEV. So pmtmr_ioport was still valid at that time.

> and the whole misery would not have happened at all. Though it's a
> Good Thing that Xen is so screwed as it points to a real flaw which
> might happen on real hardware as well. See below
> 
> >     hpet_enable() is never called (b/c xen_time_init is called), and
> >     for calibration of tsc_khz (calibrate_tsc == xen_tsc_khz) we
> >     get a valid value.
> >     
> >     So 'tsc_read_refs' tries to read the ACPI PM timer (acpi_pm_read_early),
> >     however that is disabled under Xen:
> >     
> >     [    1.099272] calling  init_acpi_pm_clocksource+0x0/0xdc @ 1
> >     [    1.140186] PM-Timer failed consistency check  (0x0xffffff) - aborting.
> >     
> >     So the tsc_calibrate_check gets called, it can't do HPET, and reading
> >     from ACPI PM timer results in getting 0xffffff.. .. and
> >     (0xffff..-0xffff..)/some other value results in div_zero.
> 
> Nonsense. 0/(some other value) does not result in a divide by zero
> except "some other value" is zero.

<scratches his head> You are right. 
> 
> >     There is a check in 'tsc_refine_calibration_work' for invalid
> >     values:
> >     
> >        /* hpet or pmtimer available ? */
> >              if (!hpet && !ref_start && !ref_stop)
> >                       goto out;
> >     
> >     But since ref_start and ref_stop have 0xffffff it does not trigger.
> >
> >     This little fix makes the read to be 0 and the check triggers.
> 
> First of all the patch disables the pm_timer completely, which happens
> to results in a 0 read as a side effect. But the main point of this

I does not look like a side-effect. Specifically:

static inline u32 acpi_pm_read_early(void)
{
        if (!pmtmr_ioport)
                return 0;

	 return acpi_pm_read_verified() & ACPI_PM_MASK;
}

.. ends up taking the !pmtmr_ioport path which is what
tsc_refine_calibration_work has a check for.

> fix is to disable pmtimer in case of failure in the init function
> completely.
> 
> Further there are several error conditions in this init function and
> we really need to disable pmtimer for all of them not just for the
> case you encountered.

Good point. What about this patch? John, is it OK if I carry
your Ack-by on this modified patch?

commit 7b530022a59683b3164404ee8ee2d5750748b58b
Author: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Date:   Thu Jan 13 12:56:51 2011 -0500

    acpi/pm: If failed at validating ACPI PM timer, inhibit future reads.
    
    Without this patch we get:
    [    4.628136] divide error: 0000 [#1] SMP
    .. snip..
    Pid: 441, comm: kworker/1:1 Not tainted 2.6.37test-05765-gda43a99-dirty #14 N61PB-M2S/N61PB-M2S
    [    4.628150] RIP: e030:[<ffffffff8101109b>]  [<ffffffff8101109b>] tsc_refine_calibration_work+0x149/0x1bb
    [    4.628157] RSP: e02b:ffff88008f0d1df0  EFLAGS: 00010246
    .. when running Linux under Xen.
    
    I've traced it down to the fact that when we boot under Xen we do
    not have the HPET enabled nor the ACPI PM timer setup properly
    (it is however detected earlier, so pmtmr_ioport is correct).
    The hpet_enable() is never called (b/c xen_time_init is called), and
    for calibration of tsc_khz (calibrate_tsc == xen_tsc_khz) we
    get a valid value.
    
    So 'tsc_read_refs' tries to read the ACPI PM timer (acpi_pm_read_early),
    however that is disabled under Xen:
    
    [    1.099272] calling  init_acpi_pm_clocksource+0x0/0xdc @ 1
    [    1.140186] PM-Timer failed consistency check  (0x0xffffff) - aborting.
    
    So the tsc_calibrate_check gets called, it can't do HPET, and reading
    from ACPI PM timer results in getting 0xffffff.. which is invalid.
    
    There is a check in 'tsc_refine_calibration_work' for invalid
    values:
    
       /* hpet or pmtimer available ? */
             if (!hpet && !ref_start && !ref_stop)
                      goto out;
    
    But since ref_start and ref_stop have 0xffffff it does not trigger.
    
    This little fix does it however.
    
    Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
    Acked-by: John Stultz <johnstul@us.ibm.com>

diff --git a/drivers/clocksource/acpi_pm.c b/drivers/clocksource/acpi_pm.c
index cfb0f52..02e0f28 100644
--- a/drivers/clocksource/acpi_pm.c
+++ b/drivers/clocksource/acpi_pm.c
@@ -207,12 +207,15 @@ static int __init init_acpi_pm_clocksource(void)
 		if (i == ACPI_PM_READ_CHECKS) {
 			printk(KERN_INFO "PM-Timer failed consistency check "
 			       " (0x%#llx) - aborting.\n", value1);
+			pmtmr_ioport = 0;
 			return -ENODEV;
 		}
 	}
 
-	if (verify_pmtmr_rate() != 0)
+	if (verify_pmtmr_rate() != 0) {
+		pmtmr_ioport = 0;
 		return -ENODEV;
+	}
 
 	return clocksource_register_hz(&clocksource_acpi_pm,
 						PMTMR_TICKS_PER_SEC);
