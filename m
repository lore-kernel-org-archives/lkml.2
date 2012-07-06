Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030372Ab2GFMHz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 08:07:55 -0400
Received: from mo-p00-ob.rzone.de ([81.169.146.162]:35201 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030326Ab2GFMHy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 08:07:54 -0400
X-RZG-AUTH: :P2EQZWCpfu+qG7CngxMFH1J+zrwiavkK6tmQaLfmwtM48/lk3M7oE7o=
X-RZG-CLASS-ID: mo00
Date: Fri, 6 Jul 2012 14:07:50 +0200
From: Olaf Hering <olaf@aepfle.de>
To: Daniel Kiper <dkiper@net-space.pl>
Cc: kexec@lists.infradead.org, xen-devel@lists.xensource.com,
        linux-kernel@vger.kernel.org
Subject: Re: incorrect layout of globals from head_64.S during kexec boot
Message-ID: <20120706120750.GA8970@aepfle.de>
References: <20120705210607.GA26908@aepfle.de>
 <20120706084120.GA31219@router-fw-old.local.net-space.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20120706084120.GA31219@router-fw-old.local.net-space.pl>
User-Agent: Mutt/1.5.21.rev5543 (2011-12-20)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 06, Daniel Kiper wrote:

> Copy is done a few times durnig kexec/kdump but the most important
> in this case, I think, is in relocate_kernel() function (look for
> rep movsl or rep movsq and code around it). But I am a bit surprised
> that kernel is decompressing itself. I always thought that it is done
> during kexec/kdump load phase but maybe I am wrong. Could you send
> me more info about your Linux Kernel version, kexec-tools version
> and exact commands which you are using to load/exececute kernel?

Its kexec-tools and kernel mainline, but it happens also with older
versions of both. kexec works fine with the forward ported version of
xenlinux.

kexec -l bzImage --ramdisk=/boot/initrd-3.5.0-rc5-bug694863+ '--command-line=root=/dev/disk/by-label/sles11sp1_full
sysrq=yes
panic=9
oops=panic
console=ttyS0,115200
log_buf_len=16M
ignore_loglevel
initcall_debug
debug earlyprintk=serial,ttyS0,115200' -t bzImage --console-serial --serial=ttyS0 --serial-baud=115200 --debug
kexec -e


As Jan pointed out, the copying is done in
arch/x86/boot/compressed/misc.c. But adding some debug to inspect
*output in parse_elf() shows that the second entry in program headers is
already shifted by 44 bytes in my testing, the others are shifted by the
same amount.

Program Headers:
  Type           Offset   VirtAddr           PhysAddr           FileSiz  MemSiz   Flg Align
  LOAD           0x200000 0xffffffff81000000 0x0000000001000000 0xa3b000 0xa3b000 R E 0x200000
  LOAD           0xe00000 0xffffffff81c00000 0x0000000001c00000 0x05b0e8 0x05b0e8 RW  0x200000
  LOAD           0x1000000 0x0000000000000000 0x0000000001c5c000 0x012c40 0x012c40 RW  0x200000
  LOAD           0x106f000 0xffffffff81c6f000 0x0000000001c6f000 0x087000 0x702000 RWE 0x200000
  NOTE           0x82d5bc 0xffffffff8162d5bc 0x000000000162d5bc 0x00017c 0x00017c     0x4


That makes me wonder wether kexec-tools is the culprit.

Olaf
