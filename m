Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932341Ab1EFKzw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 May 2011 06:55:52 -0400
Received: from mo-p00-ob.rzone.de ([81.169.146.160]:48077 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932245Ab1EFKzu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 May 2011 06:55:50 -0400
X-RZG-AUTH: :P2EQZWCpfu+qG7CngxMFH1J+zrwiavkK6tmQaLfmwtM48/lk2s7oFj0=
X-RZG-CLASS-ID: mo00
Date: Fri, 6 May 2011 12:55:46 +0200
From: Olaf Hering <olaf@aepfle.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, kexec@lists.infradead.org
Subject: Re: [PATCH] add hook to read_from_oldmem() to check for non-ram pages
Message-ID: <20110506105545.GA16945@aepfle.de>
References: <20110407095646.GA30788@aepfle.de>
 <20110503190806.GA12485@aepfle.de>
 <20110505142551.b4d2d95a.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20110505142551.b4d2d95a.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 05, Andrew Morton wrote:

> On Tue, 3 May 2011 21:08:06 +0200
> Olaf Hering <olaf@aepfle.de> wrote:

> > This will reduce the time to read /proc/vmcore.  Without this change a
> > 512M guest with 128M crashkernel region needs 200 seconds to read it,
> > with this change it takes just 2 seconds.
> 
> Seems reasonable, I suppose.

Andrew,
Thanks for your feedback.

> Is there some suitable ifdef we can put around this stuff to avoid
> adding it to kernel builds which will never use it?

The change is for pv-on-hvm guests. In this setup the (out-of-tree)
paravirtualized drivers shutdown the emulated hardware, then they
communicate directly with the backend.
There is no ifdef right now.  I guess at some point, when xen is fully
merged, this hook can be put into some CONFIG_XEN_PV_ON_HVM thing.

> > +void register_oldmem_pfn_is_ram(int (*fn)(unsigned long))
> > +{
> > +	if (oldmem_pfn_is_ram == NULL)
> > +		oldmem_pfn_is_ram = fn;
> > +}
> 
> This is racy, and it should return a success code.  And we may as well
> mark it __must_check to prevent people from cheating.

I will update that part.

> > +void unregister_oldmem_pfn_is_ram(void)
> > +{
> > +	wait_event(oldmem_fn_waitq, atomic_read(&oldmem_fn_refcount) == 0);
> > +	oldmem_pfn_is_ram = NULL;
> > +	wmb();
> > +}
> 
> I'd say we should do away with the (also racy) refcount thing. 
> Instead, require that callers not be using the thing when they
> unregister.  ie: that callers not be buggy.

I think oldmem_pfn_is_ram can be cleared unconditionally, the NULL check
in pfn_is_ram() below will prevent a crash.
This whole refcount thing is to prevent a module unload while
pfn_is_ram() is calling the hook, in other words the called code should
not go away until the hook returns to pfn_is_ram().
Should the called code increase/decrease the modules refcount instead?
I remember there was some MODULE_INC/MODULE_DEC macro (cant remember the
exact name) at some point. What needs to be done inside the module to
prevent an unload while its still in use? Is it __module_get/module_put
for each call of fn()? 

The called function which will go into the xen source at some point
looks like shown below. HVMOP_get_mem_type was just merged into xen-unstable.

xen-unstable.hg/unmodified_drivers/linux-2.6/platform-pci/platform-pci.c

#ifdef HAVE_OLDMEM_PFN_IS_RAM
static int xen_oldmem_pfn_is_ram(unsigned long pfn)
{
	struct xen_hvm_get_mem_type a;
	int ret;

	a.domid = DOMID_SELF;
	a.pfn = pfn;
	if (HYPERVISOR_hvm_op(HVMOP_get_mem_type, &a))
		return -ENXIO;

	switch (a.mem_type) {
		case HVMMEM_mmio_dm:
			ret = 0;
			break;
		case HVMMEM_ram_rw:
		case HVMMEM_ram_ro:
		default:
			ret = 1;
			break;
	}

	return ret;
}
#endif

static int __devinit platform_pci_init(...)
{
        /* other init stuff */
#ifdef HAVE_OLDMEM_PFN_IS_RAM
        register_oldmem_pfn_is_ram(&xen_oldmem_pfn_is_ram);
#endif
        /* other init stuff */
}


Also, this xen driver has no module_exit. So for xen the unregister is
not an issue. I havent looked at the to-be-merged pv-on-hvm drivers,
maybe they can be properly unloaded.

> > +static int pfn_is_ram(unsigned long pfn)
> > +{
> > +	int (*fn)(unsigned long);
> > +	/* pfn is ram unless fn() checks pagetype */
> > +	int ret = 1;
> > +
> > +	atomic_inc(&oldmem_fn_refcount);
> > +	smp_mb__after_atomic_inc();
> > +	fn = oldmem_pfn_is_ram;
> > +	if (fn)
> > +		ret = fn(pfn);
> > +	if (atomic_dec_and_test(&oldmem_fn_refcount))
> > +		wake_up(&oldmem_fn_waitq);
> > +
> > +	return ret;
> > +}
> 
> This function would have been a suitable place at which to document the
> entire feature.  As it stands, anyone who is reading this code won't
> have any clue why it exists.

I will add a comment.

> > +EXPORT_SYMBOL_GPL(register_oldmem_pfn_is_ram);
> > +EXPORT_SYMBOL_GPL(unregister_oldmem_pfn_is_ram);
> 
> Each export should be placed immediately after the function which is
> being exported, please.  Checkpatch reports this.  Please use checkpatch.

Will do.

> > +++ linux-2.6.39-rc5/include/linux/crash_dump.h
> > @@ -66,6 +66,11 @@ static inline void vmcore_unusable(void)
> >  	if (is_kdump_kernel())
> >  		elfcorehdr_addr = ELFCORE_ADDR_ERR;
> >  }
> > +
> > +#define HAVE_OLDMEM_PFN_IS_RAM 1
> 
> What's this for?

So that out-of-tree drivers dont fail to compile when they call that
hook unconditionally. Perhaps they could use the kernel version.

Olaf
