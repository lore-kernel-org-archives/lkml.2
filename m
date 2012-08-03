Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752423Ab2HCS5g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2012 14:57:36 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:47561 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752062Ab2HCS5c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2012 14:57:32 -0400
Date: Fri, 3 Aug 2012 11:53:24 -0700
From: Silas Boyd-Wickizer <sbw@mit.edu>
To: Jean Delvare <khali@linux-fr.org>
Cc: linux-kernel@vger.kernel.org,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Harald Welte <laforge@openezx.org>, x86@kernel.org
Subject: Re: [PATCH 3/3] Use get_online_cpus to avoid races involving
 for_each_online_cpu
Message-ID: <20120803185323.GA3525@mit.edu>
References: <20120803000708.GD3443@mit.edu>
 <20120803155640.7e2356fb@endymion.delvare>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120803155640.7e2356fb@endymion.delvare>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 03, 2012 at 03:56:40PM +0200, Jean Delvare wrote:
> Hi Silas,
> 
> On Thu, 2 Aug 2012 17:07:08 -0700, Silas Boyd-Wickizer wrote:
> > via_cputemp_init in drivers/hwmon/via-cputemp.c loops with
> > for_each_online_cpu, adding platform_devices, then calls
> > register_hotcpu_notifier.  If a CPU is offlined between the loop and
> > register_hotcpu_notifier, then later onlined, via_cputemp_device_add
> > will attempt to platform devices with the same ID.
> 
> Missing word in this last sentence.

Fixed.

> 
> > 
> > This fix surrounds for_each_online_cpu and register_hotcpu_notifier
> > with get_online_cpus+put_online_cpus.
> > 
> > Build tested.
> 
> Thanks for reporting and for the fix. Two questions:
> 
> What about via_cputemp_exit()? While less obvious, I suspect it is racy
> too. The notifier is unregistered first. If a CPU gets offline before
> the devices are removed, we will have a device pointing to a
> non-existent CPU for a short time. I think we should play it safe and
> use get/put_online_cpus() there too, as I seem to understand it
> guarantees CPUs can't go offline when we wouldn't handle that event
> properly. Alternatively, unregistering the platform driver first might
> close the race.

I added get/put_online_cpus().

> 
> Secondly, drivers/hwmon/coretemp.c is very similar to via-cputemp.c, so
> I think it needs the exact same fix(es).

Indeed -- I'll submit a fix for this.

Silas

> 
> > 
> > Signed-off-by: Silas Boyd-Wickizer <sbw@mit.edu>
> > ---
> >  drivers/hwmon/via-cputemp.c |    3 +++
> >  1 file changed, 3 insertions(+)
> > 
> > diff --git a/drivers/hwmon/via-cputemp.c b/drivers/hwmon/via-cputemp.c
> > index 8689664..9ad07c3 100644
> > --- a/drivers/hwmon/via-cputemp.c
> > +++ b/drivers/hwmon/via-cputemp.c
> > @@ -328,6 +328,7 @@ static int __init via_cputemp_init(void)
> >  	if (err)
> >  		goto exit;
> >  
> > +	get_online_cpus();
> >  	for_each_online_cpu(i) {
> >  		struct cpuinfo_x86 *c = &cpu_data(i);
> >  
> > @@ -347,12 +348,14 @@ static int __init via_cputemp_init(void)
> >  
> >  #ifndef CONFIG_HOTPLUG_CPU
> >  	if (list_empty(&pdev_list)) {
> > +		put_online_cpus();
> >  		err = -ENODEV;
> >  		goto exit_driver_unreg;
> >  	}
> >  #endif
> >  
> >  	register_hotcpu_notifier(&via_cputemp_cpu_notifier);
> > +	put_online_cpus();
> >  	return 0;
> >  
> >  #ifndef CONFIG_HOTPLUG_CPU
> 
> 
> -- 
> Jean Delvare
