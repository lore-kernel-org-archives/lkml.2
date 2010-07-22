Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759423Ab0GVVVN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 17:21:13 -0400
Received: from mga01.intel.com ([192.55.52.88]:23887 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754007Ab0GVVVM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 17:21:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.55,245,1278313200"; 
   d="scan'208";a="588787422"
Date: Thu, 22 Jul 2010 14:21:11 -0700
From: Fenghua Yu <fenghua.yu@intel.com>
To: Guenter Roeck <guenter.roeck@ericsson.com>
Cc: "Yu, Fenghua" <fenghua.yu@intel.com>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        Chen Gong <gong.chen@linux.intel.com>,
        Jean Delvare <khali@linux-fr.org>, "Wan, Huaxu" <huaxu.wan@intel.com>,
        lkml <linux-kernel@vger.kernel.org>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>
Subject: Re: [PATCH 5/5] Package Level Thermal Control and Power Limit Notification: pkgtemp doc
Message-ID: <20100722212111.GC22450@linux-os.sc.intel.com>
References: <94E56C79ECC49A4B87113985F1FEBA8D03F8AE2A4B@bgsmsx502.gar.corp.intel.com> <4C485DF1.5050407@linux.intel.com> <20100722162222.GA22450@linux-os.sc.intel.com> <20100722172726.GA4914@ericsson.com> <20100722175225.GB22450@linux-os.sc.intel.com> <20100722185814.GA5235@ericsson.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100722185814.GA5235@ericsson.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 22, 2010 at 11:58:14AM -0700, Guenter Roeck wrote:
> On Thu, Jul 22, 2010 at 01:52:25PM -0400, Fenghua Yu wrote:
> > > Just for clarification - you mention a number of sensors, but unless
> > > I am missing something only the package sensor is implemented. Is that correct ?
> > Do you mean "only the core sensor"? I think the Sandy Bridge only implements
> > core sensor now. I would think in the future more sensors could be implemented.
> > If only core sensors are implemented, there is no need to have the package
> > level thermal hw MSRs because OS can get all package level thermal info by
> > enumerating all core sensors in a package.
> > 
> Now you lost me. I understand there are the per-core sensors, read through coretemp,
> plus one package level sensor. Do you associate this existing package level sensor
> with any of the locations mentioned above (core, uncore, memory, other), or is
> that unknown ? If it is unknown, you might want to mention it.

There are more than one package level sensor. The package level MSRs take into
account the maximum across the whole package, which encompasses all the cores
and other integrated components like memory controller, uncore, graphics, etc.
Sandy Bridge implements not only core sensors but also other sensors. I take
back what I said that Sandy Bridge only implements core sensors.


> 
> > > 
> > > > +Temperature is measured in degrees Celsius and measurement resolution is
> > > > +1 degree C. Valid temperatures are from 0 to TjMax degrees C, because the actual
> > > > +value of temperature register is in fact a delta from TjMax.
> > > > +
> > > From the code, it seems that negative values can be reported. Is it guaranteed 
> > > by the chip that (TjMax - MSR_IA32_TEMPERATURE_TARGET) >= 0 ? Otherwise, the
> > > minimum temperature would be (TjMax - 127).
> > > 
> > > > +Temperature known as TjMax is the maximum junction temperature of package.
> > > > +Intel defines this temperature as 125C. At this temperature, protection
> > > 
> > > Your driver bails out at TjMax >= 120, so there is some inconsistency.
> > > Also, it seems that this is not a constant, since you are reading
> > > MSR_IA32_TEMPERATURE_TARGET to get the value.
> > > 
> > > Since the CPUs supporting the package sensor presumably also all support
> > > reading TjMax, maybe you can reword the above text to reflect this.
> > > 
> > You are right. I forgot to update this part. I'll reword it.
> > 
> > > > +mechanism will perform actions to forcibly cool down the processor. Alarm
> > > > +may be raised, if the temperature grows enough (more than TjMax) to trigger
> > > > +the Out-Of-Spec bit. Following table summarizes the exported sysfs files:
> > > > +
> > > > +temp1_input	 - Package temperature (in millidegrees Celsius).
> > > > +temp1_crit	 - Maximum junction temperature (in millidegrees Celsius).
> > > > +temp1_crit_alarm - Set when Out-of-spec bit is set, never clears.
> > > > +		   Correct CPU operation is no longer guaranteed.
> > > > +temp1_label	 - Contains string "Pysical package id X", where X is physical
> > > 
> > > Pysical --> Physical.
> > > I would suggest to drop the "id" for consistency. Core sensor names don't
> > > include "id" either.
> > > 
> > > I am not sure if "physical" should be included in the first place.
> > > Also, above description suggests that future CPUs might add more sensors.
> > > If so, the name should probably reflect the location of the current sensor,
> > > ie be something like "Package core X" or "Core package X" or "Package X (core)".
> > How about just using "package X" to align with coretemp for now? Currently there
> > is no interface to tell which sensor it is.
> > 
> Fine with me. Maybe wait for feedback from others.
> 
> You use the argument that there may be other package level sensors in the future.
> Are there any plans for this, or is this just a theory ?
> 

Not just a theory. Sandy Bridge already implements other package level sensors.
If really need to know exactly which sensors are implemented, we might go
through a channel before releasing the info.

> Next question is how to handle future sensor types. One hwmon instance per sensor,
> additional sensors in this driver, or even a new driver ?

Currently package level thermal just reports the maximum temperature across
the package. Which sensor is reporting the highest temperature is not exposed.

> 
> We had was a separate discussion if the coretemp driver should be redesigned
> to one instance per CPU. The package sensor would fit into that model,
> since you would have
> 
> coretemp-isa-0000
> Core0
> Core1
> ...
> CoreN
> Package
> 
> coretemp-isa-0001
> Core0
> Core1
> ...
> CoreM
> Package
> 
> I personally would prefer that approach. It would avoid ambiguity associating Package X
> with specific cores, and it would also easily expand to additional non-core future sensors.

Package X shows Physical id which is unique in platform topology and can be
got from cpuinfo. Package X doesn't have that problem, right?

Maybe instead of showing "Package X", pkgtemp may show "Physical id" just like
what cpuinfo shows?
