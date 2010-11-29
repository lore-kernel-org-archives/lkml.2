Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752532Ab0K2TlW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 14:41:22 -0500
Received: from imp02.mtu.ru ([62.5.255.19]:43860 "EHLO imp02.mtu.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751493Ab0K2TlU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 14:41:20 -0500
Message-ID: <4CF401DD.4000908@pavlinux.ru>
Date: Mon, 29 Nov 2010 22:41:17 +0300
From: Pavel Vasilyev <pavel@pavlinux.ru>
Reply-To: pavel@pavlinux.ru
Organization: Pavlinux. Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101026 SUSE/3.1.6 Thunderbird/3.1.6
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Repalce strncmp by memcmp
References: <4CF30B46.4000203@pavlinux.ru> <1291042737.30543.730.camel@gandalf.stny.rr.com>
In-Reply-To: <1291042737.30543.730.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
X-Spam-Flag: NO
X-Spam-Yversion: Spamooborona-3.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 29.11.2010 17:58, Steven Rostedt wrote:
> On Mon, 2010-11-29 at 05:09 +0300, Pavel Vasilyev wrote:
>> This patch replace all strncmp(a, b, c) by  memcmp(a, b, c).
> But these are not the same. strncmp() will stop when a or b hit a null.
> I'm not sure if memcmp() must do so, It may for some reason check
> anything within the memory of a+c-1 or b+c-1. What happens if a or b are
> right at the end of a vmalloc page, and is just a single character and
> null?
>
> 	x = vmalloc(32);
> 	strcpy(x, "some 31 byte string + null");
>
> 	call_func(x + 31);
>
> in call_func we have:
>
> 	call_func(char *a) {
>
> 	strncmp(a, "this is some big string", 23);
>
> With strncmp() when we hit a+1, it will stop comparing because a+1 is
> null. With memcmp there's no such guarantee. We can then take a kernel
> oops.
>
> That will be a nice thing to try to debug.
>
> Yes the above is contrived, but it demonstrates a possible problem with
> this conversion.
#include <stdio.h>
#include <errno.h>

char STR[5] = {'X','X','\0','X','X'};
char *XXX = "XX\0XX";

int main ()
{
  int a, b;
    a = memcmp  (XXX, STR, 5);
    b = strcmp (XXX, STR);
  printf (": %d %d \n", a, b);
 return 0;
}
./a.out
0 0

:)

#gdb ./a.out
(gdb) b main
Breakpoint 1 at 0x4005dc: file test.c, line 10.
(gdb) run
Starting program: /tmp/a.out

Breakpoint 1, main () at test.c:10
10        a = memcmp  (STR, XXX, 5);
(gdb) print XXX
$1 = 0x400731 "XX"
(gdb) print STR
$2 = "XX\000XX"
....
Oops, variable XXX set to XX, var. STR not changed.
Seems to me, that they into strsmp() and memcmp() already gets without
the null character.

P.S.
pavel@suse64:/tmp> gcc -v

Using built-in specs.
COLLECT_GCC=gcc
COLLECT_LTO_WRAPPER=/usr/lib64/gcc/x86_64-suse-linux/4.5/lto-wrapper
Target: x86_64-suse-linux
Configured with: ../configure --prefix=/usr --infodir=/usr/share/info
--mandir=/usr/share/man --libdir=/usr/lib64 --libexecdir=/usr/lib64
--enable-languages=c,c++,objc,fortran,obj-c++,java,ada
--enable-checking=release --with-gxx-include-dir=/usr/include/c++/4.5
--enable-ssp --disable-libssp --disable-plugin
--with-bugurl=http://bugs.opensuse.org/ --with-pkgversion='SUSE Linux'
--disable-libgcj --disable-libmudflap --with-slibdir=/lib64
--with-system-zlib --enable-__cxa_atexit
--enable-libstdcxx-allocator=new --disable-libstdcxx-pch
--enable-version-specific-runtime-libs --program-suffix=-4.5
--enable-linux-futex --without-system-libunwind --enable-gold
--with-plugin-ld=/usr/bin/gold --with-arch-32=i586 --with-tune=generic
--build=x86_64-suse-linux
Thread model: posix
gcc version 4.5.1 20101116 [gcc-4_5-branch revision 166793] (SUSE Linux
-- 

                                                         Pavel.

