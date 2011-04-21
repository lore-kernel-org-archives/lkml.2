Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754587Ab1DUVHv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 17:07:51 -0400
Received: from smtp105.prem.mail.ac4.yahoo.com ([76.13.13.44]:49039 "HELO
	smtp105.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754021Ab1DUVHu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 17:07:50 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: N7a04ksVM1m.0I_vy74zIqoJtspkUaojfuLzlArmJX6wtwJ
 uuWbcCLXPSrjAeayPzP8dQ9vgd7hRmnqrPfogwBmpZwHezQDRhS6n0x0CciM
 QQ1PT2ARKAJ3w6vrvLVoIluvMK2OP23tXgCdgEnW4.P81PnYLPSox_ODV2wi
 wGrUsbUda7O7t_b092sYCvOby5O4QQjYZ9cxpznIhD4z7MYB_raFoBzCk1KS
 oG4_.OHrBvpOM9YVbWXJeKgZP3hM.Cu25TsvuW_CLWDDWs8NT5nEsv4xIGez
 _yEdJWYIxvkcJ3EJeVwvBt2PZxn1txh.NxvtR2b1yKhNm4VBrFud3YubTHWz
 tfSX_rBVbO6iU1AixLcrhMQyC
X-Yahoo-Newman-Property: ymail-3
Date: Thu, 21 Apr 2011 16:07:43 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: James Bottomley <James.Bottomley@HansenPartnership.com>
cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        David Rientjes <rientjes@google.com>,
        Pekka Enberg <penberg@kernel.org>, Michal Hocko <mhocko@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>, linux-mm@kvack.org,
        LKML <linux-kernel@vger.kernel.org>, linux-parisc@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>, x86 maintainers <x86@kernel.org>,
        Tejun Heo <tj@kernel.org>, Dave Hansen <dave@linux.vnet.ibm.com>,
        Mel Gorman <mel@csn.ul.ie>
Subject: Re: [PATCH v3] mm: make expand_downwards symmetrical to
 expand_upwards
In-Reply-To: <1303416315.4025.36.camel@mulgrave.site>
Message-ID: <alpine.DEB.2.00.1104211553390.9496@router.home>
References: <1303337718.2587.51.camel@mulgrave.site>  <alpine.DEB.2.00.1104201530430.13948@chino.kir.corp.google.com>  <20110421221712.9184.A69D9226@jp.fujitsu.com>  <1303403847.4025.11.camel@mulgrave.site>  <alpine.DEB.2.00.1104211328000.5741@router.home>
 <1303416315.4025.36.camel@mulgrave.site>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 21 Apr 2011, James Bottomley wrote:

> > Dave Hansen, Mel: Can you provide us with some help? (Its Easter and so
> > the europeans may be off for awhile)
>
> It sort of depends on your definition of easy.  The problem going from
> DISCONTIGMEM to SPARSEMEM is sorting out the section size (the minimum
> indivisible size for a sectional_mem_map array) and also deciding on
> whether you need SPARSEMEM_EXTREME (discontigmem allows arbitrarily
> different sizes for each contiguous region) or
> ARCH_HAS_HOLES_MEMORYMODEL (allows empty mem_map regions as well).  I
> suspect most architectures will want SPARSEMEM_EXTREME (it means that
> the section array isn't fully populated) because the gaps can be huge
> (we've got a 64GB gap on parisc).

Well my favorite is SPARSEMEM_VMEMMAP because it allows page level holes
and uses the TLB (via page tables) to avoid lookups in the SPARSE maps but
that is likely not going to be in an initial fix.

> However, even though I think we can do this going forwards ... I don't
> think we can backport it as a bug fix for the slub panic.

So far there seems to be no other solution that will fix the issues
cleanly since we have a clash of the notions of a node in !NUMA between
core and discontig. Which is a pretty basic thing to get wrong.

If we can avoid all the fancy stuff and Dave can just get a minimal SPARSE
config going then this may be the best solution for stable as well.

But then these configs have been broken for years and no one noticed. This
means the users of these arches likely have been running a subset of
kernel functionality. I suspect they have never freed memory from
DISCONTIG node 1 and higher without CONFIG_DEBUG_VM on. Otherwise I
cannot explain why the VM_BUG_ONs did not trigger in
mm/page_alloc.c:move_freepages() that should have been brought to the MM
developers attention.

This set of circumstances leads to the suspicion that there were only
tests run that showed that the kernel booted. Higher node memory was never
touched and the MM code was never truly exercised.

So I am not sure that there is any urgency in this matter. No one has
cared for years after all.
