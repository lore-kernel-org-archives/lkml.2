Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755479Ab2HNJKB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 05:10:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16861 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751164Ab2HNJJ7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 05:09:59 -0400
Message-ID: <502A1500.5030306@redhat.com>
Date: Tue, 14 Aug 2012 17:06:08 +0800
From: Dave Young <dyoung@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.22) Gecko/20110904 Red Hat/3.1.14-1.el6_1 Thunderbird/3.1.14
MIME-Version: 1.0
To: Jacob Shin <jacob.shin@amd.com>
CC: X86-ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Yinghai Lu <yinghai@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Tejun Heo <tj@kernel.org>, Borislav Petkov <borislav.petkov@amd.com>,
        Chao Wang <chaowang@redhat.com>, Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH V2 0/5] x86: Create direct mappings for E820_RAM only
References: <1344894424-4434-1-git-send-email-jacob.shin@amd.com> <502A0D9F.4010509@redhat.com>
In-Reply-To: <502A0D9F.4010509@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/14/2012 04:34 PM, Dave Young wrote:

> On 08/14/2012 05:46 AM, Jacob Shin wrote:
> 
>> Currently kernel direct mappings are created for all pfns between
>> [ 0 to max_low_pfn ) and [ 4GB to max_pfn ). When we introduce memory
>> holes, we end up mapping memory ranges that are not backed by physical
>> DRAM. This is fine for lower memory addresses which can be marked as UC
>> by fixed/variable range MTRRs, however we run in to trouble with high
>> addresses.
>>
>> The following patchset creates direct mappings only for E820_RAM regions
>> between 0 ~ max_low_pfn and 4GB ~ max_pfn. And leaves non-E820_RAM and
>> memory holes unmapped.
> 
> 
> Hi,
> 
> Chaowang did some kdump test in a kvm guest with this patchset, 2nd
> kenrel just reboot after some ACPI printk, see below dmesg of 2nd kernel:

>

> After a crash:
> [snip]
> I'm in purgatory
> [    0.000000] Initializing cgroup subsys cpuset
> [    0.000000] Initializing cgroup subsys cpu
> [    0.000000] Linux version 3.5.0-0.23.el7.bz846531.x86_64 (mockbuild@)
> (gcc version 4.7.1 20120720 (Red Hat 4.7.1-5) (GCC) ) #1 SMP Mon Aug 13
> 22:17:46 EDT 2012
> [    0.000000] Command line:
> BOOT_IMAGE=/vmlinuz-3.5.0-0.23.el7.bz846531.x86_64
> root=/dev/mapper/vg_none-lv_root ro rd.md=0 rd.lvm.lv=vg_none/lv_swap
> rd.dm=0 rd.lvm.lv=vg_none/lv_root rd.luks=0 LANG=en_US.UTF-8
> console=ttyS0,115200  SYSFONT=True KEYTABLE=us earlyprintk=serial
> irqpoll nr_cpus=1 reset_devices cgroup_disable=memory mce=off
> earlyprintk=serial memmap=exactmap memmap=567K@64K
> memmap=261552K@589824K elfcorehdr=851376K
> [    0.000000] e820: BIOS-provided physical RAM map:
> [    0.000000] BIOS-e820: [mem 0x0000000000000100-0x000000000009dbff] usable
> [    0.000000] BIOS-e820: [mem 0x000000000009dc00-0x000000000009ffff]
> reserved
> [    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff]
> reserved
> [    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000003fffdfff] usable
> [    0.000000] BIOS-e820: [mem 0x000000003fffe000-0x000000003fffffff]
> reserved
> [    0.000000] BIOS-e820: [mem 0x00000000feffc000-0x00000000feffffff]
> reserved
> [    0.000000] BIOS-e820: [mem 0x00000000fffc0000-0x00000000ffffffff]
> reserved
> [    0.000000] bootconsole [earlyser0] enabled
> [    0.000000] ERROR: earlyprintk= earlyser already used
> [    0.000000] e820: last_pfn = 0x3fffe max_arch_pfn = 0x400000000
> [    0.000000] NX (Execute Disable) protection: active
> [    0.000000] e820: user-defined physical RAM map:
> [    0.000000] user: [mem 0x0000000000010000-0x000000000009dbff] usable
> [    0.000000] user: [mem 0x0000000024000000-0x0000000033f6bfff] usable
> [    0.000000] DMI 2.4 present.
> [    0.000000] No AGP bridge found
> [    0.000000] e820: last_pfn = 0x33f6c max_arch_pfn = 0x400000000
> [    0.000000] PAT not supported by CPU.
> [    0.000000] found SMP MP-table at [mem 0x000fdae0-0x000fdaef] mapped
> at [ffff8800000fdae0]
> [    0.000000] init_memory_mapping: [mem 0x24000000-0x33f6bfff]
> [    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
> [    0.000000] RAMDISK: [mem 0x3378a000-0x33f58fff]
> [    0.000000] ACPI: RSDP 00000000000fd980 00014 (v00 BOCHS )
> [    0.000000] ACPI: RSDT 000000003fffe5b0 00038 (v01 BOCHS  BXPCRSDT
> 00000001 BXPC 00000001)
> [    0.000000] ACPI: FACP 000000003fffff80 00074 (v01 BOCHS  BXPCFACP
> 00000001 BXPC 00000001)
> [    0.000000] ACPI: DSDT 000000003fffe5f0 01121 (v01   BXPC   BXDSDT
> 00000001 INTL 20100528)
> [    0.000000] ACPI: FACS 000000003fffff40 00040
> [    0.000000] ACPI: SSDT 000000003ffffea0 0009E (v01 BOCHS  BXPCSSDT
> 00000001 BXPC 00000001)
> [    0.000000] ACPI: APIC 000000003ffffdb0 00078 (v01 BOCHS  BXPCAPIC
> 00000001 BXPC 00000001)
> [    0.000000] ACPI: HPET 000000003ffffd70 00038 (v01 BOCHS  BXPCHPET
> 00000001 BXPC 00000001)
> [    0.000000] ACPI: SSDT 000000003ffff720 00644 (v01   BXPC BXSSDTPC
> 00000001 INTL 20100528)
> 
> ====2nd kernel reboot here=====


The above is copied from rhel7 3.5.0 test kernel, with linus tree + this
patch set there's nearly same output.

> 
> 
>>
>> This revision of the patchset attempts to resolve comments and concerns
>> from the following threads:
>>
>> https://lkml.org/lkml/2012/8/11/95
>>
>> and
>>
>> https://lkml.org/lkml/2011/12/16/486
>>
>> Jacob Shin (5):
>>   x86: Only direct map addresses that are marked as E820_RAM
>>   x86: find_early_table_space based on memory ranges that are being
>>     mapped
>>   x86: Keep track of direct mapped pfn ranges
>>   x86: Fixup code testing if a pfn is direct mapped
>>   x86: Move enabling of PSE and PGE out of init_memory_mapping
>>
>>  arch/x86/include/asm/page_types.h |    9 +++
>>  arch/x86/kernel/amd_gart_64.c     |    4 +-
>>  arch/x86/kernel/cpu/amd.c         |    6 +-
>>  arch/x86/kernel/setup.c           |  118 ++++++++++++++++++++++++++++++++-----
>>  arch/x86/mm/init.c                |   72 +++++++++++-----------
>>  arch/x86/mm/init_64.c             |    3 +-
>>  arch/x86/platform/efi/efi.c       |    8 +--
>>  arch/x86/platform/efi/efi_64.c    |    2 +
>>  8 files changed, 157 insertions(+), 65 deletions(-)
>>
> 
> 
> 



-- 
Thanks
Dave
