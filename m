Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759790Ab2EJPD4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 11:03:56 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:45910 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757216Ab2EJPDy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 11:03:54 -0400
Date: Thu, 10 May 2012 10:57:45 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: "Liu, Jinsong" <jinsong.liu@intel.com>
Cc: "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3] Xen physical cpus interface
Message-ID: <20120510145745.GO26152@phenom.dumpdata.com>
References: <DE8DF0795D48FD4CA783C40EC8292335154F3E@SHSMSX101.ccr.corp.intel.com>
 <20120420192439.GA32170@phenom.dumpdata.com>
 <DE8DF0795D48FD4CA783C40EC82923351B5807@SHSMSX101.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DE8DF0795D48FD4CA783C40EC82923351B5807@SHSMSX101.ccr.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 10, 2012 at 02:54:07PM +0000, Liu, Jinsong wrote:
> Konrad,
> 
> Thanks for help me review!

Sure thing.
> Update according to your suggestion. 
> Add some comments below.
> 
> >> 
> >> Manage physical cpus in dom0, get physical cpus info and provide sys
> >> interface. 
> > 
> > Anything that exposes SysFS attributes needs documentation in
> > Documentation/ABI
> 
> Yes, added.
> 
> > 
> > Can you explain what this solves? And if there are any
> > userland applications that use this?
> > 
> 
> It provide cpu online/offline interface to user. User can use it for their own purpose, like power saving - by offlining some cpus when light workload it save power greatly.

OK, please include that in the descritpion.

> 
> > 
> > 
> >> +	switch (buf[0]) {
> > 
> > Use strict_strtoull pls.
> 
> kernel suggest:
> WARNING: strict_strtoull is obsolete, use kstrtoull instead :)

Ah yes.
.. snip..
> > And then here dev->release = &pcpu_release;
> > 
> 
> Hmm, it's good if it's convenient to do it automatically via dev->release.
> However, dev container (pcpu) would be free at some other error cases, so I prefer do it 'manually'.

You could also call pcpu_release(..) to do it manually.

> 
> > 
> >> +	/* Not open pcpu0 online access to user */
> > 
> > Huh? You mean "Nobody can touch PCPU0" ?
> 
> Add comments:
>         /*
>          * Xen never offline cpu0 due to several restrictions
>          * and assumptions. This basically doesn't add a sys control
>          * to user, one cannot attempt to offline BSP.
>          */
> 
> > 
> > Why? Why can they touch the other ones? And better yet,
> > what happens if one boots without "dom0_max_vcpus=X"
> > and powers of some of the CPUs?
> > 
> 
> Only those at cpu present map has its sys interface.

OK, put that in the file so folks are aware of the limitations.

> 
> >> +static int __init xen_pcpu_init(void)
> >> +{
> >> +	int ret;
> >> +
> >> +	if (!xen_initial_domain())
> >> +		return -ENODEV;
> >> +
> >> +	ret = subsys_system_register(&xen_pcpu_subsys, NULL); +	if (ret) {
> >> +		pr_warning(XEN_PCPU "Failed to register pcpu subsys\n");
> >> +		return ret; +	}
> >> +
> >> +	INIT_LIST_HEAD(&xen_pcpus.list);
> >> +
> >> +	ret = xen_sync_pcpus();
> >> +	if (ret) {
> >> +		pr_warning(XEN_PCPU "Failed to sync pcpu info\n"); +		return ret;
> >> +	}
> >> +
> >> +	ret = bind_virq_to_irqhandler(VIRQ_PCPU_STATE, 0,
> >> +				      xen_pcpu_interrupt, 0,
> >> +				      "pcpu", NULL);
> > 
> > "xen-pcpu"
> > 
> >> +	if (ret < 0) {
> >> +		pr_warning(XEN_PCPU "Failed to bind pcpu virq\n");
> > 
> > Shouldn't you delete what 'xen_sync_pcpus' did?
> 
> yes, add error handling.
> 
> > Or is it OK to still work without the interrupts? What is the purpose
> > of that interrupt? How does it actually work - the hypervisor
> > decides when/where to turn off CPUs?
> > 
> 
> user online/offline cpu via sys interface --> xen implement --> inject virq back to dom0 --> sync cpu status.

Add that in the file so the workflow is explained.
> 
> Thanks,
> Jinsong
