Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754215Ab0IJN6H (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Sep 2010 09:58:07 -0400
Received: from imr3.ericy.com ([198.24.6.13]:43314 "EHLO imr3.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754140Ab0IJN6G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Sep 2010 09:58:06 -0400
Date: Fri, 10 Sep 2010 06:56:57 -0700
From: Guenter Roeck <guenter.roeck@ericsson.com>
To: Jean Delvare <khali@linux-fr.org>
CC: Fenghua Yu <fenghua.yu@intel.com>, Ingo Molnar <mingo@elte.hu>,
        H Peter Anvin <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Jin Dongming <jin.dongming@np.css.fujitsu.com>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        lm-sensors <lm-sensors@lm-sensors.org>
Subject: Re: [PATCH v2] x86/therm_throt.c: Fix error handling in
 thermal_throttle_add_dev
Message-ID: <20100910135657.GE20082@ericsson.com>
References: <1283905550-18571-1-git-send-email-fenghua.yu@intel.com>
 <20100910101937.373d8a16@hyperion.delvare>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20100910101937.373d8a16@hyperion.delvare>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 10, 2010 at 04:19:37AM -0400, Jean Delvare wrote:
> On Tue,  7 Sep 2010 17:25:50 -0700, Fenghua Yu wrote:
> > From: Fenghua Yu <fenghua.yu@intel.com>
> > 
> > When sysfs_add_file_to_group fails, thermal_throttle_add_dev removes the
> > created group and returns with the error code and the driver cleans up and
> > returns with the error code. Thus the driver either installs all devices
> > successfully or doesn't install any device at all.
> 
> I don't think this makes any sense. While I generally agree with the
> idea that a given device (actually, CPU feature) should either be fully
> available or not available at all, I don't get the point of preventing
> the driver from loading because one device couldn't be initialized for
> whatever reason. I don't know of any other driver behaving this way.
> 
> What's the rationale? I think Ingo's wording was inaccurate and when he
> wrote "we should either initialize a driver fully - or not intialize it
> at all" he really meant "device" not "driver. Ingo?
> 

Question is what happens if an error is returned from device initialization.
If it causes the driver not to be loaded, it will have to clean up first.
To avoid that, it would have to drop the error from individual device
initializations, like it did before.

As such, it really comes down to philosophy and personal preference.
Mine would be to return the error and fail driver installation (after all,
something must really be wrong for that to happen), but then philosopy
isn't really my field ... so I'll yield to others.

Guenter

> > 
> > Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
> > ---
> >  arch/x86/kernel/cpu/mcheck/therm_throt.c |   36 ++++++++++++++++++++++++++---
> >  1 files changed, 32 insertions(+), 4 deletions(-)
> > 
> > diff --git a/arch/x86/kernel/cpu/mcheck/therm_throt.c b/arch/x86/kernel/cpu/mcheck/therm_throt.c
> > index c2a8b26..5099e90 100644
> > --- a/arch/x86/kernel/cpu/mcheck/therm_throt.c
> > +++ b/arch/x86/kernel/cpu/mcheck/therm_throt.c
> > @@ -211,19 +211,33 @@ static __cpuinit int thermal_throttle_add_dev(struct sys_device *sys_dev)
> >  	if (err)
> >  		return err;
> >  
> > -	if (cpu_has(c, X86_FEATURE_PLN))
> > +	if (cpu_has(c, X86_FEATURE_PLN)) {
> >  		err = sysfs_add_file_to_group(&sys_dev->kobj,
> >  					      &attr_core_power_limit_count.attr,
> >  					      thermal_attr_group.name);
> > -	if (cpu_has(c, X86_FEATURE_PTS))
> > +		if (err)
> > +			goto error;
> > +	}
> > +
> > +	if (cpu_has(c, X86_FEATURE_PTS)) {
> >  		err = sysfs_add_file_to_group(&sys_dev->kobj,
> >  					      &attr_package_throttle_count.attr,
> >  					      thermal_attr_group.name);
> > -		if (cpu_has(c, X86_FEATURE_PLN))
> > +		if (err)
> > +			goto error;
> > +
> > +		if (cpu_has(c, X86_FEATURE_PLN)) {
> >  			err = sysfs_add_file_to_group(&sys_dev->kobj,
> >  					&attr_package_power_limit_count.attr,
> >  					thermal_attr_group.name);
> > +			if (err)
> > +				goto error;
> > +		}
> > +	}
> >  
> > +	return 0;
> > +error:
> > +	sysfs_remove_group(&sys_dev->kobj, &thermal_attr_group);
> >  	return err;
> >  }
> >  
> 
> I'm fine with the above...
> 
> > @@ -275,6 +289,7 @@ static struct notifier_block thermal_throttle_cpu_notifier __cpuinitdata =
> >  static __init int thermal_throttle_init_device(void)
> >  {
> >  	unsigned int cpu = 0;
> > +	int i;
> >  	int err;
> >  
> >  	if (!atomic_read(&therm_throt_en))
> > @@ -288,13 +303,26 @@ static __init int thermal_throttle_init_device(void)
> >  	/* connect live CPUs to sysfs */
> >  	for_each_online_cpu(cpu) {
> >  		err = thermal_throttle_add_dev(get_cpu_sysdev(cpu));
> > -		WARN_ON(err);
> > +		if (err)
> > +			goto error;
> >  	}
> >  #ifdef CONFIG_HOTPLUG_CPU
> >  	mutex_unlock(&therm_cpu_lock);
> >  #endif
> >  
> >  	return 0;
> > +error:
> > +	WARN_ON(err);
> > +
> > +	/* cleanup. */
> > +	for (i = 0; i < cpu; i++)
> > +		thermal_throttle_remove_dev(get_cpu_sysdev(i));
> > +#ifdef CONFIG_HOTPLUG_CPU
> > +	mutex_unlock(&therm_cpu_lock);
> > +#endif
> > +	unregister_hotcpu_notifier(&thermal_throttle_cpu_notifier);
> > +
> > +	return err;
> >  }
> >  device_initcall(thermal_throttle_init_device);
> >  
> 
> ... but not with this!
> 
> -- 
> Jean Delvare
