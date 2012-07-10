Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754199Ab2GJOW7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 10:22:59 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:36825 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752195Ab2GJOW6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 10:22:58 -0400
Date: Tue, 10 Jul 2012 10:14:11 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Olaf Hering <olaf@aepfle.de>
Cc: Jan Beulich <JBeulich@suse.com>, xen-devel@lists.xensource.com,
        kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
        Daniel Kiper <dkiper@net-space.pl>
Subject: Re: [Xen-devel] incorrect layout of globals from head_64.S during
 kexec boot
Message-ID: <20120710141411.GB1791@phenom.dumpdata.com>
References: <20120705210607.GA26908@aepfle.de>
 <20120706084120.GA31219@router-fw-old.local.net-space.pl>
 <20120706120750.GA8970@aepfle.de>
 <4FF6FCA9020000780008E0BB@nat28.tlf.novell.com>
 <20120706133105.GA20600@aepfle.de>
 <20120706141419.GA21951@aepfle.de>
 <4FF7174C020000780008E1FF@nat28.tlf.novell.com>
 <20120706172918.GA15222@aepfle.de>
 <20120710093327.GA13864@aepfle.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120710093327.GA13864@aepfle.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 10, 2012 at 11:33:27AM +0200, Olaf Hering wrote:
> On Fri, Jul 06, Olaf Hering wrote:
> 
> > On Fri, Jul 06, Jan Beulich wrote:
> > 
> > > > Could it be that some code tweaks the stack content used by decompress()
> > > > in some odd way? But that would most likely lead to a crash, not to
> > > > unexpected uncompressing results.
> > > 
> > > Especially if the old and new kernel are using the exact same
> > > image, how about the decompression writing over the shared
> > > info page causing all this? As the decompressor wouldn't
> > > expect Xen to possibly write stuff there itself, it could easily be
> > > that some repeat count gets altered, thus breaking the
> > > decompressed data without the decompression code necessarily
> > > noticing.
> > 
> > In my case the gfn of the shared info page is 1f54.
> > Is it possible to move the page at runtime? It looks like it can be done
> > because the hvm loader configures fffff initially.
> > 
> > Perhaps the PVonHVM code has to give up the shared pages or move them to
> > some dedicated unused page during the process of booting into the new
> > kernel.
> 
> The pfn 1f54 of the shared info page is in the middle of the new bzImage:
> pfn    32080 KiB   <= ok, so the old .bss

> _head  29360 KiB
> _text  33826 KiB
> _end   33924 KiB

So _head is at 1CAC and _text starts at  2108h?
Ugh, and 1F54 gets overriden. And with your patch, the data gets
stuck in between _text and _end? No wait, where would the shared_info
be located in the old kernel? Somewhere below the 1CACh?

I presume 1F54 is the _brk_end for the old kernel as well?

Could you tell me how the decompress code works? Is the new kernel
put at PFN 1000h and the decompressor code is put below it?

And the decompressor code uses the .bss section of the "new" kernel
to do its deed - since it assumes that the carcass of the old kernel
is truly dead and it is not raising a hand saying: "I am not dead yet!".

Which brings me to another question - say we do use this patch, what
if the decompressor overwrites the old kernels .data section. Won't
we run into this problem again?

And what about the new kernel? It will try to register at a new
MFN location the VCPU structure. Is that something that the hypervisor
is OK with? Does that work with more than VCPU? Or is is stuck with
just one VCPU (b/c it couldn't actually do the hypercall?).

Or is the registration OK, since the new kernel has the same layout
so it registers at the same MFN as the "dead" kernel and it works
peachy? What if the kernel version used in the kexec is different
from the old one (say it has less built in things)? That would mean
the .text and .data section are different than the "dead" kernel?

> 
> In other words, the compressed vmlinux.bin gets slightly modified during
> uncompression. For some reason this does not lead to decompression
> errors.

Hm
> 
> In the patch below the pfn is moved from the bss to the data section. As
> a result the new location is now at 28680 KiB, which is outside of the
> bzImage.
> 
> Maybe there is a way to use another dedicated page as shared info page.

That would do it, but it has the negative consequence that we end up
consuming an extra PAGE_SIZE that on baremetal kernels won't be used.

Also, I think there are other issues lurking around. The other
users of the .bss (or rather of the extend_brk) call would also be
trashed. On PVHVM that would be the DMI. On PV guests (Daniel
has some thoughts on how to make kexec work under PV guests) that
means the P2M tree gets trashed.

And I am kind of worried that moving it to the .data section won't
be completly safe - as the decompressor might blow away that part too.


> 
> Olaf
> 
> 
> diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
> index ff962d4..258e8f3 100644
> --- a/arch/x86/xen/enlighten.c
> +++ b/arch/x86/xen/enlighten.c
> @@ -1469,19 +1469,16 @@ void __ref xen_hvm_init_shared_info(void)
>  {
>  	int cpu;
>  	struct xen_add_to_physmap xatp;
> -	static struct shared_info *shared_info_page = 0;
> +	static struct shared_info shared_info_page __page_aligned_data = {  };
>  
> -	if (!shared_info_page)
> -		shared_info_page = (struct shared_info *)
> -			extend_brk(PAGE_SIZE, PAGE_SIZE);
>  	xatp.domid = DOMID_SELF;
>  	xatp.idx = 0;
>  	xatp.space = XENMAPSPACE_shared_info;
> -	xatp.gpfn = __pa(shared_info_page) >> PAGE_SHIFT;
> +	xatp.gpfn = __pa(&shared_info_page) >> PAGE_SHIFT;
>  	if (HYPERVISOR_memory_op(XENMEM_add_to_physmap, &xatp))
>  		BUG();
>  
> -	HYPERVISOR_shared_info = (struct shared_info *)shared_info_page;
> +	HYPERVISOR_shared_info = &shared_info_page;
>  
>  	/* xen_vcpu is a pointer to the vcpu_info struct in the shared_info
>  	 * page, we use it in the event channel upcall and in some pvclock
> 
> _______________________________________________
> Xen-devel mailing list
> Xen-devel@lists.xen.org
> http://lists.xen.org/xen-devel
