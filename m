Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751724Ab2JOI6V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 04:58:21 -0400
Received: from smtp.eu.citrix.com ([62.200.22.115]:11866 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751413Ab2JOI6U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 04:58:20 -0400
X-IronPort-AV: E=Sophos;i="4.80,587,1344211200"; 
   d="scan'208";a="15163228"
Message-ID: <1350291497.18058.5.camel@zakaz.uk.xensource.com>
Subject: Re: [Xen-devel] [PATCH V2 2/7]: PVH: use native irq, enable
 callback, use HVM ring ops, ...
From: Ian Campbell <Ian.Campbell@citrix.com>
To: Mukesh Rathor <mukesh.rathor@oracle.com>
CC: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "Xen-devel@lists.xensource.com" <Xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Mon, 15 Oct 2012 09:58:17 +0100
In-Reply-To: <20121012120619.6d8f3317@mantra.us.oracle.com>
References: <20121011145711.0d9c27df@mantra.us.oracle.com>
	 <1350031937.14806.49.camel@zakaz.uk.xensource.com>
	 <20121012120619.6d8f3317@mantra.us.oracle.com>
Organization: Citrix Systems, Inc.
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.3-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-10-12 at 20:06 +0100, Mukesh Rathor wrote:
> On Fri, 12 Oct 2012 09:52:17 +0100
> Ian Campbell <Ian.Campbell@citrix.com> wrote:
> 
> > >  drivers/xen/cpu_hotplug.c            |    4 +++-
> > >  drivers/xen/events.c                 |    9 ++++++++-
> > >  drivers/xen/xenbus/xenbus_client.c   |    3 ++-
> > >  7 files changed, 27 insertions(+), 8 deletions(-)
> > > 
> > > diff --git a/arch/x86/include/asm/xen/interface.h
> > > b/arch/x86/include/asm/xen/interface.h index 555f94d..f11edb0 100644
> > > --- a/arch/x86/include/asm/xen/interface.h
> > > +++ b/arch/x86/include/asm/xen/interface.h
> > > @@ -143,7 +143,13 @@ struct vcpu_guest_context {
> > >      struct cpu_user_regs user_regs;         /* User-level CPU
> > > registers     */ struct trap_info trap_ctxt[256];        /* Virtual
> > > IDT                  */ unsigned long ldt_base, ldt_ents;       /*
> > > LDT (linear address, # ents) */
> > > -    unsigned long gdt_frames[16], gdt_ents; /* GDT (machine
> > > frames, # ents) */
> > > +    union {
> > > +	struct {
> > > +		/* PV: GDT (machine frames, # ents).*/
> > > +		unsigned long gdt_frames[16], gdt_ents;
> > > +	} s;
> > > +	unsigned long gdtaddr, gdtsz;	    /* PVH: GDTR addr
> > > and size */
> > 
> > I've pointed out a few times that I think this is wrong -- gdtaddr and
> > gdtsz will overlap each other in the union. I'm not sure how it even
> > works, unless the hypervisor is ignoring one or the other. You need:
> > 
> > union {
> > 	struct {
> > 		unsigned long gdt_frames[16], gdt_ents;
> > 	} pv;
> > 	struct {
> > 		unsigned long gdtaddr, gdtsz;
> > 	} pvh;
> > } gdt;
> > 
> > (I've gone with naming the union gdt instead of u. You might want
> > therefore to also drop the gdt prefix from the members?)
> 
> Is it worth it, I mean, making it a union. Would you be OK if I just
> used gdt_frames[0] and gdt_ends for gdtaddr and size?

What's the problem with making it a union? Seems like you are 80% of the
way there.

Why is this different between PV and PVH in the first place (at the API
level I mean, obviously the handling in the h/v will differ)?

At the very least gdtsz and gdt_ents are the same thing with different
units AFAICT and so can be combined.

How come you don't need the same stuff for ldt*?

Ian.


