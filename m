Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755912Ab0HCKQI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 06:16:08 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:42465 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755854Ab0HCKQG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 06:16:06 -0400
Message-ID: <4C57EC0B.2080607@kernel.org>
Date: Tue, 03 Aug 2010 03:14:35 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100714 SUSE/3.0.6 Thunderbird/3.0.6
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Cyrill Gorcunov <gorcunov@gmail.com>,
        Pekka Enberg <penberg@cs.helsinki.fi>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -v3] x86: Setup early console as early as possible
References: <4C56701B.1030000@kernel.org>	<20100802150958.GA5544@lenovo>	<4C571B25.3080806@kernel.org>	<20100802201750.GG5544@lenovo>	<4C57C1DE.9050400@kernel.org> <20100803020638.4e2177c3.akpm@linux-foundation.org>
In-Reply-To: <20100803020638.4e2177c3.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt354.oracle.com [141.146.40.154]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090208.4C57EC18.0208,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/03/2010 02:06 AM, Andrew Morton wrote:
> On Tue, 03 Aug 2010 00:14:38 -0700 Yinghai Lu <yinghai@kernel.org> wrote:
> 
>>
>> Analyze "console=uart8250,io,0x3f8,115200n8" in i386_start_kernel/x86_64_start_kernel,
>> and call setup_early_serial8250_console() to init early serial console.
>>
>> only can handle io port kind of 8250. because mmio need ioremap.
>>
>> -v2: use boot_params.hdr.version instead of adding another variable, Suggested by hpa
>>      update after using x86 memblock patchset
>> -v3: x86 memblock can not make into with 2.6.36 now
>>      so update this patch to be applied before x86 memblock patchset again.
>>
>> ...
>>
>> --- linux-2.6.orig/kernel/printk.c
>> +++ linux-2.6/kernel/printk.c
>> @@ -1203,6 +1203,10 @@ void register_console(struct console *ne
>>  	if (console_drivers && newcon->flags & CON_BOOT) {
>>  		/* find the last or real console */
>>  		for_each_console(bcon) {
>> +			/* not again */
>> +			if (bcon == newcon)
>> +				return;
>> +
>>  			if (!(bcon->flags & CON_BOOT)) {
>>  				printk(KERN_INFO "Too late to register bootconsole %s%d\n",
> 
> Why this change?

without that will get

early console in setup code
early console in decompress_kernel
decompress_kernel:
  input: [0x24a0269-0x2e8b642], output: 0x1000000, heap: [0x2e90e40-0x2e97e3f]

Decompressing Linux... Parsing ELF... done.
Booting the kernel.
[    0.000000] bootconsole [uart0] enabled
[    0.000000] Kernel Layout:
[    0.000000]   .text: [0x01000000-0x01cb210d]
[    0.000000] .rodata: [0x01cb8000-0x02419fff]
[    0.000000]   .data: [0x0241a000-0x025b583f]
[    0.000000]   .init: [0x025b7000-0x02875fff]
[    0.000000]    .bss: [0x02880000-0x0348bb6f]
[    0.000000]    .brk: [0x0348c000-0x034abfff]
[    0.000000]     memblock_x86_reserve_range: [0x01000000-0x0348bb6f]    TEXT DATA BSS
[    0.000000]     memblock_x86_reserve_range: [0x2c6b0000-0x2ffcefff]          RAMDISK
[    0.000000]     memblock_x86_reserve_range: [0x0009fc00-0x000fffff]  * BIOS reserved
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 2.6.35-tip-yh-01758-g649ef4b-dirty (yhlu@linux-siqj) (gcc version 4.4.1 [gcc-4_4-branch revision 150839] (SUSE Linux) ) #148 SMP Tue Aug 3 03:09:06 PDT 2010
[    0.000000] Command line: BOOT_IMAGE=linux debug apic=debug ramdisk_size=262144 root=/dev/ram0 rw ip=dhcp console=uart8250,io,0x3f8,115200 initrd=initrd.img
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000]   AMD AuthenticAMD
[    0.000000]   Centaur CentaurHauls
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: [0x00000000000000-0x0000000009efff] (usable)
[    0.000000]  BIOS-e820: [0x0000000009f000-0x0000000009ffff] (reserved)
[    0.000000]  BIOS-e820: [0x000000000e8000-0x000000000fffff] (reserved)
[    0.000000]  BIOS-e820: [0x00000000100000-0x0000002ffeffff] (usable)
[    0.000000]  BIOS-e820: [0x0000002fff0000-0x0000002fffffff] (ACPI data)
[    0.000000]  BIOS-e820: [0x000000fffbc000-0x000000ffffffff] (reserved)
[    0.000000] Early serial console at I/O port 0x3f8 (options '115200')
[    0.000000] Early serial console at I/O port 0x3f8 (options '115200')
[    0.000000] Early serial console at I/O port 0x3f8 (options '115200')
[    0.000000] Early serial console at I/O port 0x3f8 (options '115200')
....
