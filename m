Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754953Ab1E0Mqp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 08:46:45 -0400
Received: from unicorn.mansr.com ([78.86.181.103]:39287 "EHLO
	unicorn.mansr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753903Ab1E0Mql convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 08:46:41 -0400
From: =?iso-8859-1?Q?M=E5ns_Rullg=E5rd?= <mans@mansr.com>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Nicolas Pitre <nico@fluxnic.net>, Will Deacon <Will.Deacon@arm.com>,
        =?iso-8859-1?Q?M?= =?iso-8859-1?Q?=E5ns_Rullg=E5rd?= 
	<mans@mansr.com>,
        lkml <linux-kernel@vger.kernel.org>, ak@linux.intel.com,
        Andrew Morton <akpm@linux-foundation.org>, sam@ravnborg.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] ARM: Do not allow unaligned accesses when CONFIG_ALIGNMENT_TRAP
References: <20110524171331.GA2941@arm.com>
	<20110525111405.GA12010@e102109-lin.cambridge.arm.com>
	<20110525124348.GA2340@arm.com> <yw1xaaeanbxe.fsf@unicorn.mansr.com>
	<BANLkTim2TOZgB-3Vkv5RcK572Qr07s3=CA@mail.gmail.com>
	<1306429854.26735.9.camel@e102144-lin.cambridge.arm.com>
	<alpine.LFD.2.00.1105261650330.3207@xanadu.home>
	<20110526215101.GL24876@n2100.arm.linux.org.uk>
	<20110527083806.GA21100@e102109-lin.cambridge.arm.com>
	<20110527085414.GP24876@n2100.arm.linux.org.uk>
	<20110527095111.GC21100@e102109-lin.cambridge.arm.com>
Date: Fri, 27 May 2011 13:46:38 +0100
In-Reply-To: <20110527095111.GC21100@e102109-lin.cambridge.arm.com> (Catalin
	Marinas's message of "Fri, 27 May 2011 10:51:11 +0100")
Message-ID: <yw1xlixse2fl.fsf@unicorn.mansr.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Catalin Marinas <catalin.marinas@arm.com> writes:

> On Fri, May 27, 2011 at 09:54:14AM +0100, Russell King - ARM Linux wrote:
>> 
>> Ok, we need to check one last thing, and that's what the behaviour is
>> with -mno-unaligned-access and packed structures (such as the ethernet
>> header).  If it makes no difference, then I suggest we always build
>> with -mno-unaligned-access.
>
> I tried some simple code below:
>
> struct test {
> 	unsigned char a[6];
> 	unsigned long b;
> } __attribute__((packed));
>
> void set(struct test *t, unsigned long v)
> {
> 	t->b = v;
> }
>
> int main(void)
> {
> 	struct test t;
> 	
> 	set(&t, 10);
>
> 	return 0;
> }
>
> With -mno-unaligned-access in newer toolchains, the set() function looks
> like this (compiled with -march=armv7):
>
> 00000000 <set>:
>    0:   e7e7c451        ubfx    ip, r1, #8, #8
>    4:   e7e72851        ubfx    r2, r1, #16, #8
>    8:   e1a03c21        lsr     r3, r1, #24
>    c:   e5c01006        strb    r1, [r0, #6]
>   10:   e5c0c007        strb    ip, [r0, #7]
>   14:   e5c02008        strb    r2, [r0, #8]
>   18:   e5c03009        strb    r3, [r0, #9]
>   1c:   e12fff1e        bx      lr
>
> If I don't pass -mno-unaligned-access later toolchains use unaligned
> accesses by default and the set() function is more efficient:
>
> 00000000 <set>:
>    0:   e5801006        str     r1, [r0, #6]
>    4:   e12fff1e        bx      lr

This is certainly something we should want.  Although some people
expressed concerns over introducing unaligned accesses where there were
previously none, I don't see how this could pose a problem as long as we
make sure strict alignment checking is off.  Some basic testing of code
paths known to use unaligned accesses should suffice IMO.

> The problem is that in addition to that we also get unaligned stack
> variables which are not really efficient. Either way we have a drawback
> somewhere. We could argue that -fconserve-stack is badly implemented on
> ARM.

Unless someone can demonstrate a clear win from -fconserve-stack, I
think it's pretty obvious that this flag does more harm than good on
ARM, especially in conjunction with unaligned accesses being allowed.

If the stack packing could be disabled while retaining the other
(presumably beneficial) effects of -fconserve-stack, it might be
reconsidered.

-- 
Måns Rullgård
mans@mansr.com
