Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755615Ab0FIHnR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 03:43:17 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:44610 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752986Ab0FIHnQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 03:43:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=gw71ttEgz4APn6VF5VBILJfkcxaVi1BWksirOL6W1TIszs6Tqazry7Z825dOcFDTqd
         /h6Julzd6vUeUvMYgCEuf0JkqKtCwjcRyR1EwnvP292sJ7ivV7OTdY7PIhX/8A0rIiZL
         twQH26U3sg1cwaB6LpZt7O76Dma2nPUiYw7Uw=
MIME-Version: 1.0
In-Reply-To: <1276068030_13535@mail4.comsite.net>
References: <1275761686-4996-1-git-send-email-vapier@gentoo.org> 
	<1276068030_13535@mail4.comsite.net>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Wed, 9 Jun 2010 03:42:55 -0400
Message-ID: <AANLkTin_MR82jafZkkzfv33dO6DqyFnHUiU4g6luXB_0@mail.gmail.com>
Subject: Re: [PATCH 1/2] vmlinux.lds.h: allow people to set a smaller rootfs 
	alignment
To: Milton Miller <miltonm@bga.com>
Cc: linux-kernel@vger.kernel.org, Tim Abbott <tabbott@ksplice.com>,
       "H. Peter Anvin" <hpa@zytor.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 9, 2010 at 03:20, Milton Miller wrote:
> On Sat,  5 Jun 2010 at around 14:14:45 -0400, Mike Frysinger wrote:
>> Add a new INIT_RAMFS() define to compliment the existing INIT_RAM_FS, but
>> this one lets people control the alignment.
>>
>> diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
>> index 48c5299..9ca268f 100644
>> --- a/include/asm-generic/vmlinux.lds.h
>> +++ b/include/asm-generic/vmlinux.lds.h
>> @@ -619,14 +619,15 @@
>>               VMLINUX_SYMBOL(__security_initcall_end) = .;
>>
>>  #ifdef CONFIG_BLK_DEV_INITRD
>> -#define INIT_RAM_FS                                                  \
>> -     . = ALIGN(PAGE_SIZE);                                           \
>> +#define INIT_RAMFS(align)                                            \
>> +     . = ALIGN(align);                                               \
>>       VMLINUX_SYMBOL(__initramfs_start) = .;                          \
>>       *(.init.ramfs)                                                  \
>>       VMLINUX_SYMBOL(__initramfs_end) = .;
>>  #else
>> -#define INIT_RAM_FS
>> +#define INIT_RAMFS(align)
>>  #endif
>> +#define INIT_RAM_FS INIT_RAMFS(PAGE_SIZE)
>
> [ and patch 2/2 calls the new macro with align 4, for only blackfin ].
>
> Mike,
> As you identified, the alignment for the __initramfs is too large.
>
> As can be seen by the grammer of the INIT_RAM_FS in [1], the section
> itself always requires alignment of exactly 4 [2].
>
> I realize it requires a bit more auditing and cordination, but we
> should really just change the macro to align to 4.
>
> [1] Documentation/early-userspace/buffer-format.txt,
> [2] for the general case; as compressed fragments are aligin(1)

the back story is to bring the alignment back to the way it was before
for Blackfin systems, not to drop it down to some min value.  so dont
credit me with too much here ;).

if we look at the alignments before the unification, we can easily see
why Tim was a bit cautious and started the common value at PAGE_SIZE:
alpha: PAGE_SIZE
arm: 32
avr32: 32
blackfin: 4
cris: none (so default from the input sections == 4?)
frv: 4096 (== PAGE_SIZE?)
h8300: 4
ia64: none (so default from the input sections == 4?)
m32r: 4096 (== PAGE_SIZE?)
m68k: 8192 (== 2x PAGE_SIZE?)
microblaze: 4096 (== PAGE_SIZE?)
mips: PAGE_SIZE
mn10300: PAGE_SIZE
parisc: PAGE_SIZE
powerpc: PAGE_SIZE
s390: 0x100
score: PAGE_SIZE
sh: PAGE_SIZE
sparc: PAGE_SIZE
x86: PAGE_SIZE
xtensa: 4096 (== PAGE_SIZE?)

i have no problem changing the default to 4 since it works fine on
Blackfin systems.  your analysis of the source alignment also seems
reasonable ... i assume that the 8 byte fields in the source cpio
arent referenced directly, otherwise it'd cause problems on 64bit
systems that require 64bit values to be naturally aligned.

beyond that, i dont see why any larger alignment values would be
required since this source archive isnt executed directly.  it gets
expanded into a ramfs and then freed with the rest of the init stuff.
-mike
