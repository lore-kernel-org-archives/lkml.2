Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752074Ab2B1HT4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 02:19:56 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:52251 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753041Ab2B1HTy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 02:19:54 -0500
Date: Tue, 28 Feb 2012 15:19:43 +0800
From: Yong Zhang <yong.zhang0@gmail.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: deepthi@linux.vnet.ibm.com, linux-kernel@vger.kernel.org, lenb@kernel.org,
        linux-acpi@vger.kernel.org
Subject: Re: [PATCH RFC] acpi: Fix unprotected smp_processor_id() in
 acpi_processor_cst_has_changed()
Message-ID: <20120228071943.GE1112@zhy>
Reply-To: Yong Zhang <yong.zhang0@gmail.com>
References: <20120223205805.GA31838@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20120223205805.GA31838@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 23, 2012 at 12:58:05PM -0800, Paul E. McKenney wrote:
> The acpi_processor_cst_has_changed() function is invoked from a
> CPU_ONLINE or CPU_DEAD function, which might well execute on CPU 0
> even though the CPU being hotplugged is some other CPU.  In addition,
> acpi_processor_cst_has_changed() invokes smp_processor_id() without
> protection, resulting in splats when onlining CPUs.
> 
> This commit therefore changes the smp_processor_id() to pr->id, as is
> used elsewhere in the code, for example, in acpi_processor_add().
> 
> This works for me, but I don't claim to understand ACPI.
> 
> Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>

Got the same warning.
And the patch works on my side.

Tested-by: Yong Zhang <yong.zhang0@gmail.com>

> 
> diff --git a/drivers/acpi/processor_idle.c b/drivers/acpi/processor_idle.c
> index 0e8e2de..9e57b06 100644
> --- a/drivers/acpi/processor_idle.c
> +++ b/drivers/acpi/processor_idle.c
> @@ -1159,8 +1159,7 @@ int acpi_processor_cst_has_changed(struct acpi_processor *pr)
>  	 * to make the code that updates C-States be called once.
>  	 */
>  
> -	if (smp_processor_id() == 0 &&
> -			cpuidle_get_driver() == &acpi_idle_driver) {
> +	if (pr->id == 0 && cpuidle_get_driver() == &acpi_idle_driver) {
>  
>  		cpuidle_pause_and_lock();
>  		/* Protect against cpu-hotplug */
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
Only stand for myself
