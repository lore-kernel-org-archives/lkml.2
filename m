Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752147Ab1BOHne (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 02:43:34 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:61759 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750982Ab1BOHnc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 02:43:32 -0500
Message-ID: <4D5A2E9F.4080702@monstr.eu>
Date: Tue, 15 Feb 2011 08:43:27 +0100
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Thunderbird 2.0.0.22 (X11/20090625)
MIME-Version: 1.0
To: "Steven J. Magnani" <steve@digidescorp.com>
CC: microblaze-uclinux@itee.uq.edu.au, linux-kernel@vger.kernel.org,
        stable@kernel.org
Subject: Re: [PATCH] microblaze: fix /dev/zero corruption from __clear_user()
References: <1297361533-24627-1-git-send-email-steve@digidescorp.com>
In-Reply-To: <1297361533-24627-1-git-send-email-steve@digidescorp.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven J. Magnani wrote:
> A userland read of more than PAGE_SIZE bytes from /dev/zero results in
> (a) not all of the bytes returned being zero, and
> (b) memory corruption due to zeroing of bytes beyond the user buffer.
> 
> This is caused by improper constraints on the assembly __clear_user function.
> The constrints don't indicate to the compiler that the pointer argument is
> modified. Since the function is inline, this results in double-incrementing
> of the pointer when __clear_user() is invoked through a multi-page read() of
> /dev/zero. 
> 
> Signed-off-by: Steven J. Magnani <steve@digidescorp.com>

I wasn't able to reproduce this issue on MMU and noMMU systems (log below).
I think it is toolchain issue.

Anyway it will be the best not to increment "to" at all and use "n" as offset.
This could also speed it up this function.
There is also possibility to add sb to delay slot but it works from Microblaze 5.00.a and later.

I will add this patch to my next branch and will be good to get some statistic and then to write
some optimization for it.

Acked-by: Michal Simek <monstr@monstr.eu>

Thanks,
Michal


My log:
# dd if=/dev/zero of=/tmp/1 bs=64k count=1
1+0 records in
1+0 records out
~ # hexdump /tmp/1
0000000 0000 0000 0000 0000 0000 0000 0000 0000
*
0010000
~ # md5sum /tmp/1
fcd6bcb56c1689fcef28b57c22475bad  /tmp/1
~ # cat /proc/cpuinfo
CPU-Family:     MicroBlaze
FPGA-Arch:      spartan6
CPU-Ver:        7.30.a, big endian
CPU-MHz:        90.00
BogoMips:       44.54
HW:
  Shift:         yes
  MSR:           yes
  PCMP:          yes
  DIV:           no
  MMU:           3
  MUL:           v2
  FPU:           no
  Exc:           ill
Icache:         16kB    line length:    16B
Dcache:         16kB    line length:    16B
                 write-through
HW-Debug:       yes
PVR-USR1:       00
PVR-USR2:       00000000
Page size:      16384
~ #

-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel 2.6 Microblaze Linux - http://www.monstr.eu/fdt/
Microblaze U-BOOT custodian
