Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753367Ab1AJKay (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 05:30:54 -0500
Received: from smtp.eu.citrix.com ([62.200.22.115]:33438 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753090Ab1AJKaw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 05:30:52 -0500
X-IronPort-AV: E=Sophos;i="4.60,299,1291593600"; 
   d="scan'208";a="3677674"
Date: Mon, 10 Jan 2011 10:32:19 +0000
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball-desktop
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        Jeremy Fitzhardinge <Jeremy.Fitzhardinge@citrix.com>
Subject: Re: [PATCH 09/11] xen: introduce gnttab_map_refs and
 gnttab_unmap_refs
In-Reply-To: <20110105202355.GB29993@dumpdata.com>
Message-ID: <alpine.DEB.2.00.1101071357420.2390@kaball-desktop>
References: <alpine.DEB.2.00.1012151259510.2390@kaball-desktop> <1292420446-3348-9-git-send-email-stefano.stabellini@eu.citrix.com> <20110105202355.GB29993@dumpdata.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 5 Jan 2011, Konrad Rzeszutek Wilk wrote:
> > +
> > +	ret = HYPERVISOR_grant_table_op(GNTTABOP_map_grant_ref, map_ops, count);
> > +
> > +	for (i = 0; i < count; i++) {
> > +		pfn = mfn_to_pfn(map_ops[i].host_addr >> PAGE_SHIFT);
> 
> Shouldn't you be checking the flag to see if this a bus address? You could
> also use the PFN_DOWN macro here..

Yes, actually I should be checking for GNTMAP_contains_pte.

> > +		pte = (pte_t *) __va((pfn << PAGE_SHIFT) +
> > +				(map_ops[i].host_addr & ~PAGE_MASK));
> 
> PFN_PHYS(pfn)? Or better You could use the mfn_to_virt macro here:
> 
> 		pte = (pte_t *) mfn_to_virt(PFN_DOWN(map_ops[i].ost_addr));
> 		pte += (map_ops[i].host_addr & _PAGE_MASK);
> 

Good suggestion, I have applied it (plus a small change to the pointer
arithmetic).

> > +		val = *pte;
> > +		mfn = (native_pte_val(val) & PTE_PFN_MASK) >> PAGE_SHIFT;
> 
> mfn = pte_mfn(pte) ?
> 

yep, done that.

