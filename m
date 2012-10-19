Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030416Ab2JSOch (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 10:32:37 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:27279 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754283Ab2JSOcg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 10:32:36 -0400
Date: Fri, 19 Oct 2012 10:18:51 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Alexander Duyck <alexander.h.duyck@intel.com>
Cc: Konrad Rzeszutek Wilk <konrad@kernel.org>, Hillf Danton <dhillf@gmail.com>,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, rob@landley.net,
        akpm@linux-foundation.org, joerg.roedel@amd.com, bhelgaas@google.com,
        shuahkhan@gmail.com, fujita.tomonori@lab.ntt.co.jp,
        linux-kernel@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH v2 1/7] swiotlb: Make io_tlb_end a physical address
 instead of a virtual one
Message-ID: <20121019141851.GM26830@phenom.dumpdata.com>
References: <20121011203010.12444.15503.stgit@gitlad.jf.intel.com>
 <20121011203421.12444.32871.stgit@gitlad.jf.intel.com>
 <CAJd=RBApQjWBA8w0y7_FhVAOoi17FO=UkCKQqnAX_vbFikkEVA@mail.gmail.com>
 <507C2F20.8000504@intel.com>
 <20121018124143.GA13854@localhost.localdomain>
 <508025FD.80703@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <508025FD.80703@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 18, 2012 at 08:53:33AM -0700, Alexander Duyck wrote:
> On 10/18/2012 05:41 AM, Konrad Rzeszutek Wilk wrote:
> > On Mon, Oct 15, 2012 at 08:43:28AM -0700, Alexander Duyck wrote:
> >> On 10/13/2012 05:52 AM, Hillf Danton wrote:
> >>> Hi Alexander,
> >>>
> >>> On Fri, Oct 12, 2012 at 4:34 AM, Alexander Duyck
> >>> <alexander.h.duyck@intel.com> wrote:
> >>>> This change replaces all references to the virtual address for io_tlb_end
> >>>> with references to the physical address io_tlb_end.  The main advantage of
> >>>> replacing the virtual address with a physical address is that we can avoid
> >>>> having to do multiple translations from the virtual address to the physical
> >>>> one needed for testing an existing DMA address.
> >>>>
> >>>> Signed-off-by: Alexander Duyck <alexander.h.duyck@intel.com>
> >>>> ---
> >>>>
> >>>>  lib/swiotlb.c |   24 +++++++++++++-----------
> >>>>  1 files changed, 13 insertions(+), 11 deletions(-)
> >>>>
> >>>> diff --git a/lib/swiotlb.c b/lib/swiotlb.c
> >>>> index f114bf6..19aac9f 100644
> >>>> --- a/lib/swiotlb.c
> >>>> +++ b/lib/swiotlb.c
> >>>> @@ -57,7 +57,8 @@ int swiotlb_force;
> >>>>   * swiotlb_tbl_sync_single_*, to see if the memory was in fact allocated by this
> >>>>   * API.
> >>>>   */
> >>>> -static char *io_tlb_start, *io_tlb_end;
> >>>> +static char *io_tlb_start;
> >>>> +phys_addr_t io_tlb_end;
> >>> If add io_tlb_start_phy and io_tlb_end_phy, could we get same results
> >>> with less hunks?
> >>>
> >>> Hillf
> >> What do you mean by less hunks?  Are you referring to the memory space? 
> > As in less patch movements.
> >> If so, then the patches I am submitting do not impact how much space is
> >> used for the bounce buffer.  The only real result of these patches is
> >> that the total code path is significantly reduced since we don't have to
> >> perform any virtual to physical translations in the hot-path.
> > No. He is referring that you can keep io_tlb_end still here. Just
> > do the computation of the physical address in the init path (of the end).
> > Then you don't need to do the shifting in the 'is-this-swiotlb-buffer'
> > and can just do a simple:
> > 	if (dma_addr >= io_tlb_start && dma_addr <= io_tlb_end)
> >
> 
> That is how the code ends up.  The v2 and v3 version of these patches
> leave the end value there.  As this patch says I am just changing the

Great!
> end to be physical instead of virtual.  I reviewed the code and realized
> that I wasn't saving anything by removing it since the overall code was
> larger as a result so I just converted it to a physical address.  There
> are no users of io_tlb_end that are accessing it as a virtual value so
> all I did is just change it to a physical one and drop the virt_to_phys
> calls that were made on it.  If I am not mistaken by the second patch
> the is_swiotlb_buffer call is literally what you have described above. 
> Here is the snippet from the 2nd patch:
> 
> static int is_swiotlb_buffer(phys_addr_t paddr)
>  {
> -	return paddr >= virt_to_phys(io_tlb_start) && paddr < io_tlb_end;
> +	return paddr >= io_tlb_start && paddr < io_tlb_end;
>  }
> 
> 
> As far as the number of patches I decided to do this incrementally
> instead of trying to do it all at once.  That way it is clearer to the
> reviewer what I am doing in each step and it can be more easily bisected
> in case I messed up somewhere.  If you want fewer patches I can do that
> but I don't see the point in combining patches since they are all just
> going to result in the same total change anyway.

No that is OK. BTW, I did a testing of your V2 patches with Xen-SWIOTLB
and they worked. But it was on non-debug env. The debug one does such
evil things as make the initial domain memory start at the end physical
memory and put the underlaying MFNs (machine frame numbers, the real
physical frames) in reverse order. So for example pfn 100, ends up being
mfn 0xf00d, and pfn 101 ends up being oxf00c.
