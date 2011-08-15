Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754285Ab1HOO7g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 10:59:36 -0400
Received: from DMZ-MAILSEC-SCANNER-4.MIT.EDU ([18.9.25.15]:46252 "EHLO
	dmz-mailsec-scanner-4.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753937Ab1HOO7e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 10:59:34 -0400
X-AuditID: 1209190f-b7b44ae000000a24-0a-4e4933bd62dd
Message-ID: <4E493449.70907@mit.edu>
Date: Mon, 15 Aug 2011 10:59:21 -0400
From: Andy Lutomirski <luto@MIT.EDU>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20110707 Thunderbird/5.0
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>
CC: melwyn lobo <linux.melwyn@gmail.com>,
        Denys Vlasenko <vda.linux@googlemail.com>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, borislav.petkov@amd.com
Subject: Re: x86 memcpy performance
References: <a5a38901541cbe2805361c1887f2f395.squirrel@www.skyhub.de>
In-Reply-To: <a5a38901541cbe2805361c1887f2f395.squirrel@www.skyhub.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrHKsWRmVeSWpSXmKPExsUixCmqrbvX2NPP4NsCC4uLbRfZLK4ulrX4
	vOEfm8W0jeIWl3fNYbN4/jjcYsulZlaLzZumMls86nvLbrHz4QNGBy6P7619LB6tl/6yeVx5
	yuFxq+0Ps8fOWXfZPZ5OmMzu8e7cOXaPEzN+s3h83iTncaLlC2sAVxSXTUpqTmZZapG+XQJX
	xpQ1a1kK1nJXLPnI28B4l6OLkZNDQsBEonHeNTYIW0ziwr31QDYXh5DAPkaJVY9eMEE4Gxgl
	Dv1+xQ7hvGWSeHTmLCNIC6+AisSx5rXMIDaLgKrErKMfWEFsNqB4x9IHTCC2qECQxP3fDSwQ
	9YISJ2c+AbNFBJQkvi6aC7aBWeArk8TBoxvAmoUFlCVObtoKViQk4Cpx4skvdhCbU8BNYtus
	20D3cQA1WEt8210EEmYWkJfY/nYO8wRGwVlIVsxCqJqFpGoBI/MqRtmU3Crd3MTMnOLUZN3i
	5MS8vNQiXRO93MwSvdSU0k2M4KiS5N/B+O2g0iFGAQ5GJR7eFe/c/YRYE8uKK3MPMUpyMCmJ
	8s4HxqQQX1J+SmVGYnFGfFFpTmrxIUYJDmYlEd6ZRkA53pTEyqrUonyYlDQHi5I4b+MOBz8h
	gfTEktTs1NSC1CKYrAwHh5IE73mQoYJFqempFWmZOSUIaSYOTpDhPEDDz4LU8BYXJOYWZ6ZD
	5E8x6nIsuzX/GKMQS15+XqqUOO8WkCIBkKKM0jy4ObBk+IpRHOgtYYhRPMBECjfpFdASJqAl
	t3Z5gCwpSURISTUwhn5btk9YTq54yTz2H1wBi2p2Zy7Y5hL5hC+Jpf15fV26UMfm3b8uLPfv
	2b+12iqu7pSF4JS1n2evmhOVLnjFWYdH2i2bQyZUQF5eusY5apF2mI7eb1OW4h03OdJkCna8
	+/d1D/fVc1Gis2f9PJzxXU8vyFkyTW9XhM/turx8ezdT85qb9+uVWIozEg21mIuKEwFMx+MJ
	YQMAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/15/2011 10:55 AM, Borislav Petkov wrote:
> On Mon, 15 August, 2011 3:27 pm, melwyn lobo wrote:
>> Hi,
>> Was on a vacation for last two days. Thanks for the good insights into
>> the issue.
>> Ingo, unfortunately the data we have is on a soon to be released
>> platform and strictly confidential at this stage.
>>
>> Boris, thanks for the patch. On seeing your patch:
>> +void *__sse_memcpy(void *to, const void *from, size_t len)
>> +{
>> +       unsigned long src = (unsigned long)from;
>> +       unsigned long dst = (unsigned long)to;
>> +       void *p = to;
>> +       int i;
>> +
>> +       if (in_interrupt())
>> +               return __memcpy(to, from, len)
>> So what is the reason we cannot use sse_memcpy in interrupt context.
>> (fpu registers not saved ? )
>
> Because, AFAICT, when we handle an #NM exception while running
> sse_memcpy in an IRQ handler, we might need to allocate FPU save state
> area, which in turn, can sleep. Then, we might get another IRQ while
> sleeping and we should be deadlocked.
>
> But let me stress on the "AFAICT" above, someone who actually knows the
> FPU code should correct me if I'm missing something.

I don't think you ever get #NM as a result of kernel_fpu_begin, but you 
can certainly have problems when kernel_fpu_begin nests by accident. 
There's irq_fpu_usable() for this.

(irq_fpu_usable() reads cr0 sometimes and I suspect it can be slow.)

--Andy
