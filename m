Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754066Ab2HQN3O (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 09:29:14 -0400
Received: from smtp.citrix.com ([66.165.176.89]:44740 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751287Ab2HQN3E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 09:29:04 -0400
X-IronPort-AV: E=Sophos;i="4.77,784,1336363200"; 
   d="scan'208";a="34977602"
Message-ID: <502E4713.9050000@citrix.com>
Date: Fri, 17 Aug 2012 14:28:51 +0100
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20120428 Iceowl/1.0b1 Icedove/3.0.11
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>
Subject: Re: [Xen-devel] [PATCH 1/2] xen/p2m: Fix for 32-bit builds the "Reserve
 8MB of _brk space for P2M"
References: <1345132214-15298-1-git-send-email-konrad.wilk@oracle.com> <1345132214-15298-2-git-send-email-konrad.wilk@oracle.com> <20120816173215.GB9790@phenom.dumpdata.com> <20120816210206.GA17966@phenom.dumpdata.com> <502E2784.8060806@citrix.com> <20120817130621.GC31903@phenom.dumpdata.com>
In-Reply-To: <20120817130621.GC31903@phenom.dumpdata.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17/08/12 14:06, Konrad Rzeszutek Wilk wrote:
> On Fri, Aug 17, 2012 at 12:14:12PM +0100, David Vrabel wrote:
>> On 16/08/12 22:02, Konrad Rzeszutek Wilk wrote:
>>>
>>> So I thought about this some more and came up with this patch. Its
>>> RFC and going to run it through some overnight tests to see how they fare.
>>>
>>>
>>> commit da858a92dbeb52fb3246e3d0f1dd57989b5b1734
>>> Author: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
>>> Date:   Fri Jul 27 16:05:47 2012 -0400
>>>
>>>     xen/p2m: Reuse existing P2M leafs if they are filled with 1:1 PFNs or INVALID.
>>>     
>>>     If P2M leaf is completly packed with INVALID_P2M_ENTRY or with
>>>     1:1 PFNs (so IDENTITY_FRAME type PFNs), we can swap the P2M leaf
>>>     with either a p2m_missing or p2m_identity respectively. The old
>>>     page (which was created via extend_brk or was grafted on from the
>>>     mfn_list) can be re-used for setting new PFNs.
>>
>> Does this actually find any p2m pages to reclaim?
> 
> Very much so. When I run the kernel without dom0_mem, and end up returning
> around 372300 pages back, and then populating them back - they (mostly)
> all get to re-use the transplanted mfn_list.
> 
> The ones in the 9a-100 obviously don't.
>>
>> xen_set_identity_and_release() is careful to set the largest possible
>> range as 1:1 and the comments at the top of p2m.c suggest the mid
>> entries will be made to point to p2m_identity already.
> 
> Right, and that is still true - for cases where the are no mid entries
> (so P2M[3][400] for example can point in the middle of the MMIO region).
> 
> But if you boot without dom0_mem=max, that region (P2M[3][400]) would at
> the start be backed by the &mfn_list, so when we call 1-1 on that region
> it ends up sticking in the &mfn_list a whole bunch of IDENTITY_FRAME(pfn).

Ah, I see.  This makes sense now.

> This patch harvests those chunks of &mfn_list that have that and re-uses them.
> 
> And without any dom0_mem= I seem to at most call extend_bkr twice (to
> allocate the top leafs P2M[4] and P2M[5]). Hm, to be on a safe side I should
> probably do 'reserve_brk(p2m_popualated, 3 * PAGE_SIZE)' in case we
> end up transplanting 3GB of PFNs in in the P2M[4], P2M[5] and P2M[6] nodes.

That sounds sensible.

David
