Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755926Ab2JVScG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 14:32:06 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:26183 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751811Ab2JVScF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 14:32:05 -0400
Date: Mon, 22 Oct 2012 11:31:54 -0700
From: Mukesh Rathor <mukesh.rathor@oracle.com>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        Ian Campbell <Ian.Campbell@citrix.com>
Subject: Re: [PATCH 2/6] xen/pvh: Extend vcpu_guest_context, p2m, event, and
 xenbus to support PVH.
Message-ID: <20121022113154.0e28ff1d@mantra.us.oracle.com>
In-Reply-To: <alpine.DEB.2.02.1210221439530.2689@kaball.uk.xensource.com>
References: <1350695882-12820-1-git-send-email-konrad.wilk@oracle.com>
	<1350695882-12820-3-git-send-email-konrad.wilk@oracle.com>
	<alpine.DEB.2.02.1210221439530.2689@kaball.uk.xensource.com>
Organization: Oracle Corporation
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Oct 2012 14:44:40 +0100
Stefano Stabellini <stefano.stabellini@eu.citrix.com> wrote:

> On Sat, 20 Oct 2012, Konrad Rzeszutek Wilk wrote:
> > From: Mukesh Rathor <mukesh.rathor@oracle.com>
> > 
> > make gdt_frames[]/gdt_ents into a union with {gdtaddr, gdtsz}, as
> > PVH only needs to send down gdtaddr and gdtsz.
> > 
> > For interrupts, PVH uses native_irq_ops.
> > vcpu hotplug is currently not available for PVH.
> > 
> > For events we follow what PVHVM does - to use callback vector.
> > Lastly, also use HVM path to setup XenBus.
> > 
> > Signed-off-by: Mukesh Rathor <mukesh.rathor@oracle.com>
> > Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> > ---
> >  		return true;
> >  	}
> > -	xen_copy_trap_info(ctxt->trap_ctxt);
> > +	/* check for autoxlated to get it right for 32bit kernel */
> 
> I am not sure what this comment means, considering that in another
> comment below you say that we don't support 32bit PVH kernels.

Function is common to both 32bit and 64bit kernels. We need to check 
for auto xlated also in the if statement in addition to supervisor 
mode kernel, so 32 bit doesn't go down the wrong path.

PVH is not supported for 32bit kernels, and gs_base_user doesn't exist
in the structure for 32bit so it needs to be if'def'd 64bit which is
ok because PVH is not supprted on 32bit kernel.

> > +					(unsigned
> > long)xen_hypervisor_callback;
> > +		ctxt->failsafe_callback_eip =
> > +					(unsigned
> > long)xen_failsafe_callback;
> > +	}
> > +	ctxt->user_regs.cs = __KERNEL_CS;
> > +	ctxt->user_regs.esp = idle->thread.sp0 - sizeof(struct
> > pt_regs); 
> >  	per_cpu(xen_cr3, cpu) = __pa(swapper_pg_dir);
> >  	ctxt->ctrlreg[3] =
> > xen_pfn_to_cr3(virt_to_mfn(swapper_pg_dir));
> 
> The tradional path looks the same as before, however it is hard to
> tell whether the PVH path is correct without the Xen side. For
> example, what is gdtsz?

gdtsz is GUEST_GDTR_LIMIT and gdtaddr is GUEST_GDTR_BASE in the vmcs.

thanks,
Mukesh
