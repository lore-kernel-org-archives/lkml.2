Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759501Ab1JGDNX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Oct 2011 23:13:23 -0400
Received: from terminus.zytor.com ([198.137.202.10]:53676 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757290Ab1JGDNW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Oct 2011 23:13:22 -0400
References: <1317945508-19575-1-git-send-email-jistone@redhat.com> <990b8719-066b-4e1d-892f-6a3ea4241fb2@email.android.com> <m2d3e936fn.fsf@firstfloor.org> <4E8E690C.9010206@redhat.com>
User-Agent: K-9 Mail for Android
In-Reply-To: <4E8E690C.9010206@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] x86: Make variable_test_bit reference all of *addr
From: "hpanvin@gmail.com" <hpa@zytor.com>
Date: Thu, 06 Oct 2011 20:12:48 -0700
To: Josh Stone <jistone@redhat.com>, Andi Kleen <andi@firstfloor.org>
CC: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Jakub Jelinek <jakub@redhat.com>
Message-ID: <84050df0-7a6c-4dbe-85b7-ed9e98a813aa@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I mean the volatile in "asm volatile".

Josh Stone <jistone@redhat.com> wrote:

>On 10/06/2011 04:58 PM, Josh Stone wrote:
>> [...]/arch/x86/include/asm/bitops.h: In function ‘can_boost.part.1’:
>> [...]/arch/x86/include/asm/bitops.h:319:2: warning: use of memory
>input without lvalue in asm operand 1 is deprecated [enabled by
>default]
>
>I probably should have noted that Jakub also blamed gcc's behavior, for
>transforming const memory into a literal constant and then complaining
>about lvalues.  He fixed that upstream, and applied to 4.6.1-10.fc16:
>  http://gcc.gnu.org/bugzilla/show_bug.cgi?id=50571
>
>I didn't figure out any automated way to detect the problem in general
>(apart from the presence of that warning), but here's how I'm checking
>kprobes' in particular.
>
>Using gcc-4.6.1-9.fc15.i686:
>> $ objdump -rd arch/x86/kernel/kprobes.o | grep -A1 -w bt
>>      551:	0f a3 05 00 00 00 00 	bt     %eax,0x0
>> 			554: R_386_32	.rodata.cst4
>> $ objdump -s -j .rodata -j .rodata.cst4 arch/x86/kernel/kprobes.o
>> 
>> arch/x86/kernel/kprobes.o:     file format elf32-i386
>> 
>> Contents of section .rodata:
>>  0000 02000000                             ....            
>> Contents of section .rodata.cst4:
>>  0000 4c030000                             L...            
>
>Using gcc-4.6.1-9.fc15.i686, with my variable_test_bit patch:
>> $ objdump -rd arch/x86/kernel/kprobes.o | grep -A1 -w bt
>>      551:	0f a3 05 20 00 00 00 	bt     %eax,0x20
>> 			554: R_386_32	.rodata
>> $ objdump -s -j .rodata arch/x86/kernel/kprobes.o
>> 
>> arch/x86/kernel/kprobes.o:     file format elf32-i386
>> 
>> Contents of section .rodata:
>>  0000 02000000 00000000 00000000 00000000  ................
>>  0010 00000000 00000000 00000000 00000000  ................
>>  0020 4c030000 0f000200 ffff0000 ffcff0c0  L...............
>>  0030 0000ffff 3bbbfff8 03ff2ebb 26bb2e77  ....;.......&..w
>
>Using gcc-4.6.1-10.fc16.i686, with Jakub's fix, without my patch:
>> $ objdump -rd arch/x86/kernel/kprobes.o | grep -A1 -w bt
>>      551:	0f a3 05 20 00 00 00 	bt     %eax,0x20
>> 			554: R_386_32	.rodata
>> $ objdump -s -j .rodata arch/x86/kernel/kprobes.o
>> 
>> arch/x86/kernel/kprobes.o:     file format elf32-i386
>> 
>> Contents of section .rodata:
>>  0000 02000000 00000000 00000000 00000000  ................
>>  0010 00000000 00000000 00000000 00000000  ................
>>  0020 4c030000 0f000200 ffff0000 ffcff0c0  L...............
>>  0030 0000ffff 3bbbfff8 03ff2ebb 26bb2e77  ....;.......&..w
>
>There's some zero-padding on the previous .rodata contents, but then
>starting at 0x20 it now has the full 32-bytes of
>twobyte_is_boostable[].
>
>So Jakub's gcc change fixes this issue independently of my patch, but I
>got the impression from him that the way the kernel is expressing this
>is still in the realm of "gcc might break your expectations here".  If
>that's not the case, then my patch here is only needed if you want to
>cope with prior broken versions.  Jakub, do you have an idea of the
>range of gcc versions broken in this way?
>
>On 10/06/2011 07:02 PM, Andi Kleen wrote:
>> "hpanvin@gmail.com" <hpa@zytor.com> writes:
>>> This is concerning... the kernel relies heavily on asm volatile
>being
>>> a universal memory consumer.  If that is suddenly broken, we are
>f***
>>> in many, many, MANY places in the kernel all of a sudden!
>> 
>> I don't think that's true. We generally add "memory" clobbers for
>this
>> purpose. asm volatile just means "don't move" 
>> 
>> Just this one doesn't have it for unknown reasons (someone
>overoptimizing?)
>
>Which overoptimizing part are you referring to?  The only part of
>variable_test_bit that's not volatile is "m" (*(unsigned long *)addr),
>and throwing volatile in that cast does nothing for the problem (at
>least on gcc-4.6.1-9.fc15).
>
>We can make twobyte_is_boostable[] volatile instead, which does the
>trick, but that seems a kludge to me.
>
>
>Josh

-- 
Sent from my Android phone with K-9 Mail. Please excuse my brevity.
