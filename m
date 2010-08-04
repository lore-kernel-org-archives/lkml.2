Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932250Ab0HDJfz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 05:35:55 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:23764 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755789Ab0HDJfx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 05:35:53 -0400
Message-ID: <4C593424.4080603@kernel.org>
Date: Wed, 04 Aug 2010 02:34:28 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100714 SUSE/3.0.6 Thunderbird/3.0.6
MIME-Version: 1.0
To: Tvrtko Ursulin <tvrtko.ursulin@sophos.com>
CC: Avi Kivity <avi@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: 2.6.35 hangs on early boot in KVM
References: <201008031028.57263.tvrtko.ursulin@sophos.com> <201008040918.58318.tvrtko.ursulin@sophos.com> <4C592D60.5050309@kernel.org> <201008041016.09176.tvrtko.ursulin@sophos.com>
In-Reply-To: <201008041016.09176.tvrtko.ursulin@sophos.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090202.4C59346C.00BA,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/04/2010 02:16 AM, Tvrtko Ursulin wrote:
> On Wednesday 04 Aug 2010 10:05:36 Yinghai Lu wrote:
>> On 08/04/2010 01:18 AM, Tvrtko Ursulin wrote:
>>> On Tuesday 03 Aug 2010 21:57:48 Yinghai Lu wrote:
>>>> On Tue, Aug 3, 2010 at 8:59 AM, Tvrtko Ursulin
>>>>
>>>> <tvrtko.ursulin@sophos.com> wrote:
>>>>> On Tuesday 03 Aug 2010 16:17:20 Tvrtko Ursulin wrote:
>>>>>> On Tuesday 03 Aug 2010 15:57:03 Tvrtko Ursulin wrote:
>>>>>>> On Tuesday 03 Aug 2010 15:51:08 Avi Kivity wrote:
>>>>>>>>   On 08/03/2010 12:28 PM, Tvrtko Ursulin wrote:
>>>>>>>>> I have basically built 2.6.35 with make oldconfig from a working
>>>>>>>>> 2.6.34. Latter works fine in kvm while 2.6.35 hangs very early. I
>>>>>>>>> see nothing after grub (have early printk and verbose bootup
>>>>>>>>> enabled), just a blinking VGA cursor and CPU at 100%.
>>>>>>>>
>>>>>>>> Please copy kvm@vger.kernel.org on kvm issues.
>>>>>>>>
>>>>>>>>> CONFIG_PRINTK_TIME=y
>>>>>>>>
>>>>>>>> Try disabling this as a workaround.
>>>>>>>
>>>>>>> I am in the middle of a bisect run with five builds left to go,
>>>>>>> currently I have:
>>>>>>>
>>>>>>> bad 537b60d17894b7c19a6060feae40299d7109d6e7
>>>>>>> good 93c9d7f60c0cb7715890b1f9e159da6f4d1f5a65
>>>>>>
>>>>>> Bisect is looking good, narrowed it to ten revisions, but I am not
>>>>>> sure to make it to the end today:
>>>>>>
>>>>>> bad cb41838bbc4403f7270a94b93a9a0d9fc9c2e7ea
>>>>>> good 41d59102e146a4423a490b8eca68a5860af4fe1c
>>>>>
>>>>> Bisect points the finger to "x86, ioapic: In mpparse use
>>>>> mp_register_ioapic" (cf7500c0ea133d66f8449d86392d83f840102632), so I am
>>>>> copying Eric. No idea whether this commit is solely to blame or it is a
>>>>> combined interaction with KVM, but I am sure you guys will know.
>>>>>
>>>>> If you want me to test something else please shout.
>>>>
>>>> please try attached patch, to see if it help.
>>>
>>> No luck (no visible difference, no output on VGA or serial console). (Btw
>>> there is a typo in pin_2_irq_leagcy so that you do not push it directly).
>>
>> can you try current tip with
>> earlyprintk=ttyS0,115200 or console=uart8250,io,0x3f8,115200?
> 
> Not the tip but 2.6.35 with earlyprintk=ttyS0,115200:
> 
> [    0.000000] Initializing cgroup subsys cpuset
> [    0.000000] Initializing cgroup subsys cpu
> [    0.000000] Linux version 2.6.35 (root@kvm-ktest-32) (gcc version 4.4.3 (Ubuntu 4.4.3-4ubuntu5) ) #4
> SMP Wed Aug 4 09:15:10 BST 2010
> [    0.000000] BIOS-provided physical RAM map:
> [    0.000000]  BIOS-e820: 0000000000000000 - 000000000009f400 (usable)
> [    0.000000]  BIOS-e820: 000000000009f400 - 00000000000a0000 (reserved)
> [    0.000000]  BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
> [    0.000000]  BIOS-e820: 0000000000100000 - 000000002bbfd000 (usable)
> [    0.000000]  BIOS-e820: 000000002bbfd000 - 000000002bc00000 (reserved)
> [    0.000000]  BIOS-e820: 00000000fffbc000 - 0000000100000000 (reserved)
> [    0.000000] bootconsole [earlyser0] enabled
> [    0.000000] Notice: NX (Execute Disable) protection cannot be enabled: non-PAE kernel!
> [    0.000000] DMI 2.4 present.
> [    0.000000] last_pfn = 0x2bbfd max_arch_pfn = 0x100000
> [    0.000000] PAT not supported by CPU.
> [    0.000000] Scanning 1 areas for low memory corruption
> [    0.000000] modified physical RAM map:
> [    0.000000]  modified: 0000000000000000 - 0000000000001000 (reserved)
> [    0.000000]  modified: 0000000000001000 - 0000000000002000 (usable)
> [    0.000000]  modified: 0000000000002000 - 0000000000010000 (reserved)
> [    0.000000]  modified: 0000000000010000 - 000000000009f400 (usable)
> [    0.000000]  modified: 000000000009f400 - 00000000000a0000 (reserved)
> [    0.000000]  modified: 00000000000f0000 - 0000000000100000 (reserved)
> [    0.000000]  modified: 0000000000100000 - 000000002bbfd000 (usable)
> [    0.000000]  modified: 000000002bbfd000 - 000000002bc00000 (reserved)
> [    0.000000]  modified: 00000000fffbc000 - 0000000100000000 (reserved)
> [    0.000000] found SMP MP-table at [c00f85c0] f85c0
> [    0.000000] init_memory_mapping: 0000000000000000-000000002bbfd000
> [    0.000000] RAMDISK: 1fa29000 - 20d3e000
> [    0.000000] 699MB LOWMEM available.
> [    0.000000]   mapped low ram: 0 - 2bbfd000
> [    0.000000]   low ram: 0 - 2bbfd000
> [    0.000000] kvm-clock: Using msrs 12 and 11
> [    0.000000] kvm-clock: cpu 0, msr 0:82a341, boot clock
> [    0.000000] Zone PFN ranges:
> [    0.000000]   DMA      0x00000001 -> 0x00001000
> [    0.000000]   Normal   0x00001000 -> 0x0002bbfd
> [    0.000000] Movable zone start PFN for each node
> [    0.000000] early_node_map[3] active PFN ranges
> [    0.000000]     0: 0x00000001 -> 0x00000002
> [    0.000000]     0: 0x00000010 -> 0x0000009f
> [    0.000000]     0: 0x00000100 -> 0x0002bbfd
> [    0.000000] Using APIC driver default
> [    0.000000] Intel MultiProcessor Specification v1.4
> [    0.000000]     Virtual Wire compatibility mode.
> [    0.000000] MPTABLE: OEM ID: BOCHSCPU
> [    0.000000] MPTABLE: Product ID: 0.1
> [    0.000000] MPTABLE: APIC at: 0xFEE00000
> [    0.000000] Processor #0 (Bootup-CPU)
> [    0.000000] I/O APIC #1 Version 17 at 0xFEC00000.

so your host is 32bit or 64bit?

can you use working 32bit guest to dump mptable like "debug apic=debug acpi=off earlyprintk..." ?

Yinghai
