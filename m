Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758213Ab0JVSGZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 14:06:25 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:33376 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753421Ab0JVSGX (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Fri, 22 Oct 2010 14:06:23 -0400
Date: Fri, 22 Oct 2010 14:05:51 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        "Xen-devel@lists.xensource.com" <Xen-devel@lists.xensource.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: define arch_vm_get_page_prot to set _PAGE_IOMAP
 on VM_IO vmas
Message-ID: <20101022180551.GA26597@dumpdata.com>
References: <4CC0C14E.5080205@goop.org>
 <4CC0C318.90401@zytor.com>
 <4CC0CA07.3000306@goop.org>
 <4CC0DEB8.1060309@zytor.com>
 <20101022150826.GA23325@dumpdata.com>
 <4CC1BF58.9020001@zytor.com>
 <20101022180231.GA26365@dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101022180231.GA26365@dumpdata.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 22, 2010 at 02:02:31PM -0400, Konrad Rzeszutek Wilk wrote:
> On Fri, Oct 22, 2010 at 09:44:08AM -0700, H. Peter Anvin wrote:
> > On 10/22/2010 08:08 AM, Konrad Rzeszutek Wilk wrote:
> > >>
> > >> Okay, could you clarify this part a bit?  Why does the kernel need to
> > >> know the difference between "pseudo-physical" and "machine addresses" at
> > >> all?  If they overlap, there is a problem, and if they don't overlap, it
> > >> will be a 1:1 mapping anyway...
> > > 
> > > The flag (_PAGE_IOMAP) is used when we set the PTE so that the MFN value is
> > > used instead of the PFN. We need that b/c when a driver does page_to_pfn()
> > > it ends up using the PFN as bus address to write out registers data.
> > > 
> > > Without this patch, the page->virt->PFN value is used and the PFN != to real MFN
> > > so we end up writing in a memory address that the PCI device has no idea about.
> > > By setting the PTE with the MFN, the virt->PFN gets the real MFN value.
> > > 
> > > The drivers I am talking about are mostly, if not all, located in drivers/gpu
> > > and it looks that we are missing two more patches to utilize the patch
> > > that Jeremy posted.
> > > 
> > > Please note that I am _not_ suggesting that the two patches
> > > below should go out - I still need to post them on drm mailing list.
> > > 
> > 
> > I'm still seriously confused.  If I understand this correctly, we're
> > talking about DMA addresses here (as opposed to PIO addresses, i.e.
> > BARs), right?
> 
> Correct. The BARs are ok since they go through the ioremap.

Whoops. I answered that incorrectly. No, we are not talking about
BARs. The BARs are ok (look at x86/PCI: make sure _PAGE_IOMAP it set on pci mappings
patch, http://amailbox.org/mailarchive/linux-kernel/2010/10/12/4630930/thread)

We are talking about the GPU's VM engine (or the GART on the Northbridge).
