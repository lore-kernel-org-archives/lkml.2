Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758725Ab0GHXGz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jul 2010 19:06:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50709 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757723Ab0GHXGy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jul 2010 19:06:54 -0400
Message-ID: <4C3659BC.4030603@redhat.com>
Date: Thu, 08 Jul 2010 19:05:32 -0400
From: Prarit Bhargava <prarit@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.9) Gecko/20100505 Fedora/3.0.4-2.el6 Thunderbird/3.0.4
MIME-Version: 1.0
To: Suresh Siddha <suresh.b.siddha@intel.com>
CC: Linux Kernel <linux-kernel@vger.kernel.org>,
       "jens.axboe@oracle.com" <jens.axboe@oracle.com>,
       the arch/x86 maintainers <x86@kernel.org>,
       Don Zickus <dzickus@redhat.com>
Subject: Re: cpu softplug kernel hang
References: <4C361E6C.2080107@redhat.com> <1278627466.2834.86.camel@sbs-t61.sc.intel.com>
In-Reply-To: <1278627466.2834.86.camel@sbs-t61.sc.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 07/08/2010 06:17 PM, Suresh Siddha wrote:
> On Thu, 2010-07-08 at 11:52 -0700, Prarit Bhargava wrote:
>   
>> The panic below is from an 2.6.32-based kernel, however, AFAICT the same
>> issue exists with the latest 2.6.35-rc3+ kernel.
>>
>> I have diagnosed the issue as being identical to the issue that I fixed
>> with the Intel rngd
>> driver sometime ago:
>>
>> http://marc.info/?l=linux-kernel&m=117275119001289&w=2
>>
>> When doing the following,
>>
>> while true; do
>>         for i in `seq 12 23`; do echo 0 >
>> /sys/devices/system/cpu/cpu$i/online; done
>>         sleep 5
>>         for i in `seq 12 23`; do echo 1 >
>> /sys/devices/system/cpu/cpu$i/online; done
>>         sleep 5
>> done
>>
>> I see (with the nmi_watchdog enabled)
>>
>> BUG: NMI Watchdog detected LOCKUP on CPU11, ip ffffffff81029e72, registers:
>> CPU 11 
>> Modules linked in: nfs lockd fscache nfs_acl auth_rpcgss autofs4 sunrpc
>> cpufreq_ondemand acpi_cpufreq freq_table ipv6 dm_mirror dm_region_hash dm_log
>> uinput sg serio_raw i2c_i801 iTCO_wdt iTCO_vendor_support ioatdma i7core_edac
>> edac_core shpchp igb dca ext4 mbcache jbd2 sr_mod cdrom sd_mod crc_t10dif ahci
>> pata_acpi ata_generic pata_jmicron radeon ttm drm_kms_helper drm i2c_algo_bit
>> i2c_core dm_mod [last unloaded: microcode]
>>
>> Modules linked in: nfs lockd fscache nfs_acl auth_rpcgss autofs4 sunrpc
>> cpufreq_ondemand acpi_cpufreq freq_table ipv6 dm_mirror dm_region_hash dm_log
>> uinput sg serio_raw i2c_i801 iTCO_wdt iTCO_vendor_support ioatdma i7core_edac
>> edac_core shpchp igb dca ext4 mbcache jbd2 sr_mod cdrom sd_mod crc_t10dif ahci
>> pata_acpi ata_generic pata_jmicron radeon ttm drm_kms_helper drm i2c_algo_bit
>> i2c_core dm_mod [last unloaded: microcode]
>> Pid: 704, comm: kexec Not tainted 2.6.32 #1 X8DTN
>> RIP: 0010:[<ffffffff81029e72>]  [<ffffffff81029e72>] ipi_handler+0x32/0xa0
>> RSP: 0000:ffff8801474a3f58  EFLAGS: 00000046
>> RAX: 0000000000000000 RBX: ffff880337393ea8 RCX: ffff88013ae41580
>> RDX: 00000000ffffffff RSI: 0000000000000000 RDI: ffff880337393ea8
>> RBP: ffff8801474a3f68 R08: 0000000061c941a6 R09: 00000000578070b9
>> R10: 0000000080507210 R11: 0000000025410601 R12: 0000000000000086
>> R13: 00000000ffffffff R14: ffffffff817491d0 R15: 0000000090793245
>> FS:  00007fefd5f3d700(0000) GS:ffff8801474a0000(0000) knlGS:0000000000000000
>> CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
>> CR2: 000000000040d000 CR3: 0000000316a8e000 CR4: 00000000000006e0
>> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>> DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
>> Process kexec (pid: 704, threadinfo ffff880314caa000, task ffff880335a0b500)
>> Stack:
>>  ffff880147571f40 000000000000000b ffff8801474a3f98 ffffffff810a6d28
>> <0> 00000000aa149910 00000000f21570f0 000000000008b495 00000000521ebd53
>> <0> ffff8801474a3fa8 ffffffff8102ea57 ffff880314cabf80 ffffffff81013e53
>> Call Trace:
>>  <IRQ> 
>>  [<ffffffff810a6d28>] generic_smp_call_function_interrupt+0x78/0x130
>>  [<ffffffff8102ea57>] smp_call_function_interrupt+0x27/0x40
>>  [<ffffffff81013e53>] call_function_interrupt+0x13/0x20
>>  <EOI> 
>> Code: 0f 1f 44 00 00 48 89 fb 9c 58 0f 1f 44 00 00 49 89 c4 fa 66 0f 1f 44 00
>> 00 f0 ff 0f 8b 47 04 85 c0 75 0f 66 0f 1f 44 00 00 f3 90 <8b> 43 04 85 c0 74 f7
>> 8b 7b 18 83 ff ff 74 47 48 8b 05 08 25 a1 
>>
>> Since this is a panic, I get traces from all other cpus.
>>
>> CPU 14 is in _write_lock_irq
>> CPU  2 is in _read_lock
>>     
> which is this lock?
>   

Suresh,

I didn't keep a core :( because the stack trace was obvious.  But it
doesn't matter which lock it is as much as it matters that one cpu has
acquired the lock under non-irq, and the other is requesting it under
irq.  Then if a third cpu does an IPI ... we're deadlocked. 

smp_call_function comes with this note on the function passed into it

 "@func: The function to run. This must be fast and non-blocking."

ipi_handler is clearly blocking.

IIRC, that was added shortly after I hit the Intel rngd issue.

I'm hitting this condition anywhere from lt 2 mins to 5 hours after
running the test, and other HW vendors have reported the same NMI backtrace.


>   
>> CPU  6 has called smp_call_function() with the ipi_handler to sync mtrr's on
>> the new cpu
>>     
> Either we need to take that lock at all the places with interrupts
> disabled or we need to implement the rendezvous logic using stop
> machine.
>   

The first suggestion isn't an option because that would effectively kill
any read_lock/write_lock_irq combination in the kernel, and
stop_machine() schedules on all online cpus.  Since the cpu that is
currently being brought online is one of those cpus and it is in the
idle() state, it cannot schedule. 

I'm going to play with the code a bit and see if I can figure out something.

I'm leaning towards (sorry for the horrible pseudo code)

    cpu X = cpu being brought up
 
    run mtrr code on cpu X
    use some variant of stop_machine to run on all cpus except CPU X

P.
