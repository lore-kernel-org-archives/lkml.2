Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031414Ab2HIP6Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 11:58:25 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:43767 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031274Ab2HIP6V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 11:58:21 -0400
Date: Thu, 9 Aug 2012 10:57:50 -0500
From: Kent Yoder <key@linux.vnet.ibm.com>
To: Ashley Lai <adlai@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        tpmdd-devel@lists.sourceforge.net, benh@kernel.crashing.org,
        linuxppc-dev@lists.ozlabs.org, rcj@linux.vnet.ibm.com,
        adlai@us.ibm.com
Subject: Re: [PATCH 3/3] drivers/char/tpm: Add securityfs support for event
 log
Message-ID: <20120809155750.GA7352@linux.vnet.ibm.com>
References: <1344367748.24990.1.camel@footlong>
 <1344369479.24990.9.camel@footlong>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1344369479.24990.9.camel@footlong>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12080915-5806-0000-0000-00001833866D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ashley,

> diff --git a/drivers/char/tpm/Makefile b/drivers/char/tpm/Makefile
> index 547509d..b53da57 100644
> --- a/drivers/char/tpm/Makefile
> +++ b/drivers/char/tpm/Makefile
> @@ -2,9 +2,15 @@
>  # Makefile for the kernel tpm device drivers.
>  #
>  obj-$(CONFIG_TCG_TPM) += tpm.o
> +obj-$(CONFIG_TCG_TPM) += tpm_bios.o
>  ifdef CONFIG_ACPI
> -	obj-$(CONFIG_TCG_TPM) += tpm_bios.o
>  	tpm_bios-objs += tpm_eventlog.o tpm_acpi.o
> +else
> +ifdef CONFIG_TCG_IBMVTPM
> +	tpm_bios-objs += tpm_eventlog.o tpm_of.o
> +else
> +	tpm_bios-objs += tpm_eventlog.o tpm_noeventlog.o

  tpm_eventlog.c is included in all cases here...

> diff --git a/drivers/char/tpm/tpm_eventlog.h b/drivers/char/tpm/tpm_eventlog.h
> index 8e23ccd..5fbea94 100644
> --- a/drivers/char/tpm/tpm_eventlog.h
> +++ b/drivers/char/tpm/tpm_eventlog.h
> @@ -68,4 +68,28 @@ enum tcpa_pc_event_ids {
>  };
> 
>  int read_log(struct tpm_bios_log *log);
> +
> +#if defined(CONFIG_ACPI) || defined(CONFIG_PPC64)
> +extern struct dentry **tpm_bios_log_setup(char *);
> +extern void tpm_bios_log_teardown(struct dentry **);
> +#else
> +static inline struct dentry **tpm_bios_log_setup(char *name)
> +{
> +	return NULL;
> +}
> +static inline void tpm_bios_log_teardown(struct dentry **dir)
> +{
> +}
> +#endif

  But here, without acpi or ppc64, we compile in stubs, which breaks
things. It looks like we don't need these stubs at all anymore, and can
rely on TPM_NO_EVENT_LOG to bail out in the cases on x86 where ACPI is
disabled.

Kent

> +
> +#ifdef CONFIG_PPC64
> +#define TPM_NO_EVENT_LOG !of_find_node_by_name(NULL, "ibm,vtpm")
> +#else
> +#ifdef CONFIG_ACPI
> +#define TPM_NO_EVENT_LOG 0
> +#else
> +#define TPM_NO_EVENT_LOG 1
> +#endif
> +#endif
> +
>  #endif
> diff --git a/drivers/char/tpm/tpm_noeventlog.c b/drivers/char/tpm/tpm_noeventlog.c
> new file mode 100644
> index 0000000..f30a2bf
> --- /dev/null
> +++ b/drivers/char/tpm/tpm_noeventlog.c
> @@ -0,0 +1,21 @@
> +/*
> + * Copyright (C) 2012 IBM Corporation
> + *
> + * Author: Ashley Lai <adlai@us.ibm.com>
> + *
> + * Maintained by: <tpmdd-devel@lists.sourceforge.net>
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License
> + * as published by the Free Software Foundation; either version
> + * 2 of the License, or (at your option) any later version.
> + *
> + */
> +
> +#include <linux/slab.h>
> +#include "tpm_eventlog.h"
> +
> +int read_log(struct tpm_bios_log *log)
> +{
> +	return -EINVAL;
> +}
> diff --git a/drivers/char/tpm/tpm_of.c b/drivers/char/tpm/tpm_of.c
> new file mode 100644
> index 0000000..6d44adb
> --- /dev/null
> +++ b/drivers/char/tpm/tpm_of.c
> @@ -0,0 +1,68 @@
> +/*
> + * Copyright 2012 IBM Corporation
> + *
> + * Author: Ashley Lai <adlai@us.ibm.com>
> + *
> + * Maintained by: <tpmdd-devel@lists.sourceforge.net>
> + *
> + * Read the event log created by the firmware on PPC64
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License
> + * as published by the Free Software Foundation; either version
> + * 2 of the License, or (at your option) any later version.
> + *
> + */
> +
> +#include <linux/slab.h>
> +#include <linux/of.h>
> +
> +#include "tpm.h"
> +#include "tpm_eventlog.h"
> +
> +int read_log(struct tpm_bios_log *log)
> +{
> +	struct device_node *np;
> +	const u32 *sizep;
> +	const __be64 *basep;
> +
> +	if (log->bios_event_log != NULL) {
> +		pr_err("%s: ERROR - Eventlog already initialized\n", __func__);
> +		return -EFAULT;
> +	}
> +
> +	np = of_find_node_by_name(NULL, "ibm,vtpm");
> +	if (!np) {
> +		pr_err("%s: ERROR - IBMVTPM not supported\n", __func__);
> +		return -ENODEV;
> +	}
> +
> +	sizep = of_get_property(np, "linux,sml-size", NULL);
> +	if (sizep == NULL) {
> +		pr_err("%s: ERROR - SML size not found\n", __func__);
> +		return -EIO;
> +	}
> +	if (*sizep == 0) {
> +		pr_err("%s: ERROR - event log area empty\n", __func__);
> +		return -EIO;
> +	}
> +
> +	basep = of_get_property(np, "linux,sml-base", NULL);
> +	if (basep == NULL) {
> +		pr_err(KERN_ERR "%s: ERROR - SML not found\n", __func__);
> +		return -EIO;
> +	}
> +
> +	log->bios_event_log = kmalloc(*sizep, GFP_KERNEL);
> +	if (!log->bios_event_log) {
> +		pr_err("%s: ERROR - Not enough memory for BIOS measurements\n",
> +		       __func__);
> +		return -ENOMEM;
> +	}
> +
> +	log->bios_event_log_end = log->bios_event_log + *sizep;
> +
> +	memcpy(log->bios_event_log, __va(be64_to_cpup(basep)), *sizep);
> +
> +	return 0;
> +}
> -- 
> 1.7.1
> 
> 

