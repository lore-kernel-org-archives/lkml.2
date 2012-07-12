Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161181Ab2GLOaF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 10:30:05 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:22959 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161106Ab2GLOaB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 10:30:01 -0400
Date: Thu, 12 Jul 2012 10:21:25 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Olaf Hering <olaf@aepfle.de>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, xen-devel@lists.xensource.com,
        linux-kernel@vger.kernel.org
Subject: Re: [Xen-devel] [PATCH] xen pv-on-hvm: add pfn_is_ram helper for
 kdump
Message-ID: <20120712142125.GF5204@phenom.dumpdata.com>
References: <1342083605-15371-1-git-send-email-olaf@aepfle.de>
 <20120712134703.GD5204@phenom.dumpdata.com>
 <20120712142234.GA22009@aepfle.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120712142234.GA22009@aepfle.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 12, 2012 at 04:22:34PM +0200, Olaf Hering wrote:
> On Thu, Jul 12, Konrad Rzeszutek Wilk wrote:
> 
> > On Thu, Jul 12, 2012 at 11:00:05AM +0200, Olaf Hering wrote:
> > > Register pfn_is_ram helper speed up reading /proc/vmcore in the kdump
> > > kernel. See commit message of 997c136f518c ("fs/proc/vmcore.c: add hook
> > > to read_from_oldmem() to check for non-ram pages") for details.
> > 
> > What about the 'unregister_oldmem_pfn_is_ram' call? Should this
> > be implemented here as well?
> 
> There is no need to unregister because PVonHVM is not going away during
> the lifetime of the guest.
> 
> > > +#include <linux/crash_dump.h>
> > 
> > Should this also have an #idef CONFIG_PROC_VMCORE?
> > Or is it going to compile OK without CONFIG_PROC_VMCORE defined?
> 
> All includes are supposed to work without ifdefs in the code, which is
> the case also for crash_dump.h

OK.
> 
> > > + *   previous kernel. If the pfn is ballooned, handle it properly.
> > 
> > . and by handle it properly you mean return -ENXIO?
> 
> Return code 0 means its a ballooned page and needs special care,
> non-null means it has to be handled as a RAM page.
> 
> If the hypervisor is too old (4.1 and earlier) it just means that in
> case of kdump it will just cause high load in dom0. 
> In case of kexec it will mean that the new kernel will crash because it
> can not know which pfn is actually there.
> 
> > > + * Returns 0 if the pfn is not backed by a RAM page.
> > > + */
> > > +static int xen_oldmem_pfn_is_ram(unsigned long pfn)
> > > +{
> > > +	struct xen_hvm_get_mem_type a;
> > 
> > Can you make this have already initialized values, like:
> > 
> > 	struct xen_hvm_get_mem_type a = {
> > 		.domid = DOMID_SELF;
> > 		.pfn = pfn
> > 	};
> 
> Yes.
> 
> > Also is this hypercall new? Or has it been in existence for some time?
> 
> Its new in 4.2, and was backported to 4.1.1 as well.

Can you include the c/s in git commit pls?
