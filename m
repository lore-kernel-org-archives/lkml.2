Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757362Ab1LHBHs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 20:07:48 -0500
Received: from mx1.redhat.com ([209.132.183.28]:5639 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757231Ab1LHBHq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 20:07:46 -0500
Date: Wed, 7 Dec 2011 20:07:31 -0500
From: Dave Jones <davej@redhat.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, kay.sievers@vrfy.org, trenn@suse.de,
        Andi Kleen <ak@linux.intel.com>, hpa@zytor.com
Subject: Re: [PATCH 07/10] cpufreq: Add support for x86 cpuinfo auto loading
Message-ID: <20111208010730.GB27892@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
	kay.sievers@vrfy.org, trenn@suse.de,
	Andi Kleen <ak@linux.intel.com>, hpa@zytor.com
References: <1323304882-27953-1-git-send-email-andi@firstfloor.org>
 <1323304882-27953-8-git-send-email-andi@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1323304882-27953-8-git-send-email-andi@firstfloor.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 07, 2011 at 04:41:20PM -0800, Andi Kleen wrote:
 
I think this bit isn't right..

 > diff --git a/drivers/cpufreq/e_powersaver.c b/drivers/cpufreq/e_powersaver.c
 > index 4bd6815..4604951 100644
 > --- a/drivers/cpufreq/e_powersaver.c
 > +++ b/drivers/cpufreq/e_powersaver.c
 
 > +static struct x86_cpu_id eps_cpu_id[] = {
 > +	{ X86_VENDOR_CENTAUR, 6, X86_MODEL_ANY, X86_FEATURE_EST },
 > +	{}
 > +};
 ...

 > +MODULE_DEVICE_TABLE(x86cpu, eps_cpu_id);
 > +
 >  static int __init eps_init(void)
 >  {
 > -	struct cpuinfo_x86 *c = &cpu_data(0);
 > -
 > -	/* This driver will work only on Centaur C7 processors with
 > -	 * Enhanced SpeedStep/PowerSaver registers */
 > -	if (c->x86_vendor != X86_VENDOR_CENTAUR
 > -	    || c->x86 != 6 || c->x86_model < 10)
 > -		return -ENODEV;

This makes e_powersaver bind to every family 6 VIA cpu.
But the old logic only bound to certain models.
Won't this will clash with this other driver if both are built ?

 > diff --git a/drivers/cpufreq/longhaul.c b/drivers/cpufreq/longhaul.c
 > index f47d26e..b4263ce 100644
 > --- a/drivers/cpufreq/longhaul.c
 > +++ b/drivers/cpufreq/longhaul.c
 > 
 > +static struct x86_cpu_id longhaul_id[] = {
 > +	{ X86_VENDOR_CENTAUR, 6 },
 > +	{}
 > +};
 > +MODULE_DEVICE_TABLE(x86cpu, longhaul_id);

iirc, the intention here was longhaul on cpus that don't have EST,
and e_powersaver on those that do. Maybe an additional check for the
absense of EST in longhaul's init code would do the trick.
(sidenote: I don't recall why we even have e-powersaver, instead of them
 just using acpi-cpufreq).

 > +static struct x86_cpu_id powernow_k8_ids[] = {
 > +	{ X86_VENDOR_AMD, 0xf, },
 > +	/* RED-PEN If HW PSTATE was a normal feature bit it could be matched here
 > +	 * instead of a (limited) model list.
 > +	 */

You mean make fake one in the identify code ? Do-able I guess.
Though that would just be moving this list from this driver to a different place,
and as this is the only place that cares..

Other stuff looks ok on a quick eyeball. I wouldn't be surprised though if
this series throws some surprises, especially on some of the older hardware.

Seems like a step in the right direction though.

	Dave

