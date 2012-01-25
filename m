Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751470Ab2AYWeE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jan 2012 17:34:04 -0500
Received: from smtp.eu.citrix.com ([62.200.22.115]:15161 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750772Ab2AYWeC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jan 2012 17:34:02 -0500
X-IronPort-AV: E=Sophos;i="4.71,570,1320624000"; 
   d="scan'208";a="10292513"
Message-ID: <1327530840.856.9.camel@dagon.hellion.org.uk>
Subject: Re: [Xen-devel] Regressions in v3.3-rc1 introduced by
 "xen/granttable: Grant tables V2 implementation"
From: Ian Campbell <Ian.Campbell@citrix.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Paul Durrant <Paul.Durrant@citrix.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "ANNIE LI (annie.li@oracle.com)" <annie.li@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Wed, 25 Jan 2012 22:34:00 +0000
In-Reply-To: <20120125205043.GB21284@phenom.dumpdata.com>
References: <20120125044949.GB29759@phenom.dumpdata.com>
	 <20120125051253.GA15501@phenom.dumpdata.com>
	 <1327485333.24561.232.camel@zakaz.uk.xensource.com>
	 <291EDFCB1E9E224A99088639C4762022C80E2F0F23@LONPMAILBOX01.citrite.net>
	 <20120125205043.GB21284@phenom.dumpdata.com>
Organization: Citrix Systems, Inc.
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-01-25 at 20:50 +0000, Konrad Rzeszutek Wilk wrote:
> On Wed, Jan 25, 2012 at 03:23:28PM +0000, Paul Durrant wrote:
> > > -----Original Message-----
> > > From: Paul Durrant
> > > Sent: 25 January 2012 07:17
> > > To: Ian Campbell; Konrad Rzeszutek Wilk
> > > Cc: annie.li@oracle.com; xen-devel@lists.xensource.com; linux-
> > > kernel@vger.kernel.org
> > > Subject: RE: [Xen-devel] Regressions in v3.3-rc1 introduced by
> > > "xen/granttable: Grant tables V2 implementation"
> > > 
> > > > -----Original Message-----
> > > >
> > > > On HVM for gnttab_shared we make an add_to_physmap call with
> > > > XENMAPSPACE_grant_table (in gnttab_map). I don't see any support call
> > > > to do something similar for the status array though and I don't see a
> > > > XENMAPSPACE_* specifically for that case either in the hypervisor either.
> > > >
> > > 
> > > There is no map-space for the status pages. To map them you use the
> > > standard map space but OR a bit (top bit IIRC) into in the idx. It's a bit icky,
> > > but that's how it is.
> > > 
> > 
> > I fixed a bug in xen-unstable a few weeks back that prevented
> mapping of the status frames so I guess the bug is possibly due to
> trying to use gnttab 2 on 4.1, where this bug would hit, but failing
> to check the return code from the status mapping hypercall?
> 
> changeset:   24428:5b4b7e565ab8
> user:        Paul Durrant <paul.durrant@citrix.com>
> date:        Sun Dec 18 14:39:14 2011 +0000
> summary:     Fix grant_table v2 status mapping.
> 
> changeset:   24427:931bf1105730
> user:        Paul Durrant <paul.durrant@citrix.com>
> date:        Sun Dec 18 14:38:32 2011 +0000
> summary:     Allow VMs to query their own grant table version.
> 
> 
> Looks like c/s 24427 needs to be in the hypervior. Hm, but that exists
> in 4.1 too as 23204. Will try back-porting cs 24428 in Xen 4.1 and seeing
> if that does it.

I think this bug is a red herring -- the current code in Linux will
never get anywhere near triggering it because it never even tries to map
the status pages into the p2m.

IOW the call to XENMEM_add_to_physmap in
drivers/xen/grant-table.c:gnttab_map() needs to be done for the status
pages too or there is no chance of v2 grant tables working for HVM
guests.

I think the best bet is to disable v2 for HVM guests for now (something
like your second patch) and implement it for 3.4.

Ian.


