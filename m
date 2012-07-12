Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934195Ab2GLRu7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 13:50:59 -0400
Received: from smtp.eu.citrix.com ([62.200.22.115]:20796 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932781Ab2GLRu4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 13:50:56 -0400
X-IronPort-AV: E=Sophos;i="4.77,575,1336348800"; 
   d="scan'208";a="13508760"
Date: Thu, 12 Jul 2012 18:50:16 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: David Vrabel <david.vrabel@citrix.com>
CC: Roger Pau Monne <roger.pau@citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Ian Campbell <Ian.Campbell@citrix.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "Tim (Xen.org)" <tim@xen.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>
Subject: Re: [Xen-devel] [PATCH WIP 2/6] xen/arm: Introduce xen_guest_init
In-Reply-To: <4FFEBD42.80001@citrix.com>
Message-ID: <alpine.DEB.2.02.1207121845420.23783@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1206221644370.27860@kaball.uk.xensource.com> <1340381685-22529-1-git-send-email-stefano.stabellini@eu.citrix.com> <1340381685-22529-2-git-send-email-stefano.stabellini@eu.citrix.com> <20120709144505.GD12102@phenom.dumpdata.com>
 <4FFAF3E3.7070306@citrix.com> <4FFEB9B4.2040307@citrix.com> <4FFEBD42.80001@citrix.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Jul 2012, David Vrabel wrote:
> On 12/07/12 12:49, Roger Pau Monne wrote:
> > David Vrabel wrote:
> >> On 09/07/12 15:45, Konrad Rzeszutek Wilk wrote:
> >>> On Fri, Jun 22, 2012 at 05:14:41PM +0100, Stefano Stabellini wrote:
> >>>> We used to rely on a core_initcall to initialize Xen on ARM, however
> >>>> core_initcalls are actually called after early consoles are initialized.
> >>>> That means that hvc_xen.c is going to be initialized before Xen.
> >>>>
> >>>> Given the lack of a better alternative, just call a new Xen
> >>>> initialization function (xen_guest_init) from xen_cons_init.
> >>>>
> >>>> xen_guest_init has to be arch independant, so write both an ARM and an
> >>>> x86 implementation. The x86 implementation is currently empty because we
> >>>> can be sure that xen_hvm_guest_init is called early enough.
> >>>>
> >>>> Probably we can get rid of this as soon as we have better DT support.
> >>> What is DT?
> >>
> >> Device Tree.  It's a binary describing the hardware and some system
> >> configuration that is passed to the kernel by the boot loader or (in
> >> this case) the hypervisor.  Vaguely analogous to ACPI except it's not
> >> crazy ;).
> >>
> >> We really should get the device tree bindings sorted out before
> >> accepting any kernel side patches.  I think we can do this even if Xen's
> >> device tree support is incomplete.
> > 
> > Will this be passed from the hypervisor to the linux kernel using a
> > specific mechanism (different than the native one)?
> 
> The same mechanism.  The kernel is booted with the physical address of
> the device tree blob in a register (r2 I think) .  Xen sorts this out
> for dom0 and the toolstack is responsible for this for domUs.
> 
> I would expect the device tree to include the physical address of the
> shared page with something like this.
> 
> hypervisor {
>    xen {
>        shared-info = <0x00 0x12345678 0 4096>;
>    };
> };
> 
> Arch code in ARM would check for the hypervisor node (very) early on and
> call a hypervisor specific init function based on the name of the child
> node (xen in this case).
 
There is no need to specify the shared-info page address in the DT as we
already have a mechanism to map it dynamically (XENMAPSPACE_shared_info).

However we could use DT to pass the address of the grant table pages
instead of introducing HVM_PARAM_GRANT_START_PFN (see
http://marc.info/?l=linux-kernel&m=134140077708602&w=2).
