Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754257Ab2JLTG1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 15:06:27 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:27985 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752493Ab2JLTGZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 15:06:25 -0400
Date: Fri, 12 Oct 2012 12:06:19 -0700
From: Mukesh Rathor <mukesh.rathor@oracle.com>
To: Ian Campbell <Ian.Campbell@citrix.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "Xen-devel@lists.xensource.com" <Xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH V2 2/7]: PVH: use native irq, enable
 callback, use HVM ring ops, ...
Message-ID: <20121012120619.6d8f3317@mantra.us.oracle.com>
In-Reply-To: <1350031937.14806.49.camel@zakaz.uk.xensource.com>
References: <20121011145711.0d9c27df@mantra.us.oracle.com>
	<1350031937.14806.49.camel@zakaz.uk.xensource.com>
Organization: Oracle Corporation
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 12 Oct 2012 09:52:17 +0100
Ian Campbell <Ian.Campbell@citrix.com> wrote:

> >  drivers/xen/cpu_hotplug.c            |    4 +++-
> >  drivers/xen/events.c                 |    9 ++++++++-
> >  drivers/xen/xenbus/xenbus_client.c   |    3 ++-
> >  7 files changed, 27 insertions(+), 8 deletions(-)
> > 
> > diff --git a/arch/x86/include/asm/xen/interface.h
> > b/arch/x86/include/asm/xen/interface.h index 555f94d..f11edb0 100644
> > --- a/arch/x86/include/asm/xen/interface.h
> > +++ b/arch/x86/include/asm/xen/interface.h
> > @@ -143,7 +143,13 @@ struct vcpu_guest_context {
> >      struct cpu_user_regs user_regs;         /* User-level CPU
> > registers     */ struct trap_info trap_ctxt[256];        /* Virtual
> > IDT                  */ unsigned long ldt_base, ldt_ents;       /*
> > LDT (linear address, # ents) */
> > -    unsigned long gdt_frames[16], gdt_ents; /* GDT (machine
> > frames, # ents) */
> > +    union {
> > +	struct {
> > +		/* PV: GDT (machine frames, # ents).*/
> > +		unsigned long gdt_frames[16], gdt_ents;
> > +	} s;
> > +	unsigned long gdtaddr, gdtsz;	    /* PVH: GDTR addr
> > and size */
> 
> I've pointed out a few times that I think this is wrong -- gdtaddr and
> gdtsz will overlap each other in the union. I'm not sure how it even
> works, unless the hypervisor is ignoring one or the other. You need:
> 
> union {
> 	struct {
> 		unsigned long gdt_frames[16], gdt_ents;
> 	} pv;
> 	struct {
> 		unsigned long gdtaddr, gdtsz;
> 	} pvh;
> } gdt;
> 
> (I've gone with naming the union gdt instead of u. You might want
> therefore to also drop the gdt prefix from the members?)

Is it worth it, I mean, making it a union. Would you be OK if I just
used gdt_frames[0] and gdt_ends for gdtaddr and size?

thanks
Mukesh


