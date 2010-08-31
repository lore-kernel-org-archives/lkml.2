Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756842Ab0HaHHj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Aug 2010 03:07:39 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:13205 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756326Ab0HaHHh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Aug 2010 03:07:37 -0400
Date: Tue, 31 Aug 2010 09:07:25 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Fenghua Yu <fenghua.yu@intel.com>
Cc: Jin Dongming <jin.dongming@np.css.fujitsu.com>,
        "Brown, Len" <len.brown@intel.com>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        "H. Peter Anvin" <hpa@linux.jf.intel.com>,
        LKLM <linux-kernel@vger.kernel.org>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        mingo Redhat <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [Patch-next] Trival fixes in thermal_throttle_add_dev().
Message-ID: <20100831090725.5d83eedb@hyperion.delvare>
In-Reply-To: <20100831010251.GA28885@fenghua-desk.sc.intel.com>
References: <4C75D3C4.6040802@np.css.fujitsu.com>
	<20100826060822.GA15021@fenghua-desk.sc.intel.com>
	<4C7625D1.4060201@np.css.fujitsu.com>
	<20100827152007.27636fa5@hyperion.delvare>
	<4C7B64A8.2030208@np.css.fujitsu.com>
	<493994B35A117E4F832F97C4719C4C04A111EEDF@orsmsx505.amr.corp.intel.com>
	<4C7C5314.7090404@np.css.fujitsu.com>
	<20100831010251.GA28885@fenghua-desk.sc.intel.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Fenghua,

On Mon, 30 Aug 2010 18:02:52 -0700, Fenghua Yu wrote:
> On Mon, Aug 30, 2010 at 05:55:48PM -0700, Jin Dongming wrote:
> > This patch fixed the following two problems.
> >   1. When the feature PTS is not supported by CPU, the sysfile
> >      package_power_limit_count for package should not be generated.
> >   2. No matter whether a sysfile is failed to be created or not,
> >      the next one will be created.
> > 
> > As the resolving methods:
> >   1. Add missing { and } after checking PTS feature.
> >   2. Fix the error handling.
> > 
> > Signed-off-by: Jin Dongming <jin.dongming@np.css.fujitsu.com>
> > Reviewed-by: Fenghua Yu <fenghua.yu@initel.com>
> > ---
> >  arch/x86/kernel/cpu/mcheck/therm_throt.c |   15 ++++++++++++++-
> >  1 files changed, 14 insertions(+), 1 deletions(-)
> > 
> > diff --git a/arch/x86/kernel/cpu/mcheck/therm_throt.c b/arch/x86/kernel/cpu/mcheck/therm_throt.c
> > index d9368ee..79d563a 100644
> > --- a/arch/x86/kernel/cpu/mcheck/therm_throt.c
> > +++ b/arch/x86/kernel/cpu/mcheck/therm_throt.c
> > @@ -216,14 +216,27 @@ static __cpuinit int thermal_throttle_add_dev(struct sys_device *sys_dev,
> >  		err = sysfs_add_file_to_group(&sys_dev->kobj,
> >  					      &attr_core_power_limit_count.attr,
> >  					      thermal_attr_group.name);
> > -	if (cpu_has(c, X86_FEATURE_PTS))
> > +	if (err)
> > +		goto error;
> > +
> > +	if (cpu_has(c, X86_FEATURE_PTS)) {
> >  		err = sysfs_add_file_to_group(&sys_dev->kobj,
> >  					      &attr_package_throttle_count.attr,
> >  					      thermal_attr_group.name);
> > +		if (err)
> > +			goto error;
> > +
> >  		if (cpu_has(c, X86_FEATURE_PLN))
> >  			err = sysfs_add_file_to_group(&sys_dev->kobj,
> >  					&attr_package_power_limit_count.attr,
> >  					thermal_attr_group.name);
> > +		if (err)
> > +			goto error;
> > +	}
> > +
> > +	return 0;
> > +error:
> > +	sysfs_remove_group(&sys_dev->kobj, &thermal_attr_group);
> >  
> >  	return err;
> >  }
> 
> This fix is incorrect. In this patch, a previous error prevents from adding any
> further devices. There shouldn't be such dependency among the devices.

I don't quite follow you. Did you mean to write that a previous error
prevents from creating further _attributes_ for the same device? This
would be true.

Now I don't think this is a problem because 1* such errors should never
happen anyway and 2* if they do happen then further attempts to create
the other attributes are unlikely to succeed either.

-- 
Jean Delvare
