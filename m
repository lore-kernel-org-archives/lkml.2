Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753432Ab1ARUzM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jan 2011 15:55:12 -0500
Received: from mailhost.informatik.uni-hamburg.de ([134.100.9.70]:56621 "EHLO
	mailhost.informatik.uni-hamburg.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752839Ab1ARUzK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jan 2011 15:55:10 -0500
Message-ID: <4D35FE23.1010102@metafoo.de>
Date: Tue, 18 Jan 2011 21:54:59 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20101226 Icedove/3.0.11
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] asm-generic/io.h: Fix io{read,write}{16,32}be for big
 endian systems
References: <1295374261-19609-1-git-send-email-lars@metafoo.de> <201101181944.07146.arnd@arndb.de> <4D35E378.70300@metafoo.de> <201101182056.35673.arnd@arndb.de>
In-Reply-To: <201101182056.35673.arnd@arndb.de>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 01/18/2011 08:56 PM, Arnd Bergmann wrote:
> On Tuesday 18 January 2011 20:01:12 Lars-Peter Clausen wrote:
>> Well, i've though about that as well, but in the current asm-generic/io.h readl is
>> unconditionally defined as cpu_to_le32(__raw_readl(addr)) and ioread32 is defined as
>> readl.
>>
>> So unless an arch io.h undefines those macros and redefines them (which none of the
>> current archs does, as far as i can see), we are o
>>
>> If an arch chooses to redefine ioread or readl, it should probably also redefine
>> ioread{16,32}be.
> 
> Right, but the header file also serves as a template for new architectures
> that cannot directly use it. I would prefer not to give a possibly bad example
> here, especially when it's in a rarely used function.

Maybe I'm missing something here, but if I have a big-endian architecture isn't
ioread{16,32}be what I should use to access iomapped memory?

>>> The right solution is probably to use swab16/swab32 for the
>>> big-endian functions. This also corrects the iowrite functions
>>> which really should be using cpu_to_be32 instead of be32_to_cpu
>>> (although they are always defined to be the same afaict.
>>
>> This would first cause a conversion to little-endian, which is a swap() in the
>> generic case and then you would call swap() again on the result. Which is basically a
>> noop, but I'm not sure if compilers will detect this.
> 
> The overhead of the swab() is certainly dwarfed by the long time spent in
> readl().

Well at least the code size overhead is fundamental:

I have this simple function:

  cycles_t get_cycles(void)
  {
  	return ioread32be(CSR_TIMER_COUNTER(timer));
  }

which when compiled for the lm32 arch results in the following assembler code

with #define ioread32be(addr) be32_to_cpu(__raw_readl(addr)):

  00000128 <get_cycles>:
	mvhi r2,0x4021
	ori r2,r2,0xa100
	lw r1,(r2+0)
	lw r1,(r1+0)
	ret

with #define ioread32be(addr) swap32(ioread32(addr)):

  4001a694 <get_cycles>:
	addi sp,sp,-16
	sw (sp+16),r11
	sw (sp+12),r12
	sw (sp+8),r13
	sw (sp+4),ra
	mvhi r2,0x4021
	ori r2,r2,0xa100
	lw r1,(r2+0)
	mvi r2,24
	mvhi r13,0xff
	lw r12,(r1+0)
	mv r1,r12
	calli 400f6f9c <__lshrsi3>
	mv r11,r1
	mvi r2,24
	mv r1,r12
	calli 400f6f6c <__ashlsi3>
	or r11,r11,r1
	mvi r2,8
	andi r1,r12,0xff00
	calli 400f6f6c <__ashlsi3>
	or r11,r11,r1
	mvi r2,8
	and r1,r12,r13
	calli 400f6f9c <__lshrsi3>
	or r11,r11,r1
	mv r1,r11
	mvi r2,24
	calli 400f6f9c <__lshrsi3>
	mv r12,r1
	mvi r2,24
	mv r1,r11
	calli 400f6f6c <__ashlsi3>
	or r12,r12,r1
	mvi r2,8
	andi r1,r11,0xff00
	calli 400f6f6c <__ashlsi3>
	or r12,r12,r1
	mvi r2,8
	and r1,r11,r13
	calli 400f6f9c <__lshrsi3>
	or r1,r12,r1
	lw ra,(sp+4)
	lw r11,(sp+16)
	lw r12,(sp+12)
	lw r13,(sp+8)
	addi sp,sp,16
	ret


So I as someone who implements arch support has two options either redefine
ioread32be in the arch io header, or use __raw_readl everywhere to access iomap memory.
> 
> I would prefer to swap twice in this case and let the compiler work it out
> if possible. The next best alternative would probably be to define both
> ioread and ioread_be using __raw_readl in combination with a le32_to_cpu
> or be32_to_cpu.
> 
> 	Arnd

- - Lars
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAk01/iMACgkQBX4mSR26RiNRQQCfeS4P27FYN5Sy3oxFqzbjsWAe
NH8Ani1IDQfLoM4kqpkDXneGkQN4HXqz
=OQK1
-----END PGP SIGNATURE-----
