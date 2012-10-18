Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756316Ab2JRPxg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 11:53:36 -0400
Received: from mga11.intel.com ([192.55.52.93]:30388 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752496Ab2JRPxe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 11:53:34 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,608,1344236400"; 
   d="scan'208";a="237023156"
Message-ID: <508025FD.80703@intel.com>
Date: Thu, 18 Oct 2012 08:53:33 -0700
From: Alexander Duyck <alexander.h.duyck@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad@kernel.org>
CC: Hillf Danton <dhillf@gmail.com>, konrad.wilk@oracle.com,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, rob@landley.net,
        akpm@linux-foundation.org, joerg.roedel@amd.com, bhelgaas@google.com,
        shuahkhan@gmail.com, fujita.tomonori@lab.ntt.co.jp,
        linux-kernel@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH v2 1/7] swiotlb: Make io_tlb_end a physical address instead
 of a virtual one
References: <20121011203010.12444.15503.stgit@gitlad.jf.intel.com> <20121011203421.12444.32871.stgit@gitlad.jf.intel.com> <CAJd=RBApQjWBA8w0y7_FhVAOoi17FO=UkCKQqnAX_vbFikkEVA@mail.gmail.com> <507C2F20.8000504@intel.com> <20121018124143.GA13854@localhost.localdomain>
In-Reply-To: <20121018124143.GA13854@localhost.localdomain>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/18/2012 05:41 AM, Konrad Rzeszutek Wilk wrote:
> On Mon, Oct 15, 2012 at 08:43:28AM -0700, Alexander Duyck wrote:
>> On 10/13/2012 05:52 AM, Hillf Danton wrote:
>>> Hi Alexander,
>>>
>>> On Fri, Oct 12, 2012 at 4:34 AM, Alexander Duyck
>>> <alexander.h.duyck@intel.com> wrote:
>>>> This change replaces all references to the virtual address for io_tlb_end
>>>> with references to the physical address io_tlb_end.  The main advantage of
>>>> replacing the virtual address with a physical address is that we can avoid
>>>> having to do multiple translations from the virtual address to the physical
>>>> one needed for testing an existing DMA address.
>>>>
>>>> Signed-off-by: Alexander Duyck <alexander.h.duyck@intel.com>
>>>> ---
>>>>
>>>>  lib/swiotlb.c |   24 +++++++++++++-----------
>>>>  1 files changed, 13 insertions(+), 11 deletions(-)
>>>>
>>>> diff --git a/lib/swiotlb.c b/lib/swiotlb.c
>>>> index f114bf6..19aac9f 100644
>>>> --- a/lib/swiotlb.c
>>>> +++ b/lib/swiotlb.c
>>>> @@ -57,7 +57,8 @@ int swiotlb_force;
>>>>   * swiotlb_tbl_sync_single_*, to see if the memory was in fact allocated by this
>>>>   * API.
>>>>   */
>>>> -static char *io_tlb_start, *io_tlb_end;
>>>> +static char *io_tlb_start;
>>>> +phys_addr_t io_tlb_end;
>>> If add io_tlb_start_phy and io_tlb_end_phy, could we get same results
>>> with less hunks?
>>>
>>> Hillf
>> What do you mean by less hunks?  Are you referring to the memory space? 
> As in less patch movements.
>> If so, then the patches I am submitting do not impact how much space is
>> used for the bounce buffer.  The only real result of these patches is
>> that the total code path is significantly reduced since we don't have to
>> perform any virtual to physical translations in the hot-path.
> No. He is referring that you can keep io_tlb_end still here. Just
> do the computation of the physical address in the init path (of the end).
> Then you don't need to do the shifting in the 'is-this-swiotlb-buffer'
> and can just do a simple:
> 	if (dma_addr >= io_tlb_start && dma_addr <= io_tlb_end)
>

That is how the code ends up.  The v2 and v3 version of these patches
leave the end value there.  As this patch says I am just changing the
end to be physical instead of virtual.  I reviewed the code and realized
that I wasn't saving anything by removing it since the overall code was
larger as a result so I just converted it to a physical address.  There
are no users of io_tlb_end that are accessing it as a virtual value so
all I did is just change it to a physical one and drop the virt_to_phys
calls that were made on it.  If I am not mistaken by the second patch
the is_swiotlb_buffer call is literally what you have described above. 
Here is the snippet from the 2nd patch:

static int is_swiotlb_buffer(phys_addr_t paddr)
 {
-	return paddr >= virt_to_phys(io_tlb_start) && paddr < io_tlb_end;
+	return paddr >= io_tlb_start && paddr < io_tlb_end;
 }


As far as the number of patches I decided to do this incrementally
instead of trying to do it all at once.  That way it is clearer to the
reviewer what I am doing in each step and it can be more easily bisected
in case I messed up somewhere.  If you want fewer patches I can do that
but I don't see the point in combining patches since they are all just
going to result in the same total change anyway.

Thanks,

Alex


