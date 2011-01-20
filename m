Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753468Ab1ATRzj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 12:55:39 -0500
Received: from mail3.caviumnetworks.com ([12.108.191.235]:15272 "EHLO
	mail3.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753411Ab1ATRzh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 12:55:37 -0500
Message-ID: <4D387719.5030508@caviumnetworks.com>
Date: Thu, 20 Jan 2011 09:55:37 -0800
From: David Daney <ddaney@caviumnetworks.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101027 Fedora/3.0.10-1.fc12 Thunderbird/3.0.10
MIME-Version: 1.0
To: Deng-Cheng Zhu <dengcheng.zhu@gmail.com>
CC: linux-mips@linux-mips.org, ralf@linux-mips.org,
        linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [PATCH 0/6] MIPS: perf: Make perf work for 64-bit/Octeon counters.
References: <1294367707-2593-1-git-send-email-ddaney@caviumnetworks.com> <AANLkTimZKz_Epg8DOvwkWWcS0viUa2V2TygUS80osEwh@mail.gmail.com>
In-Reply-To: <AANLkTimZKz_Epg8DOvwkWWcS0viUa2V2TygUS80osEwh@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 20 Jan 2011 17:55:37.0609 (UTC) FILETIME=[3E779F90:01CBB8CB]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/20/2011 01:59 AM, Deng-Cheng Zhu wrote:
> Hi, David
>
>
> Today I did a quick test against your patch set on my MIPS32 Malta board.
> After fixing a small compiling issue (see my comment for patch #5), I
> successfully built the kernel based on my previous mainline-sync changes.
> And when doing the test, I was using the an previously compiled 'perf'
> tool, because the latest perf tool needs arch specific DWARF register
> mapping definitions (and currently we have not yet submitted this patch).
>
> And here's the test result:
>
> # When this patch set is built in, the simple 'perf stat' command takes
> very long time (182 seconds for the ls command). See following:
>
> -sh-4.0# perf stat -e cycles -e instructions ls /
> bin   dev  home  lost+found  opt   root  share  tmp    usr
> boot  etc  lib   mnt         proc  sbin  sys    trans  var
>
>   Performance counter stats for 'ls /':
>
>           2825998290  cycles
>           2148970283  instructions             #      0.760 IPC
>
>        181.901999444  seconds time elapsed
>
> # When this patch is NOT used, namely, only the mainline-sync changes are
> built in, the time looks reasonable:
>
> -sh-4.0# perf stat -e cycles -e instructions ls /
> bin   dev  home  lost+found  opt   root  share  tmp    usr
> boot  etc  lib   mnt         proc  sbin  sys    trans  var
>
>   Performance counter stats for 'ls /':
>
>              2051461  cycles
>              1041512  instructions             #      0.508 IPC
>
>          0.046426513  seconds time elapsed
>
> I noticed that you changed quite a lot of original logics in MIPS
> Perf-events, including the deletion of the 'msbs' member in the struct
> cpu_hw_events. Honestly speaking, I have not yet taken a careful look into
> the patch set to find out how you deal with the MIPS specific 0x80000000
> counter overflow (certainly, the value is for MIPS32), instead of
> 0xffffffff. But maybe this code logic could be related to the test result.
>


I will try to figure out what is happening.  Most of my testing was done 
with an explicit '-c' argument to the perf tool.

Thanks for testing it.

If it is OK with you, and once we have tested it, we could use the last 
patch set you posted to lmo 
(http://patchwork.linux-mips.org/patch/1850/), and add mine on top of it.

David Daney









>
> Deng-Cheng
>
>
> 2011/1/7 David Daney<ddaney@caviumnetworks.com>:
>> The existing MIPS perf hardware counter support only handles 32-bit
>> wide counters.  Some CPUs (like Octeon) have the 64-bit wide variety.
>> This patch set allows perf to work on Octeon, and I hope not break
>> existing systems.  I have not tested it on non-Octeon systems, so it
>> would be good if someone could test that.
>>
>> Summary of the patches:
>>
>> 1) Fix faulty Octeon interrupt controller code.
>>
>> 2) Add some register definitions.
>>
>> 3,4) Clean up existing code.
>>
>> 5) 64-bit perf counter support.
>>
>> 6) Octeon perf event bindings.
>>
>> Patch 4/6 is the biggest and has the highest chance of having broken
>> something.
>>
>> This patch set depends on a couple of others that have previously been
>> sent to Ralf:
>>
>> http://patchwork.linux-mips.org/patch/1927/
>> http://patchwork.linux-mips.org/patch/1850/
>> http://patchwork.linux-mips.org/patch/1851/
>> http://patchwork.linux-mips.org/patch/1852/
>> http://patchwork.linux-mips.org/patch/1853/
>> http://patchwork.linux-mips.org/patch/1854/
>>
>> David Daney (6):
>>   MIPS: Octeon: Enable per-CPU IRQs on all CPUs.
>>   MIPS: Add accessor macros for 64-bit performance counter registers.
>>   MIPS: perf: Cleanup formatting in arch/mips/kernel/perf_event.c
>>   MIPS: perf: Reorganize contents of perf support files.
>>   MIPS: perf: Add support for 64-bit perf counters.
>>   MIPS: perf: Add Octeon support for hardware perf.
>>
>>   arch/mips/Kconfig                    |    2 +-
>>   arch/mips/cavium-octeon/octeon-irq.c |   30 +-
>>   arch/mips/cavium-octeon/smp.c        |   10 +
>>   arch/mips/include/asm/mipsregs.h     |    8 +
>>   arch/mips/kernel/Makefile            |    5 +-
>>   arch/mips/kernel/perf_event.c        |  521 +--------------
>>   arch/mips/kernel/perf_event_mipsxx.c | 1265 +++++++++++++++++++++++++---------
>>   7 files changed, 977 insertions(+), 864 deletions(-)
>>
>> Cc: Peter Zijlstra<a.p.zijlstra@chello.nl>
>> Cc: Paul Mackerras<paulus@samba.org>
>> Cc: Ingo Molnar<mingo@elte.hu>
>> Cc: Arnaldo Carvalho de Melo<acme@redhat.com>
>> Cc: Deng-Cheng Zhu<dengcheng.zhu@gmail.com>
>> --
>> 1.7.2.3
>>
>>
>

