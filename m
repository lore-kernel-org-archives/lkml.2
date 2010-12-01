Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756332Ab0LASzL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 13:55:11 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:2682 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753007Ab0LASzJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 13:55:09 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6184"; a="65057777"
Subject: Re: [PATCH] drivers: char: hvc: add arm JTAG DCC console support
From: Daniel Walker <dwalker@codeaurora.org>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        Tony Lindgren <tony@atomide.com>, Arnd Bergmann <arnd@arndb.de>,
        Nicolas Pitre <nico@fluxnic.net>, Greg Kroah-Hartman <gregkh@suse.de>,
        Mike Frysinger <vapier@gentoo.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Randy Dunlap <randy.dunlap@oracle.com>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        linuxppc-dev@lists.ozlabs.org
In-Reply-To: <4CF5DD63.40803@codeaurora.org>
References: <1291145141-18301-1-git-send-email-dwalker@codeaurora.org>
	 <4CF5DD63.40803@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 01 Dec 2010 10:54:56 -0800
Message-ID: <1291229696.14404.39.camel@c-dwalke-linux.qualcomm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-11-30 at 21:30 -0800, Stephen Boyd wrote:
> On 11/30/2010 11:25 AM, Daniel Walker wrote:
> > @@ -682,6 +682,15 @@ config HVC_UDBG
> >         select HVC_DRIVER
> >         default n
> >  
> > +config HVC_DCC
> > +       bool "ARM JTAG DCC console"
> > +       depends on ARM
> > +       select HVC_DRIVER
> > +       help
> > +         This console uses the JTAG DCC on ARM to create a console under the HVC
> 
> Looks like you added one too many spaces for indent here.

The first line is fine, but the other two might need an extra space.

> > diff --git a/drivers/char/hvc_dcc.c b/drivers/char/hvc_dcc.c
> > new file mode 100644
> > index 0000000..6470f63
> > --- /dev/null
> > +++ b/drivers/char/hvc_dcc.c
> > +static inline u32 __dcc_getstatus(void)
> > +{
> > +	u32 __ret;
> > +
> > +	asm("mrc p14, 0, %0, c0, c1, 0	@ read comms ctrl reg"
> > +		: "=r" (__ret) : : "cc");
> > +
> > +	return __ret;
> > +}
> 
> Without marking this asm volatile my compiler decides it can cache the
> value of __ret in a register and then check the value of it continually
> in hvc_dcc_put_chars() (I had to replace get_wait/put_wait with 1 and
> fixup the branch otherwise my disassembler barfed on __dcc_(get|put)char).
> 
> 
> 00000000 <hvc_dcc_put_chars>:
>    0:   ee103e11        mrc     14, 0, r3, cr0, cr1, {0}
>    4:   e3a0c000        mov     ip, #0  ; 0x0
>    8:   e2033202        and     r3, r3, #536870912      ; 0x20000000
>    c:   ea000006        b       2c <hvc_dcc_put_chars+0x2c>
>   10:   e3530000        cmp     r3, #0  ; 0x0
>   14:   1afffffd        bne     10 <hvc_dcc_put_chars+0x10>
>   18:   e7d1000c        ldrb    r0, [r1, ip]
>   1c:   ee10fe11        mrc     14, 0, pc, cr0, cr1, {0}
>   20:   2afffffd        bcs     1c <hvc_dcc_put_chars+0x1c>
>   24:   ee000e15        mcr     14, 0, r0, cr0, cr5, {0}
>   28:   e28cc001        add     ip, ip, #1      ; 0x1
>   2c:   e15c0002        cmp     ip, r2
>   30:   bafffff6        blt     10 <hvc_dcc_put_chars+0x10>
>   34:   e1a00002        mov     r0, r2
>   38:   e12fff1e        bx      lr
> 
> As you can see, the value of the mrc is checked against DCC_STATUS_TX
> (bit 29) and then stored in r3 for later use. Marking this volatile
> produces the following:
> 
> 00000000 <hvc_dcc_put_chars>:
>    0:   e3a03000        mov     r3, #0  ; 0x0
>    4:   ea000007        b       28 <hvc_dcc_put_chars+0x28>
>    8:   ee100e11        mrc     14, 0, r0, cr0, cr1, {0}
>    c:   e3100202        tst     r0, #536870912  ; 0x20000000
>   10:   1afffffc        bne     8 <hvc_dcc_put_chars+0x8>
>   14:   e7d10003        ldrb    r0, [r1, r3]
>   18:   ee10fe11        mrc     14, 0, pc, cr0, cr1, {0}
>   1c:   2afffffd        bcs     18 <hvc_dcc_put_chars+0x18>
>   20:   ee000e15        mcr     14, 0, r0, cr0, cr5, {0}
>   24:   e2833001        add     r3, r3, #1      ; 0x1
>   28:   e1530002        cmp     r3, r2
>   2c:   bafffff5        blt     8 <hvc_dcc_put_chars+0x8>
>   30:   e1a00002        mov     r0, r2
>   34:   e12fff1e        bx      lr
> 
> which looks better.
> 
> I marked all the asm in this driver as volatile. Is that correct?

Are you talking about __dcc_getstatus only? I don't think adding
volatile is going to hurt anything, if not having it causes problems.

> > +#if defined(CONFIG_CPU_V7)
> > +static inline char __dcc_getchar(void)
> > +{
> > +	char __c;
> > +
> > +	asm("get_wait:	mrc p14, 0, pc, c0, c1, 0                          \n\
> > +			bne get_wait                                       \n\
> > +			mrc p14, 0, %0, c0, c5, 0	@ read comms data reg"
> > +		: "=r" (__c) : : "cc");
> > +
> > +	return __c;
> > +}
> > +#else
> > +static inline char __dcc_getchar(void)
> > +{
> > +	char __c;
> > +
> > +	asm("mrc p14, 0, %0, c0, c5, 0	@ read comms data reg"
> > +		: "=r" (__c));
> > +
> > +	return __c;
> > +}
> > +#endif
> > +
> > +#if defined(CONFIG_CPU_V7)
> > +static inline void __dcc_putchar(char c)
> > +{
> > +	asm("put_wait:	mrc p14, 0, pc, c0, c1, 0                 \n\
> > +			bcs put_wait                              \n\
> > +			mcr p14, 0, %0, c0, c5, 0                   "
> > +	: : "r" (c) : "cc");
> > +}
> > +#else
> > +static inline void __dcc_putchar(char c)
> > +{
> > +	asm("mcr p14, 0, %0, c0, c5, 0	@ write a char"
> > +		: /* no output register */
> > +		: "r" (c));
> > +}
> > +#endif
> > +
> 
> I don't think both the v7 and v6 functions are necessary. It seems I can
> get away with just the second version of __dcc_(get|put)char() on a v7.
> The mrc p14, 0, pc, c0, c1, 0 will assign the top 4 bits (31-28) to the
> condition codes NZCV on v7. It also looks like on an ARM11 (a v6) will
> also do the same thing if I read the manuals right. The test in the
> inline assembly is saying, wait for a character to be ready or wait for
> a character to be read then actually write a character or read one. The
> code in hvc_dcc_put_chars() is already doing the same thing, albeit in a
> slightly different form. Instead of getting the status bits put into the
> condition codes and looping with bne or bcs it will read the register,
> and it with bit 29 or bit 28 to see if it should wait and then continue
> with the writing/reading. I think you can just drop the looping for the
> v7 version of the functions and have this driver work on v6 and v7.

We could maybe drop the looping for TX, but RX has no C based looping
even tho for v7 it's recommended that we loop (presumably for v6 it's
not recommended).

> Alternatively, you can make some function that says tx buffer is empty,
> rx buffer is full or something but I don't see how saving a couple
> instructions buys us much when we can have one driver for v6 and v7.
> 
> I see that Tony Lindgren modified the DCC macros for v7 in commit
> 200b7a8 (ARM: 5884/1: arm: Fix DCC console for v7, 2010-01-19). I'm not
> sure why though, since it seems that a v6 and a v7 should really do the
> same thing by waiting for the buffers to be ready before filling them or
> reading them. Which probably means we can get low-level dcc debugging on
> all targets if I'm not mistaken.

This is primarily why these function look they way they do. I'd like to
hear from Tony, because he apparent didn't think they did the same
thing.

> > +static int hvc_dcc_put_chars(uint32_t vt, const char *buf, int count)
> > +{
> > +	int i;
> > +
> > +	for (i = 0; i < count; i++) {
> > +		while (__dcc_getstatus() & DCC_STATUS_TX)
> > +			cpu_relax();
> > +
> > +		__dcc_putchar((char)(buf[i] & 0xFF));
> 
> Is this & 0xFF and cast to char unnecessary? buf is a char array, and
> chars are always 8 bits. Can't we just do __dcc_putchar(buf[i])?

Yeah, doesn't seem like it.

> > +static int hvc_dcc_get_chars(uint32_t vt, char *buf, int count)
> > +{
> > +	int i;
> > +
> > +	for (i = 0; i < count; ++i) {
> > +		int c = -1;
> > +
> > +		if (__dcc_getstatus() & DCC_STATUS_RX)
> > +			c = __dcc_getchar();
> > +		if (c < 0)
> > +			break;
> > +		buf[i] = c;
> > +	}
> 
> I think this for loop can be simplified. __dcc_getchar() returns a char.
> It never returns -1, so the check for c < 0 can't be taken if
> __dcc_getstatus() & DCC_STATUS_RX is true. The only case you break the
> loop in then is if __dcc_getstatus() & DCC_STATUS_RX is false. So you
> can have a simple if-else and assign buf[i] in the if branch and break
> in the else branch.
> 

Like this?

	for (i = 0; i < count; ++i) {

		if (__dcc_getstatus() & DCC_STATUS_RX)
			buf[i] = __dcc_getchar();
		else
			break;
	}

It's a micro clean up I guess ..

Daniel
-- 

Sent by a consultant of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

