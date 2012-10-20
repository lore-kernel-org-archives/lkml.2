Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755976Ab2JTQGP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Oct 2012 12:06:15 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:8432 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752191Ab2JTQGN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Oct 2012 12:06:13 -0400
X-Authority-Analysis: v=2.0 cv=dvhZ+ic4 c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=PdVooQ8_IH0A:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=I8zvMHDzoRsA:10 a=6m4_6qrbAAAA:8 a=JAFRKqFjht8yuyCg8v4A:9 a=QEXdDO2ut3YA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Subject: Build bug because of binutils 2.21
From: Steven Rostedt <rostedt@goodmis.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 20 Oct 2012 12:06:10 -0400
Message-ID: <1350749170.2980.25.camel@pippen.local.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter,

Thomas suggested that I email you to decide if a bug I stumbled on with
binutils should be cause to blacklist version 2.21. Note, testing
against 2.22 does not show this issue.

A couple of days ago I went to test 3.6.1-rt2 and while building the
i386 kernel, the build failed. I first thought it was a bug in the -rt
patch, but then I tested vanilla 3.6.1 and that failed too. I then went
to debug this in my non -rt development repo but the build completed
without failure.

With more investigation, it seemed that one repo would cause the issue
but the other did not. A diff -r showed that the two repos were
identical (besides the .git files and my patches directory).

The build was basically:

  cd good
  make ARCH=i386 O=/work/build clean
  make ARCH=i386 O=/work/build
  <works>
  cd ../bad
  make ARCH=i386 O=/work/build clean
  make ARCH=i386 O=/work/build
  <fails build>

The error was:

lib/lib.a(decompress.o):(.rodata+0x44): undefined reference to `unlzo'

In desperation to figure out what was happening, I did the following:

 cp -r bad test
 cd test
 make ARCH=i386 O=/work/build

And it worked! Note, I could go back and forth between the directories
and the test always worked and the 'bad' directory always failed.

Doing a make V=1, I was able to find that the problem happened during
the compile of decompress_unlzo.c. Strange that the file was identical
in both directories. I even removed the file from the good directory and
made it a softlink to the bad one, and the good directory still worked.
I even removed it again and made it a hard link and it still worked!

Finally I found that the output of the assembly from decompress_unlzo.c
was slightly different. By doing the make V=1 code by hand, I could
start with the output of the .s (by making it with the -S gcc option)
that .s created by the good directory would succeed the final link, and
the .s created by the bad directory would fail the final link.

Here's the diff between the two .s files:

--- lib/decompress_unlzo.stable-rt.git.s        2012-10-20 09:37:22.000000000 -0400
+++ lib/decompress_unlzo.stable-xt.git.s        2012-10-20 09:37:22.000000000 -0400
@@ -63,7 +63,7 @@
        .type   parse_header, @function
 parse_header:
 .LFB1043:
-       .file 3 "/work/rt/stable-rt.git/lib/decompress_unlzo.c"
+       .file 3 "/work/rt/stable-xt.git/lib/decompress_unlzo.c"
        .loc 3 55 0
        .cfi_startproc
 .LVL3:
@@ -3942,6 +3942,8 @@
        .string "GNU C 4.6.0"
 .LASF187:
        .string "acpi_disabled"
+.LASF204:
+       .string "/work/rt/stable-xt.git/lib/decompress_unlzo.c"
 .LASF87:
        .string "NR_INACTIVE_FILE"
 .LASF42:
@@ -3996,8 +3998,6 @@
        .string "long long int"
 .LASF101:
        .string "NR_BOUNCE"
-.LASF57:
-       .string "PCPU_FC_EMBED"
 .LASF182:
        .string "ioport_resource"
 .LASF119:
@@ -4308,8 +4308,8 @@
        .string "kmalloc"
 .LASF147:
        .string "unlzo"
-.LASF204:
-       .string "/work/rt/stable-rt.git/lib/decompress_unlzo.c"
+.LASF57:
+       .string "PCPU_FC_EMBED"
 .LASF192:
        .string "x86_bios_cpu_apicid"
 .LASF77:

Note, the stable-rt.git file was the 'bad' directory and the
'stable-xt.git' file was from the good copied directory.

I tarballed all the necessary files and placed them here:
http://rostedt.homelinux.com/private/broken.tar.bz2

If you untar this and go into the broken directory, you will find a
'compile' file. Edit the GCC_PATH and GCC_PREFIX to point to a gcc with
2.21 binutils and you should be able to see this same bug. Note, my gcc
and my binutils were compiled from scratch, and I've been using this for
years and this is the first time I've had issues with it. I tested this
on both a Debian box and a Fedora F14 box, and they both showed the
issue (same version of gcc/binutils for both as I built them
individually for both boxes).

If you run ./compile with no arguments, it will compile, archive and
link the good .s file and should succeed. If you run ./compile with an
argument (any argument), it will compile, archive and link the bad .s
file and should give you that error message. If you run it with an
argument but also define GCC_AR_PATH and GCC_AR_PREFIX to be the path
and prefix of ar from binutils 2.22, it will then work.

It looks like there is a bug with 'ar' in binutils 2.21 that can cause
linking issues with these .s files.

As I said, Thomas suggested to ask you if this should be cause to
blacklist 2.21 as a 'reliable' toolchain for building the kernel. Makes
no difference to me. I've just finished upgrading my distcc farm to
2.22.

-- Steve


