Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754321Ab1BSXQ6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Feb 2011 18:16:58 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:41759 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753395Ab1BSXQ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Feb 2011 18:16:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=waofUxYON92L7Dx3+nSsGezM+/c74nCW3yuBSsFFORCJDZ0fGnVzysEukav7+G9LPp
         6QNYUCiWb6MptcknkzebhjHGXT2yvb2Znipu5q93qEoqkldszcqfTzwFBSG9zR67zoDq
         qyYLPl0qpwPb8zicd4uAQbPTwSQUvCGz69oAs=
MIME-Version: 1.0
In-Reply-To: <20110219183027.GT29493@n2100.arm.linux.org.uk>
References: <1295891761-18366-1-git-send-email-catalin.marinas@arm.com>
	<1295891761-18366-13-git-send-email-catalin.marinas@arm.com>
	<20110212104400.GF15616@n2100.arm.linux.org.uk>
	<1297689846.31111.43.camel@e102109-lin.cambridge.arm.com>
	<20110219183027.GT29493@n2100.arm.linux.org.uk>
Date: Sat, 19 Feb 2011 23:16:56 +0000
X-Google-Sender-Auth: E1A3Tlp-KyntwOzC5ocYH2cNgQY
Message-ID: <AANLkTimrwJA_KkfueXohLbTe5-Ji57P127WCw-h_0umF@mail.gmail.com>
Subject: Re: [PATCH v4 12/19] ARM: LPAE: Add context switching support
From: Catalin Marinas <catalin.marinas@arm.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id p1JNH6Ci022771

On Saturday, 19 February 2011, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:
> On Mon, Feb 14, 2011 at 01:24:06PM +0000, Catalin Marinas wrote:
>> On Sat, 2011-02-12 at 10:44 +0000, Russell King - ARM Linux wrote:
>> > On Mon, Jan 24, 2011 at 05:55:54PM +0000, Catalin Marinas wrote:
>> > > +#ifdef CONFIG_ARM_LPAE
>> > > +#define cpu_set_asid(asid) {                                         \
>> > > +     unsigned long ttbl, ttbh;                                       \
>> > > +     asm("   mrrc    p15, 0, %0, %1, c2              @ read TTBR0\n" \
>> > > +         "   mov     %1, %1, lsl #(48 - 32)          @ set ASID\n"   \
>> > > +         "   mcrr    p15, 0, %0, %1, c2              @ set TTBR0\n"  \
>> > > +         : "=r" (ttbl), "=r" (ttbh)                                  \
>> > > +         : "r" (asid & ~ASID_MASK));                                 \
>> >
>> > This is wrong:
>> > 1. It does nothing with %2 (the new asid)
>> > 2. it shifts the high address bits of TTBR0 left 16 places each time its
>> >    called.
>>
>> It was worse actually, not even compiled in because it had output
>> arguments but it wasn't volatile. Some early clobber is also needed.
>> What about this:
>>
>> #define cpu_set_asid(asid) {                                          \
>>       unsigned long ttbl, ttbh;                                       \
>>       asm volatile(                                                   \
>>       "       mrrc    p15, 0, %0, %1, c2              @ read TTBR0\n" \
>>       "       mov     %1, %2, lsl #(48 - 32)          @ set ASID\n"   \
>>       "       mcrr    p15, 0, %0, %1, c2              @ set TTBR0\n"  \
>>       : "=&r" (ttbl), "=&r" (ttbh)                                    \
>>       : "r" (asid & ~ASID_MASK));                                     \
>> }
>
> So we don't care about the low 16 bits of ttbh which can be simply zeroed?

Since the pgd is always allocated from lowmem, it is within 32-bit of
physical address and we can safely ignore ttbh. I could write a
comment here to this.

Catalin

-- 
Catalin
���{.n�+�������+%�����ݶ��w��{.n�+����{��G�����{ay�ʇڙ�,j��f���h��������z_�(�階�ݢj"���m������G������?����&���~��iO��z��v�^�m����������?�I�
