Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755213Ab2JCQlg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 12:41:36 -0400
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:19963 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755020Ab2JCQlf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 12:41:35 -0400
X-IronPort-AV: E=Sophos;i="4.80,528,1344211200"; 
   d="scan'208";a="14921334"
Message-ID: <1349282492.650.185.camel@zakaz.uk.xensource.com>
Subject: Re: [Xen-devel] [PATCH] xen: point xen_start_info to a dummy struct
 for PV on HVM guests
From: Ian Campbell <Ian.Campbell@citrix.com>
To: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>
CC: "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Konrad Rzeszutek Wilk" <konrad.wilk@oracle.com>
Date: Wed, 3 Oct 2012 17:41:32 +0100
In-Reply-To: <1349280814.650.178.camel@zakaz.uk.xensource.com>
References: <alpine.DEB.2.02.1210031431080.29232@kaball.uk.xensource.com>
	 <1349272182.650.150.camel@zakaz.uk.xensource.com>
	 <alpine.DEB.2.02.1210031450220.29232@kaball.uk.xensource.com>
	 <1349272482.650.151.camel@zakaz.uk.xensource.com>
	 <20121003141116.GA10633@phenom.dumpdata.com>
	 <1349276431.650.156.camel@zakaz.uk.xensource.com>
	 <alpine.DEB.2.02.1210031641050.29232@kaball.uk.xensource.com>
	 <1349279862.650.171.camel@zakaz.uk.xensource.com>
	 <alpine.DEB.2.02.1210031658120.29232@kaball.uk.xensource.com>
	 <1349280814.650.178.camel@zakaz.uk.xensource.com>
Organization: Citrix Systems, Inc.
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.3-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-10-03 at 17:13 +0100, Ian Campbell wrote:
> On Wed, 2012-10-03 at 17:05 +0100, Stefano Stabellini wrote:
> > On Wed, 3 Oct 2012, Ian Campbell wrote:
> > > On Wed, 2012-10-03 at 16:48 +0100, Stefano Stabellini wrote:
> > > > On Wed, 3 Oct 2012, Ian Campbell wrote:
> > > > > On Wed, 2012-10-03 at 15:11 +0100, Konrad Rzeszutek Wilk wrote:
> > > > > > On Wed, Oct 03, 2012 at 02:54:42PM +0100, Ian Campbell wrote:
> > > > > > > On Wed, 2012-10-03 at 14:51 +0100, Stefano Stabellini wrote:
> > > > > > > > On Wed, 3 Oct 2012, Ian Campbell wrote:
> > > > > > > > > On Wed, 2012-10-03 at 14:37 +0100, Stefano Stabellini wrote:
> > > > > > > > > > PV on HVM guests don't have a start_info page mapped by Xen, so
> > > > > > > > > > xen_start_info is just NULL for them.
> > > > > > > > > > That is problem because other parts of the code expect xen_start_info to
> > > > > > > > > > point to something valid, for example xen_initial_domain() is defined as
> > > > > > > > > > follow:
> > > > > > > > > > 
> > > > > > > > > > #define xen_initial_domain()    (xen_domain() && \
> > > > > > > > > >                  xen_start_info->flags & SIF_INITDOMAIN)
> > > > > > > > > 
> > > > > > > > > But anyone who calls this before xen_start_info is setup is going to get
> > > > > > > > > a bogus result, specifically in this case they will think they are domU
> > > > > > > > > when in reality they are dom0 -- wouldn't it be better to fix those
> > > > > > > > > callsites?
> > > > > > > > 
> > > > > > > > That cannot be the case because setting up xen_start_info is the very
> > > > > > > > first thing that is done, before even calling to C.
> > > > > > > 
> > > > > > > On PV, yes, but you are trying to fix PVHVM here, no?
> > > > > > > 
> > > > > > > Otherwise if this is always set before calling into C then what is the
> > > > > > > purpose of this patch?
> > > > > > 
> > > > > > to fix this - as PVHVM has it set to NULL and we end up de-referencing
> > > > > > the xen_start_info and crashing. As so::
> > > > > > 
> > > > > 
> > > > > Right, so returning to my original point: The caller here is calling
> > > > > xen_initial_domain() *before* start info is setup. This is bogus and is
> > > > > your actual bug, all this patch does is hide that real issue.
> > > > 
> > > > That is because xen_start_info wasn't setup at all for PV on HVM guests.
> > > > 
> > > > The real reason is that PV on HVM guests don't have one, but that is
> > > > another matter. Until we get rid of all the references to xen_start_info
> > > > outside of PV specific code, we should just assume that there is one,
> > > > and that is already setup.
> > > > 
> > > > One day not too far from now, we might refactor the code to never
> > > > reference xen_start_info directly, but I don't think that now is the
> > > > time for that. Also consider that this is the same thing we do on ARM.
> > > 
> > > We actual fill in the dummy start info with valid information on ARM
> > > though, we don't just leave it full of zeroes.
> > > 
> > > If we do start out with start_info pointing to an uninitialised
> > > start_info on ARM too then I would argue that this is also a mistake.
> > 
> > Yes, we do point xen_start_info to an uninitialised start_info on ARM
> > too (I don't think is a mistake). Then when and if we have more
> > information we write them to start_info.
> 
> So callers of xen_initial_domain in dom0 before xen_guest_init is called
> get the wrong result?
> 
> That sounds like a mistake to me.

How about (modulo my not having looked up the actual names of the
constants etc):

	#define xen_initial_domain() (xen_domain() && arch_is_initial_domain())

on x86:
	int arch_is_initial_domain(void)
	{
		/* The initial domain is always PV and
		 * therefore start_info is always set for it.
		 */
		return start_info && start_info->flags & SIF_INITDOMAIN;
	}
on ARM:
	int arch_is_initial_domain(void)
	{
		static is_initial = -1;
		if (is_initial == -1)
			is_initial = HVM_param_get(HVMPARAM_DOM0)
		return is_initial;
	}


