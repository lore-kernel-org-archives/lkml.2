Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752227Ab1LSFtD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 00:49:03 -0500
Received: from mga01.intel.com ([192.55.52.88]:7732 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751262Ab1LSFs7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 00:48:59 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="103673926"
From: "Tian, Kevin" <kevin.tian@intel.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, "Yu, Ke" <ke.yu@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "lenb@kernel.org" <lenb@kernel.org>, "rjw@sisk.pl" <rjw@sisk.pl>
CC: "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "jeremy@goop.org" <jeremy@goop.org>,
        "konrad@kernel.org" <konrad@kernel.org>,
        "stefan.bader@canonical.com" <stefan.bader@canonical.com>,
        "Ian.Campbell@citrix.com" <Ian.Campbell@citrix.com>,
        "mike.mcclurg@citrix.com" <mike.mcclurg@citrix.com>,
        "liang.tang@oracle.com" <liang.tang@oracle.com>
Date: Mon, 19 Dec 2011 13:48:01 +0800
Subject: RE: [PATCH 3/8] ACPI: processor: add
 __acpi_processor_[un]register_driver helpers.
Thread-Topic: [PATCH 3/8] ACPI: processor: add
 __acpi_processor_[un]register_driver helpers.
Thread-Index: Acy8Pr/Z5B3Lv9T5RuGe8oomEBprNwB0p2vQ
Message-ID: <625BA99ED14B2D499DC4E29D8138F1506E01AABC7A@shsmsx502.ccr.corp.intel.com>
References: <1322673664-14642-1-git-send-email-konrad.wilk@oracle.com>
 <1322673664-14642-4-git-send-email-konrad.wilk@oracle.com>
 <20111216220342.GC9832@phenom.dumpdata.com>
In-Reply-To: <20111216220342.GC9832@phenom.dumpdata.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Konrad Rzeszutek Wilk [mailto:konrad.wilk@oracle.com]
> Sent: Saturday, December 17, 2011 6:04 AM
> 
> On Wed, Nov 30, 2011 at 12:20:59PM -0500, Konrad Rzeszutek Wilk wrote:
> > From: Tang Liang <liang.tang@oracle.com>
> >
> > This patch implement __acpi_processor_[un]register_driver helper,
> > so we can registry override processor driver function. Specifically
> > the Xen processor driver.
> 
> Liang,
> 
> Is the reason we are doing this b/c we need to call acpi_bus_register_driver
> and inhibit the registration of 'acpi_processor_driver' ?
> 
> And the reason we don't want 'acpi_processor_driver' to run is b/c of what?
> If the cpuidle is disabled what is the harm of running the
> 'acpi_processor_driver'
> driver?

IIRC, the reason why we want a Xen specific driver is because current driver
is integrated with OS logic too tightly, e.g. the various checks on VCPU related
structures. Long time ago the 1st version in Xen was to use same driver, by
adding various tweaking lines inside which makes it completely messed. Then
later it's found that it's clearer to create a Xen specific wrapping driver, by 
invoking some exported functions from existing one.

Thanks
Kevin

> 
> >
> > By default the values are set to the native one.
> >
> > Signed-off-by: Tang Liang <liang.tang@oracle.com>
> > Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> > ---
> >  drivers/acpi/processor_driver.c |   35
> +++++++++++++++++++++++++++++------
> >  include/acpi/processor.h        |    6 +++++-
> >  2 files changed, 34 insertions(+), 7 deletions(-)
> >
> > diff --git a/drivers/acpi/processor_driver.c b/drivers/acpi/processor_driver.c
> > index 211c078..55f0b89 100644
> > --- a/drivers/acpi/processor_driver.c
> > +++ b/drivers/acpi/processor_driver.c
> > @@ -90,6 +90,11 @@ static const struct acpi_device_id
> processor_device_ids[] = {
> >  };
> >  MODULE_DEVICE_TABLE(acpi, processor_device_ids);
> >
> > +int (*__acpi_processor_register_driver)(void) =
> acpi_processor_register_driver;
> > +void (*__acpi_processor_unregister_driver)(void) \
> > +	= acpi_processor_unregister_driver;
> > +
> > +
> >  static struct acpi_driver acpi_processor_driver = {
> >  	.name = "processor",
> >  	.class = ACPI_PROCESSOR_CLASS,
> > @@ -779,6 +784,22 @@ void acpi_processor_uninstall_hotplug_notify(void)
> >  	unregister_hotcpu_notifier(&acpi_cpu_notifier);
> >  }
> >
> > +int acpi_processor_register_driver(void)
> > +{
> > +	int result = 0;
> > +
> > +	result = acpi_bus_register_driver(&acpi_processor_driver);
> > +	return result;
> > +}
> > +
> > +void acpi_processor_unregister_driver(void)
> > +{
> > +	acpi_bus_unregister_driver(&acpi_processor_driver);
> > +
> > +	cpuidle_unregister_driver(&acpi_idle_driver);
> > +
> > +	return;
> > +}
> >  /*
> >   * We keep the driver loaded even when ACPI is not running.
> >   * This is needed for the powernow-k8 driver, that works even without
> > @@ -794,9 +815,11 @@ static int __init acpi_processor_init(void)
> >
> >  	memset(&errata, 0, sizeof(errata));
> >
> > -	result = acpi_bus_register_driver(&acpi_processor_driver);
> > -	if (result < 0)
> > -		return result;
> > +	if (__acpi_processor_register_driver) {
> > +		result = __acpi_processor_register_driver();
> > +		if (result < 0)
> > +			return result;
> > +	}
> >
> >  	acpi_processor_install_hotplug_notify();
> >
> > @@ -809,6 +832,7 @@ static int __init acpi_processor_init(void)
> >  	return 0;
> >  }
> >
> > +
> >  static void __exit acpi_processor_exit(void)
> >  {
> >  	if (acpi_disabled)
> > @@ -820,9 +844,8 @@ static void __exit acpi_processor_exit(void)
> >
> >  	acpi_processor_uninstall_hotplug_notify();
> >
> > -	acpi_bus_unregister_driver(&acpi_processor_driver);
> > -
> > -	cpuidle_unregister_driver(&acpi_idle_driver);
> > +	if (__acpi_processor_unregister_driver)
> > +		__acpi_processor_unregister_driver();
> >
> >  	return;
> >  }
> > diff --git a/include/acpi/processor.h b/include/acpi/processor.h
> > index bd99fb6..969cbc9 100644
> > --- a/include/acpi/processor.h
> > +++ b/include/acpi/processor.h
> > @@ -225,6 +225,9 @@ struct acpi_processor_errata {
> >  	} piix4;
> >  };
> >
> > +extern int (*__acpi_processor_register_driver)(void);
> > +extern void (*__acpi_processor_unregister_driver)(void);
> > +
> >  extern int acpi_processor_preregister_performance(struct
> >  						  acpi_processor_performance
> >  						  __percpu *performance);
> > @@ -242,7 +245,8 @@ int acpi_processor_notify_smm(struct module
> *calling_module);
> >
> >  void acpi_processor_install_hotplug_notify(void);
> >  void acpi_processor_uninstall_hotplug_notify(void);
> > -
> > +int acpi_processor_register_driver(void);
> > +void acpi_processor_unregister_driver(void);
> >  int acpi_processor_add(struct acpi_device *device);
> >  int acpi_processor_remove(struct acpi_device *device, int type);
> >  void acpi_processor_notify(struct acpi_device *device, u32 event);
> > --
> > 1.7.7.3
