Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754828Ab2GJJdc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 05:33:32 -0400
Received: from mo-p00-ob.rzone.de ([81.169.146.161]:39497 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752893Ab2GJJda (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 05:33:30 -0400
X-RZG-AUTH: :P2EQZWCpfu+qG7CngxMFH1J+zrwiavkK6tmQaLfmwtM48/lr387qFmLE
X-RZG-CLASS-ID: mo00
Date: Tue, 10 Jul 2012 11:33:27 +0200
From: Olaf Hering <olaf@aepfle.de>
To: Jan Beulich <JBeulich@suse.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: kexec@lists.infradead.org, xen-devel@lists.xensource.com,
        Daniel Kiper <dkiper@net-space.pl>, linux-kernel@vger.kernel.org
Subject: Re: [Xen-devel] incorrect layout of globals from head_64.S during
 kexec boot
Message-ID: <20120710093327.GA13864@aepfle.de>
References: <20120705210607.GA26908@aepfle.de>
 <20120706084120.GA31219@router-fw-old.local.net-space.pl>
 <20120706120750.GA8970@aepfle.de>
 <4FF6FCA9020000780008E0BB@nat28.tlf.novell.com>
 <20120706133105.GA20600@aepfle.de>
 <20120706141419.GA21951@aepfle.de>
 <4FF7174C020000780008E1FF@nat28.tlf.novell.com>
 <20120706172918.GA15222@aepfle.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20120706172918.GA15222@aepfle.de>
User-Agent: Mutt/1.5.21.rev5543 (2011-12-20)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 06, Olaf Hering wrote:

> On Fri, Jul 06, Jan Beulich wrote:
> 
> > > Could it be that some code tweaks the stack content used by decompress()
> > > in some odd way? But that would most likely lead to a crash, not to
> > > unexpected uncompressing results.
> > 
> > Especially if the old and new kernel are using the exact same
> > image, how about the decompression writing over the shared
> > info page causing all this? As the decompressor wouldn't
> > expect Xen to possibly write stuff there itself, it could easily be
> > that some repeat count gets altered, thus breaking the
> > decompressed data without the decompression code necessarily
> > noticing.
> 
> In my case the gfn of the shared info page is 1f54.
> Is it possible to move the page at runtime? It looks like it can be done
> because the hvm loader configures fffff initially.
> 
> Perhaps the PVonHVM code has to give up the shared pages or move them to
> some dedicated unused page during the process of booting into the new
> kernel.

The pfn 1f54 of the shared info page is in the middle of the new bzImage:
pfn    32080 KiB
_head  29360 KiB
_text  33826 KiB
_end   33924 KiB

In other words, the compressed vmlinux.bin gets slightly modified during
uncompression. For some reason this does not lead to decompression
errors.

In the patch below the pfn is moved from the bss to the data section. As
a result the new location is now at 28680 KiB, which is outside of the
bzImage.

Maybe there is a way to use another dedicated page as shared info page.

Olaf


diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index ff962d4..258e8f3 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -1469,19 +1469,16 @@ void __ref xen_hvm_init_shared_info(void)
 {
 	int cpu;
 	struct xen_add_to_physmap xatp;
-	static struct shared_info *shared_info_page = 0;
+	static struct shared_info shared_info_page __page_aligned_data = {  };
 
-	if (!shared_info_page)
-		shared_info_page = (struct shared_info *)
-			extend_brk(PAGE_SIZE, PAGE_SIZE);
 	xatp.domid = DOMID_SELF;
 	xatp.idx = 0;
 	xatp.space = XENMAPSPACE_shared_info;
-	xatp.gpfn = __pa(shared_info_page) >> PAGE_SHIFT;
+	xatp.gpfn = __pa(&shared_info_page) >> PAGE_SHIFT;
 	if (HYPERVISOR_memory_op(XENMEM_add_to_physmap, &xatp))
 		BUG();
 
-	HYPERVISOR_shared_info = (struct shared_info *)shared_info_page;
+	HYPERVISOR_shared_info = &shared_info_page;
 
 	/* xen_vcpu is a pointer to the vcpu_info struct in the shared_info
 	 * page, we use it in the event channel upcall and in some pvclock
