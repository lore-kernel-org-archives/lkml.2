Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752585Ab1KGUpM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 15:45:12 -0500
Received: from h5.dl5rb.org.uk ([81.2.74.5]:53700 "EHLO linux-mips.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751814Ab1KGUpI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 15:45:08 -0500
Date: Mon, 7 Nov 2011 20:44:49 +0000
From: Ralf Baechle <ralf@linux-mips.org>
To: Michal Marek <mmarek@suse.cz>
Cc: Arnaud Lacombe <lacombar@gmail.com>, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mips@linux-mips.org,
        David Daney <ddaney@caviumnetworks.com>
Subject: Re: [PATCH] Kbuild: append missing-syscalls to the default target
 list
Message-ID: <20111107204448.GA9949@linux-mips.org>
References: <1314234210-11090-1-git-send-email-lacombar@gmail.com>
 <4E69FEC9.2080204@suse.cz>
 <CACqU3MUFyn_jh2pN4GLENqcGVUzAwcMJUR_WLY2EtqOhMheceQ@mail.gmail.com>
 <20111101232233.GA32441@sepie.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20111101232233.GA32441@sepie.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 02, 2011 at 12:22:33AM +0100, Michal Marek wrote:

> On Wed, Sep 14, 2011 at 01:17:10AM -0400, Arnaud Lacombe wrote:
> > 2011/9/9 Michal Marek <mmarek@suse.cz>:
> > > On 25.8.2011 03:03, Arnaud Lacombe wrote:
> > >> +always += missing-syscalls
> > >> +targets += missing-syscalls
> > >> +
> > >>  quiet_cmd_syscalls = CALL    $<
> > >>        cmd_syscalls = $(CONFIG_SHELL) $< $(CC) $(c_flags)
> > >
> > > checksyscalls.sh needs to depend on generated/asm-offsets.h, otherwise a
> > > parallel build will fail.
> > >
> > true.
> > 
> > This:
> > 
> > diff --git a/Kbuild b/Kbuild
> > index 1a2eb32..4caab4f 100644
> > --- a/Kbuild
> > +++ b/Kbuild
> > @@ -94,7 +94,7 @@ targets += missing-syscalls
> >  quiet_cmd_syscalls = CALL    $<
> >        cmd_syscalls = $(CONFIG_SHELL) $< $(CC) $(c_flags)
> > 
> > -missing-syscalls: scripts/checksyscalls.sh FORCE
> > +missing-syscalls: scripts/checksyscalls.sh $(offsets-file) FORCE
> >         $(call cmd,syscalls)
> 
> OK, applied to kbuild/kbuild with this fixup.

5f7efb4c6da9f90cb306923ced2a6494d065a595 breaks 64-bit MIPS builds that
have 32-bit binary compatibility enabled, for example ip27_defconfig
or cavium-octeon_defconfig:

  CC      arch/mips/kernel/asm-offsets.s
In file included from include/linux/bitops.h:22:0,
                 from include/linux/kernel.h:17,
                 from include/linux/cache.h:4,
                 from include/linux/time.h:7,
                 from include/linux/stat.h:60,
                 from include/linux/compat.h:10,
                 from arch/mips/kernel/asm-offsets.c:11:
/home/ralf/src/linux/linux-mips/arch/mips/include/asm/bitops.h: In function ‘__fls’:
/home/ralf/src/linux/linux-mips/arch/mips/include/asm/bitops.h:570:2: warning: left shift count >= width of type [enabled by default]
/home/ralf/src/linux/linux-mips/arch/mips/include/asm/bitops.h:572:3: warning: left shift count >= width of type [enabled by default]
/home/ralf/src/linux/linux-mips/arch/mips/include/asm/bitops.h:575:2: warning: left shift count >= width of type [enabled by default]
/home/ralf/src/linux/linux-mips/arch/mips/include/asm/bitops.h:579:2: warning: left shift count >= width of type [enabled by default]
/home/ralf/src/linux/linux-mips/arch/mips/include/asm/bitops.h:583:2: warning: left shift count >= width of type [enabled by default]
/home/ralf/src/linux/linux-mips/arch/mips/include/asm/bitops.h:587:2: warning: left shift count >= width of type [enabled by default]
/home/ralf/src/linux/linux-mips/arch/mips/include/asm/bitops.h:591:2: warning: left shift count >= width of type [enabled by default]
In file included from /home/ralf/src/linux/linux-mips/arch/mips/include/asm/page.h:46:0,
                 from /home/ralf/src/linux/linux-mips/arch/mips/include/asm/compat.h:8,
                 from include/linux/compat.h:18,
                 from arch/mips/kernel/asm-offsets.c:11:
/home/ralf/src/linux/linux-mips/arch/mips/include/asm/io.h: In function ‘phys_to_virt’:
/home/ralf/src/linux/linux-mips/arch/mips/include/asm/io.h:136:9: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]
/home/ralf/src/linux/linux-mips/arch/mips/include/asm/io.h: In function ‘isa_bus_to_virt’:
/home/ralf/src/linux/linux-mips/arch/mips/include/asm/io.h:149:9: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]
/home/ralf/src/linux/linux-mips/arch/mips/include/asm/io.h: In function ‘outq’:
/home/ralf/src/linux/linux-mips/arch/mips/include/asm/io.h:444:1: error: size of unnamed array is negative
/home/ralf/src/linux/linux-mips/arch/mips/include/asm/io.h: In function ‘inq’:
/home/ralf/src/linux/linux-mips/arch/mips/include/asm/io.h:444:1: error: size of unnamed array is negative
/home/ralf/src/linux/linux-mips/arch/mips/include/asm/io.h: In function ‘outq_p’:
/home/ralf/src/linux/linux-mips/arch/mips/include/asm/io.h:444:1: error: size of unnamed array is negative
/home/ralf/src/linux/linux-mips/arch/mips/include/asm/io.h: In function ‘inq_p’:
/home/ralf/src/linux/linux-mips/arch/mips/include/asm/io.h:444:1: error: size of unnamed array is negative
/home/ralf/src/linux/linux-mips/arch/mips/include/asm/io.h: In function ‘__mem_outq’:
/home/ralf/src/linux/linux-mips/arch/mips/include/asm/io.h:444:1: error: size of unnamed array is negative
/home/ralf/src/linux/linux-mips/arch/mips/include/asm/io.h: In function ‘__mem_inq’:
/home/ralf/src/linux/linux-mips/arch/mips/include/asm/io.h:444:1: error: size of unnamed array is negative
/home/ralf/src/linux/linux-mips/arch/mips/include/asm/io.h: In function ‘__mem_outq_p’:
/home/ralf/src/linux/linux-mips/arch/mips/include/asm/io.h:444:1: error: size of unnamed array is negative
/home/ralf/src/linux/linux-mips/arch/mips/include/asm/io.h: In function ‘__mem_inq_p’:
/home/ralf/src/linux/linux-mips/arch/mips/include/asm/io.h:444:1: error: size of unnamed array is negative
In file included from /home/ralf/src/linux/linux-mips/arch/mips/include/asm/pgtable.h:15:0,
                 from include/linux/mm.h:42,
                 from arch/mips/kernel/asm-offsets.c:14:
/home/ralf/src/linux/linux-mips/arch/mips/include/asm/pgtable-64.h: In function ‘mk_swap_pte’:
/home/ralf/src/linux/linux-mips/arch/mips/include/asm/pgtable-64.h:273:1: warning: left shift count >= width of type [enabled by default]
/home/ralf/src/linux/linux-mips/arch/mips/include/asm/pgtable-64.h:273:1: warning: left shift count >= width of type [enabled by default]
In file included from arch/mips/kernel/asm-offsets.c:14:0:
include/linux/mm.h: In function ‘virt_to_head_page’:
include/linux/mm.h:393:9: warning: right shift count >= width of type [enabled by default]
In file included from arch/mips/kernel/asm-offsets.c:14:0:
include/linux/mm.h: In function ‘lowmem_page_address’:
include/linux/mm.h:723:9: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]
make[1]: *** [arch/mips/kernel/asm-offsets.s] Error 1
make: *** [archprepare] Error 2

Not yet sure what the fix should be.

  Ralf
