Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752744Ab1DNLa1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 07:30:27 -0400
Received: from smtp.eu.citrix.com ([62.200.22.115]:10296 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751492Ab1DNLaZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 07:30:25 -0400
X-IronPort-AV: E=Sophos;i="4.64,210,1301875200"; 
   d="scan'208";a="5301851"
Date: Thu, 14 Apr 2011 12:30:11 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball-desktop
To: "H. Peter Anvin" <hpa@linux.intel.com>
CC: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        "jeremy@goop.org" <jeremy@goop.org>,
        "yinghai@kernel.org" <yinghai@kernel.org>,
        "mingo@elte.hu" <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 2/4] x86,xen: introduce
 x86_init.mapping.pagetable_reserve
In-Reply-To: <4DA5EAE4.2060406@linux.intel.com>
Message-ID: <alpine.DEB.2.00.1104141218110.22672@kaball-desktop>
References: <alpine.DEB.2.00.1104121149280.22672@kaball-desktop> <1302607192-21355-2-git-send-email-stefano.stabellini@eu.citrix.com> <4DA5EAE4.2060406@linux.intel.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Apr 2011, H. Peter Anvin wrote:
> On 04/12/2011 04:19 AM, stefano.stabellini@eu.citrix.com wrote:
> > From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> > 
> > Introduce a new x86_init hook called pagetable_reserve that during the
> > initial memory mapping is used to reserve a range of memory addresses for
> > kernel pagetable usage.
> > 
> > On native it just calls memblock_x86_reserve_range while on xen it also
> > takes care of setting the spare memory previously allocated
> > for kernel pagetable pages from RO to RW, so that it can be used for
> > other purposes.
> > 
> 
> What are the *semantics* of this hook?
> 
> Hooks are insanely nasty if they are just defined by a particular code
> flow, as evidenced by the royal mess called paravirt_ops.

I hope that the other email I have just sent clarifies the purpose of
the hook.
I admit that as it is it wouldn't find much usage outside
init_memory_mapping.
Maybe adding the corresponding hook to allocate the initial kernel
pagetable pages would help generalizing it.  Or maybe we just need a
better comment in the code:


/* Reserve the kernel pagetable pages we used and free the other ones so
 * that they can be reused for other purposes.
 * 
 * On native it just means calling memblock_x86_reserve_range, on Xen it
 * also means marking RW the pagetable pages that we allocated before
 * but that haven't been used here.
 */
if (!after_bootmem && pgt_buf_end > pgt_buf_start)
		x86_init.mapping.pagetable_reserve(PFN_PHYS(pgt_buf_start),
				PFN_PHYS(pgt_buf_end));
		
