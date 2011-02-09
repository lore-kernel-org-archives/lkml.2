Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754377Ab1BIUKI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Feb 2011 15:10:08 -0500
Received: from imp02.mtu.ru ([62.5.255.19]:56931 "EHLO imp02.mtu.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752505Ab1BIUKG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Feb 2011 15:10:06 -0500
Message-ID: <4D52F404.4000709@pavlinux.ru>
Date: Wed, 09 Feb 2011 23:07:32 +0300
From: Pavel Vasilyev <pavel@pavlinux.ru>
Reply-To: pavel@pavlinux.ru
Organization: Pavlinux. Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; ru; rv:1.9.2.13) Gecko/20101206 Microsoft/666 Notepad
MIME-Version: 1.0
To: Andy Isaacson <adi@hexapodia.org>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: CONFIG_KERNEL_XZ obscure build failure if xz(1) not installed
References: <20110209195258.GN11874@hexapodia.org>
In-Reply-To: <20110209195258.GN11874@hexapodia.org>
X-Enigmail-Version: 1.1.2
OpenPGP: id=03742489
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Flag: NO
X-Spam-Yversion: Spamooborona-3.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

09.02.2011 22:52, Andy Isaacson пишет:
> % uname -m
> x86_64
> % git log -1 | head
> commit 100b33c8bd8a3235fd0b7948338d6cbb3db3c63d
> % grep XZ .config
> CONFIG_HAVE_KERNEL_XZ=y
> CONFIG_KERNEL_XZ=y
> CONFIG_RD_XZ=y
> CONFIG_SQUASHFS_XZ=y
> CONFIG_XZ_DEC=y
> CONFIG_XZ_DEC_X86=y
> CONFIG_XZ_DEC_POWERPC=y
> CONFIG_XZ_DEC_IA64=y
> CONFIG_XZ_DEC_ARM=y
> CONFIG_XZ_DEC_ARMTHUMB=y
> CONFIG_XZ_DEC_SPARC=y
> CONFIG_XZ_DEC_BCJ=y
> CONFIG_XZ_DEC_TEST=y
> CONFIG_DECOMPRESS_XZ=y
> % make -j4
> ...
>   CC      arch/x86/boot/tty.o
>   CC      arch/x86/oprofile/oprofile.mod.o
>   XZKERN  arch/x86/boot/compressed/vmlinux.bin.xz
> exec: 23: xz: not found
>   CC      arch/x86/boot/video.o
>   CC      crypto/crc32c.mod.o
>   CC      crypto/pcrypt.mod.o
>   CC      arch/x86/boot/video-mode.o
>   CC      drivers/acpi/acpi_memhotplug.mod.o
>   MKPIGGY arch/x86/boot/compressed/piggy.S
> arch/x86/boot/compressed/vmlinux.bin.xz: No such file or directory
>   CC      arch/x86/boot/version.o
>   LD      arch/x86/boot/compressed/vmlinux
> ... [hundreds of lines of output snipped]
>   LD [M]  net/sched/act_csum.ko
>   IHEX    firmware/bnx2/bnx2-mips-09-6.2.1.fw
>   IHEX    firmware/bnx2/bnx2-mips-06-6.2.1.fw
> % echo $?
> 2
> % ls -l arch/x86/boot/bzImage
> -rw-r--r-- 1 adi adi 1991504 Feb  1 18:41 arch/x86/boot/bzImage
> 
> The failure is obscured by trailing make output, and since a broken
> bzImage is created, "make install" succeeds, and the first visible
> failure is after reboot when I get the lovely
> 
>     Decompressing Linux...
> 
>     Input is not in the XZ format (wrong magic bytes)
> 
>      -- System halted
> 
> Sometimes I run "make -j4 && make install" which would have caught this,
> but the error should be more prominent and we shouldn't create bzImage
> if the dependencies are not present.

 :)

Signed-off-by: Pavel Vasilyev <pavel@pavlinux.ru>
---
diff --git a/scripts/xz_wrap.sh b/scripts/xz_wrap.sh
index 17a5798..5ec9d36 100644
--- a/scripts/xz_wrap.sh
+++ b/scripts/xz_wrap.sh
@@ -20,4 +20,4 @@ case $ARCH in
        sparc)          BCJ=--sparc ;;
 esac

-exec xz --check=crc32 $BCJ --lzma2=$LZMA2OPTS,dict=32MiB
+exec xz --check=crc32 $BCJ --lzma2=$LZMA2OPTS,dict=32MiB || exit 1

-- 

                                                         Pavel.
