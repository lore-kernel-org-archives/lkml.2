Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756818Ab2FOQhl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 12:37:41 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:45940 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751375Ab2FOQhj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 12:37:39 -0400
MIME-Version: 1.0
Message-ID: <7e925563-082b-468f-a7d8-829e819eeac0@default>
Date: Fri, 15 Jun 2012 09:35:34 -0700 (PDT)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Minchan Kim <minchan@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Nitin Gupta <ngupta@vflare.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Tejun Heo <tj@kernel.org>,
        David Howells <dhowells@redhat.com>, x86@kernel.org,
        Nick Piggin <npiggin@gmail.com>,
        Konrad Rzeszutek Wilk <konrad@darnok.org>
Subject: RE: [PATCH v2 3/3] x86: Support local_flush_tlb_kernel_range
References: <1337133919-4182-1-git-send-email-minchan@kernel.org>
 <1337133919-4182-3-git-send-email-minchan@kernel.org>
 <4FB4B29C.4010908@kernel.org> <1337266310.4281.30.camel@twins>
 <4FDB5107.3000308@linux.vnet.ibm.com>
In-Reply-To: <4FDB5107.3000308@linux.vnet.ibm.com>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 2.0.1.6  (510070) [OL
 12.0.6607.1000 (x86)]
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Seth Jennings [mailto:sjenning@linux.vnet.ibm.com]
> Sent: Friday, June 15, 2012 9:13 AM
> To: Peter Zijlstra
> Cc: Minchan Kim; Greg Kroah-Hartman; Nitin Gupta; Dan Magenheimer; linux-kernel@vger.kernel.org;
> linux-mm@kvack.org; Thomas Gleixner; Ingo Molnar; Tejun Heo; David Howells; x86@kernel.org; Nick
> Piggin
> Subject: Re: [PATCH v2 3/3] x86: Support local_flush_tlb_kernel_range
> 
> On 05/17/2012 09:51 AM, Peter Zijlstra wrote:
> 
> > On Thu, 2012-05-17 at 17:11 +0900, Minchan Kim wrote:
> >>> +++ b/arch/x86/include/asm/tlbflush.h
> >>> @@ -172,4 +172,16 @@ static inline void flush_tlb_kernel_range(unsigned long start,
> >>>       flush_tlb_all();
> >>>  }
> >>>
> >>> +static inline void local_flush_tlb_kernel_range(unsigned long start,
> >>> +             unsigned long end)
> >>> +{
> >>> +     if (cpu_has_invlpg) {
> >>> +             while (start < end) {
> >>> +                     __flush_tlb_single(start);
> >>> +                     start += PAGE_SIZE;
> >>> +             }
> >>> +     } else
> >>> +             local_flush_tlb();
> >>> +}
> >
> > It would be much better if you wait for Alex Shi's patch to mature.
> > doing the invlpg thing for ranges is not an unconditional win.
> 
> From what I can tell Alex's patches have stalled.  The last post was v6
> on 5/17 and there wasn't a single reply to them afaict.
> 
> According to Alex's investigation of this "tipping point", it seems that
> a good generic value is 8.  In other words, on most x86 hardware, it is
> cheaper to flush up to 8 tlb entries one by one rather than doing a
> complete flush.
> 
> So we can do something like:
> 
>      if (cpu_has_invlpg && (end - start)/PAGE_SIZE <= 8) {
>              while (start < end) {
> 
> Would this be acceptable?

Hey Seth, Nitin --

After more work digging around zsmalloc and zbud, I really think
this TLB flushing, as well as the "page pair mapping" code can be
completely eliminated IFF zsmalloc is limited to items PAGE_SIZE or
less.  Since this is already true of zram (and in-tree zcache), and
zsmalloc currently has no other users, I think you should seriously
consider limiting zsmalloc in that way, or possibly splitting out
one version of zsmalloc which handles items PAGE_SIZE or less,
and a second version that can handle larger items but has (AFAIK)
no users.

If you consider it an option to have (a version of) zsmalloc
limited to items PAGE_SIZE or less, let me know and we can
get into the details.

Thanks,
Dan
