Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756286Ab2DQQHP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 12:07:15 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:41842 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752570Ab2DQQHN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 12:07:13 -0400
Date: Tue, 17 Apr 2012 12:02:08 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: "Liu, Jinsong" <jinsong.liu@intel.com>
Cc: "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] Register native mce handler as vMCE bounce back point
Message-ID: <20120417160208.GB28477@phenom.dumpdata.com>
References: <DE8DF0795D48FD4CA783C40EC8292335146A7A@SHSMSX101.ccr.corp.intel.com>
 <20120416202821.GC14982@phenom.dumpdata.com>
 <DE8DF0795D48FD4CA783C40EC829233514BFD4@SHSMSX101.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DE8DF0795D48FD4CA783C40EC829233514BFD4@SHSMSX101.ccr.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
X-CT-RefId: str=0001.0A090202.4F8D952E.0017,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 17, 2012 at 12:55:49PM +0000, Liu, Jinsong wrote:
> Konrad Rzeszutek Wilk wrote:
> > On Mon, Apr 16, 2012 at 01:07:35AM +0000, Liu, Jinsong wrote:
> >>> From 76e40a60878ff72986fd8d92611400195ae0f997 Mon Sep 17 00:00:00
> >>> 2001 
> >> From: Liu, Jinsong <jinsong.liu@intel.com>
> >> Date: Mon, 16 Apr 2012 00:16:58 +0800
> >> Subject: [PATCH 2/2] Register native mce handler as vMCE bounce back
> >> point 
> >> 
> >> When xen hyeprvisor inject vMCE to guest, use native mce handler to
> >> handle it 
> > 
> > hypervisor
> > 
> >> 
> >> Signed-off-by: Liu, Jinsong <jinsong.liu@intel.com>
> >> Signed-off-by: Ke, Liping <liping.ke@intel.com>
> >> Signed-off-by: Jiang, Yunhong <yunhong.jiang@intel.com>
> >> Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
> >>  --- arch/x86/xen/enlighten.c |   10 +++++++---
> >>  1 files changed, 7 insertions(+), 3 deletions(-)
> >> 
> >> diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
> >> index 15628d4..346ba64 100644
> >> --- a/arch/x86/xen/enlighten.c
> >> +++ b/arch/x86/xen/enlighten.c
> >> @@ -614,8 +614,8 @@ static int cvt_gate_to_trap(int vector, const
> >> gate_desc *val,  	/* 
> >>  	 * Look for known traps using IST, and substitute them
> >>  	 * appropriately.  The debugger ones are the only ones we care
> >> -	 * about.  Xen will handle faults like double_fault and
> >> -	 * machine_check, so we should never see them.  Warn if
> >> +	 * about.  Xen will handle faults like double_fault,
> >> +	 * so we should never see them.  Warn if
> >>  	 * there's an unexpected IST-using fault handler.  	 */
> >>  	if (addr == (unsigned long)debug)
> >> @@ -630,7 +630,11 @@ static int cvt_gate_to_trap(int vector, const
> >>  gate_desc *val,  		return 0; #ifdef CONFIG_X86_MCE
> >>  	} else if (addr == (unsigned long)machine_check) { -		return 0;
> >> +		/*
> >> +		 * when xen hyeprvisor inject vMCE to guest,
> >> +		 * use native mce handler to handle it
> >> +		 */
> >> +		;
> > 
> > 
> > Can you just take the check out?
> 
> What do you mean by 'check out'? remove
> else if (addr == (unsigned long) machine_check) {
> 	;
> }
> ?
> 
> That would fail to register mce bounce back point.

Right, b/c right after we hit this check:
  /* Some other trap using IST? */
 639                 if (WARN_ON(val->ist != 0))
 640                         return 0;
 641         }

.. And the val->ist is not set for MCEs right?

> 
> > 
> > 
> >>  #endif
> >>  	} else {
> >>  		/* Some other trap using IST? */
> >> --
> >> 1.7.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
