Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752278Ab1JHKSO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Oct 2011 06:18:14 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:37597 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751963Ab1JHKSK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Oct 2011 06:18:10 -0400
MIME-Version: 1.0
In-Reply-To: <4E382602.6050308@grupopie.com>
References: <02ae01cc4d91$aed71670$0c854350$%kim@samsung.com>
 <20110729100241.GB25640@n2100.arm.linux.org.uk> <2563791.8cBqodrk1o@flatron>
 <1514384.7oMe1aulyC@flatron> <4E382602.6050308@grupopie.com>
From: Eric Miao <eric.y.miao@gmail.com>
Date: Sat, 8 Oct 2011 18:17:49 +0800
Message-ID: <CAMPhdO80ua0WphKnx3nyBLN7LsUDnDKPX1QbzWEjjfO5t3Uz5Q@mail.gmail.com>
Subject: Re: Question about "Inconsistent kallsyms data"
To: Paulo Marques <pmarques@grupopie.com>
Cc: Tomasz Figa <tomasz.figa@gmail.com>, linux-samsung-soc@vger.kernel.org,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-kernel@vger.kernel.org, Kukjin Kim <kgene.kim@samsung.com>,
        Ben Dooks <ben-linux@fluff.org>, linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 3, 2011 at 12:29 AM, Paulo Marques <pmarques@grupopie.com> wrote:
> Tomasz Figa wrote:
>> On Friday 29 of July 2011 at 12:58:32, Tomasz Figa wrote:
>>>[...]
>>> I will try to bisect the case with s3c6400 defconfig.
>>
>> I have no idea why, but I cannot reproduce the issue anymore, even after make
>> distclean or starting with a clean tree. A build system bug?
>>
>> I do not know much technical details about the kernel build system, but might
>> it be a concurrency issue (I use make -j5 for building with 5 jobs)?
>
> Usually this is caused by symbols moving slightly between kernel compiles.
>
> This is an explanation of the process I wrote a while ago in a different
> thread at LKML:
>
>> Now as for CONFIG_KALLSYMS_EXTRA_PASS: to build the kallsyms table, the
>> build process first links a kernel image with an empty kallsyms table
>> and use that to fetch information for all the symbols.
>>
>> It then uses that information to build the table with the right size,
>> and links it again. If everything goes ok, this new version as all the
>> symbols in the correct places and the final table can be built with the
>> correct addresses.
>>
>> The final linking should produce the same result as only the data on the
>> kallsyms table changed, but not its size.
>>
>> However, there have been bugs in the past with section alignments and
>> symbol reordering for symbols with the same address, etc., etc. that
>> make this final table not have the exact same size, and the build fails
>> with an inconsistent kallsyms data message. At this point, the user can
>> turn on the CONFIG_KALLSYMS_EXTRA_PASS and temporarily solve the problem
>> while the developers find the correct fix. Without this option, in this
>> situation the kernel would simply fail the compilation.
>>
>> All this has been stable for a while and this option hasn't been needed
>> recently (AFAIK), but if there is some bug in some new binutils or
>> something, the option might be needed again.
>
> To check inconsistencies, the Makefile compares ".tmp_System.map" and
> "System.map" for differences.
>
> On a normal build they should be identical, but if this fails with
> "Inconsistent kallsyms data" you could try comparing the two files to
> check which symbols are causing trouble.

I met this issue today as well. Didn't have a chance to compare the
files, as I did a 'rm -fr ../build' and reconfigured/re-built everything,
and 'make O=../build clean' didn't work for me.

I'm using a toolchain with version info as below:

$ arm-linux-gnueabi-gcc -v
Using built-in specs.
COLLECT_GCC=arm-linux-gnueabi-gcc
COLLECT_LTO_WRAPPER=/usr/lib/gcc/arm-linux-gnueabi/4.5.2/lto-wrapper
Target: arm-linux-gnueabi
Configured with: ../src/configure -v --with-pkgversion='Ubuntu/Linaro
4.5.2-8ubuntu3'
--with-bugurl=file:///usr/share/doc/gcc-4.5/README.Bugs
--enable-languages=c,c++,fortran,objc,obj-c++ --prefix=/usr
--program-suffix=-4.5 --enable-shared --enable-multiarch
--with-multiarch-defaults=i386-linux-gnu --enable-linker-build-id
--with-system-zlib --libexecdir=/usr/lib --without-included-gettext
--enable-threads=posix
--with-gxx-include-dir=/usr/arm-linux-gnueabi/include/c++/4.5.2
--libdir=/usr/lib --enable-nls --enable-clocale=gnu
--enable-libstdcxx-debug --enable-libstdcxx-time=yes --enable-plugin
--enable-gold --enable-ld=default --with-plugin-ld=ld.gold
--enable-objc-gc --disable-sjlj-exceptions --with-arch=armv7-a
--with-float=softfp --with-fpu=vfpv3-d16 --with-mode=thumb
--disable-werror --enable-checking=release
--program-prefix=arm-linux-gnueabi-
--includedir=/usr/arm-linux-gnueabi/include --build=i686-linux-gnu
--host=i686-linux-gnu --target=arm-linux-gnueabi
--with-headers=/usr/arm-linux-gnueabi/include
--with-libs=/usr/arm-linux-gnueabi/lib
Thread model: posix
gcc version 4.5.2 (Ubuntu/Linaro 4.5.2-8ubuntu3)


>
> --
> Paulo Marques - www.grupopie.com
>
> "All generalizations are false."
>
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
>
