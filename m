Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932461Ab1EYHiY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 03:38:24 -0400
Received: from mail-yi0-f46.google.com ([209.85.218.46]:45123 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754666Ab1EYHiX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 03:38:23 -0400
Message-ID: <4DDCB1EB.4020707@landley.net>
Date: Wed, 25 May 2011 02:38:19 -0500
From: Rob Landley <rob@landley.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110424 Thunderbird/3.1.10
MIME-Version: 1.0
To: Ralf Baechle <ralf@linux-mips.org>
CC: linux-kernel@vger.kernel.org, jaxboe@fusionio.com
Subject: Re: MIPS panic in 2.6.39 (bisected to 7eaceaccab5f)
References: <4DDB5673.5060206@landley.net> <20110524143937.GB30117@linux-mips.org>
In-Reply-To: <20110524143937.GB30117@linux-mips.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/24/2011 09:39 AM, Ralf Baechle wrote:
> On Tue, May 24, 2011 at 01:55:47AM -0500, Rob Landley wrote:
> 
>> You can reproduce this under qemu by grabbing:
>>
>>   http://landley.net/aboriginal/downloads/binaries/system-image-mips.tar.bz2
>>
>> If you extract that tarball and ./run-emulator.sh it should boot
>> to a mips shell prompt.  Now build your own vmlinux to replace the
>> kernel in there with (using the attached .config), and try again,
>> you should get a panic message something like:
>>
>> PID hash table entries: 512 (order: -1, 2048 bytes)
>> Dentry cache hash table entries: 16384 (order: 4, 65536 bytes)
>> Inode-cache hash table entries: 8192 (order: 3, 32768 bytes)
>> Primary instruction cache 2kB, VIPT, 2-way, linesize 16 bytes.
>> Primary data cache 2kB, 2-way, VIPT, no aliases, linesize 16 bytes
>> Writing ErrCtl register=00000000
>> Readback ErrCtl register=00000000
>> Memory: 125836k/127004k available (2172k kernel code, 1168k reserved, 507k data, 156k init, 0k highmem)
>> SLUB: Genslabs=9, HWalign=64, Order=0-3, MinObjects=0, CPUs=1, Nodes=1
>> NR_IRQS:256
>> CPU 0 Unable to handle kernel paging request at virtual address 00000080, epc == 803a09b0, ra == 803a0990
>> Oops[#1]:
>> Cpu 0
>> $ 0   : 00000000 00000050 1bdc0001 00000000
>> $ 4   : 00000018 00000000 00000001 00000000
>> $ 8   : fffffff8 00000001 00000000 fffffffc
>> $12   : fffffffc 00000000 00000008 fffffffc
>> $16   : 803bce58 803bef35 803c0000 803c0000
>> $20   : 80380000 00000000 00000000 00000000
>> $24   : 00000000 00000000                  
>> $28   : 80382000 80383ec8 00000000 803a0990
>> Hi    : 00000000
>> Lo    : 00000000
>> epc   : 803a09b0 arch_init_irq+0x38/0x15c
>>     Not tainted
>> ra    : 803a0990 arch_init_irq+0x18/0x15c
>> Status: 10000002    KERNEL EXL 
>> Cause : 0080000c
>> BadVA : 00000080
>> PrId  : 00019300 (MIPS 24Kc)
>> Process swapper (pid: 0, threadinfo=80382000, task=803855c0, tls=00000000)
>> Stack : 803a17d4 87804000 803bce58 803bef35 803c0000 803c0000 8039fac4 8039fac4
>>         00000000 803bce58 80380f04 0000004a 8039f454 00000000 803beee0 00000000
>>         00000000 00000000 00000000 00000000 00000000 80315f00 00000000 00000000
>>         00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
>>         00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
>>         ...
>> Call Trace:
>> [<803a09b0>] arch_init_irq+0x38/0x15c
>> [<8039fac4>] start_kernel+0x1f0/0x33c
>> [<80315f00>] kernel_entry+0x0/0x94
>>
>>
>> Code: 8c437048  3c021bdc  34420001 <ac620080> 24030001  3c02803c  080e827d  ac437040  8c43701c 
>>
>>
>> I bisected it the problem to commit
>> 7eaceaccab5f40bbfda044629a6298616aeaed50, but have no idea what
>> the actual bug is.  (Other than "a null pointer dereference from
>> arch_init_irq", I just dunno _why_.)
> 
> That commit just does not seem to be the answer.

It's possible my script misbisected it or found some other unrelated
issue, I can try bisecting again...

Yup, my earlier bisect got confused by a different bug.  This specific
bug was introduced by:

af3a1f6f4813907e143f87030cde67a9971db533 is the first bad commit
commit af3a1f6f4813907e143f87030cde67a9971db533
Author: Ralf Baechle <ralf@linux-mips.org>
Date:   Tue Mar 29 11:43:19 2011 +0200

    MIPS: Malta: Fix GCC 4.6.0 build error

      CC      arch/mips/mti-malta/malta-init.o
    arch/mips/mti-malta/malta-init.c: In function 'prom_init':
    arch/mips/mti-malta/malta-init.c:196:6: error: variable 'result' set
but not used [-Werror=unused-but-set-variable]
    cc1: all warnings being treated as errors

    Signed-off-by: Ralf Baechle <ralf@linux-mips.org>

:040000 040000 58f11c3479ae15f2c4d0a3e7486c7aa4e1ca3e96
33ad31b666926e7090b5165b79773eee38b58229 M      arch

And this time I checked out the commit, confirmed it had the problem,
did "git show | patch -p1 -R", rebuilt, and confirmed that the problem
was fixed.

Sorry Jens, my bad...

> Can you provide the kernel disassembly for the arch_init_irq() function?

803a0978 <arch_init_irq>:
803a0978:       27bdffe0        addiu   sp,sp,-32
803a097c:       afbf0018        sw      ra,24(sp)
803a0980:       0c0e8a23        jal     803a288c <init_i8259_irqs>
803a0984:       00000000        nop
803a0988:       0c0e8a4e        jal     803a2938 <mips_cpu_irq_init>
803a098c:       00000000        nop
803a0990:       3c028038        lui     v0,0x8038
803a0994:       8c426ae0        lw      v0,27360(v0)
803a0998:       1040000a        beqz    v0,803a09c4 <arch_init_irq+0x4c>
803a099c:       3c02803c        lui     v0,0x803c
803a09a0:       3c02803c        lui     v0,0x803c
803a09a4:       8c437048        lw      v1,28744(v0)
803a09a8:       3c021bdc        lui     v0,0x1bdc
803a09ac:       34420001        ori     v0,v0,0x1
803a09b0:       ac620080        sw      v0,128(v1)
803a09b4:       24030001        li      v1,1
803a09b8:       3c02803c        lui     v0,0x803c
803a09bc:       080e827d        j       803a09f4 <arch_init_irq+0x7c>
803a09c0:       ac437040        sw      v1,28736(v0)
803a09c4:       8c43701c        lw      v1,28700(v0)
803a09c8:       2402fffa        li      v0,-6
803a09cc:       1462000a        bne     v1,v0,803a09f8 <arch_init_irq+0x80>
803a09d0:       3c02803c        lui     v0,0x803c
803a09d4:       3c04bbc8        lui     a0,0xbbc8
803a09d8:       34820110        ori     v0,a0,0x110
803a09dc:       8c420000        lw      v0,0(v0)
803a09e0:       3c03803c        lui     v1,0x803c
803a09e4:       7c420080        ext     v0,v0,0x2,0x1
803a09e8:       ac627040        sw      v0,28736(v1)
803a09ec:       3c02803c        lui     v0,0x803c
803a09f0:       ac447044        sw      a0,28740(v0)
803a09f4:       3c02803c        lui     v0,0x803c
803a09f8:       8c43701c        lw      v1,28700(v0)
803a09fc:       2862fffa        slti    v0,v1,-6
803a0a00:       14400016        bnez    v0,803a0a5c <arch_init_irq+0xe4>
803a0a04:       3c058038        lui     a1,0x8038
803a0a08:       2862fffc        slti    v0,v1,-4
803a0a0c:       14400007        bnez    v0,803a0a2c <arch_init_irq+0xb4>
803a0a10:       3c02803c        lui     v0,0x803c
803a0a14:       2462ffff        addiu   v0,v1,-1
803a0a18:       2c420002        sltiu   v0,v0,2
803a0a1c:       10400010        beqz    v0,803a0a60 <arch_init_irq+0xe8>
803a0a20:       24a56ae4        addiu   a1,a1,27364
803a0a24:       080e8290        j       803a0a40 <arch_init_irq+0xc8>

And so on.

> Also, does the problem go away if you switch from CONFIG_MIPS_MT_SMP to
> CONFIG_MIPS_MT_DISABLED?  The former is designed to run on all MIPS CPUs
> and on a non-MT enabled CPU core it should just disable MT and run happily
> anyway.  I know there was work on MT support being done by Thiemo Seufer
> and I wonder if that ever made it into qemu and if so, if qemu gets MT
> right.

I switched to that config symbol and it made no difference.

Have you guys been able to reproduce the problem?

Rob
