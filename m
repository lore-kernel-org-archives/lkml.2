Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754451Ab1GRJFW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jul 2011 05:05:22 -0400
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:28270 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753552Ab1GRJFV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jul 2011 05:05:21 -0400
X-IronPort-AV: E=Sophos;i="4.67,221,1309737600"; 
   d="scan'208";a="6822191"
Subject: Re: [Xen-devel] [PATCH] xen: update machine_to_phys_order on	
 resume
From: Ian Campbell <Ian.Campbell@eu.citrix.com>
To: Jan Beulich <JBeulich@novell.com>
CC: Keir Fraser <keir.xen@gmail.com>, "olaf@aepfle.de" <olaf@aepfle.de>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "Konrad Rzeszutek Wilk" <konrad.wilk@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "keir@xen.org" <keir@xen.org>
In-Reply-To: <4E240F3D020000780004DD70@nat28.tlf.novell.com>
References: <CA499EDA.1E10E%keir.xen@gmail.com>
	 <1310977905.20648.26.camel@zakaz.uk.xensource.com>
	 <4E240F3D020000780004DD70@nat28.tlf.novell.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Citrix Systems, Inc.
Date: Mon, 18 Jul 2011 10:05:18 +0100
Message-ID: <1310979918.20648.31.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-07-18 at 09:47 +0100, Jan Beulich wrote:
> > @@ -960,6 +962,54 @@
> >      }
> >      break;
> >  
> > +    case XEN_DOMCTL_setfeatures:
> > +    {
> > +        struct domain *d;
> > +        ret = -ESRCH;
> > +        if ( (d = rcu_lock_domain_by_id(op->domain)) != NULL )
> > +        {
> > +            printk("dom%d set features[%d] = %#x\n", d->domain_id, op->u.setfeatures.submap_idx, op->u.setfeatures.submap);
> > +
> > +            switch (op->u.setfeatures.submap_idx) {
> > +            case 0:
> > +                if ( !paging_mode_translate(d) )
> 
> ... this condition looks inverted to me.

Quite possibly. I only ever actually tested this with a dodgy PV in HVM
container implementation.

> > +                {
> > +                    op->u.setfeatures.submap &= ~(1U<<XENFEAT_writable_page_tables);
> > +                    op->u.setfeatures.submap &= ~(1U<<XENFEAT_auto_translated_physmap);
> > +                }
> > +                if ( !is_pvhvm_domain(d) )
> > +                {
> > +                    op->u.setfeatures.submap &= ~(1U<<XENFEAT_supervisor_mode_kernel);
> > +                }
> > +
> > +                op->u.setfeatures.submap &= ~(1U<<XENFEAT_writable_descriptor_tables);
> 
> Why do you turn this off unconditionally?

Unless you build the hypervisor with supervisor_mode_kernel=1 (i.e.
never) then it does not support XENFEAT_writable_descriptor_tables. In
fact XENFEAT_supervisor_mode_kernel should also be unconditionally
cleared (the check is a remnant of the PV in HVM container stuff).

Note that XENFEAT_writable_descriptor_tables means that the guest kernel
should not make pagetable pages RO at all, which is different from the
hypervisor's support for writing to RO pagetables (i.e. emulating
pagetable updates).

> 
> > +
> > +                /* XXX other features */
> 
> That's perhaps also the place holder where the passed in information
> would actually get stored?

Yep ;-)

Ian.

