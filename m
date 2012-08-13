Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752556Ab2HMQPt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 12:15:49 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:43889 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752491Ab2HMQPq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 12:15:46 -0400
Message-ID: <1344874518.4430.12.camel@footlong>
Subject: Re: [PATCH V2 3/3] drivers/char/tpm: Add securityfs support for
 event log
From: Ashley Lai <adlai@linux.vnet.ibm.com>
To: Michael Ellerman <michael@ellerman.id.au>
Cc: linux-kernel@vger.kernel.org, rcj@linux.vnet.ibm.com,
        linux-security-module@vger.kernel.org,
        tpmdd-devel@lists.sourceforge.net, adlai@us.ibm.com,
        key@linux.vnet.ibm.com, linuxppc-dev@lists.ozlabs.org
Date: Mon, 13 Aug 2012 11:15:18 -0500
In-Reply-To: <1344583401.27290.15.camel@concordia>
References: <1344553253.28791.7.camel@footlong>
	 <1344553986.28791.13.camel@footlong> <1344583401.27290.15.camel@concordia>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12081316-6148-0000-0000-00000893DED7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thank you so much for reviewing the code.  Please see my reply below.

On Fri, 2012-08-10 at 17:23 +1000, Michael Ellerman wrote:
> On Thu, 2012-08-09 at 18:13 -0500, Ashley Lai wrote:
> > This patch retrieves the event log data from the device tree
> > during file open. The event log data will then displayed through
> > securityfs.
> 
> Hi Ashley,
> 
> Comments inline ..
> 
> > diff --git a/drivers/char/tpm/Makefile b/drivers/char/tpm/Makefile
> > index 547509d..b53da57 100644
> > --- a/drivers/char/tpm/Makefile
> > +++ b/drivers/char/tpm/Makefile
> > @@ -2,9 +2,15 @@
> >  # Makefile for the kernel tpm device drivers.
> >  #
> >  obj-$(CONFIG_TCG_TPM) += tpm.o
> > +obj-$(CONFIG_TCG_TPM) += tpm_bios.o
> >  ifdef CONFIG_ACPI
> > -	obj-$(CONFIG_TCG_TPM) += tpm_bios.o
> >  	tpm_bios-objs += tpm_eventlog.o tpm_acpi.o
> > +else
> > +ifdef CONFIG_TCG_IBMVTPM
> > +	tpm_bios-objs += tpm_eventlog.o tpm_of.o
> > +else
> > +	tpm_bios-objs += tpm_eventlog.o tpm_noeventlog.o
> 
> What does it mean to build tpm_eventlog and tpm_noeventlog ?

This is the case where the event log is not available. I agree it does not
look clean.  I'm thinking of moving tpm_noeventlog into header file to
eliminate this file.

> 
> 
> 
> > diff --git a/drivers/char/tpm/tpm_eventlog.h b/drivers/char/tpm/tpm_eventlog.h
> > index 8e23ccd..21ac6af 100644
> > --- a/drivers/char/tpm/tpm_eventlog.h
> > +++ b/drivers/char/tpm/tpm_eventlog.h
> > @@ -68,4 +68,18 @@ enum tcpa_pc_event_ids {
> >  };
> >  
> >  int read_log(struct tpm_bios_log *log);
> > +
> > +extern struct dentry **tpm_bios_log_setup(char *);
> > +extern void tpm_bios_log_teardown(struct dentry **);
> > +
> > +#ifdef CONFIG_PPC64
> > +#define TPM_NO_EVENT_LOG !of_find_node_by_name(NULL, "ibm,vtpm")
> > +#else
> > +#ifdef CONFIG_ACPI
> > +#define TPM_NO_EVENT_LOG 0
> > +#else
> > +#define TPM_NO_EVENT_LOG 1
> > +#endif
> > +#endif
> 
> This should be a static inline, with the ifdefs inside.

I just realized that it does not need to call of_find_node_by_name() 
here because if ibm,vtpm is not there it does not go to probe. Thanks
for pointing this out.

> 
> How often is this called? of_find_node_by_name() is not particularly
> efficient. It might be better to search once and save a flag indicating
> whether you found it.

This is called during load and unload of the driver. I'll remove the call to
of_find_node_by_name() in next version.  See above.

> 
> Also you must call of_node_put() on the result of
> of_find_node_by_name(), so at the least you must do:

Nice catch!!! I will fix other places in the code in the next
version.

> 
> struct device_node *np;
> np = of_find_node_by_name(NULL, "ibm,vtpm");
> of_node_put(np);
> return (np != NULL);
> 
> >  #endif
> > diff --git a/drivers/char/tpm/tpm_noeventlog.c b/drivers/char/tpm/tpm_noeventlog.c
> > new file mode 100644
> > index 0000000..f30a2bf
> > --- /dev/null
> > +++ b/drivers/char/tpm/tpm_noeventlog.c
> > @@ -0,0 +1,21 @@
> > +/*
> > + * Copyright (C) 2012 IBM Corporation
>                 ^^
> Don't use (C)

Will remove it.

> 
> > + *
> > + * Author: Ashley Lai <adlai@us.ibm.com>
> > + *
> > + * Maintained by: <tpmdd-devel@lists.sourceforge.net>
> > + *
> > + * This program is free software; you can redistribute it and/or
> > + * modify it under the terms of the GNU General Public License
> > + * as published by the Free Software Foundation; either version
> > + * 2 of the License, or (at your option) any later version.
> > + *
> > + */
> > +
> > +#include <linux/slab.h>
> > +#include "tpm_eventlog.h"
> > +
> > +int read_log(struct tpm_bios_log *log)
> > +{
> > +	return -EINVAL;
> > +}
> 
> Wouldn't it be simpler to put this in a header with the appropriate
> ifdefs, and then you'd need less logic in the Makefile?

Will move this to header file. Thanks.

> 
> 
> > diff --git a/drivers/char/tpm/tpm_of.c b/drivers/char/tpm/tpm_of.c
> > new file mode 100644
> > index 0000000..6d44adb
> > --- /dev/null
> > +++ b/drivers/char/tpm/tpm_of.c
> > @@ -0,0 +1,68 @@
> > +/*
> > + * Copyright 2012 IBM Corporation
> > + *
> > + * Author: Ashley Lai <adlai@us.ibm.com>
> > + *
> > + * Maintained by: <tpmdd-devel@lists.sourceforge.net>
> > + *
> > + * Read the event log created by the firmware on PPC64
> > + *
> > + * This program is free software; you can redistribute it and/or
> > + * modify it under the terms of the GNU General Public License
> > + * as published by the Free Software Foundation; either version
> > + * 2 of the License, or (at your option) any later version.
> > + *
> > + */
> > +
> > +#include <linux/slab.h>
> > +#include <linux/of.h>
> > +
> > +#include "tpm.h"
> > +#include "tpm_eventlog.h"
> > +
> > +int read_log(struct tpm_bios_log *log)
> > +{
> > +	struct device_node *np;
> > +	const u32 *sizep;
> > +	const __be64 *basep;
> > +
> > +	if (log->bios_event_log != NULL) {
> > +		pr_err("%s: ERROR - Eventlog already initialized\n", __func__);
> > +		return -EFAULT;
> > +	}
> > +
> > +	np = of_find_node_by_name(NULL, "ibm,vtpm");
> > +	if (!np) {
> > +		pr_err("%s: ERROR - IBMVTPM not supported\n", __func__);
> > +		return -ENODEV;
> > +	}
> 
> All your return paths below here must call of_node_put(np).

I'll fix it in next version.  Thanks.

> 
> > +	sizep = of_get_property(np, "linux,sml-size", NULL);
> > +	if (sizep == NULL) {
> > +		pr_err("%s: ERROR - SML size not found\n", __func__);
> > +		return -EIO;
> > +	}
> > +	if (*sizep == 0) {
> > +		pr_err("%s: ERROR - event log area empty\n", __func__);
> > +		return -EIO;
> > +	}
> > +
> > +	basep = of_get_property(np, "linux,sml-base", NULL);
> > +	if (basep == NULL) {
> > +		pr_err(KERN_ERR "%s: ERROR - SML not found\n", __func__);
> > +		return -EIO;
> > +	}
> > +
> > +	log->bios_event_log = kmalloc(*sizep, GFP_KERNEL);
> > +	if (!log->bios_event_log) {
> > +		pr_err("%s: ERROR - Not enough memory for BIOS measurements\n",
> > +		       __func__);
> > +		return -ENOMEM;
> > +	}
> > +
> > +	log->bios_event_log_end = log->bios_event_log + *sizep;
> > +
> > +	memcpy(log->bios_event_log, __va(be64_to_cpup(basep)), *sizep);
> > +
> > +	return 0;
> > +}
> 
> 
> cheers
> 



