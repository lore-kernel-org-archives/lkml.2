Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757536Ab2FOTyS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 15:54:18 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:63506 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757440Ab2FOTyR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 15:54:17 -0400
Message-ID: <4FDB92CF.1070603@vflare.org>
Date: Fri, 15 Jun 2012 12:53:51 -0700
From: Nitin Gupta <ngupta@vflare.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Dan Magenheimer <dan.magenheimer@oracle.com>
CC: Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Minchan Kim <minchan@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Tejun Heo <tj@kernel.org>, David Howells <dhowells@redhat.com>,
        x86@kernel.org, Nick Piggin <npiggin@gmail.com>,
        Konrad Rzeszutek Wilk <konrad@darnok.org>
Subject: Re: [PATCH v2 3/3] x86: Support local_flush_tlb_kernel_range
References: <1337133919-4182-1-git-send-email-minchan@kernel.org> <1337133919-4182-3-git-send-email-minchan@kernel.org> <4FB4B29C.4010908@kernel.org> <1337266310.4281.30.camel@twins> <4FDB5107.3000308@linux.vnet.ibm.com> <7e925563-082b-468f-a7d8-829e819eeac0@default> <4FDB66B7.2010803@vflare.org> <10ea9d19-bd24-400c-8131-49f0b4e9e5ae@default> <4FDB8808.9010508@linux.vnet.ibm.com> <9c6c8ae0-0212-402d-a906-0d0c61e5e058@default>
In-Reply-To: <9c6c8ae0-0212-402d-a906-0d0c61e5e058@default>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/15/2012 12:39 PM, Dan Magenheimer wrote:
>> From: Seth Jennings [mailto:sjenning@linux.vnet.ibm.com]
>>> The compression code already compresses to a per-cpu page-pair
>>> already and then that "zpage" is copied into the space allocated
>>> for it by zsmalloc.  For that final copy, if the copy code knows
>>> the target may cross a page boundary, has both target pages
>>> kmap'ed, and is smart about doing the copy, the "pair mapping"
>>> can be avoided for compression.
>>
>> The problem is that by "smart" you mean "has access to zsmalloc
>> internals".  zcache, or any user, would need the know the kmapped
>> address of the first page, the offset to start at within that page, and
>> the kmapped address of the second page in order to do the smart copy
>> you're talking about.  Then the complexity to do the smart copy that
>> would have to be implemented in each user.
> 
> Or simply add a zsmalloc_copy in zsmalloc and require that
> it be used by the caller (instead of a memcpy).
> 
>>> The decompression path calls lzo1x directly and it would be
>>> a huge pain to make lzo1x smart about page boundaries.  BUT
>>> since we know that the decompressed result will always fit
>>> into a page (actually exactly a page), you COULD do an extra
>>> copy to the end of the target page (using the same smart-
>>> about-page-boundaries copying code from above) and then do
>>> in-place decompression, knowing that the decompression will
>>> not cross a page boundary.  So, with the extra copy, the "pair
>>> mapping" can be avoided for decompression as well.
>>
>> This is an interesting thought.
>>
>> But this does result in a copy in the decompression (i.e. page fault)
>> path, where right now, it is copy free.  The compressed data is
>> decompressed directly from its zsmalloc allocation to the page allocated
>> in the fault path.
> 
> The page fault occurs as soon as the lzo1x compression code starts anyway,
> a

s do all the cache faults... both just occur earlier, so the only
> additional cost is the actual cpu instructions to move the sequence of
> (compressed) bytes from the zsmalloc-allocated area to the end
> of the target page.
> 
> TLB operations can be very expensive, not to mention (as the
> subject of this thread attests) non-portable.
>  

Even if you go for copying chunks followed by decompression, it still
requires two kmaps and kunmaps. Each of these require one local TLB
invlpg. So, a total of 2 local maps + unmaps even with this approach.

The only additional requirement of zsmalloc is that it requires two
mappings which are virtually contiguous. The cost is the same in both
approaches but the current zsmalloc approach presents a much cleaner
interface.

Thanks,
Nitin
