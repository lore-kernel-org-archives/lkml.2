Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754663Ab2FKNcW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 09:32:22 -0400
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:41507 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754491Ab2FKNcU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 09:32:20 -0400
Message-ID: <4FD5F329.2090302@linux.vnet.ibm.com>
Date: Mon, 11 Jun 2012 19:01:21 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120424 Thunderbird/12.0
MIME-Version: 1.0
To: Dave Hansen <dave@linux.vnet.ibm.com>
CC: Deepthi Dharwar <deepthi@linux.vnet.ibm.com>,
        Linux PM mailing list <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, "Tomas M." <tmezzadra@gmail.com>,
        Ferenc Wagner <wferi@niif.hu>, Arnd Bergmann <arnd@arndb.de>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Len Brown <len.brown@intel.com>,
        Kevin Hilman <khilman@ti.com>,
        Arjan van de Ven <arjan@linux.intel.com>, Jean Pihet <j-pihet@ti.com>,
        Trinabh Gupta <g.trinabh@gmail.com>,
        linux-pm@lists.linux-foundation.org, preeti@linux.vnet.ibm.com
Subject: Re: Suspend/resume regressions on Lenovo S10-3
References: <4FC2DA8C.7050401@linux.vnet.ibm.com> <4FCF5249.2070600@linux.vnet.ibm.com>
In-Reply-To: <4FCF5249.2070600@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 12061103-7014-0000-0000-0000015AB68A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dave,

On 06/06/2012 06:21 PM, Deepthi Dharwar wrote:

> On 05/28/2012 07:23 AM, Dave Hansen wrote:
> 
>> I have a Lenovo S10-3 Atom netbook.  It's always had some amount of
>> trouble working with the intel_idle driver, so I usually compile that
>> out an use the acpi one.


What problem did you face with intel_idle driver? Is it suspend/resume
related?

I see a comment in drivers/idle/intel_idle.c such as:

/*
 * Known limitations
 * [...]
 *
 * ACPI has a .suspend hack to turn off deep c-statees during suspend
 * to avoid complications with the lapic timer workaround.
 * Have not seen issues with suspend, but may need same workaround here.
 *
 */

So, if you are facing suspend issues with the intel_idle driver, we probably
need to add that same workaround here as well, to make it work.

Please let us know what problem you are facing.

Regards,
Srivatsa S. Bhat

>>  However, just after 3.1, suspend/resume broke.
>>  'echo mem > /sys/power/state' would hang before suspending.  I bisected
>> it down to the commits around:
>>
>> 	e978aa7d7d57d04eb5f88a7507c4fb98577def77 / v3.1-1-ge978aa7
>>
>> by Deepthi.  But, current mainline (v3.4-07644-g07acfc2) hangs with a
>> different symptom: it suspends, but hangs on resume from suspend.  I
>> think _that_ delta in the behavior was caused by:
>>
>> 	3439a8da16bcad6b0982ece938c9f8299bb53584
>>
>>         ACPI / cpuidle: Remove acpi_idle_suspend (to fix suspend
>> 		regression)
>>
>> It's a bit of a pain to bisect these two different things in parallel.
>> I was trying to tell git bisect 'good' on working suspend/resume, 'bad'
>> on the hang during resume, and 'skip' on the hangs _during_ suspend.  83
>> kernels in, I'm not sure that's working very well. :)
>>
>> Deepthi, do you have any idea why your patches broke me in the first
>> place?  Perhaps we should fix that regression first before we go on and
>> try to figure out what changed to let it suspend again, but break later.
> 
> 
> Hi Dave,
> 
> Sorry about my patches breaking your suspend-resume.
> 
> I, basically tried out building and booting 3.1 kernel with 
> my patch set to reproduce the failure. I could clearly
> see suspend not happening. It turns out to be 
> a bug with my first patch in global registration
> series submitted earlier.
> 
> e978aa7d7d57d04eb5f88a7507c4fb98577def77 / v3.1-1-ge978aa7
> 
> The following patch, fixes the suspend issues
> seen on my laptop due to earlier cpuidle cleanup 
> (Lenevo T420 booting with acpi_idle enabled). 
> Can you please give this a try
> on top of my patch set (without Rafael's fix) 
> and see if it fixes the problem for you. 
> I am not reverting acpi_idle_suspend flag and 
> hopefully it should resume fine too. 
> 
> ---
> 
> This patch fixes suspend-resume issue seen in the kernel 3.1
> series using acpi_idle_driver because of cpuidle global 
> registration cleanup.
> Here, when acpi_idle_suspend flag was set ( during suspend)
> the interrupts were not getting enabled in acpi_idle_enter_bm()
> routine which was causing the system to hang.
> 
> 
> Signed-off-by: Deepthi Dharwar <deepthi@linux.vnet.ibm.com>
> 
> ---
>  drivers/acpi/processor_idle.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/acpi/processor_idle.c b/drivers/acpi/processor_idle.c
> index 24fe3af..6e35293 100644
> --- a/drivers/acpi/processor_idle.c
> +++ b/drivers/acpi/processor_idle.c
> @@ -895,8 +895,9 @@ static int acpi_idle_enter_bm(struct cpuidle_device *dev,
>  	if (unlikely(!pr))
>  		return -EINVAL;
> 
> -
>  	if (acpi_idle_suspend) {
> +		local_irq_disable();
> +		local_irq_enable();
>  		cpu_relax();
>  		return -EINVAL;
>  	}
> 
> Cheers,
> Deepthi
> 



-- 
Regards,
Srivatsa S. Bhat
IBM Linux Technology Center

