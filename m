Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756989Ab1EMWGh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 May 2011 18:06:37 -0400
Received: from mail-px0-f173.google.com ([209.85.212.173]:38980 "EHLO
	mail-px0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752928Ab1EMWGf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 May 2011 18:06:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=n8ST8BJ8LIIfdgJg1EJPBMEgnM2KVw+d0qy674EqencT9Uurw+VNmBIIioEPCQOL7y
         TO0E2Y8dxNbihnmIMdyRNETizmyaV8iG1H8i4aeDZwVtbCMolnu81RNt4qouqNobONWr
         LVPngOCnmTLfCP/+U4tCAbDvGfb+QTDH8Fn+Y=
MIME-Version: 1.0
In-Reply-To: <20110513184532.GC14607@jayachandranc.netlogicmicro.com>
References: <7aa38c32b7748a95e814e5bb0583f967@localhost>
	<20110513150707.GA26389@linux-mips.org>
	<BANLkTikcyEzjOWt9pWToE=89dySSEYbw_g@mail.gmail.com>
	<20110513155605.GA30674@linux-mips.org>
	<BANLkTinnALQV6dXkJ0AjaQ1=bTawYMMkuQ@mail.gmail.com>
	<20110513173633.GA14607@jayachandranc.netlogicmicro.com>
	<BANLkTim+z7TSCvNA2duA6LsUzNsiu9OQaQ@mail.gmail.com>
	<20110513184532.GC14607@jayachandranc.netlogicmicro.com>
Date: Fri, 13 May 2011 15:06:35 -0700
Message-ID: <BANLkTi=CJPuhO7OjCv5UF_ABQMb-bFe-2A@mail.gmail.com>
Subject: Re: [PATCH 1/4] MIPS: Replace _PAGE_READ with _PAGE_NO_READ
From: Kevin Cernekee <cernekee@gmail.com>
To: "Jayachandran C." <jayachandranc@netlogicmicro.com>
Cc: Ralf Baechle <ralf@linux-mips.org>,
        David Daney <ddaney@caviumnetworks.com>, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 13, 2011 at 11:45 AM, Jayachandran C.
<jayachandranc@netlogicmicro.com> wrote:
> The current linux-mips queue works for me, and I don't have the old source
> or binaries with me anymore. You surely should be able build with
> nlm_xlr_defconfig and see if the rixi is enabled in the build, if you want
> any config register dump on the CPU, please let me know.

I was able to locate an old MIPS R5000 based system and get linux-mips
queue running on it.  Here are the settings:

CONFIG_ARCH_DMA_ADDR_T_64BIT=y
CONFIG_64BIT_PHYS_ADDR=y
CONFIG_ARCH_PHYS_ADDR_T_64BIT=y
CONFIG_PHYS_ADDR_T_64BIT=y
CONFIG_SYS_SUPPORTS_32BIT_KERNEL=y
CONFIG_CPU_SUPPORTS_32BIT_KERNEL=y
CONFIG_SYS_SUPPORTS_64BIT_KERNEL=y
CONFIG_CPU_SUPPORTS_64BIT_KERNEL=y
CONFIG_32BIT=y
# CONFIG_64BIT is not set
CONFIG_SMP=y

This was intended to mimic the XLR configuration: 32-bit kernel on a
64-bit CPU with 64-bit physical addressing, SMP (albeit with 1 CPU),
no RI/XI.

After applying all 4 of my page cleanup patches, the system still
booted and ran normally.

Userspace is glibc with a bash shell (also tried uClibc w/bash, same
result).  Since the reported assertion appeared to be in bash.

Jayachandran - how do you think we should debug this?  It seems like
the problem only shows up on XLR.  Since this is a relatively new
platform, is it possible that something else might be broken still?

FWIW, here are the TLB handlers:

Refill:

    80000000:   401b2000        mfc0    k1,c0_context
    80000004:   3c1a80a5        lui     k0,0x80a5
    80000008:   001bddc2        srl     k1,k1,0x17
    8000000c:   035bd821        addu    k1,k0,k1
    80000010:   401a4000        mfc0    k0,c0_badvaddr
    80000014:   8f7b4000        lw      k1,16384(k1)
    80000018:   001ad542        srl     k0,k0,0x15
    8000001c:   001ad080        sll     k0,k0,0x2
    80000020:   037ad821        addu    k1,k1,k0
    80000024:   401a2000        mfc0    k0,c0_context
    80000028:   8f7b0000        lw      k1,0(k1)
    8000002c:   335a0ff0        andi    k0,k0,0xff0
    80000030:   037ad821        addu    k1,k1,k0
    80000034:   df7a0000        ld      k0,0(k1)
    80000038:   df7b0008        ld      k1,8(k1)
    8000003c:   001ad1ba        dsrl    k0,k0,0x6
    80000040:   409a1000        mtc0    k0,c0_entrylo0
    80000044:   001bd9ba        dsrl    k1,k1,0x6
    80000048:   409b1800        mtc0    k1,c0_entrylo1
    8000004c:   00000000        nop
    80000050:   42000006        tlbwr
    80000054:   42000018        eret

Load:

    801fe000:   401b2000        mfc0    k1,c0_context
    801fe004:   3c1a80a5        lui     k0,0x80a5
    801fe008:   001bddc2        srl     k1,k1,0x17
    801fe00c:   035bd821        addu    k1,k0,k1
    801fe010:   401a4000        mfc0    k0,c0_badvaddr
    801fe014:   8f7b4000        lw      k1,16384(k1)
    801fe018:   001ad542        srl     k0,k0,0x15
    801fe01c:   001ad080        sll     k0,k0,0x2
    801fe020:   037ad821        addu    k1,k1,k0
    801fe024:   401a4000        mfc0    k0,c0_badvaddr
    801fe028:   8f7b0000        lw      k1,0(k1)
    801fe02c:   001ad242        srl     k0,k0,0x9
    801fe030:   335a0ff8        andi    k0,k0,0xff8
    801fe034:   037ad821        addu    k1,k1,k0
    801fe038:   d37a0000        lld     k0,0(k1)
    801fe03c:   42000008        tlbp
    801fe040:   335a0001        andi    k0,k0,0x1
    801fe044:   13400010        beqz    k0,0x801fe088
    801fe048:   d37a0000        lld     k0,0(k1)
    801fe04c:   375a0084        ori     k0,k0,0x84
    801fe050:   f37a0000        scd     k0,0(k1)
    801fe054:   1340fff8        beqz    k0,0x801fe038
    801fe058:   00000000        nop
    801fe05c:   377b0008        ori     k1,k1,0x8
    801fe060:   3b7b0008        xori    k1,k1,0x8
    801fe064:   df7a0000        ld      k0,0(k1)
    801fe068:   df7b0008        ld      k1,8(k1)
    801fe06c:   001ad1ba        dsrl    k0,k0,0x6
    801fe070:   409a1000        mtc0    k0,c0_entrylo0
    801fe074:   001bd9ba        dsrl    k1,k1,0x6
    801fe078:   409b1800        mtc0    k1,c0_entrylo1
    801fe07c:   00000000        nop
    801fe080:   42000002        tlbwi
    801fe084:   42000018        eret
    801fe088:   080036d8        j       0x8000db60
    801fe08c:   00000000        nop

Store:

    801fe200:   401b2000        mfc0    k1,c0_context
    801fe204:   3c1a80a5        lui     k0,0x80a5
    801fe208:   001bddc2        srl     k1,k1,0x17
    801fe20c:   035bd821        addu    k1,k0,k1
    801fe210:   401a4000        mfc0    k0,c0_badvaddr
    801fe214:   8f7b4000        lw      k1,16384(k1)
    801fe218:   001ad542        srl     k0,k0,0x15
    801fe21c:   001ad080        sll     k0,k0,0x2
    801fe220:   037ad821        addu    k1,k1,k0
    801fe224:   401a4000        mfc0    k0,c0_badvaddr
    801fe228:   8f7b0000        lw      k1,0(k1)
    801fe22c:   001ad242        srl     k0,k0,0x9
    801fe230:   335a0ff8        andi    k0,k0,0xff8
    801fe234:   037ad821        addu    k1,k1,k0
    801fe238:   d37a0000        lld     k0,0(k1)
    801fe23c:   42000008        tlbp
    801fe240:   335a0003        andi    k0,k0,0x3
    801fe244:   3b5a0003        xori    k0,k0,0x3
    801fe248:   17400010        bnez    k0,0x801fe28c
    801fe24c:   d37a0000        lld     k0,0(k1)
    801fe250:   375a018c        ori     k0,k0,0x18c
    801fe254:   f37a0000        scd     k0,0(k1)
    801fe258:   1340fff7        beqz    k0,0x801fe238
    801fe25c:   00000000        nop
    801fe260:   377b0008        ori     k1,k1,0x8
    801fe264:   3b7b0008        xori    k1,k1,0x8
    801fe268:   df7a0000        ld      k0,0(k1)
    801fe26c:   df7b0008        ld      k1,8(k1)
    801fe270:   001ad1ba        dsrl    k0,k0,0x6
    801fe274:   409a1000        mtc0    k0,c0_entrylo0
    801fe278:   001bd9ba        dsrl    k1,k1,0x6
    801fe27c:   409b1800        mtc0    k1,c0_entrylo1
    801fe280:   00000000        nop
    801fe284:   42000002        tlbwi
    801fe288:   42000018        eret
    801fe28c:   0800371d        j       0x8000dc74
    801fe290:   00000000        nop

Modify:

    801fe400:   401b2000        mfc0    k1,c0_context
    801fe404:   3c1a80a5        lui     k0,0x80a5
    801fe408:   001bddc2        srl     k1,k1,0x17
    801fe40c:   035bd821        addu    k1,k0,k1
    801fe410:   401a4000        mfc0    k0,c0_badvaddr
    801fe414:   8f7b4000        lw      k1,16384(k1)
    801fe418:   001ad542        srl     k0,k0,0x15
    801fe41c:   001ad080        sll     k0,k0,0x2
    801fe420:   037ad821        addu    k1,k1,k0
    801fe424:   401a4000        mfc0    k0,c0_badvaddr
    801fe428:   8f7b0000        lw      k1,0(k1)
    801fe42c:   001ad242        srl     k0,k0,0x9
    801fe430:   335a0ff8        andi    k0,k0,0xff8
    801fe434:   037ad821        addu    k1,k1,k0
    801fe438:   d37a0000        lld     k0,0(k1)
    801fe43c:   42000008        tlbp
    801fe440:   335a0002        andi    k0,k0,0x2
    801fe444:   13400010        beqz    k0,0x801fe488
    801fe448:   d37a0000        lld     k0,0(k1)
    801fe44c:   375a018c        ori     k0,k0,0x18c
    801fe450:   f37a0000        scd     k0,0(k1)
    801fe454:   1340fff8        beqz    k0,0x801fe438
    801fe458:   00000000        nop
    801fe45c:   377b0008        ori     k1,k1,0x8
    801fe460:   3b7b0008        xori    k1,k1,0x8
    801fe464:   df7a0000        ld      k0,0(k1)
    801fe468:   df7b0008        ld      k1,8(k1)
    801fe46c:   001ad1ba        dsrl    k0,k0,0x6
    801fe470:   409a1000        mtc0    k0,c0_entrylo0
    801fe474:   001bd9ba        dsrl    k1,k1,0x6
    801fe478:   409b1800        mtc0    k1,c0_entrylo1
    801fe47c:   00000000        nop
    801fe480:   42000002        tlbwi
    801fe484:   42000018        eret
    801fe488:   0800371d        j       0x8000dc74
    801fe48c:   00000000        nop
