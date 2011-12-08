Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757430Ab1LHBOA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 20:14:00 -0500
Received: from one.firstfloor.org ([213.235.205.2]:54247 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756619Ab1LHBOA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 20:14:00 -0500
Date: Thu, 8 Dec 2011 02:13:56 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Dave Jones <davej@redhat.com>, Andi Kleen <andi@firstfloor.org>,
        linux-kernel@vger.kernel.org, kay.sievers@vrfy.org, trenn@suse.de,
        Andi Kleen <ak@linux.intel.com>, hpa@zytor.com
Subject: Re: [PATCH 07/10] cpufreq: Add support for x86 cpuinfo auto loading
Message-ID: <20111208011356.GA24062@one.firstfloor.org>
References: <1323304882-27953-1-git-send-email-andi@firstfloor.org> <1323304882-27953-8-git-send-email-andi@firstfloor.org> <20111208010730.GB27892@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111208010730.GB27892@redhat.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 07, 2011 at 08:07:31PM -0500, Dave Jones wrote:
>  > +MODULE_DEVICE_TABLE(x86cpu, eps_cpu_id);
>  > +
>  >  static int __init eps_init(void)
>  >  {
>  > -	struct cpuinfo_x86 *c = &cpu_data(0);
>  > -
>  > -	/* This driver will work only on Centaur C7 processors with
>  > -	 * Enhanced SpeedStep/PowerSaver registers */
>  > -	if (c->x86_vendor != X86_VENDOR_CENTAUR
>  > -	    || c->x86 != 6 || c->x86_model < 10)
>  > -		return -ENODEV;
> 
> This makes e_powersaver bind to every family 6 VIA cpu.
> But the old logic only bound to certain models.
> Won't this will clash with this other driver if both are built ?

The code does

static int __init eps_init(void)
{
        if (!x86_match_cpu(eps_cpu_id) || boot_cpu_data.x86_model < 10)
                return -ENODEV;

So modprobe will load it, but if the CPU is too old it will just error out
again. I think that's reasonable.  There's no direct way current
to express a >= in the matches because modprobe uses fnmatch()

Also most likely the old CPUs won't have the EST bit anyways, then
it won't even be loaded.

> 
>  > diff --git a/drivers/cpufreq/longhaul.c b/drivers/cpufreq/longhaul.c
>  > index f47d26e..b4263ce 100644
>  > --- a/drivers/cpufreq/longhaul.c
>  > +++ b/drivers/cpufreq/longhaul.c
>  > 
>  > +static struct x86_cpu_id longhaul_id[] = {
>  > +	{ X86_VENDOR_CENTAUR, 6 },
>  > +	{}
>  > +};
>  > +MODULE_DEVICE_TABLE(x86cpu, longhaul_id);
> 
> iirc, the intention here was longhaul on cpus that don't have EST,
> and e_powersaver on those that do. Maybe an additional check for the
> absense of EST in longhaul's init code would do the trick.
> (sidenote: I don't recall why we even have e-powersaver, instead of them
>  just using acpi-cpufreq).

It's not done today, but I could add it. 

But I tried to keep the existing behaviour. AFAIK distros just load them
all right? This matches this. I have no way to test these CPUs so I would 
prefer to be as compatible as possible.
> 
>  > +static struct x86_cpu_id powernow_k8_ids[] = {
>  > +	{ X86_VENDOR_AMD, 0xf, },
>  > +	/* RED-PEN If HW PSTATE was a normal feature bit it could be matched here
>  > +	 * instead of a (limited) model list.
>  > +	 */
> 
> You mean make fake one in the identify code ? Do-able I guess.
> Though that would just be moving this list from this driver to a different place,
> and as this is the only place that cares..

Ok. 

Thanks for the review. I'll remove the comment.

-Andi

