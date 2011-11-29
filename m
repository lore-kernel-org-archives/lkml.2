Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754624Ab1K2Khh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 05:37:37 -0500
Received: from e28smtp09.in.ibm.com ([122.248.162.9]:49415 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753908Ab1K2Khe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 05:37:34 -0500
Message-ID: <4ED4B5E1.1070900@linux.vnet.ibm.com>
Date: Tue, 29 Nov 2011 16:07:21 +0530
From: Deepthi Dharwar <deepthi@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.23) Gecko/20110922 Thunderbird/3.1.15
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
CC: Nicolas Kalkhof <nkalkhof@web.de>, linux-kernel@vger.kernel.org,
        Linux PM mailing list <linux-pm@vger.kernel.org>,
        linux-acpi@vger.kernel.org
Subject: Re: Too many poll_idle cpu calls in kernel 3.2 rc-series
References: <1587582695.5658131.1322424808507.JavaMail.fmail@mwmweb005> <4ED3E8AD.6050304@linux.vnet.ibm.com>
In-Reply-To: <4ED3E8AD.6050304@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 11112910-2674-0000-0000-000001E805E1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 11/29/2011 01:31 AM, Srivatsa S. Bhat wrote:

> 
> Adding linux-pm mailing list to CC.
> 
> Thanks,
> Srivatsa S. Bhat
> 
> On 11/28/2011 01:43 AM, Nicolas Kalkhof wrote:
> 
>> the kernel v3.2 series shows excessive poll_idle calls during system idle phases causing the cpu
>> (mobile i7 2620M) to heat up and draw additional 10% more power.  All kernel versions between
>> 3.2-rc1 and 3.2-rc3 are affected. Perf Top and Powertop both show the same issue.
>> I've posted a similar bug report before: http://marc.info/?l=linux-kernel&m=132164909313594&w=2
>> and used perf top -U to verify the poll_idle calls as requested.
>>
>> dmesg and kernel .config attached.
>>
>> Could someone please confirm this issue?
>>
>> Thanks and Regards
>> Nic
>>
>> perf top -U shows:
>> Events: 30K cycles
>>  97.88%  [kernel]   [k] poll_idle
>>   0.17%  [kernel]   [k] sdhci_irq
>>   0.08%  [kernel]   [k] unix_poll
>>   0.06%  [kernel]   [k] _raw_spin_lock_irqsave
>>   0.06%  [kernel]   [k] page_fault
>>   0.05%  [kernel]   [k] fget_light
>>   0.05%  [kernel]   [k] format_decode
>>   0.04%  [kernel]   [k] kmem_cache_alloc
>>   0.04%  [kernel]   [k] clear_page
>>   0.04%  [kernel]   [k] _raw_spin_unlock_irqrestore
>>   0.03%  [kernel]   [k] do_select
>>   0.03%  [kernel]   [k] seq_printf
>>   0.03%  [kernel]   [k] vfs_read
>>   0.03%  [kernel]   [k] _raw_spin_lock
>>   0.03%  [kernel]   [k] vsnprintf
>>   0.03%  [kernel]   [k] number.clone.1
>>   0.03%  [kernel]   [k] fput
>>
>> Powertop shows:
>> n                Avg residency       P-states (frequencies)
>> C0 (cpu running)        ( 5.4%)       Turbo Mode     1.5%
>> polling           1.8ms (94.6%)         2.71 Ghz     0.1%
>> C1 mwait          0.0ms ( 0.0%)         2.21 Ghz     0.1%
>> C2 mwait          0.0ms ( 0.0%)         1400 Mhz     0.1%
>> C3 mwait          0.0ms ( 0.0%)          800 Mhz    98.2%
>> C4 mwait          0.0ms ( 0.0%)
>> Wakeups-from-idle per second : 529.4    interval: 5.0s
>>
> 


I compiled and tested the latest kernel 3.2-rc3 on my thinkpad i5-2540M
(sandy bridge config) with Intel_Idle enabled after few mins of
booting and I see that the cores are going to lower C-states.

Following is my powertop o/p:
===========================
Core    	|             CPU 0               CPU 1
POLL        0.0%    | POLL        0.0%    0.0 ms      0.0%    0.0 ms
C1-SNB      1.4%    | C1-SNB      2.2%    0.7 ms      0.5%    0.9 ms
C3-SNB      0.9%    | C3-SNB      1.6%    1.2 ms      0.1%    1.2 ms
C6-SNB      0.2%    | C6-SNB      0.3%    1.6 ms      0.0%    0.9 ms
C7-SNB     95.8%    | C7-SNB     93.7%    3.7 ms     97.8%   15.1 ms

Core    |             CPU 2               CPU 3
POLL        0.0%    | POLL        0.0%    0.0 ms      0.0%    0.0 ms
C1-SNB      0.0%    | C1-SNB      0.1%    0.4 ms      0.0%    0.1 ms
C3-SNB      2.3%    | C3-SNB      0.0%    0.3 ms      4.6%  149.8 ms
C6-SNB      0.0%    | C6-SNB      0.0%    1.2 ms      0.0%    0.0 ms
C7-SNB     95.8%    | C7-SNB     99.4%   12.0 ms     92.1%   71.4 ms

	

-ThinkPad-T420:~$ uname -a
Linux-ThinkPad-T420 3.2.0-rc3 #1 SMP Tue Nov 29 14:37:22 IST 2011 x86_64
x86_64 x86_64 GNU/Linux

ThinkPad-T420:~$ cat /proc/cpuinfo
processor	: 0
vendor_id	: GenuineIntel
cpu family	: 6
model		: 42
model name	: Intel(R) Core(TM) i5-2540M CPU @ 2.60GHz
stepping	: 7
microcode	: 0x1a
cpu MHz		: 800.000
cache size	: 3072 KB
physical id	: 0
siblings	: 4
core id		: 0
cpu cores	: 2
apicid		: 0
initial apicid	: 0
fpu		: yes
fpu_exception	: yes
cpuid level	: 13
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov
pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx
rdtscp lm constant_tsc arch_perfmon pebs bts nopl xtopology nonstop_tsc
aperfmperf pni pclmulqdq dtes64 monitor ds_cpl vmx smx est tm2 ssse3
cx16 xtpr pdcm pcid sse4_1 sse4_2 x2apic popcnt tsc_deadline_timer aes
xsave avx lahf_lm ida arat epb xsaveopt pln pts dts tpr_shadow vnmi
flexpriority ept vpid
bogomips	: 5182.63
clflush size	: 64
cache_alignment	: 64
address sizes	: 36 bits physical, 48 bits virtual
power management:

.config
CONFIG_ARCH_HAS_CPU_IDLE_WAIT=y
CONFIG_ARCH_HAS_DEFAULT_IDLE=y
CONFIG_CPU_IDLE=y
CONFIG_CPU_IDLE_GOV_LADDER=y
CONFIG_CPU_IDLE_GOV_MENU=y
CONFIG_INTEL_IDLE=y

Regards,
Deepthi

