Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754688Ab0K2WSi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 17:18:38 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:41177 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753453Ab0K2WSh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 17:18:37 -0500
X-Authority-Analysis: v=1.1 cv=6ptpMFIBtxRk0xdOb6IhJTbTLVRlKjWFes7R4SsWCrA= c=1 sm=0 a=UuO6cx77fMcA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=KSb9T-wMAAAA:8 a=oW5JGhqbkifNF9hSQwAA:9 a=jZyTK9zdjXmMG-yYGqIA:7 a=Om0vvFoArCXafKOQkwiJc-gvpgMA:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH] Repalce strncmp by memcmp
From: Steven Rostedt <rostedt@goodmis.org>
To: pavel@pavlinux.ru
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <4CF401DD.4000908@pavlinux.ru>
References: <4CF30B46.4000203@pavlinux.ru>
	 <1291042737.30543.730.camel@gandalf.stny.rr.com>
	 <4CF401DD.4000908@pavlinux.ru>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Mon, 29 Nov 2010 17:18:33 -0500
Message-ID: <1291069113.30543.876.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-11-29 at 22:41 +0300, Pavel Vasilyev wrote:
> On 29.11.2010 17:58, Steven Rostedt wrote:
> > On Mon, 2010-11-29 at 05:09 +0300, Pavel Vasilyev wrote:
> >> This patch replace all strncmp(a, b, c) by  memcmp(a, b, c).
> > But these are not the same. strncmp() will stop when a or b hit a null.
> > I'm not sure if memcmp() must do so, It may for some reason check
> > anything within the memory of a+c-1 or b+c-1. What happens if a or b are
> > right at the end of a vmalloc page, and is just a single character and
> > null?
> >
> > 	x = vmalloc(32);
> > 	strcpy(x, "some 31 byte string + null");
> >
> > 	call_func(x + 31);
> >
> > in call_func we have:
> >
> > 	call_func(char *a) {
> >
> > 	strncmp(a, "this is some big string", 23);
> >
> > With strncmp() when we hit a+1, it will stop comparing because a+1 is
> > null. With memcmp there's no such guarantee. We can then take a kernel
> > oops.
> >
> > That will be a nice thing to try to debug.
> >
> > Yes the above is contrived, but it demonstrates a possible problem with
> > this conversion.
> #include <stdio.h>
> #include <errno.h>
> 
> char STR[5] = {'X','X','\0','X','X'};
> char *XXX = "XX\0XX";
> 
> int main ()
> {
>   int a, b;
>     a = memcmp  (XXX, STR, 5);
>     b = strcmp (XXX, STR);
>   printf (": %d %d \n", a, b);
>  return 0;
> }
> ./a.out
> 0 0
> 
> :)

Um, do you realize that the kernel does not always use the same memcmp
as gcc.


> 
> #gdb ./a.out
> (gdb) b main
> Breakpoint 1 at 0x4005dc: file test.c, line 10.
> (gdb) run
> Starting program: /tmp/a.out
> 
> Breakpoint 1, main () at test.c:10
> 10        a = memcmp  (STR, XXX, 5);
> (gdb) print XXX
> $1 = 0x400731 "XX"
> (gdb) print STR
> $2 = "XX\000XX"
> ....
> Oops, variable XXX set to XX, var. STR not changed.
> Seems to me, that they into strsmp() and memcmp() already gets without
> the null character.
> 
> P.S.
> pavel@suse64:/tmp> gcc -v

This is meaningless, because the kernel may have its own memcmp and
strncmp.

And you seem to be missing my point. I'm not saying that it will give
you an incorrect result, I'm saying that if memcmp simply reads the
memory that is not mapped in, then you might cause the kernel to crash.

This is fine if all implementations of memcmp() reads the data
sequentially and stops when not equal. If for some reason there's an
implementation that compares, not from the beginning of the data, but
say from the end, then this can cause a fault.

Note, that strncmp and memcmp act differently for:

	(a, b, c) where c is larger than strlen(a)+1 and strlen(b)+1,

 and the two match. Try it:

	char *a = "abc\0 123";
	char *b = "abc\0 456";

	printf("%d %d\n", strncmp(a, b, 10), memcmp(a, b, 10));

-- Steve


> 
> Using built-in specs.
> COLLECT_GCC=gcc
> COLLECT_LTO_WRAPPER=/usr/lib64/gcc/x86_64-suse-linux/4.5/lto-wrapper
> Target: x86_64-suse-linux
> Configured with: ../configure --prefix=/usr --infodir=/usr/share/info
> --mandir=/usr/share/man --libdir=/usr/lib64 --libexecdir=/usr/lib64
> --enable-languages=c,c++,objc,fortran,obj-c++,java,ada
> --enable-checking=release --with-gxx-include-dir=/usr/include/c++/4.5
> --enable-ssp --disable-libssp --disable-plugin
> --with-bugurl=http://bugs.opensuse.org/ --with-pkgversion='SUSE Linux'
> --disable-libgcj --disable-libmudflap --with-slibdir=/lib64
> --with-system-zlib --enable-__cxa_atexit
> --enable-libstdcxx-allocator=new --disable-libstdcxx-pch
> --enable-version-specific-runtime-libs --program-suffix=-4.5
> --enable-linux-futex --without-system-libunwind --enable-gold
> --with-plugin-ld=/usr/bin/gold --with-arch-32=i586 --with-tune=generic
> --build=x86_64-suse-linux
> Thread model: posix
> gcc version 4.5.1 20101116 [gcc-4_5-branch revision 166793] (SUSE Linux


