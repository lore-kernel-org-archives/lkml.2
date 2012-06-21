Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758394Ab2FUHHz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 03:07:55 -0400
Received: from ozlabs.org ([203.10.76.45]:44121 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757659Ab2FUHHx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 03:07:53 -0400
Message-ID: <1340262473.1998.19.camel@concordia>
Subject: Re: linux-next: build failure after merge of the final tree
 (powerpc related)
From: Michael Ellerman <michael@ellerman.id.au>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        ppc-dev <linuxppc-dev@lists.ozlabs.org>, linux-kernel@vger.kernel.org,
        amodra@gmail.com
Date: Thu, 21 Jun 2012 17:07:53 +1000
In-Reply-To: <1340259896.3942.2.camel@pasglop>
References: <20120620175014.a822a766e0f91f7b44f48fa0@canb.auug.org.au>
	 <1340256961.1998.11.camel@concordia> <1340259896.3942.2.camel@pasglop>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 8BIT
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-06-21 at 16:24 +1000, Benjamin Herrenschmidt wrote:
> On Thu, 2012-06-21 at 15:36 +1000, Michael Ellerman wrote:
> > 
> > powerpc64-linux-ld: /src/next/net/openvswitch/vport-netdev.c:189:(.text+0x89b990): 
> >         sibling call optimization to `_restgpr0_28' does not allow automatic multiple TOCs;
> >         recompile with -mminimal-toc or -fno-optimize-sibling-calls, or make `_restgpr0_28' extern
> > 
> > 
> > And those are generated calls so I don't see how we can fix them.
> 
> Is this a module ? We should really be linking that stuff directly with the module....

No, it's builtin.

> The interesting thing is that we do build everything except a handful of
> files with -mminimal-toc unless something's wrong with our main Makefile....

Yeah, the top arch Makefile sets it, though we do override it in a few
places. I tried removing those overrides and it didn't seem to make any
difference.

> Can you show the full build command that triggers the above ?

Well that would be a few MBs of log, but here's an excerpt:

make -f scripts/Makefile.build obj=net/openvswitch
  /opt/cross/gcc-4.6-nolibc/powerpc64-linux/bin/powerpc64-linux-gcc -m64 -Wp,-MD,net/openvswitch/.vport-netdev.o.d  -nostdinc -isystem /opt/cross/gcc-4.6.3-nolibc/powerpc64-linux/lib/gcc/powerpc64-linux/4.6.3/include -I/home/michael/src/kmk/next/arch/powerpc/include -Iarch/powerpc/include/generated -Iinclude  -include /home/michael/src/kmk/next/include/linux/kconfig.h -D__KERNEL__ -Iarch/powerpc -Wall -Wundef -Wstrict-prototypes -Wno-trigraphs -fno-strict-aliasing -fno-common -Werror-implicit-function-declaration -Wno-format-security -fno-delete-null-pointer-checks -Os -msoft-float -pipe -Iarch/powerpc -mminimal-toc -mtraceback=no -mcall-aixdesc -mtune=power7 -mtune=cell -mno-altivec -mno-vsx -mno-spe -mspe=no -funit-at-a-time -fno-dwarf2-cfi-asm -mno-string -mno-sched-epilog -Wa,-maltivec -fno-reorder-blocks -fno-ipa-cp-clone -fno-partial-inlining -Wframe-larger-than=2048 -fno-stack-protector -Wno-unused-but-set-variable -g -femit-struct-debug-baseonly -pg -fno-inline-functions-called-once -Wdeclaration-after-statement -Wno-pointer-sign -fno-strict-overflow -fconserve-stack -DCC_HAVE_ASM_GOTO  -fprofile-arcs -ftest-coverage    -D"KBUILD_STR(s)=#s" -D"KBUILD_BASENAME=KBUILD_STR(vport_netdev)"  -D"KBUILD_MODNAME=KBUILD_STR(openvswitch)" -c -o net/openvswitch/.tmp_vport-netdev.o net/openvswitch/vport-netdev.c
  if [ "-pg" = "-pg" ]; then set -e ; perl /home/michael/src/kmk/next/scripts/recordmcount.pl "powerpc" "little" "64" "/opt/cross/gcc-4.6-nolibc/powerpc64-linux/bin/powerpc64-linux-objdump" "/opt/cross/gcc-4.6-nolibc/powerpc64-linux/bin/powerpc64-linux-objcopy" "/opt/cross/gcc-4.6-nolibc/powerpc64-linux/bin/powerpc64-linux-gcc -m64 -Wall -Wundef -Wstrict-prototypes -Wno-trigraphs -fno-strict-aliasing -fno-common -Werror-implicit-function-declaration -Wno-format-security -fno-delete-null-pointer-checks -Os -msoft-float -pipe -Iarch/powerpc -mminimal-toc -mtraceback=no -mcall-aixdesc -mtune=power7 -mtune=cell -mno-altivec -mno-vsx -mno-spe -mspe=no -funit-at-a-time -fno-dwarf2-cfi-asm -mno-string -mno-sched-epilog -Wa,-maltivec -fno-reorder-blocks -fno-ipa-cp-clone -fno-partial-inlining -Wframe-larger-than=2048  -fno-stack-protector -Wno-unused-but-set-variable -g  -femit-struct-debug-baseonly -pg  -fno-inline-functions-called-once -Wdeclaration-after-statement -Wno-pointer-sign -fno-strict-overflow -fconserve-stack -DCC_HAVE_ASM_GOTO" "/opt/cross/gcc-4.6-nolibc/powerpc64-linux/bin/powerpc64-linux-ld -m elf64ppc" "/opt/cross/gcc-4.6-nolibc/powerpc64-linux/bin/powerpc64-linux-nm --synthetic" "" "" "0" "net/openvswitch/vport-netdev.o"; fi;

And then a whole bunch of calls to ld.

So we are at least building that file with -mminimal-toc.

cheers

