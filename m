Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754320Ab1BWHn2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 02:43:28 -0500
Received: from smtp-out.google.com ([74.125.121.67]:55278 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753996Ab1BWHnW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 02:43:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=uzGirVz1guHPkkRO2yN7H3HObb0wE6BI5Yj+uuHpFABmTaEsT8fkZluEFwmBE8hwCL
         V4t/t5hmzR8U8QeCgx6Q==
MIME-Version: 1.0
In-Reply-To: <4D61D230.907@cn.fujitsu.com>
References: <20110216031831.571628191@google.com> <4D61D230.907@cn.fujitsu.com>
From: Paul Turner <pjt@google.com>
Date: Tue, 22 Feb 2011 23:42:48 -0800
Message-ID: <AANLkTinyZSeTQd9t9wCp+LMZ+gGM4H0mZBc+daZgnZ5u@mail.gmail.com>
Subject: Re: [CFS Bandwidth Control v4 0/7] Introduction
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, Bharata B Rao <bharata@linux.vnet.ibm.com>,
        Dhaval Giani <dhaval@linux.vnet.ibm.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Gautham R Shenoy <ego@in.ibm.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Pavel Emelyanov <xemul@openvz.org>,
        Herbert Poetzl <herbert@13thfloor.at>, Avi Kivity <avi@redhat.com>,
        Chris Friesen <cfriesen@nortel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for the report Xiao -- I wasn't able to reproduce this yet with
a simple guest, I will try a more modern image tomorrow.

One suspicion is that this might be connected with the missing
runnable accounting in sched_stoptask.c.

On Sun, Feb 20, 2011 at 6:47 PM, Xiao Guangrong
<xiaoguangrong@cn.fujitsu.com> wrote:
> On 02/16/2011 11:18 AM, Paul Turner wrote:
>> Hi all,
>>
>> Please find attached v4 of CFS bandwidth control; while this rebase against
>> some of the latest SCHED_NORMAL code is new, the features and methodology are
>> fairly mature at this point and have proved both effective and stable for
>> several workloads.
>>
>> As always, all comments/feedback welcome.
>>
>
> Hi Paul,
>
> Thanks for the great features!
>
> I applied the patchset to kvm tree, then tested with kvm guest, unfortunately,
> it seems don't work normally.
>
> The steps is follow:
>
> # mount -t cgroup -o cpu none /mnt/
> # qemu-system-x86_64 -enable-kvm  -smp 4 -m 512M -drive file=fc64.img,index=0,media=disk
>
> Don't do any configuration in cgroup, and run the kvm guest directly (don't use libvirt),
> the guest booted very slowly and i saw some "soft lockup" bugs reported in the guest,
> i also noticed one CPU usage is 100% for more than 60s and other CPUs is 10%~30% in the host
> when guest was booting.
>
> And if cgroup is not mounted, the guest runs well.
>
> The kernel config file is attached and my system cpu info is:
>
> # cat /proc/cpuinfo
> processor       : 0
> vendor_id       : GenuineIntel
> cpu family      : 6
> model           : 30
> model name      : Intel(R) Core(TM) i5 CPU         760  @ 2.80GHz
> stepping        : 5
> cpu MHz         : 1197.000
> cache size      : 8192 KB
> physical id     : 0
> siblings        : 4
> core id         : 0
> cpu cores       : 4
> apicid          : 0
> initial apicid  : 0
> fpu             : yes
> fpu_exception   : yes
> cpuid level     : 11
> wp              : yes
> flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx rdtscp lm constant_tsc arch_perfmon pebs bts rep_good nopl xtopology nonstop_tsc aperfmperf pni dtes64 monitor ds_cpl vmx smx est tm2 ssse3 cx16 xtpr pdcm sse4_1 sse4_2 popcnt lahf_lm ida dts tpr_shadow vnmi flexpriority ept vpid
> bogomips        : 5584.73
> clflush size    : 64
> cache_alignment : 64
> address sizes   : 36 bits physical, 48 bits virtual
> power management:
>
> processor       : 1
> vendor_id       : GenuineIntel
> cpu family      : 6
> model           : 30
> model name      : Intel(R) Core(TM) i5 CPU         760  @ 2.80GHz
> stepping        : 5
> cpu MHz         : 1197.000
> cache size      : 8192 KB
> physical id     : 0
> siblings        : 4
> core id         : 1
> cpu cores       : 4
> apicid          : 2
> initial apicid  : 2
> fpu             : yes
> fpu_exception   : yes
> cpuid level     : 11
> wp              : yes
> flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx rdtscp lm constant_tsc arch_perfmon pebs bts rep_good nopl xtopology nonstop_tsc aperfmperf pni dtes64 monitor ds_cpl vmx smx est tm2 ssse3 cx16 xtpr pdcm sse4_1 sse4_2 popcnt lahf_lm ida dts tpr_shadow vnmi flexpriority ept vpid
> bogomips        : 5585.03
> clflush size    : 64
> cache_alignment : 64
> address sizes   : 36 bits physical, 48 bits virtual
> power management:
>
> processor       : 2
> vendor_id       : GenuineIntel
> cpu family      : 6
> model           : 30
> model name      : Intel(R) Core(TM) i5 CPU         760  @ 2.80GHz
> stepping        : 5
> cpu MHz         : 1197.000
> cache size      : 8192 KB
> physical id     : 0
> siblings        : 4
> core id         : 2
> cpu cores       : 4
> apicid          : 4
> initial apicid  : 4
> fpu             : yes
> fpu_exception   : yes
> cpuid level     : 11
> wp              : yes
> flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx rdtscp lm constant_tsc arch_perfmon pebs bts rep_good nopl xtopology nonstop_tsc aperfmperf pni dtes64 monitor ds_cpl vmx smx est tm2 ssse3 cx16 xtpr pdcm sse4_1 sse4_2 popcnt lahf_lm ida dts tpr_shadow vnmi flexpriority ept vpid
> bogomips        : 5585.03
> clflush size    : 64
> cache_alignment : 64
> address sizes   : 36 bits physical, 48 bits virtual
> power management:
>
> processor       : 3
> vendor_id       : GenuineIntel
> cpu family      : 6
> model           : 30
> model name      : Intel(R) Core(TM) i5 CPU         760  @ 2.80GHz
> stepping        : 5
> cpu MHz         : 1197.000
> cache size      : 8192 KB
> physical id     : 0
> siblings        : 4
> core id         : 3
> cpu cores       : 4
> apicid          : 6
> initial apicid  : 6
> fpu             : yes
> fpu_exception   : yes
> cpuid level     : 11
> wp              : yes
> flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx rdtscp lm constant_tsc arch_perfmon pebs bts rep_good nopl xtopology nonstop_tsc aperfmperf pni dtes64 monitor ds_cpl vmx smx est tm2 ssse3 cx16 xtpr pdcm sse4_1 sse4_2 popcnt lahf_lm ida dts tpr_shadow vnmi flexpriority ept vpid
> bogomips        : 5585.03
> clflush size    : 64
> cache_alignment : 64
> address sizes   : 36 bits physical, 48 bits virtual
> power management:
>
>
>
