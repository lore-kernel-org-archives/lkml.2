Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753985Ab2GMUUJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2012 16:20:09 -0400
Received: from mo-p00-ob.rzone.de ([81.169.146.160]:17612 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751093Ab2GMUUG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2012 16:20:06 -0400
X-RZG-AUTH: :P2EQZWCpfu+qG7CngxMFH1J+zrwiavkK6tmQaLfmztM8TOFGiC0MElja
X-RZG-CLASS-ID: mo00
Date: Fri, 13 Jul 2012 22:20:03 +0200
From: Olaf Hering <olaf@aepfle.de>
To: Keir Fraser <keir.xen@gmail.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Jan Beulich <JBeulich@suse.com>, xen-devel@lists.xensource.com,
        kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
        Daniel Kiper <dkiper@net-space.pl>
Subject: Re: [Xen-devel] incorrect layout of globals from head_64.S during
 kexec boot
Message-ID: <20120713202003.GA20972@aepfle.de>
References: <20120710180953.GB20075@aepfle.de>
 <CC223C2F.3817C%keir.xen@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CC223C2F.3817C%keir.xen@gmail.com>
User-Agent: Mutt/1.5.21.rev5543 (2011-12-20)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 10, Keir Fraser wrote:

> On 10/07/2012 19:09, "Olaf Hering" <olaf@aepfle.de> wrote:
> > I'm not sure, most likely the gfn will just disappear from the guest,
> > like a ballooned page disappears. Accessing it will likely cause a
> > crash.
> 
> Best thing to do, is possible, is map the shared-info page in the
> xen-platform pci device's BAR memory range. Then it will not conflict with
> any RAM.
> 
> If you do map it over the top of an existing RAM page, you will have to
> repopulate that RAM page before kexec, using populate_physmap hypercall. The
> good news is that the populate_physmap hypercall will have the side effect
> of unmapping the shared-info page, reayd to be mapped wherever the new
> kernel would like it to reside :)

Keir,

is this a safe thing to do in a SMP guest?
If arch/x86/xen/enlighten.c:xen_hvm_init_shared_info() allocates a page
(backed by mfn M and pfn A) and assigns *HYPERVISOR_shared_info and
*xen_vcpu then everything will reference these pointers.

If drivers/xen/platform-pci.c:platform_pci_init would also do a
XENMAPSPACE_shared_info call with pfn B, isnt there a small window where
pfn A is not backed by a mfn because mfn M is now connected to pfn C? As
a result other code paths which access *HYPERVISOR_shared_info and
*xen_vcpu between the hypercall and the update of the pointers will read
0xff.


If I read the hypercall code of XENMEM_add_to_physmap correctly the mfn
backing *HYPERVISOR_shared_info will remain the same, so there is no need
to copy data from the old to the new *HYPERVISOR_shared_info.

What do you think, is that race real?

Olaf
