Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751518Ab2JANki (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 09:40:38 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:43571 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751367Ab2JANkh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 09:40:37 -0400
Date: Mon, 1 Oct 2012 15:40:21 +0200
From: Daniel Kiper <daniel.kiper@oracle.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: andrew.cooper3@citrix.com, jbeulich@suse.com, linux-kernel@vger.kernel.org,
        xen-devel@lists.xensource.com
Subject: Re: [PATCH 01/11] kexec: introduce kexec_ops struct
Message-ID: <20121001134021.GH2942@host-192-168-1-59.local.net-space.pl>
References: <1348769198-29580-1-git-send-email-daniel.kiper@oracle.com>
 <1348769198-29580-2-git-send-email-daniel.kiper@oracle.com>
 <20120928160728.GA16262@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120928160728.GA16262@localhost.localdomain>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 28, 2012 at 12:07:42PM -0400, Konrad Rzeszutek Wilk wrote:
> On Thu, Sep 27, 2012 at 08:06:28PM +0200, Daniel Kiper wrote:
> > Some kexec/kdump implementations (e.g. Xen PVOPS) on different archs could
> > not use default functions or require some changes in behavior of kexec/kdump
> > generic code. To cope with that problem kexec_ops struct was introduced.
> > It allows a developer to replace all or some functions and control some
> > functionality of kexec/kdump generic code.
> >
> > Default behavior of kexec/kdump generic code is not changed.
> >
> > Signed-off-by: Daniel Kiper <daniel.kiper@oracle.com>
> > ---
> >  include/linux/kexec.h |   18 +++++++
> >  kernel/kexec.c        |  125 ++++++++++++++++++++++++++++++++++++-------------
> >  2 files changed, 111 insertions(+), 32 deletions(-)
> >
> > diff --git a/include/linux/kexec.h b/include/linux/kexec.h
> > index 37c5f72..beb08ca 100644
> > --- a/include/linux/kexec.h
> > +++ b/include/linux/kexec.h
> > @@ -165,7 +165,25 @@ struct kimage {
> >  #endif
> >  };
> >
> > +struct kexec_ops {
> > +	bool always_use_normal_alloc;
>
> So most of these are self-explanatory. But the bool is not that clear
> to me. Could you include a documentation comment explaining
> its purpose and its implications?

OK.

> > +	struct page *(*kimage_alloc_pages)(gfp_t gfp_mask,
> > +						unsigned int order,
> > +						unsigned long limit);
> > +	void (*kimage_free_pages)(struct page *page);
> > +	unsigned long (*page_to_pfn)(struct page *page);
> > +	struct page *(*pfn_to_page)(unsigned long pfn);
> > +	unsigned long (*virt_to_phys)(volatile void *address);
> > +	void *(*phys_to_virt)(unsigned long address);
> > +	int (*machine_kexec_prepare)(struct kimage *image);
> > +	int (*machine_kexec_load)(struct kimage *image);
> > +	void (*machine_kexec_cleanup)(struct kimage *image);
> > +	void (*machine_kexec_unload)(struct kimage *image);
> > +	void (*machine_kexec_shutdown)(void);
> > +	void (*machine_kexec)(struct kimage *image);
> > +};
> >
> > +extern struct kexec_ops kexec_ops;
>
> Is this neccessary?

Yes, because it is used by Xen machine_kexec_??.c files.

> >  /* kexec interface functions */
> >  extern void machine_kexec(struct kimage *image);
> > diff --git a/kernel/kexec.c b/kernel/kexec.c
> > index 0668d58..98556f3 100644
> > --- a/kernel/kexec.c
> > +++ b/kernel/kexec.c
> > @@ -56,6 +56,47 @@ struct resource crashk_res = {
> >  	.flags = IORESOURCE_BUSY | IORESOURCE_MEM
> >  };
> >
> > +static struct page *kimage_alloc_pages(gfp_t gfp_mask,
> > +					unsigned int order,
> > +					unsigned long limit);
> > +static void kimage_free_pages(struct page *page);
> > +
> > +static unsigned long generic_page_to_pfn(struct page *page)
> > +{
> > +	return page_to_pfn(page);
> > +}
> > +
> > +static struct page *generic_pfn_to_page(unsigned long pfn)
> > +{
> > +	return pfn_to_page(pfn);
> > +}
> > +
> > +static unsigned long generic_virt_to_phys(volatile void *address)
> > +{
> > +	return virt_to_phys(address);
> > +}
> > +
> > +static void *generic_phys_to_virt(unsigned long address)
> > +{
> > +	return phys_to_virt(address);
> > +}
> > +
> > +struct kexec_ops kexec_ops = {
> > +	.always_use_normal_alloc = false,
> > +	.kimage_alloc_pages = kimage_alloc_pages,
> > +	.kimage_free_pages = kimage_free_pages,
> > +	.page_to_pfn = generic_page_to_pfn,
> > +	.pfn_to_page = generic_pfn_to_page,
> > +	.virt_to_phys = generic_virt_to_phys,
> > +	.phys_to_virt = generic_phys_to_virt,
> > +	.machine_kexec_prepare = machine_kexec_prepare,
> > +	.machine_kexec_load = NULL,
>
> Instead of NULL should they just point to some nop function?

OK.

Daniel
