Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755037Ab1KNLFQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Nov 2011 06:05:16 -0500
Received: from e1.ny.us.ibm.com ([32.97.182.141]:35004 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754418Ab1KNLFP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Nov 2011 06:05:15 -0500
Message-ID: <4EC0F5A5.7070304@linux.vnet.ibm.com>
Date: Mon, 14 Nov 2011 16:34:05 +0530
From: Deepthi Dharwar <deepthi@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.17) Gecko/20110424 Thunderbird/3.1.10
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Len Brown <lenb@kernel.org>, Ferenc Wagner <wferi@niif.hu>,
        "Tomas M." <tmezzadra@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        g.trinabh@gmail.com, j-pihet@ti.com, khilman@ti.com,
        arjan@linux.intel.com, len.brown@intel.com,
        Arjan van de Ven <arjan@infradead.org>,
        Linux PM list <linux-pm@vger.kernel.org>
Subject: Re: [PATCH] ACPI / cpuidle: Remove acpi_idle_suspend (to fix suspend
 regression)
References: <4EBD46DF.6060507@gmail.com> <201111120250.14151.rjw@sisk.pl> <87k475cxvf.fsf@tac.ki.iif.hu> <201111122317.27576.rjw@sisk.pl>
In-Reply-To: <201111122317.27576.rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 11111411-6078-0000-0000-0000045C19A8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks a lot Ferenc and Tomas for reporting the problem and testing the fix.
Thanks a ton Rafael for plugging the bug with an amazing turn around time !!

-- Deepthi

On Sunday 13 November 2011 03:47 AM, Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki <rjw@sisk.pl>
> 
> After commit e978aa7d7d57d04eb5f88a7507c4fb98577def77 (cpuidle: Move
> dev->last_residency update to driver enter routine; remove
> dev->last_state) setting acpi_idle_suspend to 1 by
> acpi_processor_suspend() causes the ACPI cpuidle routines to return
> error codes continuously, which in turn causes cpuidle to lock up
> (hard).  However, acpi_idle_suspend doesn't appear to be useful for
> any particular purpose (it's racy and doesn't really provide any real
> protection), so it can be removed, which makes the problem go away.
> 
> Reported-and-tested-by: Tomas M. <tmezzadra@gmail.com>
> Reported-and-tested-by: Ferenc Wagner <wferi@niif.hu>
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> ---
>  drivers/acpi/processor_idle.c |   29 -----------------------------
>  1 file changed, 29 deletions(-)
> 
> Index: linux/drivers/acpi/processor_idle.c
> ===================================================================
> --- linux.orig/drivers/acpi/processor_idle.c
> +++ linux/drivers/acpi/processor_idle.c
> @@ -224,7 +224,6 @@ static void lapic_timer_state_broadcast(
>  /*
>   * Suspend / resume control
>   */
> -static int acpi_idle_suspend;
>  static u32 saved_bm_rld;
> 
>  static void acpi_idle_bm_rld_save(void)
> @@ -243,21 +242,13 @@ static void acpi_idle_bm_rld_restore(voi
> 
>  int acpi_processor_suspend(struct acpi_device * device, pm_message_t state)
>  {
> -	if (acpi_idle_suspend == 1)
> -		return 0;
> -
>  	acpi_idle_bm_rld_save();
> -	acpi_idle_suspend = 1;
>  	return 0;
>  }
> 
>  int acpi_processor_resume(struct acpi_device * device)
>  {
> -	if (acpi_idle_suspend == 0)
> -		return 0;
> -
>  	acpi_idle_bm_rld_restore();
> -	acpi_idle_suspend = 0;
>  	return 0;
>  }
> 
> @@ -763,13 +754,6 @@ static int acpi_idle_enter_c1(struct cpu
> 
>  	local_irq_disable();
> 
> -	/* Do not access any ACPI IO ports in suspend path */
> -	if (acpi_idle_suspend) {
> -		local_irq_enable();
> -		cpu_relax();
> -		return -EINVAL;
> -	}
> -
>  	lapic_timer_state_broadcast(pr, cx, 1);
>  	kt1 = ktime_get_real();
>  	acpi_idle_do_entry(cx);
> @@ -810,13 +794,6 @@ static int acpi_idle_enter_simple(struct
> 
>  	local_irq_disable();
> 
> -	if (acpi_idle_suspend) {
> -		local_irq_enable();
> -		cpu_relax();
> -		return -EINVAL;
> -	}
> -
> -
>  	if (cx->entry_method != ACPI_CSTATE_FFH) {
>  		current_thread_info()->status &= ~TS_POLLING;
>  		/*
> @@ -895,12 +872,6 @@ static int acpi_idle_enter_bm(struct cpu
>  	if (unlikely(!pr))
>  		return -EINVAL;
> 
> -
> -	if (acpi_idle_suspend) {
> -		cpu_relax();
> -		return -EINVAL;
> -	}
> -
>  	if (!cx->bm_sts_skip && acpi_idle_bm_check()) {
>  		if (drv->safe_state_index >= 0) {
>  			return drv->states[drv->safe_state_index].enter(dev,
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

