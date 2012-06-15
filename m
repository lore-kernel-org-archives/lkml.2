Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756062Ab2FOJlX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 05:41:23 -0400
Received: from smtp.citrix.com ([66.165.176.89]:21882 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753394Ab2FOJlW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 05:41:22 -0400
X-IronPort-AV: E=Sophos;i="4.75,776,1330923600"; 
   d="scan'208";a="28195337"
Message-ID: <4FDB033F.8050703@citrix.com>
Date: Fri, 15 Jun 2012 10:41:19 +0100
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20120428 Icedove/3.0.11
MIME-Version: 1.0
To: David Vrabel <david.vrabel@citrix.com>
CC: "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "H. Peter Anvin" <hpa@zytor.com>, "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] x86/mm: remove arch-specific ptep_get_and_clear()
 function
References: <1339582845-25659-1-git-send-email-david.vrabel@citrix.com> <1339582845-25659-2-git-send-email-david.vrabel@citrix.com>
In-Reply-To: <1339582845-25659-2-git-send-email-david.vrabel@citrix.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13/06/12 11:20, David Vrabel wrote:
> From: David Vrabel <david.vrabel@citrix.com>
> 
> x86 provides a ptep_get_and_clear() function instead of using the
> generic implementation so it can atomically get and clear the PTE.
> 
> It is not clear why x86 has this requirement.  PTE updates are done
> while the appropriate PTE lock are held, so presumably, it is an
> attempt to ensure that the accessed and dirty bits of the PTE are
> saved even if they have been updated by the hardware due to a
> concurrent access on another CPU.
> 
> However, the atomic exchange is not sufficient for saving the dirty
> bit as if there is a TLB entry for this page on another CPU then the
> dirty bit may be written by that processor after the PTE is cleared
> but before the TLB entry is flushed.  It is also not clear from the
> Intel SDM[1] if the processor's read of the PTE and the write to set
> the accessed bit are atomic or not.

This reasoning is probably not correct.  When a dirty bit must be
updated in a PTE the processor does a pagetable walk (possibly using any
cached page table structures).  The AMD APM section 5.4.2 states:

"The processor never sets the Accessed bit or the Dirty bit for a not
present page (P = 0)."

and

"If PTE[D] is cleared to 0, software can rely on the fact that the page
has not been written."

Thus this patch would /introduce/ a race where a dirty bit set would be
lost (rather than extending the window where this would happen).

However (and this is a weaker argument), no sensible userspace
application should be accessing pages that are being unmapped or
remapped (since it is unpredictable whether they will fault) so perhaps
this additional unpredictable behaviour is acceptable?

> With this patch the get/clear becomes a read of the PTE and call to
> pte_clear() which allows the clears to be batched by some
> paravirtualized guests (such as Xen guests).  This can lead to
> significant performance improvements in munmap().  e.g., for Xen, a
> trap-and-emulate[2] for every page becomes a hypercall for every 31
> pages.
> 
> There should be no change in the performance on native or for KVM
> guests.  There may be a performance regression with lguest guests as
> an optimization for avoiding calling pte_update() when doing a full
> teardown of an mm is removed.

Having looked further into how lguest works the performance penalty is
likely to not be as bad as I first thought.  pte_clear() does call
pte_update() but these are batched and the batch size seems to be up-to
64 calls so the performance penalty should be pretty minimal.

> [1] Intel Software Developer's Manual Vol 3A section 4.8 says nothing
> on this.
> 
> [2] For 32-bit guests, two traps are required for every page to update
> both halves of the PTE.
