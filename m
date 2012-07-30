Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754231Ab2G3NmE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2012 09:42:04 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:55846 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753798Ab2G3NmC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2012 09:42:02 -0400
Date: Mon, 30 Jul 2012 06:39:13 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Feng Tang <feng.tang@intel.com>
Cc: "Paul E. McKenney" <paul.mckenney@linaro.org>,
        Len Brown <len.brown@intel.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux Kernel Mail List <linux-kernel@vger.kernel.org>
Subject: Re: [Regression 3.4] tick_broadcast_mask is not restored after a CPU
 has been offline/onlined
Message-ID: <20120730133913.GK2556@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20120730151559.772d4055@feng-i7>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120730151559.772d4055@feng-i7>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12073013-7606-0000-0000-00000269055E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 30, 2012 at 03:15:59PM +0800, Feng Tang wrote:
> Hi All,
> 
> When I debugged a suspend/resume bug, I found that tick_broadcast_mask is not
> restored for a CPU after it is offline/onlined since kernel 3.4, while it's
> fine for 3.3.

Could you please try 3.5?

> Further check show it is caused by the commit 9505626d7bfe
>    ACPI: Fix unprotected smp_processor_id() in acpi_processor_cst_has_changed()
> 	
>     The acpi_processor_cst_has_changed() function is invoked from a
>     CPU_ONLINE or CPU_DEAD function, which might well execute on CPU 0
>     even though the CPU being hotplugged is some other CPU.  In addition,
>     acpi_processor_cst_has_changed() invokes smp_processor_id() without
>     protection, resulting in splats when onlining CPUs.
>     
>     This commit therefore changes the smp_processor_id() to pr->id, as is
>     used elsewhere in the code, for example, in acpi_processor_add().
>     
>     Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
> 
> diff --git a/drivers/acpi/processor_idle.c b/drivers/acpi/processor_idle.c
> index 0e8e2de..9e57b06 100644
> --- a/drivers/acpi/processor_idle.c
> +++ b/drivers/acpi/processor_idle.c
> @@ -1159,8 +1159,7 @@ int acpi_processor_cst_has_changed(struct acpi_processor *pr)
>          * to make the code that updates C-States be called once.
>          */
> 
> -       if (smp_processor_id() == 0 &&
> -                       cpuidle_get_driver() == &acpi_idle_driver) {
> +       if (pr->id == 0 && cpuidle_get_driver() == &acpi_idle_driver) {
> 
>                 cpuidle_pause_and_lock();
>                 /* Protect against cpu-hotplug */
> 
> The root cause is acpi_processor_cst_has_changed() will also be called when
> cpu_up() is run on cpu 0 to boot up other cpu, this commit will prevent the
> following code be run for that cpu, which triggers some side effect like the
> broadcast_mask is not restored. 
> 
> I raise this problem up and I don't if revert is a good solution here.

Indeed, that would re-introduce the splats from unprotected use of
smp_processor_id().  :-(

							Thanx, Paul

