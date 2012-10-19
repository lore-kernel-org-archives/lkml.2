Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758415Ab2JSQVo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 12:21:44 -0400
Received: from mga14.intel.com ([143.182.124.37]:21113 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751997Ab2JSQVn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 12:21:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,613,1344236400"; 
   d="scan'208";a="206608543"
Message-ID: <50817E15.60308@intel.com>
Date: Fri, 19 Oct 2012 09:21:41 -0700
From: Alexander Duyck <alexander.h.duyck@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Konrad Rzeszutek Wilk <konrad@kernel.org>, Hillf Danton <dhillf@gmail.com>,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, rob@landley.net,
        akpm@linux-foundation.org, joerg.roedel@amd.com, bhelgaas@google.com,
        shuahkhan@gmail.com, fujita.tomonori@lab.ntt.co.jp,
        linux-kernel@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH v2 1/7] swiotlb: Make io_tlb_end a physical address instead
 of a virtual one
References: <20121011203010.12444.15503.stgit@gitlad.jf.intel.com> <20121011203421.12444.32871.stgit@gitlad.jf.intel.com> <CAJd=RBApQjWBA8w0y7_FhVAOoi17FO=UkCKQqnAX_vbFikkEVA@mail.gmail.com> <507C2F20.8000504@intel.com> <20121018124143.GA13854@localhost.localdomain> <508025FD.80703@intel.com> <20121019141851.GM26830@phenom.dumpdata.com>
In-Reply-To: <20121019141851.GM26830@phenom.dumpdata.com>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/19/2012 07:18 AM, Konrad Rzeszutek Wilk wrote:
> On Thu, Oct 18, 2012 at 08:53:33AM -0700, Alexander Duyck wrote:
>> end to be physical instead of virtual.  I reviewed the code and realized
>> that I wasn't saving anything by removing it since the overall code was
>> larger as a result so I just converted it to a physical address.  There
>> are no users of io_tlb_end that are accessing it as a virtual value so
>> all I did is just change it to a physical one and drop the virt_to_phys
>> calls that were made on it.  If I am not mistaken by the second patch
>> the is_swiotlb_buffer call is literally what you have described above. 
>> Here is the snippet from the 2nd patch:
>>
>> static int is_swiotlb_buffer(phys_addr_t paddr)
>>  {
>> -	return paddr >= virt_to_phys(io_tlb_start) && paddr < io_tlb_end;
>> +	return paddr >= io_tlb_start && paddr < io_tlb_end;
>>  }
>>
>>
>> As far as the number of patches I decided to do this incrementally
>> instead of trying to do it all at once.  That way it is clearer to the
>> reviewer what I am doing in each step and it can be more easily bisected
>> in case I messed up somewhere.  If you want fewer patches I can do that
>> but I don't see the point in combining patches since they are all just
>> going to result in the same total change anyway.
> No that is OK. BTW, I did a testing of your V2 patches with Xen-SWIOTLB
> and they worked. But it was on non-debug env. The debug one does such
> evil things as make the initial domain memory start at the end physical
> memory and put the underlaying MFNs (machine frame numbers, the real
> physical frames) in reverse order. So for example pfn 100, ends up being
> mfn 0xf00d, and pfn 101 ends up being oxf00c.

Glad to hear they are working under Xen.  As I said I am pretty sure if
it was working before it should still be working after these changes
since the only difference is that instead of working with virtual
addresses and having to call virt_to_phys to get the pseudo-physical
addresses we are just working with the pseudo-physical addresses directly.

Thanks,

Alex




