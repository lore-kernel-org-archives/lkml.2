Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755405Ab1KPJe0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 04:34:26 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:56190 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753689Ab1KPJeY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 04:34:24 -0500
Date: Wed, 16 Nov 2011 17:32:56 +0800
From: wangyanqing <udknight@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: castet.matthieu@free.fr, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, gregkh@suse.de, tglx@linutronix.de,
        mingo@elte.hu, hpa@linux.intel.com, spock@gentoo.org
Subject: Re: [PATCH -V1] x86: make executable for video bios area
Message-ID: <20111116093256.GA5390@udknight.homenetwork>
Mail-Followup-To: wangyanqing <Udknight@gmail.com>,
	linux-kernel@vger.kernel.org, castet.matthieu@free.fr,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	gregkh@suse.de, tglx@linutronix.de, mingo@elte.hu,
	hpa@linux.intel.com, spock@gentoo.org
References: <20111115064237.GA3990@udknight.homenetwork>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111115064237.GA3990@udknight.homenetwork>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All!
Here is the result of my research, hope it is useful to resolve this question.

Notice:trace from up to down	
1:pci_arch_init()

2:pci_mmcfg_early_init() ;boot without PCI_PROBE_NOEARLY  

3:__pci_mmcfg_init(1);

4:pci_mmcfg_arch_init(); mmcfg need acpi

5:pci_probe = (pci_probe & ~PCI_PROBE_MASK) | PCI_PROBE_MMCONF; <== IMPORTANT: clean PCI_PROBE_BIOS away

6:pci_pcbios_init();

7:pci_probe & PCI_PROBE_BIOS ; it will fail

8:pci_find_bios() will no chance to execute 

the result is:
1:pcibios_enabled will always 0
2:set_bios_x will no chance to execute, so from BIOS_BEGIN to BIOS_END is  NX

lrmi:linux real mode interface project, http://sourceforge.net/projects/lrmi/
v86d use lrmi
lrmi.c:358

 if (!map_file((void *)0xc0000, 0x40000,
                PROT_READ | PROT_EXEC,
                MAP_FIXED | MAP_SHARED, "/dev/mem", 0xc0000)) {
                munmap((void *)0, 0x502);
                munmap((void *)0xa0000, 0x20000);
                real_mem_deinit();
                return 0;
        }
this function to map 000c0000-00100000 with X privilege

00000000-00001000 rw-s 00000000 00:01 822        /dev/mem 
00009000-0000a000 r-xp 00001000 00:01 912        /sbin/v86d 
00010000-00050000 rwxp 00000000 00:01 818        /dev/zero 
000a0000-000c0000 rw-s 000a0000 00:01 822        /dev/mem 
000c0000-00100000 r-xs 000c0000 00:01 822        /dev/mem 
08048000-0804c000 r-xp 00001000 00:01 912        /sbin/v86d 
0804c000-0804d000 rw-p 00004000 00:01 912        /sbin/v86d 
b779a000-b779b000 r-xp 00000000 00:00 0          [vdso]
bfac2000-bfae3000 rw-p 00000000 00:00 0          [stack]

At last we get the reason that my machine hang with black screen
The reason is when I boot with ACPI, BIOS_BEGIN to BIOS_END is NX,
then v86d try to map 0xc0000 to 0x100000 with executable privilege, 
it mmap success(mem.c:300, mmap_mem haven't check whether it is illegal), 
but the pages between BIOS_BEGIN and BIOS_END is NX at all, so it hang!

Question:
1:boot with ACPI make BIOS area NX on X86, is that what we want?
2:mmap_mem haven't check whether it is illegal the mmap target address, right?

Thanks




