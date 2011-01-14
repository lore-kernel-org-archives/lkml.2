Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757845Ab1ANPo2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 10:44:28 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:60997 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756857Ab1ANPoX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 10:44:23 -0500
Subject: Re: [PATCH] acpi/pm: If failed at validating ACPI PM timer,
 inhibit future reads.
From: john stultz <johnstul@us.ibm.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Ian Campbell <Ian.Campbell@eu.citrix.com>, mingo@redhat.com,
        hpa@zytor.com, linux-kernel@vger.kernel.org, andi@firstfloor.org,
        williams@redhat.com, schwidefsky@de.ibm.com, mingo@elte.hu,
        linux-tip-commits@vger.kernel.org
In-Reply-To: <20110114140941.GA3062@dumpdata.com>
References: <tip-08ec0c58fb8a05d3191d5cb6f5d6f81adb419798@git.kernel.org>
	 <20110111081352.GA22867@shutemov.name>
	 <alpine.LFD.2.00.1101110926040.12146@localhost6.localdomain6>
	 <20110111083054.GB22867@shutemov.name>
	 <alpine.LFD.2.00.1101110936291.12146@localhost6.localdomain6>
	 <20110111095640.GC22867@shutemov.name>
	 <20110113174909.GA28738@dumpdata.com> <1294941698.5617.12.camel@work-vm>
	 <20110113214022.GA12097@dumpdata.com>
	 <alpine.LFD.2.00.1101132301300.2678@localhost6.localdomain6>
	 <20110114140941.GA3062@dumpdata.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 14 Jan 2011 07:44:09 -0800
Message-ID: <1295019849.2655.8.camel@work-vm>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-01-14 at 09:09 -0500, Konrad Rzeszutek Wilk wrote:
> On Thu, Jan 13, 2011 at 11:15:16PM +0100, Thomas Gleixner wrote:
> > On Thu, 13 Jan 2011, Konrad Rzeszutek Wilk wrote:
> > 
> > > tgl, John,
> > > 
> > > Should I push this to Linus or are you guys going to push
> > > this patch during this merge window?
> > 
> > Wait a moment. This patch is fresh of the press and not that urgent,
> > really.
> 
> It is a regression compared to 2.6.37 kernel. I don't know the
> urgency requirements for regressions but I figured the earlier the
> better.
> 
> >  
> > >     I've traced it down to the fact that when we boot under Xen we do
> > >     not have the HPET enabled nor the ACPI PM timer setup. The
> > 
> > Crap. If Xen would not have setup the pm timer then it would not even
> > reach the consistency check. It would simply bail out via
> 
> Keep in mind that Linux (under Xen) does see the ACPI PM-Timer at bootup
> (it parses the ACPI tables), and when it tries to actually read the 
> values, so past this point:
> 
> > 
> >         if (!pmtmr_ioport)
> >                 return -ENODEV;
> > 
> 
> .. it fails at:
>    if (i == ACPI_PM_READ_CHECKS) {
> 
> and returns -ENODEV. So pmtmr_ioport was still valid at that time.
> 
> > and the whole misery would not have happened at all. Though it's a
> > Good Thing that Xen is so screwed as it points to a real flaw which
> > might happen on real hardware as well. See below
> > 
> > >     hpet_enable() is never called (b/c xen_time_init is called), and
> > >     for calibration of tsc_khz (calibrate_tsc == xen_tsc_khz) we
> > >     get a valid value.
> > >     
> > >     So 'tsc_read_refs' tries to read the ACPI PM timer (acpi_pm_read_early),
> > >     however that is disabled under Xen:
> > >     
> > >     [    1.099272] calling  init_acpi_pm_clocksource+0x0/0xdc @ 1
> > >     [    1.140186] PM-Timer failed consistency check  (0x0xffffff) - aborting.
> > >     
> > >     So the tsc_calibrate_check gets called, it can't do HPET, and reading
> > >     from ACPI PM timer results in getting 0xffffff.. .. and
> > >     (0xffff..-0xffff..)/some other value results in div_zero.
> > 
> > Nonsense. 0/(some other value) does not result in a divide by zero
> > except "some other value" is zero.
> 
> <scratches his head> You are right. 

The (0xffff - 0xffff) bit ends up as the divisor in calc_pmtmr_ref.

> > 
> > >     There is a check in 'tsc_refine_calibration_work' for invalid
> > >     values:
> > >     
> > >        /* hpet or pmtimer available ? */
> > >              if (!hpet && !ref_start && !ref_stop)
> > >                       goto out;
> > >     
> > >     But since ref_start and ref_stop have 0xffffff it does not trigger.
> > >
> > >     This little fix makes the read to be 0 and the check triggers.
> > 
> > First of all the patch disables the pm_timer completely, which happens
> > to results in a 0 read as a side effect. But the main point of this
> 
> I does not look like a side-effect. Specifically:
> 
> static inline u32 acpi_pm_read_early(void)
> {
>         if (!pmtmr_ioport)
>                 return 0;
> 
> 	 return acpi_pm_read_verified() & ACPI_PM_MASK;
> }
> 
> .. ends up taking the !pmtmr_ioport path which is what
> tsc_refine_calibration_work has a check for.
> 
> > fix is to disable pmtimer in case of failure in the init function
> > completely.
> > 
> > Further there are several error conditions in this init function and
> > we really need to disable pmtimer for all of them not just for the
> > case you encountered.
> 
> Good point. What about this patch? John, is it OK if I carry
> your Ack-by on this modified patch?

I'm actually looking at a different fix, as I'm worried by Thomas'
comment about hitting the same issue on real hardware if we catch the
same pmtrm value both times.

thanks
-john




