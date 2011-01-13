Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757347Ab1AMVlj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 16:41:39 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:27295 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755699Ab1AMVlc (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Thu, 13 Jan 2011 16:41:32 -0500
Date: Thu, 13 Jan 2011 16:40:22 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: john stultz <johnstul@us.ibm.com>, Thomas Gleixner <tglx@linutronix.de>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Ian Campbell <Ian.Campbell@eu.citrix.com>,
        Thomas Gleixner <tglx@linutronix.de>, mingo@redhat.com, hpa@zytor.com,
        linux-kernel@vger.kernel.org, andi@firstfloor.org, williams@redhat.com,
        schwidefsky@de.ibm.com, mingo@elte.hu,
        linux-tip-commits@vger.kernel.org
Subject: [PATCH] acpi/pm: If failed at validating ACPI PM timer, inhibit
 future reads.
Message-ID: <20110113214022.GA12097@dumpdata.com>
References: <1289003985-29060-1-git-send-email-johnstul@us.ibm.com>
 <tip-08ec0c58fb8a05d3191d5cb6f5d6f81adb419798@git.kernel.org>
 <20110111081352.GA22867@shutemov.name>
 <alpine.LFD.2.00.1101110926040.12146@localhost6.localdomain6>
 <20110111083054.GB22867@shutemov.name>
 <alpine.LFD.2.00.1101110936291.12146@localhost6.localdomain6>
 <20110111095640.GC22867@shutemov.name>
 <20110113174909.GA28738@dumpdata.com>
 <1294941698.5617.12.camel@work-vm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1294941698.5617.12.camel@work-vm>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

tgl, John,

Should I push this to Linus or are you guys going to push
this patch during this merge window?

commit ad0a17d46570aca172080016601813173a778fb7
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
    not have the HPET enabled nor the ACPI PM timer setup. The
    hpet_enable() is never called (b/c xen_time_init is called), and
    for calibration of tsc_khz (calibrate_tsc == xen_tsc_khz) we
    get a valid value.
    
    So 'tsc_read_refs' tries to read the ACPI PM timer (acpi_pm_read_early),
    however that is disabled under Xen:
    
    [    1.099272] calling  init_acpi_pm_clocksource+0x0/0xdc @ 1
    [    1.140186] PM-Timer failed consistency check  (0x0xffffff) - aborting.
    
    So the tsc_calibrate_check gets called, it can't do HPET, and reading
    from ACPI PM timer results in getting 0xffffff.. .. and
    (0xffff..-0xffff..)/some other value results in div_zero.
    
    There is a check in 'tsc_refine_calibration_work' for invalid
    values:
    
       /* hpet or pmtimer available ? */
             if (!hpet && !ref_start && !ref_stop)
                      goto out;
    
    But since ref_start and ref_stop have 0xffffff it does not trigger.
    
    This little fix makes the read to be 0 and the check triggers.
    
    Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
    Acked-by: John Stultz <johnstul@us.ibm.com>

diff --git a/drivers/clocksource/acpi_pm.c b/drivers/clocksource/acpi_pm.c
index cfb0f52..709bb6d 100644
--- a/drivers/clocksource/acpi_pm.c
+++ b/drivers/clocksource/acpi_pm.c
@@ -207,6 +207,7 @@ static int __init init_acpi_pm_clocksource(void)
 		if (i == ACPI_PM_READ_CHECKS) {
 			printk(KERN_INFO "PM-Timer failed consistency check "
 			       " (0x%#llx) - aborting.\n", value1);
+			pmtmr_ioport = 0;
 			return -ENODEV;
 		}
 	}
