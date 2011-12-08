Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751347Ab1LHQLH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Dec 2011 11:11:07 -0500
Received: from imr4.ericy.com ([198.24.6.9]:56815 "EHLO imr4.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751220Ab1LHQLD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Dec 2011 11:11:03 -0500
Subject: Re: [PATCH 06/10] HWMON: Convert coretemp to x86 cpuid autoprobing
From: Guenter Roeck <guenter.roeck@ericsson.com>
Reply-To: guenter.roeck@ericsson.com
To: Jean Delvare <khali@linux-fr.org>
CC: Andi Kleen <andi@firstfloor.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kay Sievers <kay.sievers@vrfy.org>, "trenn@suse.de" <trenn@suse.de>,
        Andi Kleen <ak@linux.intel.com>,
        "fenghua.yu@intel.com" <fenghua.yu@intel.com>
In-Reply-To: <20111208082402.3591123f@endymion.delvare>
References: <1323304882-27953-1-git-send-email-andi@firstfloor.org>
	 <1323304882-27953-7-git-send-email-andi@firstfloor.org>
	 <20111208024001.GA4912@ericsson.com>
	 <20111208082402.3591123f@endymion.delvare>
Content-Type: text/plain; charset="UTF-8"
Organization: Ericsson
Date: Thu, 8 Dec 2011 08:09:29 -0800
Message-ID: <1323360569.2415.16.camel@groeck-laptop>
MIME-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-12-08 at 02:24 -0500, Jean Delvare wrote:
> Hi Andi,
> 
> Thanks a lot for working on this. I wanted to give it a try long ago but
> could never find the time.
> 
> On Wed, 7 Dec 2011 18:40:01 -0800, Guenter Roeck wrote:
> > Andi,
> > 
> > On Wed, Dec 07, 2011 at 07:41:19PM -0500, Andi Kleen wrote:
> > > From: Andi Kleen <ak@linux.intel.com>
> > > 
> > > Use the new x86 cpuid autoprobe interface for the Intel coretemp
> > > driver.
> > > 
> > > Cc: fenghua.yu@intel.com
> > > Cc: khali@linux-fr.org
> > > Cc: guenter.roeck@ericsson.com
> > > Signed-off-by: Andi Kleen <ak@linux.intel.com>
> > > ---
> > >  drivers/hwmon/coretemp.c |   17 ++++++++++++++---
> > >  1 files changed, 14 insertions(+), 3 deletions(-)
> > > 
> > > diff --git a/drivers/hwmon/coretemp.c b/drivers/hwmon/coretemp.c
> > > index 104b376..5de1579 100644
> > > --- a/drivers/hwmon/coretemp.c
> > > +++ b/drivers/hwmon/coretemp.c
> > > @@ -39,6 +39,7 @@
> > >  #include <linux/moduleparam.h>
> > >  #include <asm/msr.h>
> > >  #include <asm/processor.h>
> > > +#include <asm/cpu_device_id.h>
> > >  
> > >  #define DRVNAME	"coretemp"
> > >  
> > > @@ -756,13 +757,23 @@ static struct notifier_block coretemp_cpu_notifier __refdata = {
> > >  	.notifier_call = coretemp_cpu_callback,
> > >  };
> > >  
> > > +static struct x86_cpu_id coretemp_ids[] = {
> 
> Can't this be made const?
> 
Unless I am missing something, the patchset would have to change to
accept a const as parameter to x86_match_cpu().

> > > +	{ X86_VENDOR_INTEL, X86_FAMILY_ANY, X86_MODEL_ANY, X86_FEATURE_DTS },
> > > +	{}
> > > +};
> > > +MODULE_DEVICE_TABLE(x86cpu, coretemp_ids);
> > > +
> > >  static int __init coretemp_init(void)
> > >  {
> > >  	int i, err = -ENODEV;
> > >  
> > > -	/* quick check if we run Intel */
> > > -	if (cpu_data(0).x86_vendor != X86_VENDOR_INTEL)
> > > -		goto exit;
> > > +	/*
> > > +	 * CPUID.06H.EAX[0] indicates whether the CPU has thermal
> > > +	 * sensors. We check this bit only, all the early CPUs
> > > +	 * without thermal sensors will be filtered out.
> > > +	 */
> > > +	if (!x86_match_cpu(coretemp_ids))
> > > +		return -ENODEV;
> >
> > X86_FEATURE_DTS is checked elsewhere in the driver, in function get_core_online().
> > Can that check be removed ?
> 
> Is it not possible in theory to mix a CPU with DTS and one without DTS
> on the same system? There may be a reason why the DTS flag was checked
> in get_core_online() (i.e. on a per-core basis) rather than in
> coretemp_init(). I seem to recall that someone explicitly asked for it.
> 
> To avoid any risk of regression, I wouldn't touch this part of the code.
> 
Ok, makes sense.

Thanks,
Guenter


