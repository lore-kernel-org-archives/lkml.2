Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755150Ab2JRMlx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 08:41:53 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:50985 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754801Ab2JRMlv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 08:41:51 -0400
Date: Thu, 18 Oct 2012 08:41:44 -0400
From: Konrad Rzeszutek Wilk <konrad@kernel.org>
To: Alexander Duyck <alexander.h.duyck@intel.com>
Cc: Hillf Danton <dhillf@gmail.com>, konrad.wilk@oracle.com,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, rob@landley.net,
        akpm@linux-foundation.org, joerg.roedel@amd.com, bhelgaas@google.com,
        shuahkhan@gmail.com, fujita.tomonori@lab.ntt.co.jp,
        linux-kernel@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH v2 1/7] swiotlb: Make io_tlb_end a physical address
 instead of a virtual one
Message-ID: <20121018124143.GA13854@localhost.localdomain>
References: <20121011203010.12444.15503.stgit@gitlad.jf.intel.com>
 <20121011203421.12444.32871.stgit@gitlad.jf.intel.com>
 <CAJd=RBApQjWBA8w0y7_FhVAOoi17FO=UkCKQqnAX_vbFikkEVA@mail.gmail.com>
 <507C2F20.8000504@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <507C2F20.8000504@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 15, 2012 at 08:43:28AM -0700, Alexander Duyck wrote:
> On 10/13/2012 05:52 AM, Hillf Danton wrote:
> > Hi Alexander,
> >
> > On Fri, Oct 12, 2012 at 4:34 AM, Alexander Duyck
> > <alexander.h.duyck@intel.com> wrote:
> >> This change replaces all references to the virtual address for io_tlb_end
> >> with references to the physical address io_tlb_end.  The main advantage of
> >> replacing the virtual address with a physical address is that we can avoid
> >> having to do multiple translations from the virtual address to the physical
> >> one needed for testing an existing DMA address.
> >>
> >> Signed-off-by: Alexander Duyck <alexander.h.duyck@intel.com>
> >> ---
> >>
> >>  lib/swiotlb.c |   24 +++++++++++++-----------
> >>  1 files changed, 13 insertions(+), 11 deletions(-)
> >>
> >> diff --git a/lib/swiotlb.c b/lib/swiotlb.c
> >> index f114bf6..19aac9f 100644
> >> --- a/lib/swiotlb.c
> >> +++ b/lib/swiotlb.c
> >> @@ -57,7 +57,8 @@ int swiotlb_force;
> >>   * swiotlb_tbl_sync_single_*, to see if the memory was in fact allocated by this
> >>   * API.
> >>   */
> >> -static char *io_tlb_start, *io_tlb_end;
> >> +static char *io_tlb_start;
> >> +phys_addr_t io_tlb_end;
> > If add io_tlb_start_phy and io_tlb_end_phy, could we get same results
> > with less hunks?
> >
> > Hillf
> 
> What do you mean by less hunks?  Are you referring to the memory space? 

As in less patch movements.
> If so, then the patches I am submitting do not impact how much space is
> used for the bounce buffer.  The only real result of these patches is
> that the total code path is significantly reduced since we don't have to
> perform any virtual to physical translations in the hot-path.

No. He is referring that you can keep io_tlb_end still here. Just
do the computation of the physical address in the init path (of the end).
Then you don't need to do the shifting in the 'is-this-swiotlb-buffer'
and can just do a simple:
	if (dma_addr >= io_tlb_start && dma_addr <= io_tlb_end)

