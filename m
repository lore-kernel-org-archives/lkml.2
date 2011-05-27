Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758723Ab1E0HzZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 03:55:25 -0400
Received: from h5.dl5rb.org.uk ([81.2.74.5]:37055 "EHLO duck.linux-mips.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752470Ab1E0HzV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 03:55:21 -0400
Date: Fri, 27 May 2011 08:55:13 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: Rob Landley <rob@landley.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: MIPS panic in 2.6.39 (bisected to 7eaceaccab5f)
Message-ID: <20110527075512.GE30117@linux-mips.org>
References: <4DDB5673.5060206@landley.net>
 <20110524143937.GB30117@linux-mips.org>
 <4DDCB1EB.4020707@landley.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DDCB1EB.4020707@landley.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 25, 2011 at 02:38:19AM -0500, Rob Landley wrote:

> af3a1f6f4813907e143f87030cde67a9971db533 is the first bad commit
> commit af3a1f6f4813907e143f87030cde67a9971db533
> Author: Ralf Baechle <ralf@linux-mips.org>
> Date:   Tue Mar 29 11:43:19 2011 +0200
> 
>     MIPS: Malta: Fix GCC 4.6.0 build error
> 
>       CC      arch/mips/mti-malta/malta-init.o
>     arch/mips/mti-malta/malta-init.c: In function 'prom_init':
>     arch/mips/mti-malta/malta-init.c:196:6: error: variable 'result' set
> but not used [-Werror=unused-but-set-variable]
>     cc1: all warnings being treated as errors
> 
>     Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
> 
> :040000 040000 58f11c3479ae15f2c4d0a3e7486c7aa4e1ca3e96
> 33ad31b666926e7090b5165b79773eee38b58229 M      arch
> 
> And this time I checked out the commit, confirmed it had the problem,
> did "git show | patch -p1 -R", rebuilt, and confirmed that the problem
> was fixed.
> 
> Sorry Jens, my bad...
> 
> > Can you provide the kernel disassembly for the arch_init_irq() function?
> 
> 803a0978 <arch_init_irq>:
> 803a0978:       27bdffe0        addiu   sp,sp,-32
> 803a097c:       afbf0018        sw      ra,24(sp)
> 803a0980:       0c0e8a23        jal     803a288c <init_i8259_irqs>
> 803a0984:       00000000        nop
> 803a0988:       0c0e8a4e        jal     803a2938 <mips_cpu_irq_init>
> 803a098c:       00000000        nop
> 803a0990:       3c028038        lui     v0,0x8038
> 803a0994:       8c426ae0        lw      v0,27360(v0)
> 803a0998:       1040000a        beqz    v0,803a09c4 <arch_init_irq+0x4c>
> 803a099c:       3c02803c        lui     v0,0x803c
> 803a09a0:       3c02803c        lui     v0,0x803c
> 803a09a4:       8c437048        lw      v1,28744(v0)
> 803a09a8:       3c021bdc        lui     v0,0x1bdc
> 803a09ac:       34420001        ori     v0,v0,0x1
> 803a09b0:       ac620080        sw      v0,128(v1)
> 803a09b4:       24030001        li      v1,1
> 803a09b8:       3c02803c        lui     v0,0x803c
> 803a09bc:       080e827d        j       803a09f4 <arch_init_irq+0x7c>
> 803a09c0:       ac437040        sw      v1,28736(v0)
> 803a09c4:       8c43701c        lw      v1,28700(v0)
> 803a09c8:       2402fffa        li      v0,-6
> 803a09cc:       1462000a        bne     v1,v0,803a09f8 <arch_init_irq+0x80>
> 803a09d0:       3c02803c        lui     v0,0x803c
> 803a09d4:       3c04bbc8        lui     a0,0xbbc8
> 803a09d8:       34820110        ori     v0,a0,0x110
> 803a09dc:       8c420000        lw      v0,0(v0)
> 803a09e0:       3c03803c        lui     v1,0x803c
> 803a09e4:       7c420080        ext     v0,v0,0x2,0x1
> 803a09e8:       ac627040        sw      v0,28736(v1)
> 803a09ec:       3c02803c        lui     v0,0x803c
> 803a09f0:       ac447044        sw      a0,28740(v0)
> 803a09f4:       3c02803c        lui     v0,0x803c
> 803a09f8:       8c43701c        lw      v1,28700(v0)
> 803a09fc:       2862fffa        slti    v0,v1,-6
> 803a0a00:       14400016        bnez    v0,803a0a5c <arch_init_irq+0xe4>
> 803a0a04:       3c058038        lui     a1,0x8038
> 803a0a08:       2862fffc        slti    v0,v1,-4
> 803a0a0c:       14400007        bnez    v0,803a0a2c <arch_init_irq+0xb4>
> 803a0a10:       3c02803c        lui     v0,0x803c
> 803a0a14:       2462ffff        addiu   v0,v1,-1
> 803a0a18:       2c420002        sltiu   v0,v0,2
> 803a0a1c:       10400010        beqz    v0,803a0a60 <arch_init_irq+0xe8>
> 803a0a20:       24a56ae4        addiu   a1,a1,27364
> 803a0a24:       080e8290        j       803a0a40 <arch_init_irq+0xc8>
> 
> And so on.
> 
> > Also, does the problem go away if you switch from CONFIG_MIPS_MT_SMP to
> > CONFIG_MIPS_MT_DISABLED?  The former is designed to run on all MIPS CPUs
> > and on a non-MT enabled CPU core it should just disable MT and run happily
> > anyway.  I know there was work on MT support being done by Thiemo Seufer
> > and I wonder if that ever made it into qemu and if so, if qemu gets MT
> > right.
> 
> I switched to that config symbol and it made no difference.

Ok.  That was just paranoia :)

> Have you guys been able to reproduce the problem?

Staring at the disassembly was good enough, I think.  The commit you
bisected is restructuring some of the hardware probing code for Malta and
seems to result in gcmp_present being set without _gcmp_base having been
assigned, thus the null pointer dereference.

  Ralf
