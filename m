Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758824Ab1E0J4d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 05:56:33 -0400
Received: from service87.mimecast.com ([94.185.240.25]:49934 "HELO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752867Ab1E0J4c convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 05:56:32 -0400
Subject: Re: [PATCH] ARM: Do not allow unaligned accesses when
 CONFIG_ALIGNMENT_TRAP
From: Catalin Marinas <catalin.marinas@arm.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Nicolas Pitre <nico@fluxnic.net>, Will Deacon <Will.Deacon@arm.com>,
        =?ISO-8859-1?Q?M=E5ns_Rullg=E5rd?= <mans@mansr.com>,
        lkml <linux-kernel@vger.kernel.org>, ak@linux.intel.com,
        Andrew Morton <akpm@linux-foundation.org>, sam@ravnborg.org,
        linux-arm-kernel@lists.infradead.org
In-Reply-To: <20110527095111.GC21100@e102109-lin.cambridge.arm.com>
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
Organization: ARM Limited
Date: Fri, 27 May 2011 10:56:20 +0100
Message-ID: <1306490180.21096.2.camel@e102109-lin.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1
X-OriginalArrivalTime: 27 May 2011 09:56:40.0650 (UTC) FILETIME=[605DEAA0:01CC1C54]
X-MC-Unique: 111052710562705401
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-05-27 at 10:51 +0100, Catalin Marinas wrote:
> On Fri, May 27, 2011 at 09:54:14AM +0100, Russell King - ARM Linux wrote:
> > On Fri, May 27, 2011 at 09:38:08AM +0100, Catalin Marinas wrote:
> > > OK, I tried this now:
> > >
> > > -fconserve-stack: we get unaligned accesses on the stack because the
> > > newer versions of gcc turned unaligned accesses on by default.
> > >
> > > -fconserve-stack -mno-unaligned-access: the stack variables are aligned.
> > > We probably get the benefit of -fconserve-stack as well.
> > >
> > > So as per the initial post in this thread, we could have
> > > -mno-unaligned-access on ARM always on (when CONFIG_ALIGNMENT_TRAP). As
> > > Nicolas suggested, we could compile some files with -munaligned-access
> > > (and maybe -fno-conserve-stack).
> > >
> > > I raised this with the gcc guys so they are looking into it. But it
> > > really doesn't look like a gcc bug as long as -mno-unaligned-access is
> > > taken into account.
> > 
> > Ok, we need to check one last thing, and that's what the behaviour is
> > with -mno-unaligned-access and packed structures (such as the ethernet
> > header).  If it makes no difference, then I suggest we always build
> > with -mno-unaligned-access.
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

For completeness, I tried with "unsigned short b" in the structure above
hoping that the compiler would notice that it is 16-bit aligned.
Unfortunately, it doesn't. Code below with -mno-unaligned-access:

00000000 <set>:
   0:   e1a03421        lsr     r3, r1, #8
   4:   e5c01006        strb    r1, [r0, #6]
   8:   e5c03007        strb    r3, [r0, #7]
   c:   e12fff1e        bx      lr

-- 
Catalin


