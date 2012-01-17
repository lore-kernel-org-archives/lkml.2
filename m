Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755041Ab2AQPxj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 10:53:39 -0500
Received: from cantor2.suse.de ([195.135.220.15]:36976 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754985Ab2AQPxg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 10:53:36 -0500
Date: Tue, 17 Jan 2012 07:52:10 -0800
From: Greg KH <gregkh@suse.de>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Sergei Trofimovich <slyich@gmail.com>, linux-kernel@vger.kernel.org,
        Kay Sievers <kay.sievers@vrfy.org>,
        Linux PM mailing list <linux-pm@vger.kernel.org>,
        Tony Luck <tony.luck@intel.com>, "mingo@elte.hu" <mingo@elte.hu>,
        Borislav Petkov <bp@amd64.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>, prasad@linux.vnet.ibm.com,
        Ming Lei <tom.leiming@gmail.com>, Djalal Harouni <tixxdz@opendz.org>,
        Borislav Petkov <borislav.petkov@amd.com>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        Andi Kleen <ak@linux.intel.com>,
        gouders@et.bocholt.fh-gelsenkirchen.de,
        Marcos Souza <marcos.mage@gmail.com>, justinmattock@gmail.com,
        Jeff Chua <jeff.chua.linux@gmail.com>, neilb@suse.de
Subject: Re: [PATCH] mce: fix warning messages about static struct mce_device
Message-ID: <20120117155210.GC13778@suse.de>
References: <20120116224028.GA5072@suse.de>
 <4F156B53.9020008@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F156B53.9020008@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 17, 2012 at 06:06:35PM +0530, Srivatsa S. Bhat wrote:
> On 01/17/2012 04:10 AM, Greg KH wrote:
> 
> > From: Greg Kroah-Hartman <gregkh@suse.de>
> > 
> > When suspending, there was a large list of warnings going something like:
> > 
> > 	Device 'machinecheck1' does not have a release() function, it is broken and must be fixed
> > 
> > This patch turns the static mce_devices into dynamically allocated, and
> > properly frees them when they are removed from the system.  It solves
> > the warning messages on my laptop here.
> >
> 
> ...
> 
> >  /* Per cpu device init. All of the cpus still share the same ctrl bank: */
> >  static __cpuinit int mce_device_create(unsigned int cpu)
> >  {
> > -	struct device *dev = &per_cpu(mce_device, cpu);
> > +	struct device *dev;
> >  	int err;
> >  	int i, j;
> > 
> >  	if (!mce_available(&boot_cpu_data))
> >  		return -EIO;
> > 
> > -	memset(dev, 0, sizeof(struct device));
> > +	dev = kzalloc(sizeof *dev, GFP_KERNEL);
> > +	if (!dev)
> > +		return -ENOMEM;
> >  	dev->id  = cpu;
> >  	dev->bus = &mce_subsys;
> > +	dev->release = &mce_device_release;
> > 
> >  	err = device_register(dev);
> >  	if (err)
> > @@ -2030,6 +2038,7 @@ static __cpuinit int mce_device_create(unsigned int cpu)
> >  			goto error2;
> >  	}
> >  	cpumask_set_cpu(cpu, mce_device_initialized);
> > +	mce_device[cpu] = dev;
> > 
> >  	return 0;
> >  error2:
> > @@ -2046,7 +2055,7 @@ error:
> > 
> >  /* Make sure there are no machine checks on offlined CPUs. */
> > diff --git a/arch/x86/kernel/cpu/mcheck/mce_amd.c b/arch/x86/kernel/cpu/mcheck/mce_amd.c
> > index ba0b94a..786e76a 100644
> > --- a/arch/x86/kernel/cpu/mcheck/mce_amd.c
> > +++ b/arch/x86/kernel/cpu/mcheck/mce_amd.c
> > @@ -523,6 +523,7 @@ static __cpuinit int threshold_create_bank(unsigned int cpu, unsigned int bank)
> >  {
> >  	int i, err = 0;
> >  	struct threshold_bank *b = NULL;
> > +	struct device *dev = mce_device[cpu];
> >  	char name[32];
> > 
> >  	sprintf(name, "threshold_bank%i", bank);
> > @@ -543,8 +544,7 @@ static __cpuinit int threshold_create_bank(unsigned int cpu, unsigned int bank)
> >  		if (!b)
> >  			goto out;
> > 
> > -		err = sysfs_create_link(&per_cpu(mce_device, cpu).kobj,
> > -					b->kobj, name);
> > +		err = sysfs_create_link(&dev->kobj, b->kobj, name);
> 
> 
> I don't think dereferencing 'dev' like this is safe when booting up.
> (See below for another such instance of dereferencing dev.)
> 
> Both mcheck_init_device() and threshold_init_device() are device_initcalls.
> And the latter depends on the former, because the former dynamically
> allocates and fills the 'mce_device' array of pointers.
> 
> So, what guarantees that this ordering is preserved? IOW, what ensures that
> mcheck_init_device() is completed before running threshold_init_device()?
> 
> Or am I missing something?

You must be, as this is the way it is always works, and somehow your
machine boots properly, with the symlinks setup :)

thanks,

greg k-h
