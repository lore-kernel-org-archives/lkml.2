Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757686Ab2JLIwk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 04:52:40 -0400
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:64284 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751238Ab2JLIwg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 04:52:36 -0400
X-IronPort-AV: E=Sophos;i="4.80,576,1344211200"; 
   d="scan'208";a="15120784"
Message-ID: <1350031937.14806.49.camel@zakaz.uk.xensource.com>
Subject: Re: [Xen-devel] [PATCH V2 2/7]: PVH: use native irq, enable
 callback, use HVM ring ops, ...
From: Ian Campbell <Ian.Campbell@citrix.com>
To: Mukesh Rathor <mukesh.rathor@oracle.com>
CC: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "Xen-devel@lists.xensource.com" <Xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Fri, 12 Oct 2012 09:52:17 +0100
In-Reply-To: <20121011145711.0d9c27df@mantra.us.oracle.com>
References: <20121011145711.0d9c27df@mantra.us.oracle.com>
Organization: Citrix Systems, Inc.
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.3-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-10-11 at 22:57 +0100, Mukesh Rathor wrote:
> PVH: make gdt_frames[]/gdt_ents into a union with {gdtaddr, gdtsz}, PVH
> only needs to send down gdtaddr and gdtsz. irq.c: PVH uses
> native_irq_ops. vcpu hotplug is currently not available for PVH.
> events.c: setup callback vector for PVH. Finally, PVH ring ops uses HVM
> paths for xenbus.
> 
> Signed-off-by: Mukesh R <mukesh.rathor@oracle.com>
> ---
>  arch/x86/include/asm/xen/interface.h |    8 +++++++-
>  arch/x86/xen/irq.c                   |    5 ++++-
>  arch/x86/xen/p2m.c                   |    2 +-
>  arch/x86/xen/smp.c                   |    4 ++--
>  drivers/xen/cpu_hotplug.c            |    4 +++-
>  drivers/xen/events.c                 |    9 ++++++++-
>  drivers/xen/xenbus/xenbus_client.c   |    3 ++-
>  7 files changed, 27 insertions(+), 8 deletions(-)
> 
> diff --git a/arch/x86/include/asm/xen/interface.h b/arch/x86/include/asm/xen/interface.h
> index 555f94d..f11edb0 100644
> --- a/arch/x86/include/asm/xen/interface.h
> +++ b/arch/x86/include/asm/xen/interface.h
> @@ -143,7 +143,13 @@ struct vcpu_guest_context {
>      struct cpu_user_regs user_regs;         /* User-level CPU registers     */
>      struct trap_info trap_ctxt[256];        /* Virtual IDT                  */
>      unsigned long ldt_base, ldt_ents;       /* LDT (linear address, # ents) */
> -    unsigned long gdt_frames[16], gdt_ents; /* GDT (machine frames, # ents) */
> +    union {
> +	struct {
> +		/* PV: GDT (machine frames, # ents).*/
> +		unsigned long gdt_frames[16], gdt_ents;
> +	} s;
> +	unsigned long gdtaddr, gdtsz;	    /* PVH: GDTR addr and size */

I've pointed out a few times that I think this is wrong -- gdtaddr and
gdtsz will overlap each other in the union. I'm not sure how it even
works, unless the hypervisor is ignoring one or the other. You need:

union {
	struct {
		unsigned long gdt_frames[16], gdt_ents;
	} pv;
	struct {
		unsigned long gdtaddr, gdtsz;
	} pvh;
} gdt;

(I've gone with naming the union gdt instead of u. You might want
therefore to also drop the gdt prefix from the members?)

Ian.

