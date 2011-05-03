Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753007Ab1ECP2H (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 11:28:07 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:25496 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750960Ab1ECP2G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 11:28:06 -0400
Date: Tue, 3 May 2011 11:27:45 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "yinghai@kernel.org" <yinghai@kernel.org>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>
Subject: Re: [PATCH 1/2] xen/mmu: Add workaround "x86-64, mm: Put early page
 table high"
Message-ID: <20110503152745.GB8868@dumpdata.com>
References: <1304356942-17656-1-git-send-email-konrad.wilk@oracle.com>
 <1304356942-17656-2-git-send-email-konrad.wilk@oracle.com>
 <alpine.DEB.2.00.1105031351190.10886@kaball-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1105031351190.10886@kaball-desktop>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090206.4DC01EFF.0043:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 03, 2011 at 02:20:25PM +0100, Stefano Stabellini wrote:
> On Mon, 2 May 2011, Konrad Rzeszutek Wilk wrote:
> > As a consequence of the commit:
> > 
> > commit 4b239f458c229de044d6905c2b0f9fe16ed9e01e
> > Author: Yinghai Lu <yinghai@kernel.org>
> > Date:   Fri Dec 17 16:58:28 2010 -0800
> > 
> >     x86-64, mm: Put early page table high
> > 
> > it causes the Linux kernel to crash under Xen:
> > 
> > mapping kernel into physical memory
> > Xen: setup ISA identity maps
> > about to get started...
> > (XEN) mm.c:2466:d0 Bad type (saw 7400000000000001 != exp 1000000000000000) for mfn b1d89 (pfn bacf7)
> > (XEN) mm.c:3027:d0 Error while pinning mfn b1d89
> > (XEN) traps.c:481:d0 Unhandled invalid opcode fault/trap [#6] on VCPU 0 [ec=0000]
> > (XEN) domain_crash_sync called from entry.S
> > (XEN) Domain 0 (vcpu#0) crashed on cpu#0:

.. snip..
> 
> 
> Unless I am missing something there is no guarantee that somebody else
> won't use memory in the pgt_buf_end-pgt_buf_top range when the range is
> still RO before mark_rw_past_pgt() is called again.  If so this code
> works by coincidence, that is the reason why I didn't try to reuse the
> pagetable_setup_done or the pagetable_setup_start hooks.

It looks that during sequence of events after the initial pagetable is created
and when we get to the post-allocator nobody is touching those pages.
(also one of them - the 0-4GB pagetable has been .. made RW). But if you do find it
dying/crashing, please tell so that we can revert it and use the generic work-around
or revert Yinghai's patch.
 
> In any case this code looks very ugly and fragile, do we really want to
> add a workaround as bad as this one rather than reverting the original
> commit? I think it creates a bad precedent.

This is the second one. We had the swapper_pg_dir/initial_page_table dance in x86_32
where we mark it RO, then RW (after a cr3 load) then RO and then back to RW.
(Details escape me, but it was some form of that)

But I wonder how many workarounds the generic code has because of us?

I think we need to setup some form of meeting with the x86 maintainers
to figure out some better way of handling this.
