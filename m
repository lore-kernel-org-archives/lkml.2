Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755025Ab1FXK3T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jun 2011 06:29:19 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:45397 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751735Ab1FXK3L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jun 2011 06:29:11 -0400
X-Authority-Analysis: v=1.1 cv=PfPQ8rIoTcZsncbPZjVSZ7K0hy8Zc4hmL68r4VPNpKE= c=1 sm=0 a=PnBdzaNuq4AA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=YfCOm-DyAAAA:8 a=GB2syUQhvM5va5HPZawA:9 a=EJrB1p4Wd7vWUQSfCYsA:7 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [BUG?]3.0-rc4+ftrace+kprobe: set kprobe at instruction 'stwu'
 lead to system crash/freeze
From: Steven Rostedt <rostedt@goodmis.org>
To: Yong Zhang <yong.zhang0@gmail.com>
Cc: linuxppc-dev@lists.ozlabs.org, linux-kernel <linux-kernel@vger.kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>, paulus@samba.org,
        galak@kernel.crashing.org,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
In-Reply-To: <BANLkTi=gx73d6-s-jqeke05SQYorpnzLVw@mail.gmail.com>
References: <BANLkTi=gx73d6-s-jqeke05SQYorpnzLVw@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Fri, 24 Jun 2011 06:29:07 -0400
Message-ID: <1308911347.531.56.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-06-24 at 17:21 +0800, Yong Zhang wrote:
> Hi,
> 
> When I use kprobe to do something, I found some wired thing.
> 
> When CONFIG_FUNCTION_TRACER is disabled:
> (gdb) disassemble do_fork
> Dump of assembler code for function do_fork:
>    0xc0037390 <+0>:	mflr    r0
>    0xc0037394 <+4>:	stwu    r1,-64(r1)
>    0xc0037398 <+8>:	mfcr    r12
>    0xc003739c <+12>:	stmw    r27,44(r1)
> 
> Then I:
> modprobe kprobe_example func=do_fork offset=4
> ls
> Things works well.
> 
> But when CONFIG_FUNCTION_TRACER is enabled:
> (gdb) disassemble do_fork
> Dump of assembler code for function do_fork:
>    0xc0040334 <+0>:	mflr    r0
>    0xc0040338 <+4>:	stw     r0,4(r1)
>    0xc004033c <+8>:	bl      0xc00109d4 <mcount>
>    0xc0040340 <+12>:	stwu    r1,-80(r1)
>    0xc0040344 <+16>:	mflr    r0
>    0xc0040348 <+20>:	stw     r0,84(r1)
>    0xc004034c <+24>:	mfcr    r12
> Then I:
> modprobe kprobe_example func=do_fork offset=12
> ls
> 'ls' will never retrun. system freeze.

I'm not sure if x86 had a similar issue.

Masami, have any ideas to why this happened?

I don't have a PPC32 to test on, but I can try it out on my PPC64.

-- Steve

> 
> I'm using toolchain from:http://www.denx.de/wiki/ELDK-5/WebHome
> powerpc-linux-gcc -v
> Using built-in specs.
> COLLECT_GCC=/opt/eldk-5.0/powerpc/sysroots/i686-oesdk-linux/usr/bin/powerpc-linux/powerpc-linux-gcc
> COLLECT_LTO_WRAPPER=/opt/eldk-5.0/powerpc/sysroots/i686-oesdk-linux/usr/libexec/powerpc-linux/gcc/powerpc-linux/4.5.1/lto-wrapper
> Target: powerpc-linux
> Configured with:
> /opt/poky/build/eldk-2011-05-20-5cde06e-powerpc/tmp/work/i686-nativesdk-oesdk-linux/gcc-cross-canadian-powerpc-4.5.1-r4/gcc-4.5.1/configure
> --build=x86_64-linux --host=i686-oesdk-linux --target=powerpc-linux
> --prefix=/opt/eldk-5.0/powerpc/sysroots/i686-oesdk-linux/usr
> --exec_prefix=/opt/eldk-5.0/powerpc/sysroots/i686-oesdk-linux/usr
> --bindir=/opt/eldk-5.0/powerpc/sysroots/i686-oesdk-linux/usr/bin/powerpc-linux
> --sbindir=/opt/eldk-5.0/powerpc/sysroots/i686-oesdk-linux/usr/bin/powerpc-linux
> --libexecdir=/opt/eldk-5.0/powerpc/sysroots/i686-oesdk-linux/usr/libexec/powerpc-linux
> --datadir=/opt/eldk-5.0/powerpc/sysroots/i686-oesdk-linux/usr/share
> --sysconfdir=/opt/eldk-5.0/powerpc/sysroots/i686-oesdk-linux/etc
> --sharedstatedir=/opt/eldk-5.0/powerpc/sysroots/i686-oesdk-linux/com
> --localstatedir=/opt/eldk-5.0/powerpc/sysroots/i686-oesdk-linux/var
> --libdir=/opt/eldk-5.0/powerpc/sysroots/i686-oesdk-linux/usr/lib/powerpc-linux
> --includedir=/opt/eldk-5.0/powerpc/sysroots/i686-oesdk-linux/usr/include
> --oldincludedir=/opt/eldk-5.0/powerpc/sysroots/i686-oesdk-linux/usr/include
> --infodir=/opt/eldk-5.0/powerpc/sysroots/i686-oesdk-linux/usr/share/info
> --mandir=/opt/eldk-5.0/powerpc/sysroots/i686-oesdk-linux/usr/share/man
> --with-libtool-sysroot=/opt/poky/build/eldk-2011-05-20-5cde06e-powerpc/tmp/sysroots/i686-oesdk-linux-nativesdk
> --with-gnu-ld --enable-shared --enable-languages=c,c++
> --enable-threads=posix --disable-multilib --enable-c99
> --enable-long-long --enable-symvers=gnu --enable-libstdcxx-pch
> --program-prefix=powerpc-linux- --enable-lto --enable-libssp
> --disable-bootstrap --disable-libgomp --disable-libmudflap
> --enable-cheaders=c_global
> --with-local-prefix=/opt/eldk-5.0/powerpc/sysroots/powerpc-linux/usr
> --with-gxx-include-dir=/usr/include/c++
> --with-build-time-tools=/opt/poky/build/eldk-2011-05-20-5cde06e-powerpc/tmp/sysroots/x86_64-linux/usr/powerpc-linux/bin
> --with-sysroot=/opt/eldk-5.0/powerpc/sysroots/powerpc-linux
> --with-build-sysroot=/opt/poky/build/eldk-2011-05-20-5cde06e-powerpc/tmp/sysroots/powerpc
> --disable-libunwind-exceptions --disable-libssp --disable-libgomp
> --disable-libmudflap
> --with-mpfr=/opt/poky/build/eldk-2011-05-20-5cde06e-powerpc/tmp/sysroots/i686-oesdk-linux-nativesdk
> --with-mpc=/opt/poky/build/eldk-2011-05-20-5cde06e-powerpc/tmp/sysroots/i686-oesdk-linux-nativesdk
> --enable-__cxa_atexit
> Thread model: posix
> gcc version 4.5.1 (GCC)
> 
> 
> And kernel config is attached.
> 
> BTW, I have made a patch to make kprobe_example set breakpoint easily,
> attached too.
> 
> Thanks,
> Yong
> 


