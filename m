Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932206Ab2FOPOA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 11:14:00 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:57931 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932125Ab2FOPN5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 11:13:57 -0400
Message-ID: <4FDB5107.3000308@linux.vnet.ibm.com>
Date: Fri, 15 Jun 2012 10:13:11 -0500
From: Seth Jennings <sjenning@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Minchan Kim <minchan@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Nitin Gupta <ngupta@vflare.org>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Tejun Heo <tj@kernel.org>, David Howells <dhowells@redhat.com>,
        x86@kernel.org, Nick Piggin <npiggin@gmail.com>
Subject: Re: [PATCH v2 3/3] x86: Support local_flush_tlb_kernel_range
References: <1337133919-4182-1-git-send-email-minchan@kernel.org> <1337133919-4182-3-git-send-email-minchan@kernel.org> <4FB4B29C.4010908@kernel.org> <1337266310.4281.30.camel@twins>
In-Reply-To: <1337266310.4281.30.camel@twins>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12061515-7408-0000-0000-000005E20271
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/17/2012 09:51 AM, Peter Zijlstra wrote:

> On Thu, 2012-05-17 at 17:11 +0900, Minchan Kim wrote:
>>> +++ b/arch/x86/include/asm/tlbflush.h
>>> @@ -172,4 +172,16 @@ static inline void flush_tlb_kernel_range(unsigned long start,
>>>       flush_tlb_all();
>>>  }
>>>  
>>> +static inline void local_flush_tlb_kernel_range(unsigned long start,
>>> +             unsigned long end)
>>> +{
>>> +     if (cpu_has_invlpg) {
>>> +             while (start < end) {
>>> +                     __flush_tlb_single(start);
>>> +                     start += PAGE_SIZE;
>>> +             }
>>> +     } else
>>> +             local_flush_tlb();
>>> +}
> 
> 
> It would be much better if you wait for Alex Shi's patch to mature.
> doing the invlpg thing for ranges is not an unconditional win.


>From what I can tell Alex's patches have stalled.  The last post was v6
on 5/17 and there wasn't a single reply to them afaict.

According to Alex's investigation of this "tipping point", it seems that
a good generic value is 8.  In other words, on most x86 hardware, it is
cheaper to flush up to 8 tlb entries one by one rather than doing a
complete flush.

So we can do something like:

     if (cpu_has_invlpg && (end - start)/PAGE_SIZE <= 8) {
             while (start < end) {

Would this be acceptable?

Thanks,
Seth

