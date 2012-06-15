Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756672Ab2FOKtU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 06:49:20 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:56645 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752718Ab2FOKtT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 06:49:19 -0400
User-Agent: Microsoft-Entourage/12.32.0.111121
Date: Fri, 15 Jun 2012 11:49:11 +0100
Subject: Re: [Xen-devel] [PATCH 1/2] x86/mm: remove arch-specific
 ptep_get_and_clear() function
From: Keir Fraser <keir.xen@gmail.com>
To: David Vrabel <david.vrabel@citrix.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "H. Peter Anvin" <hpa@zytor.com>, "x86@kernel.org" <x86@kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Message-ID: <CC00D1B7.35E5B%keir.xen@gmail.com>
Thread-Topic: [Xen-devel] [PATCH 1/2] x86/mm: remove arch-specific
 ptep_get_and_clear() function
Thread-Index: Ac1K5H8o2d6Ebjb+NUyoHQ2/vxnmMQ==
In-Reply-To: <4FDB033F.8050703@citrix.com>
Mime-version: 1.0
Content-type: text/plain;
	charset="US-ASCII"
Content-transfer-encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15/06/2012 10:41, "David Vrabel" <david.vrabel@citrix.com> wrote:

> This reasoning is probably not correct.  When a dirty bit must be
> updated in a PTE the processor does a pagetable walk (possibly using any
> cached page table structures).  The AMD APM section 5.4.2 states:
> 
> "The processor never sets the Accessed bit or the Dirty bit for a not
> present page (P = 0)."
> 
> and
> 
> "If PTE[D] is cleared to 0, software can rely on the fact that the page
> has not been written."

Writing of dirty and accessed bits is done as part of the page-table walk on
TLB fill. A/D bits never have writeback caching semantics. It wouldn't be
safe: e.g., on unmap, TLB flushes happen after ptes have been cleared (to
avoid TLB-fill races), but that would mean that A/D updates could be lost
even on non-explicit unmaps (e.g., page out) which is obviously bad.

> Thus this patch would /introduce/ a race where a dirty bit set would be
> lost (rather than extending the window where this would happen).
> 
> However (and this is a weaker argument), no sensible userspace
> application should be accessing pages that are being unmapped or
> remapped (since it is unpredictable whether they will fault) so perhaps
> this additional unpredictable behaviour is acceptable?

If there's a big win to be had through batching, we're better off devising a
hypercall method for capturing the atomic rmw operation as it stands, rather
than subtly messing with semantics.

 -- Keir


