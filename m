Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752696Ab0ESOQT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 10:16:19 -0400
Received: from smtp.citrix.com ([66.165.176.89]:53352 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752175Ab0ESOQS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 10:16:18 -0400
X-IronPort-AV: E=Sophos;i="4.53,263,1272859200"; 
   d="scan'208";a="8591094"
Date: Wed, 19 May 2010 15:19:38 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball-desktop
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
       Don Dutile <ddutile@redhat.com>, Sheng Yang <sheng@linux.intel.com>
Subject: Re: [PATCH 08/12] Allow xen platform pci device to be compiled as
 a module
In-Reply-To: <4BF2D941.5070401@goop.org>
Message-ID: <alpine.DEB.2.00.1005191519040.11380@kaball-desktop>
References: <alpine.DEB.2.00.1005181054260.11380@kaball-desktop> <1274178187-20602-8-git-send-email-stefano.stabellini@eu.citrix.com> <4BF2D941.5070401@goop.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 May 2010, Jeremy Fitzhardinge wrote:
> > diff --git a/drivers/xen/grant-table.c b/drivers/xen/grant-table.c
> > index 6f5f3ba..f936d30 100644
> > --- a/drivers/xen/grant-table.c
> > +++ b/drivers/xen/grant-table.c
> > @@ -56,6 +56,9 @@
> >  #define GNTTAB_LIST_END 0xffffffff
> >  #define GREFS_PER_GRANT_FRAME (PAGE_SIZE / sizeof(struct grant_entry))
> >  
> > +unsigned long (*alloc_xen_mmio_hook)(unsigned long len);
> > +EXPORT_SYMBOL_GPL(alloc_xen_mmio_hook);
> > +
> >  static grant_ref_t **gnttab_list;
> >  static unsigned int nr_grant_frames;
> >  static unsigned int boot_max_nr_grant_frames;
> > @@ -514,7 +517,7 @@ int gnttab_resume(void)
> >  		return gnttab_map(0, nr_grant_frames - 1);
> >  
> >  	if (!hvm_pv_resume_frames) {
> > -		hvm_pv_resume_frames = alloc_xen_mmio(PAGE_SIZE * max_nr_gframes);
> > +		hvm_pv_resume_frames = alloc_xen_mmio_hook(PAGE_SIZE * max_nr_gframes);
> >   
> 
> This looks like it should be restructured so the pci device driver
> itself is doing this mapping, then calling into the grant subsystem to
> tell it where the mapping is.
> 

OK


> >  		shared = ioremap(hvm_pv_resume_frames, PAGE_SIZE * max_nr_gframes);
> >  		if (shared == NULL) {
> >  			printk(KERN_WARNING
> > @@ -600,6 +603,7 @@ int gnttab_init(void)
> >  	kfree(gnttab_list);
> >  	return -ENOMEM;
> >  }
> > +EXPORT_SYMBOL_GPL(gnttab_init);
> >  
> >  static int __devinit __gnttab_init(void)
> >  {
> > diff --git a/drivers/xen/manage.c b/drivers/xen/manage.c
> > index a73edd8..49ee52d 100644
> > --- a/drivers/xen/manage.c
> > +++ b/drivers/xen/manage.c
> > @@ -34,6 +34,13 @@ enum shutdown_state {
> >  	 SHUTDOWN_HALT = 4,
> >  };
> >  
> > +void (*platform_pci_resume_hook)(void);
> > +EXPORT_SYMBOL_GPL(platform_pci_resume_hook);
> > +void (*platform_pci_disable_irq_hook)(void);
> > +EXPORT_SYMBOL_GPL(platform_pci_disable_irq_hook);
> > +void (*platform_pci_enable_irq_hook)(void);
> > +EXPORT_SYMBOL_GPL(platform_pci_enable_irq_hook);
> >   
> 
> If all this _hook stuff is here to support a modular xen platform pci
> device, then something has gone wrong.  The device should be doing this
> via its own suspend/resume handlers.
> 

I'll give it another try.


