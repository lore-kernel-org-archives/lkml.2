Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753890Ab1KLWMJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Nov 2011 17:12:09 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:37197 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752189Ab1KLWMG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Nov 2011 17:12:06 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Tomas M." <tmezzadra@gmail.com>
Subject: Re: [bisected][bug] commit e978aa7d7d57d04eb5f88 breaks suspend on laptop.
Date: Sat, 12 Nov 2011 23:14:40 +0100
User-Agent: KMail/1.13.6 (Linux/3.1.0-rc10+; KDE/4.6.0; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        deepthi@linux.vnet.ibm.com, g.trinabh@gmail.com, j-pihet@ti.com,
        khilman@ti.com, arjan@linux.intel.com, len.brown@intel.com,
        Arjan van de Ven <arjan@infradead.org>, Len Brown <lenb@kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ferenc Wagner <wferi@niif.hu>
References: <4EBD46DF.6060507@gmail.com> <201111120250.14151.rjw@sisk.pl> <4EBE72EC.5010902@gmail.com>
In-Reply-To: <4EBE72EC.5010902@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201111122314.40900.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, November 12, 2011, Tomas M. wrote:
> Yes, it was acpi_idle, and  the proposed patch fixed the problem.

Great, thanks!

Rafael


> On 11/11/2011 10:50 PM, Rafael J. Wysocki wrote:
> > On Saturday, November 12, 2011, Rafael J. Wysocki wrote:
> >> On Friday, November 11, 2011, Tomas M. wrote:
> >>> yes, that helps.
> >> What does "cat /sys/devices/system/cpu/cpuidle/current_driver" show?
> > If that's "acpi_idle", the appended patch should help (it works for
> > me at least).
> >
> > Thanks,
> > Rafael
> >
> > ---
> > From: Rafael J. Wysocki<rjw@sisk.pl>
> > Subject: ACPI / cpuidle: Remove acpi_idle_suspend (to fix suspend regression)
> >
> > After commit e978aa7d7d57d04eb5f88a7507c4fb98577def77 (cpuidle: Move
> > dev->last_residency update to driver enter routine; remove
> > dev->last_state) setting acpi_idle_suspend to 1 by
> > acpi_processor_suspend() causes the ACPI cpuidle routines to return
> > error codes continuously, which in turn causes cpuidle to lock up
> > (hard).  However, acpi_idle_suspend doesn't appear to be useful for
> > any purpose (it's racy and doesn't really provide any real
> > protection), so it can be removed, which makes the problem go away.
> >
> > Signed-off-by: Rafael J. Wysocki<rjw@sisk.pl>
> > ---
> >   drivers/acpi/processor_idle.c |   29 -----------------------------
> >   1 file changed, 29 deletions(-)
> >
> > Index: linux/drivers/acpi/processor_idle.c
> > ===================================================================
> > --- linux.orig/drivers/acpi/processor_idle.c
> > +++ linux/drivers/acpi/processor_idle.c
> > @@ -224,7 +224,6 @@ static void lapic_timer_state_broadcast(
> >   /*
> >    * Suspend / resume control
> >    */
> > -static int acpi_idle_suspend;
> >   static u32 saved_bm_rld;
> >
> >   static void acpi_idle_bm_rld_save(void)
> > @@ -243,21 +242,13 @@ static void acpi_idle_bm_rld_restore(voi
> >
> >   int acpi_processor_suspend(struct acpi_device * device, pm_message_t state)
> >   {
> > -	if (acpi_idle_suspend == 1)
> > -		return 0;
> > -
> >   	acpi_idle_bm_rld_save();
> > -	acpi_idle_suspend = 1;
> >   	return 0;
> >   }
> >
> >   int acpi_processor_resume(struct acpi_device * device)
> >   {
> > -	if (acpi_idle_suspend == 0)
> > -		return 0;
> > -
> >   	acpi_idle_bm_rld_restore();
> > -	acpi_idle_suspend = 0;
> >   	return 0;
> >   }
> >
> > @@ -763,13 +754,6 @@ static int acpi_idle_enter_c1(struct cpu
> >
> >   	local_irq_disable();
> >
> > -	/* Do not access any ACPI IO ports in suspend path */
> > -	if (acpi_idle_suspend) {
> > -		local_irq_enable();
> > -		cpu_relax();
> > -		return -EINVAL;
> > -	}
> > -
> >   	lapic_timer_state_broadcast(pr, cx, 1);
> >   	kt1 = ktime_get_real();
> >   	acpi_idle_do_entry(cx);
> > @@ -810,13 +794,6 @@ static int acpi_idle_enter_simple(struct
> >
> >   	local_irq_disable();
> >
> > -	if (acpi_idle_suspend) {
> > -		local_irq_enable();
> > -		cpu_relax();
> > -		return -EINVAL;
> > -	}
> > -
> > -
> >   	if (cx->entry_method != ACPI_CSTATE_FFH) {
> >   		current_thread_info()->status&= ~TS_POLLING;
> >   		/*
> > @@ -895,12 +872,6 @@ static int acpi_idle_enter_bm(struct cpu
> >   	if (unlikely(!pr))
> >   		return -EINVAL;
> >
> > -
> > -	if (acpi_idle_suspend) {
> > -		cpu_relax();
> > -		return -EINVAL;
> > -	}
> > -
> >   	if (!cx->bm_sts_skip&&  acpi_idle_bm_check()) {
> >   		if (drv->safe_state_index>= 0) {
> >   			return drv->states[drv->safe_state_index].enter(dev,
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 

