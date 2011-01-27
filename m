Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753826Ab1A0Wtt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 17:49:49 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39876 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753735Ab1A0Wtr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jan 2011 17:49:47 -0500
Date: Thu, 27 Jan 2011 14:49:16 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Olaf Hering <olaf@aepfle.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crash_dump: export is_kdump_kernel to modules,
 consolidate elfcorehdr_addr, setup_elfcorehdr and saved_max_pfn
Message-Id: <20110127144916.a311e637.akpm@linux-foundation.org>
In-Reply-To: <20110127104713.GA31360@aepfle.de>
References: <20110125161052.GA20105@aepfle.de>
	<20110126160426.796b0669.akpm@linux-foundation.org>
	<20110127104713.GA31360@aepfle.de>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 Jan 2011 11:47:13 +0100
Olaf Hering <olaf@aepfle.de> wrote:

> On Wed, Jan 26, Andrew Morton wrote:
> 
> > On Tue, 25 Jan 2011 17:10:52 +0100
> > Olaf Hering <olaf@aepfle.de> wrote:
> 
> > > --- /dev/null
> > > +++ linux-2.6.38.rc/kernel/crash_dump.c
> > > @@ -0,0 +1,33 @@
> > > +#include <linux/crash_dump.h>
> > > +#include <linux/init.h>
> > > +#include <linux/module.h>
> > > +
> > > +/*
> > > + * If we have booted due to a crash, max_pfn will be a very low value. We need
> > > + * to know the amount of memory that the previous kernel used.
> > > + */
> > > +unsigned long saved_max_pfn;
> > > +
> > > +/*
> > > + * stores the physical address of elf header of crash image
> > > + *
> > > + * Note: elfcorehdr_addr is not just limited to vmcore. It is also used by
> > > + * is_kdump_kernel() to determine if we are booting after a panic. Hence put
> > > + * it under CONFIG_CRASH_DUMP and not CONFIG_PROC_VMCORE.
> > > + */
> > > +unsigned long long elfcorehdr_addr = ELFCORE_ADDR_MAX;
> > > +EXPORT_SYMBOL_GPL(elfcorehdr_addr);
> > > +
> > > +/*
> > > + * elfcorehdr= specifies the location of elf core header stored by the crashed
> > > + * kernel. This option will be passed by kexec loader to the capture kernel.
> > > + */
> > > +static int __init setup_elfcorehdr(char *arg)
> > > +{
> > > +	char *end;
> > > +	if (!arg)
> > > +		return -EINVAL;
> > > +	elfcorehdr_addr = memparse(arg, &end);
> > > +	return end > arg ? 0 : -EINVAL;
> > > +}
> > > +early_param("elfcorehdr", setup_elfcorehdr);
> > 
> > Please check that this file is #including everything it needs.  Just
> > looking at it I'd expect a build error with CONFIG_KEXEC=n,
> > CONFIG_CRASH_DUMP=y due to a missed ELFCORE_ADDR_MAX definition.
> 
> I'm not sure what you mean?  ELFCORE_ADDR_MAX is in linux/crash_dump.h
> defined unconditionally. I dont see the relation to CONFIG_KEXEC.

OK,  I didn't look too closely.  I asked you to.  memparse()?  EINVAL?

--- a/kernel/crash_dump.c~crash_dump-export-is_kdump_kernel-to-modules-consolidate-elfcorehdr_addr-setup_elfcorehdr-and-saved_max_pfn-fix
+++ a/kernel/crash_dump.c
@@ -1,5 +1,7 @@
+#include <linux/kernel.h>
 #include <linux/crash_dump.h>
 #include <linux/init.h>
+#include <linux/errno.h>
 #include <linux/module.h>
 
 /*
_

