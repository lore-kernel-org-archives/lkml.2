Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752375Ab1GWN7b (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jul 2011 09:59:31 -0400
Received: from mail-fx0-f52.google.com ([209.85.161.52]:37315 "EHLO
	mail-fx0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751471Ab1GWN71 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jul 2011 09:59:27 -0400
From: Arkadiusz Miskiewicz <a.miskiewicz@gmail.com>
To: Andy Lutomirski <luto@mit.edu>
Subject: 3.1 git: ld: error: dot may not move backward
Date: Sat, 23 Jul 2011 15:59:23 +0200
User-Agent: KMail/1.13.7 (Linux/3.0.0-final-dirty; KDE/4.6.5; x86_64; ; )
Cc: Ingo Molnar <mingo@elte.hu>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201107231559.23537.a.miskiewicz@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hello,

current git (bbd9d6f7fbb0305c9a592bf05a32e87eb364a4ff)

[arekm@ixion-pld linux]$ gcc -v
Reading specs from /usr/lib64/gcc/x86_64-pld-linux/4.6.1/specs
COLLECT_GCC=gcc
COLLECT_LTO_WRAPPER=/usr/lib64/gcc/x86_64-pld-linux/4.6.1/lto-wrapper
Target: x86_64-pld-linux
Configured with: ../configure --prefix=/usr --with-local-prefix=/usr/local --
libdir=/usr/lib64 --libexecdir=/usr/lib64 --infodir=/usr/share/info --
mandir=/usr/share/man --x-libraries=/usr/lib64 --enable-checking=release --
enable-gnu-unique-object --enable-shared --enable-threads=posix --enable-
linker-build-id --enable-linux-futex --enable-
languages=c,c++,fortran,objc,obj-c++,ada,java --enable-libgomp --enable-
libmudflap --enable-c99 --enable-long-long --enable-decimal-float=yes --
enable-nls --disable-werror --enable-lto --enable-plugin --disable-cld --with-
gnu-as --with-gnu-ld --with-demangler-in-ld --with-system-zlib --with-
slibdir=/lib64 --without-system-libunwind --enable-cmath --with-long-
double-128 --with-gxx-include-dir=/usr/include/c++/4.6.1 --disable-libstdcxx-
pch --enable-__cxa_atexit --enable-libstdcxx-allocator=new --enable-libjava-
multilib=no --disable-gconf-peer --enable-java-awt=xlib,gtk --enable-libgcj --
enable-libgcj-multifile --enable-libgcj-database --enable-gtk-cairo --enable-
jni --enable-xmlj --enable-bootstrap --with-pkgversion=PLD-Linux --with-
bugurl=http://bugs.pld-linux.org x86_64-pld-linux
Thread model: posix
gcc version 4.6.1 20110714 (release) (PLD-Linux)

[arekm@ixion-pld linux]$ ld -v
GNU gold (Linux/GNU Binutils 2.21.53.0.1.20110716) 1.11

and at make bzImage 

  ld -m elf_x86_64 --build-id  -o .tmp_vmlinux1 -T arch/x86/kernel/vmlinux.lds 
arch/x86/kernel/head_64.o arch/x86/kernel/head64.o arch/x86/kernel/head.o 
arch/x86/kernel/init_task.o  init/built-in.o --start-group  usr/built-in.o  
arch/x86/built-in.o  kernel/built-in.o  mm/built-in.o  fs/built-in.o  
ipc/built-in.o  security/built-in.o  crypto/built-in.o  block/built-in.o  
lib/lib.a  arch/x86/lib/lib.a  lib/built-in.o  arch/x86/lib/built-in.o  
drivers/built-in.o  sound/built-in.o  firmware/built-in.o  arch/x86/pci/built-
in.o  arch/x86/power/built-in.o  arch/x86/video/built-in.o  net/built-in.o --
end-group
ld: error: dot may not move backward
ld: error: dot may not move backward
ld: error: load segment overlap [0x1800000 -> 0x18850e0] and [0x1884000 -> 
0x1884c10]

bisect ends with:

9fd67b4ed0714ab718f1f9bd14c344af336a6df7 is the first bad commit
commit 9fd67b4ed0714ab718f1f9bd14c344af336a6df7
Author: Andy Lutomirski <luto@MIT.EDU>
Date:   Sun Jun 5 13:50:19 2011 -0400

    x86-64: Give vvars their own page
    
    Move vvars out of the vsyscall page into their own page and mark
    it NX.
    
    Without this patch, an attacker who can force a daemon to call
    some fixed address could wait until the time contains, say,
    0xCD80, and then execute the current time.
    
    Signed-off-by: Andy Lutomirski <luto@mit.edu>
    Cc: Jesper Juhl <jj@chaosbits.net>
    Cc: Borislav Petkov <bp@alien8.de>
    Cc: Linus Torvalds <torvalds@linux-foundation.org>
    Cc: Arjan van de Ven <arjan@infradead.org>
    Cc: Jan Beulich <JBeulich@novell.com>
    Cc: richard -rw- weinberger <richard.weinberger@gmail.com>
    Cc: Mikael Pettersson <mikpe@it.uu.se>
    Cc: Andi Kleen <andi@firstfloor.org>
    Cc: Brian Gerst <brgerst@gmail.com>
    Cc: Louis Rilling <Louis.Rilling@kerlabs.com>
    Cc: Valdis.Kletnieks@vt.edu
    Cc: pageexec@freemail.hu
    Link: 
http://lkml.kernel.org/r/b1460f81dc4463d66ea3f2b5ce240f58d48effec.1307292171.git.luto@mit.edu
    Signed-off-by: Ingo Molnar <mingo@elte.hu>

:040000 040000 24ebbf4a851e35bfe4c65074f9e51a20c6ac54c8 
288ec01e5b8ccff746962f40e0e9310a31800c5d M      arch
bisect run success
[arekm@ixion-pld linux]$ git bisect log
git bisect start
# bad: [bbd9d6f7fbb0305c9a592bf05a32e87eb364a4ff] Merge branch 'for-linus' of 
git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs-2.6
git bisect bad bbd9d6f7fbb0305c9a592bf05a32e87eb364a4ff
# good: [02f8c6aee8df3cdc935e9bdd4f2d020306035dbe] Linux 3.0
git bisect good 02f8c6aee8df3cdc935e9bdd4f2d020306035dbe
# good: [cd6340199f65cad63262db0fd561bdcfd69df3bd] bnx2: Close device if 
tx_timeout reset fails
git bisect good cd6340199f65cad63262db0fd561bdcfd69df3bd
# good: [22a3b9771117d566def0150ea787fcc95f16e724] Merge branch 'for-linus' of 
git://git.kernel.org/pub/scm/linux/kernel/git/jikos/hid
git bisect good 22a3b9771117d566def0150ea787fcc95f16e724
# good: [4d4abdcb1dee03a4f9d6d2021622ed07e14dfd17] Merge branch 'perf-core-
for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip
git bisect good 4d4abdcb1dee03a4f9d6d2021622ed07e14dfd17
# good: [3e0b8df79ddb8955d2cce5e858972a9cfe763384] Merge branch 'x86-uv-for-
linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip
git bisect good 3e0b8df79ddb8955d2cce5e858972a9cfe763384
# good: [12ad3ab66103e6582ca69c0c9de18b13487eaaef] superblock: move 
pin_sb_for_writeback() to fs/super.c
git bisect good 12ad3ab66103e6582ca69c0c9de18b13487eaaef
# good: [10d9f309d88ca7f47133d57e99b72810f119f75b] get rid of useless 
dget_parent() in btrfs rename() and link()
git bisect good 10d9f309d88ca7f47133d57e99b72810f119f75b
# bad: [98eedc3a9dbf90cecb91093d2a7fa083942b7d13] Document the vDSO and add a 
reference parser
git bisect bad 98eedc3a9dbf90cecb91093d2a7fa083942b7d13
# bad: [5cec93c216db77c45f7ce970d46283bcb1933884] x86-64: Emulate legacy 
vsyscalls
git bisect bad 5cec93c216db77c45f7ce970d46283bcb1933884
# bad: [0d7b8547fb67d5c2a7d954c56b3715b0e708be4a] x86-64: Remove 
kernel.vsyscall64 sysctl
git bisect bad 0d7b8547fb67d5c2a7d954c56b3715b0e708be4a
# good: [8b4777a4b50cb0c84c1152eac85d24415fb6ff7d] x86-64: Document some of 
entry_64.S
git bisect good 8b4777a4b50cb0c84c1152eac85d24415fb6ff7d
# bad: [9fd67b4ed0714ab718f1f9bd14c344af336a6df7] x86-64: Give vvars their own 
page
git bisect bad 9fd67b4ed0714ab718f1f9bd14c344af336a6df7


-- 
Arkadiusz Miśkiewicz        PLD/Linux Team
arekm / maven.pl            http://ftp.pld-linux.org/
