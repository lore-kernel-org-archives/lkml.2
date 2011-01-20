Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755326Ab1ATJ7y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 04:59:54 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:33864 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755301Ab1ATJ7v convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 04:59:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=DraEUoHw7A9yDxuG3dmXXzXRYAUHGsE61btY0Z8DmEEFySsGPIK1TI6mQ0oDO67aws
         sufeH/3YgZhYo5SZj/TJwWVSMEA+WoYKnHey9qi0w1rt414NKZxL4OQw7g+2VW2E6VPI
         DEeAFF5A5DssVql4GsJiRFuat2e+Ffm8q257s=
MIME-Version: 1.0
In-Reply-To: <1294367707-2593-1-git-send-email-ddaney@caviumnetworks.com>
References: <1294367707-2593-1-git-send-email-ddaney@caviumnetworks.com>
Date: Thu, 20 Jan 2011 17:59:49 +0800
Message-ID: <AANLkTimZKz_Epg8DOvwkWWcS0viUa2V2TygUS80osEwh@mail.gmail.com>
Subject: Re: [PATCH 0/6] MIPS: perf: Make perf work for 64-bit/Octeon counters.
From: Deng-Cheng Zhu <dengcheng.zhu@gmail.com>
To: David Daney <ddaney@caviumnetworks.com>
Cc: linux-mips@linux-mips.org, ralf@linux-mips.org,
        linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, David


Today I did a quick test against your patch set on my MIPS32 Malta board.
After fixing a small compiling issue (see my comment for patch #5), I
successfully built the kernel based on my previous mainline-sync changes.
And when doing the test, I was using the an previously compiled 'perf'
tool, because the latest perf tool needs arch specific DWARF register
mapping definitions (and currently we have not yet submitted this patch).

And here's the test result:

# When this patch set is built in, the simple 'perf stat' command takes
very long time (182 seconds for the ls command). See following:

-sh-4.0# perf stat -e cycles -e instructions ls /
bin   dev  home  lost+found  opt   root  share  tmp    usr
boot  etc  lib   mnt         proc  sbin  sys    trans  var

 Performance counter stats for 'ls /':

         2825998290  cycles
         2148970283  instructions             #      0.760 IPC

      181.901999444  seconds time elapsed

# When this patch is NOT used, namely, only the mainline-sync changes are
built in, the time looks reasonable:

-sh-4.0# perf stat -e cycles -e instructions ls /
bin   dev  home  lost+found  opt   root  share  tmp    usr
boot  etc  lib   mnt         proc  sbin  sys    trans  var

 Performance counter stats for 'ls /':

            2051461  cycles
            1041512  instructions             #      0.508 IPC

        0.046426513  seconds time elapsed

I noticed that you changed quite a lot of original logics in MIPS
Perf-events, including the deletion of the 'msbs' member in the struct
cpu_hw_events. Honestly speaking, I have not yet taken a careful look into
the patch set to find out how you deal with the MIPS specific 0x80000000
counter overflow (certainly, the value is for MIPS32), instead of
0xffffffff. But maybe this code logic could be related to the test result.


Deng-Cheng


2011/1/7 David Daney <ddaney@caviumnetworks.com>:
> The existing MIPS perf hardware counter support only handles 32-bit
> wide counters.  Some CPUs (like Octeon) have the 64-bit wide variety.
> This patch set allows perf to work on Octeon, and I hope not break
> existing systems.  I have not tested it on non-Octeon systems, so it
> would be good if someone could test that.
>
> Summary of the patches:
>
> 1) Fix faulty Octeon interrupt controller code.
>
> 2) Add some register definitions.
>
> 3,4) Clean up existing code.
>
> 5) 64-bit perf counter support.
>
> 6) Octeon perf event bindings.
>
> Patch 4/6 is the biggest and has the highest chance of having broken
> something.
>
> This patch set depends on a couple of others that have previously been
> sent to Ralf:
>
> http://patchwork.linux-mips.org/patch/1927/
> http://patchwork.linux-mips.org/patch/1850/
> http://patchwork.linux-mips.org/patch/1851/
> http://patchwork.linux-mips.org/patch/1852/
> http://patchwork.linux-mips.org/patch/1853/
> http://patchwork.linux-mips.org/patch/1854/
>
> David Daney (6):
>  MIPS: Octeon: Enable per-CPU IRQs on all CPUs.
>  MIPS: Add accessor macros for 64-bit performance counter registers.
>  MIPS: perf: Cleanup formatting in arch/mips/kernel/perf_event.c
>  MIPS: perf: Reorganize contents of perf support files.
>  MIPS: perf: Add support for 64-bit perf counters.
>  MIPS: perf: Add Octeon support for hardware perf.
>
>  arch/mips/Kconfig                    |    2 +-
>  arch/mips/cavium-octeon/octeon-irq.c |   30 +-
>  arch/mips/cavium-octeon/smp.c        |   10 +
>  arch/mips/include/asm/mipsregs.h     |    8 +
>  arch/mips/kernel/Makefile            |    5 +-
>  arch/mips/kernel/perf_event.c        |  521 +--------------
>  arch/mips/kernel/perf_event_mipsxx.c | 1265 +++++++++++++++++++++++++---------
>  7 files changed, 977 insertions(+), 864 deletions(-)
>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
> Cc: Deng-Cheng Zhu <dengcheng.zhu@gmail.com>
> --
> 1.7.2.3
>
>
