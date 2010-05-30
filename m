Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752257Ab0E3LjP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 May 2010 07:39:15 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:60965 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750946Ab0E3LjO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 May 2010 07:39:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=Jaja+EPLbquT370n9FPwurnVn/O4weECZiPkZLXqvT7Oh2jAE73BX42TFQaINcKQQ+
         RU2VTmvnPdSoB2VXMDyuO/gf/8DZ32YelUbt5KWvHBo25XSKXSNQcSHOu7h7R3thg9mX
         +t0EPqyut2STxJ2k71sWU0lTdTEiReQaftTAs=
MIME-Version: 1.0
In-Reply-To: <201005271944.09541.toralf.foerster@gmx.de>
References: <201005271944.09541.toralf.foerster@gmx.de>
Date: Sun, 30 May 2010 13:39:12 +0200
X-Google-Sender-Auth: nIJClWuVNCqXYbFFG9HIr-D6Sf4
Message-ID: <AANLkTimYeMO_fc8C5MQedwF646_au4lvEbXkBPmQSxb9@mail.gmail.com>
Subject: Re: current git kernel crashes UML system during boot
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: =?UTF-8?Q?Toralf_F=C3=B6rster?= <toralf.foerster@gmx.de>,
       Borislav Petkov <borislav.petkov@amd.com>,
       "H. Peter Anvin" <hpa@zytor.com>
Cc: user-mode-linux-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/5/27 Toralf Förster <toralf.foerster@gmx.de>:
> I bisected it to this :
>
> There are only 'skip'ped commits left to test.
> The first bad commit could be any of:
> 4677d4a53e0d565742277e8913e91c821453e63e
> d61931d89be506372d01a90d1755f6d0a9fafe2d
> 1527bc8b928dd1399c3d3467dd47d9ede210978a
> c59bd5688299cddb71183e156e7a3c1409b90df2
> cb41838bbc4403f7270a94b93a9a0d9fc9c2e7ea
> We cannot bisect more!

For me it crashes even earlier:

ayla$ ./linux
Core dump limits :
	soft - 0
	hard - NONE
Checking that ptrace can change system call numbers...OK
Checking syscall emulation patch for ptrace...OK
Checking advanced syscall emulation patch for ptrace...OK
Checking for tmpfs mount on /dev/shm...OK
Checking PROT_EXEC mmap in /dev/shm/...OK
Checking for the skas3 patch in the host:
  - /proc/mm...not found: No such file or directory
  - PTRACE_FAULTINFO...not found
  - PTRACE_LDT...not found
UML running in SKAS0 mode
Adding 21749760 bytes to physical memory to account for exec-shield gap
Aborted
ayla$

After fixing the missing/superfluous slab inclusion issues, I bisected
it further to

commit d61931d89be506372d01a90d1755f6d0a9fafe2d
Author: Borislav Petkov <borislav.petkov@amd.com>
Date:   Fri Mar 5 17:34:46 2010 +0100

    x86: Add optimized popcnt variants

    Add support for the hardware version of the Hamming weight function,
    popcnt, present in CPUs which advertize it under CPUID, Function
    0x0000_0001_ECX[23]. On CPUs which don't support it, we fallback to the
    default lib/hweight.c sw versions.

    A synthetic benchmark comparing popcnt with __sw_hweight64 showed almost
    a 3x speedup on a F10h machine.

    Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
    LKML-Reference: <20100318112015.GC11152@aftab>
    Signed-off-by: H. Peter Anvin <hpa@zytor.com>

I reverted that commit on top of current mainline (and fixed up the
conflicts), and now
it boots again.

CPU is:

processor	: 0
vendor_id	: GenuineIntel
cpu family	: 6
model		: 23
model name	: Intel(R) Core(TM)2 Quad  CPU   Q8200  @ 2.33GHz
stepping	: 7
cpu MHz		: 2003.000
cache size	: 2048 KB
physical id	: 0
siblings	: 4
core id		: 0
cpu cores	: 4
apicid		: 0
initial apicid	: 0
fpu		: yes
fpu_exception	: yes
cpuid level	: 10
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov
pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx
lm constant_tsc arch_perfmon pebs bts rep_good aperfmperf pni dtes64
monitor ds_cpl est tm2 ssse3 cx16 xtpr pdcm sse4_1 lahf_lm
bogomips	: 4665.87
clflush size	: 64
cache_alignment	: 64
address sizes	: 36 bits physical, 48 bits virtual
power management:

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
