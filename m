Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754609Ab2KUKxQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2012 05:53:16 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:31262 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754587Ab2KUKxO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2012 05:53:14 -0500
Date: Wed, 21 Nov 2012 11:52:21 +0100
From: Daniel Kiper <daniel.kiper@oracle.com>
To: ebiederm@xmission.com
Cc: andrew.cooper3@citrix.com, hpa@zytor.com, jbeulich@suse.com,
        konrad.wilk@oracle.com, mingo@redhat.com, tglx@linutronix.de,
        x86@kernel.org, kexec@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        xen-devel@lists.xensource.com
Subject: Re: [PATCH v2 01/11] kexec: introduce kexec_ops struct
Message-ID: <20121121105221.GA2925@host-192-168-1-59.local.net-space.pl>
References: <1353423893-23125-1-git-send-email-daniel.kiper@oracle.com>
 <1353423893-23125-2-git-send-email-daniel.kiper@oracle.com>
 <87lidwtego.fsf@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87lidwtego.fsf@xmission.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 20, 2012 at 08:40:39AM -0800, ebiederm@xmission.com wrote:
> Daniel Kiper <daniel.kiper@oracle.com> writes:
>
> > Some kexec/kdump implementations (e.g. Xen PVOPS) could not use default
> > functions or require some changes in behavior of kexec/kdump generic code.
> > To cope with that problem kexec_ops struct was introduced. It allows
> > a developer to replace all or some functions and control some
> > functionality of kexec/kdump generic code.
> >
> > Default behavior of kexec/kdump generic code is not changed.
>
> Ick.
>
> > v2 - suggestions/fixes:
> >    - add comment for kexec_ops.crash_alloc_temp_store member
> >      (suggested by Konrad Rzeszutek Wilk),
> >    - simplify kexec_ops usage
> >      (suggested by Konrad Rzeszutek Wilk).
> >
> > Signed-off-by: Daniel Kiper <daniel.kiper@oracle.com>
> > ---
> >  include/linux/kexec.h |   26 ++++++++++
> >  kernel/kexec.c        |  131 +++++++++++++++++++++++++++++++++++++------------
> >  2 files changed, 125 insertions(+), 32 deletions(-)
> >
> > diff --git a/include/linux/kexec.h b/include/linux/kexec.h
> > index d0b8458..c8d0b35 100644
> > --- a/include/linux/kexec.h
> > +++ b/include/linux/kexec.h
> > @@ -116,7 +116,33 @@ struct kimage {
> >  #endif
> >  };
> >
> > +struct kexec_ops {
> > +	/*
> > +	 * Some kdump implementations (e.g. Xen PVOPS dom0) could not access
> > +	 * directly crash kernel memory area. In this situation they must
> > +	 * allocate memory outside of it and later move contents from temporary
> > +	 * storage to final resting places (usualy done by relocate_kernel()).
> > +	 * Such behavior could be enforced by setting
> > +	 * crash_alloc_temp_store member to true.
> > +	 */
>
> Why in the world would Xen not be able to access crash kernel memory?
> As currently defined it is normal memory that the kernel chooses not to
> use.
>
> If relocate kernel can access that memory you definitely can access the
> memory so the comment does not make any sense.

Crash kernel memory is reserved by Xen hypervisor and Xen hypervisor
only has access to it. dom0 does not have any mapping of this area.
However, relocate_kernel() has access to crash kernel memory
because it is executed by Xen hypervisor and whole machine
memory is identity mapped.

> > +	bool crash_alloc_temp_store;
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
>
> Ugh.  This is a nasty abstraction.
>
> You are mixing and matching a bunch of things together here.
>
> If you need to override machine_kexec_xxx please do that on a per
> architecture basis.

Yes, it is possible but I think that it is worth to do it at that
level because it could be useful for other archs too (e.g. Xen ARM port
is under development). Then we do not need to duplicate that functionality
in arch code. Additionally, Xen requires machine_kexec_load and
machine_kexec_unload hooks which are not available in current generic
kexec/kdump code.

> Special case overrides of page_to_pfn, pfn_to_page, virt_to_phys,
> phys_to_virt, and friends seem completely inappropriate.

They are required in Xen PVOPS case. If we do not do that in that way
then we at least need to duplicate almost all generic kexec/kdump existing
code in arch depended files. I do not mention that we need to capture
relevant syscall and other things. I think that this is wrong way.

> There may be a point to all of these but you are mixing and matching
> things badly.

Do you whish to split this kexec_ops struct to something which
works with addresses and something which is reponsible for
loading, unloading and executing kexec/kdump? I am able to change
that but I would like to know a bit about your vision first.

Daniel
