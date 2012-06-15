Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757417Ab2FOTIa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 15:08:30 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:42088 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757323Ab2FOTI3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 15:08:29 -0400
Message-ID: <4FDB8808.9010508@linux.vnet.ibm.com>
Date: Fri, 15 Jun 2012 14:07:52 -0500
From: Seth Jennings <sjenning@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Dan Magenheimer <dan.magenheimer@oracle.com>
CC: Nitin Gupta <ngupta@vflare.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Minchan Kim <minchan@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Tejun Heo <tj@kernel.org>, David Howells <dhowells@redhat.com>,
        x86@kernel.org, Nick Piggin <npiggin@gmail.com>,
        Konrad Rzeszutek Wilk <konrad@darnok.org>
Subject: Re: [PATCH v2 3/3] x86: Support local_flush_tlb_kernel_range
References: <1337133919-4182-1-git-send-email-minchan@kernel.org> <1337133919-4182-3-git-send-email-minchan@kernel.org> <4FB4B29C.4010908@kernel.org> <1337266310.4281.30.camel@twins> <4FDB5107.3000308@linux.vnet.ibm.com> <7e925563-082b-468f-a7d8-829e819eeac0@default> <4FDB66B7.2010803@vflare.org> <10ea9d19-bd24-400c-8131-49f0b4e9e5ae@default>
In-Reply-To: <10ea9d19-bd24-400c-8131-49f0b4e9e5ae@default>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12061519-7182-0000-0000-000001C1A0C0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> From: Seth Jennings [mailto:sjenning@linux.vnet.ibm.com]

>> To add to what Nitin just sent, without the page mapping, zsmalloc and
>> the late xvmalloc have the same issue.  Say you have a whole class of
>> objects that are 3/4 of a page.  Without the mapping, you can't cross
>> non-contiguous page boundaries and you'll have 25% fragmentation in the
>> memory pool.  This is the whole point of zsmalloc.
> 
> Yes, understood.  This suggestion doesn't change any of that.
> It only assumes that no more than one page boundary is crossed.
> 
> So, briefly, IIRC the "pair mapping" is what creates the necessity
> to do special TLB stuff.  That pair mapping is necessary
> to create the illusion to the compression/decompression code
> (and one other memcpy) that no pageframe boundary is crossed.
> Correct?


Yes.

> The compression code already compresses to a per-cpu page-pair
> already and then that "zpage" is copied into the space allocated
> for it by zsmalloc.  For that final copy, if the copy code knows
> the target may cross a page boundary, has both target pages
> kmap'ed, and is smart about doing the copy, the "pair mapping"
> can be avoided for compression.


The problem is that by "smart" you mean "has access to zsmalloc
internals".  zcache, or any user, would need the know the kmapped
address of the first page, the offset to start at within that page, and
the kmapped address of the second page in order to do the smart copy
you're talking about.  Then the complexity to do the smart copy that
would have to be implemented in each user.


> The decompression path calls lzo1x directly and it would be
> a huge pain to make lzo1x smart about page boundaries.  BUT
> since we know that the decompressed result will always fit
> into a page (actually exactly a page), you COULD do an extra
> copy to the end of the target page (using the same smart-
> about-page-boundaries copying code from above) and then do
> in-place decompression, knowing that the decompression will
> not cross a page boundary.  So, with the extra copy, the "pair
> mapping" can be avoided for decompression as well.


This is an interesting thought.

But this does result in a copy in the decompression (i.e. page fault)
path, where right now, it is copy free.  The compressed data is
decompressed directly from its zsmalloc allocation to the page allocated
in the fault path.

Doing this smart copy stuff would move most of the complexity out of
zsmalloc into the user which defeats the purpose of abstracting the
functionality out in the first place: so the each user that wants to do
something like this doesn't have to reinvent the wheel.

--
Seth

