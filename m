Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757378Ab1AMWQY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 17:16:24 -0500
Received: from www.tglx.de ([62.245.132.106]:56372 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757292Ab1AMWQR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 17:16:17 -0500
Date: Thu, 13 Jan 2011 23:15:16 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
cc: john stultz <johnstul@us.ibm.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Ian Campbell <Ian.Campbell@eu.citrix.com>, mingo@redhat.com,
        hpa@zytor.com, linux-kernel@vger.kernel.org, andi@firstfloor.org,
        williams@redhat.com, schwidefsky@de.ibm.com, mingo@elte.hu,
        linux-tip-commits@vger.kernel.org
Subject: Re: [PATCH] acpi/pm: If failed at validating ACPI PM timer, inhibit
 future reads.
In-Reply-To: <20110113214022.GA12097@dumpdata.com>
Message-ID: <alpine.LFD.2.00.1101132301300.2678@localhost6.localdomain6>
References: <1289003985-29060-1-git-send-email-johnstul@us.ibm.com> <tip-08ec0c58fb8a05d3191d5cb6f5d6f81adb419798@git.kernel.org> <20110111081352.GA22867@shutemov.name> <alpine.LFD.2.00.1101110926040.12146@localhost6.localdomain6> <20110111083054.GB22867@shutemov.name>
 <alpine.LFD.2.00.1101110936291.12146@localhost6.localdomain6> <20110111095640.GC22867@shutemov.name> <20110113174909.GA28738@dumpdata.com> <1294941698.5617.12.camel@work-vm> <20110113214022.GA12097@dumpdata.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Jan 2011, Konrad Rzeszutek Wilk wrote:

> tgl, John,
> 
> Should I push this to Linus or are you guys going to push
> this patch during this merge window?

Wait a moment. This patch is fresh of the press and not that urgent,
really.
 
>     I've traced it down to the fact that when we boot under Xen we do
>     not have the HPET enabled nor the ACPI PM timer setup. The

Crap. If Xen would not have setup the pm timer then it would not even
reach the consistency check. It would simply bail out via

        if (!pmtmr_ioport)
                return -ENODEV;

and the whole misery would not have happened at all. Though it's a
Good Thing that Xen is so screwed as it points to a real flaw which
might happen on real hardware as well. See below

>     hpet_enable() is never called (b/c xen_time_init is called), and
>     for calibration of tsc_khz (calibrate_tsc == xen_tsc_khz) we
>     get a valid value.
>     
>     So 'tsc_read_refs' tries to read the ACPI PM timer (acpi_pm_read_early),
>     however that is disabled under Xen:
>     
>     [    1.099272] calling  init_acpi_pm_clocksource+0x0/0xdc @ 1
>     [    1.140186] PM-Timer failed consistency check  (0x0xffffff) - aborting.
>     
>     So the tsc_calibrate_check gets called, it can't do HPET, and reading
>     from ACPI PM timer results in getting 0xffffff.. .. and
>     (0xffff..-0xffff..)/some other value results in div_zero.

Nonsense. 0/(some other value) does not result in a divide by zero
except "some other value" is zero.

>     There is a check in 'tsc_refine_calibration_work' for invalid
>     values:
>     
>        /* hpet or pmtimer available ? */
>              if (!hpet && !ref_start && !ref_stop)
>                       goto out;
>     
>     But since ref_start and ref_stop have 0xffffff it does not trigger.
>
>     This little fix makes the read to be 0 and the check triggers.

First of all the patch disables the pm_timer completely, which happens
to results in a 0 read as a side effect. But the main point of this
fix is to disable pmtimer in case of failure in the init function
completely.

Further there are several error conditions in this init function and
we really need to disable pmtimer for all of them not just for the
case you encountered.

Thanks,

	tglx
