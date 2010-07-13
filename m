Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752146Ab0GMHJU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jul 2010 03:09:20 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:59140 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751077Ab0GMHJS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jul 2010 03:09:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Qb/rEiiNKttvy/sBgzibKggJDK3mh7AEHc4o79jY7+5Lyj1jsWcLwZCOioz3bUOZxY
         Ghl+G0qZfGgC0oQgPMYmVUpQ5Mwv314NvPYbvq6DIi4zi+Aeh5HY4X4HDlc9jrYIIq1h
         D+epYRCRKzYLw5K2+qZCNTxAI94wZ1jIAQjpM=
MIME-Version: 1.0
In-Reply-To: <4C361E6C.2080107@redhat.com>
References: <4C361E6C.2080107@redhat.com>
Date: Tue, 13 Jul 2010 15:09:17 +0800
Message-ID: <AANLkTilg03KCv4bUCkKfKuVq0ratanCIImWJjU8zsKTV@mail.gmail.com>
Subject: Re: cpu softplug kernel hang
From: Luming Yu <luming.yu@gmail.com>
To: Prarit Bhargava <prarit@redhat.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, jens.axboe@oracle.com,
        "the arch/x86 maintainers" <x86@kernel.org>,
        Don Zickus <dzickus@redhat.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 9, 2010 at 2:52 AM, Prarit Bhargava <prarit@redhat.com> wrote:
> The panic below is from an 2.6.32-based kernel, however, AFAICT the same
> issue exists with the latest 2.6.35-rc3+ kernel.
>
> I have diagnosed the issue as being identical to the issue that I fixed
> with the Intel rngd
> driver sometime ago:
>
> http://marc.info/?l=linux-kernel&m=117275119001289&w=2
>
> When doing the following,
>
> while true; do
>        for i in `seq 12 23`; do echo 0 >
> /sys/devices/system/cpu/cpu$i/online; done
>        sleep 5
>        for i in `seq 12 23`; do echo 1 >
> /sys/devices/system/cpu/cpu$i/online; done
>        sleep 5
> done
>
> I see (with the nmi_watchdog enabled)
>
> BUG: NMI Watchdog detected LOCKUP on CPU11, ip ffffffff81029e72, registers:
> CPU 11
> Modules linked in: nfs lockd fscache nfs_acl auth_rpcgss autofs4 sunrpc
> cpufreq_ondemand acpi_cpufreq freq_table ipv6 dm_mirror dm_region_hash dm_log
> uinput sg serio_raw i2c_i801 iTCO_wdt iTCO_vendor_support ioatdma i7core_edac
> edac_core shpchp igb dca ext4 mbcache jbd2 sr_mod cdrom sd_mod crc_t10dif ahci
> pata_acpi ata_generic pata_jmicron radeon ttm drm_kms_helper drm i2c_algo_bit
> i2c_core dm_mod [last unloaded: microcode]
>
> Modules linked in: nfs lockd fscache nfs_acl auth_rpcgss autofs4 sunrpc
> cpufreq_ondemand acpi_cpufreq freq_table ipv6 dm_mirror dm_region_hash dm_log
> uinput sg serio_raw i2c_i801 iTCO_wdt iTCO_vendor_support ioatdma i7core_edac
> edac_core shpchp igb dca ext4 mbcache jbd2 sr_mod cdrom sd_mod crc_t10dif ahci
> pata_acpi ata_generic pata_jmicron radeon ttm drm_kms_helper drm i2c_algo_bit
> i2c_core dm_mod [last unloaded: microcode]
> Pid: 704, comm: kexec Not tainted 2.6.32 #1 X8DTN
> RIP: 0010:[<ffffffff81029e72>]  [<ffffffff81029e72>] ipi_handler+0x32/0xa0
> RSP: 0000:ffff8801474a3f58  EFLAGS: 00000046
> RAX: 0000000000000000 RBX: ffff880337393ea8 RCX: ffff88013ae41580
> RDX: 00000000ffffffff RSI: 0000000000000000 RDI: ffff880337393ea8
> RBP: ffff8801474a3f68 R08: 0000000061c941a6 R09: 00000000578070b9
> R10: 0000000080507210 R11: 0000000025410601 R12: 0000000000000086
> R13: 00000000ffffffff R14: ffffffff817491d0 R15: 0000000090793245
> FS:  00007fefd5f3d700(0000) GS:ffff8801474a0000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> CR2: 000000000040d000 CR3: 0000000316a8e000 CR4: 00000000000006e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> Process kexec (pid: 704, threadinfo ffff880314caa000, task ffff880335a0b500)
> Stack:
>  ffff880147571f40 000000000000000b ffff8801474a3f98 ffffffff810a6d28
> <0> 00000000aa149910 00000000f21570f0 000000000008b495 00000000521ebd53
> <0> ffff8801474a3fa8 ffffffff8102ea57 ffff880314cabf80 ffffffff81013e53
> Call Trace:
>  <IRQ>
>  [<ffffffff810a6d28>] generic_smp_call_function_interrupt+0x78/0x130
>  [<ffffffff8102ea57>] smp_call_function_interrupt+0x27/0x40
>  [<ffffffff81013e53>] call_function_interrupt+0x13/0x20
>  <EOI>
> Code: 0f 1f 44 00 00 48 89 fb 9c 58 0f 1f 44 00 00 49 89 c4 fa 66 0f 1f 44 00
> 00 f0 ff 0f 8b 47 04 85 c0 75 0f 66 0f 1f 44 00 00 f3 90 <8b> 43 04 85 c0 74 f7
> 8b 7b 18 83 ff ff 74 47 48 8b 05 08 25 a1
>
> Since this is a panic, I get traces from all other cpus.
>
> CPU 14 is in _write_lock_irq
> CPU  2 is in _read_lock
> CPU  6 has called smp_call_function() with the ipi_handler to sync mtrr's on
> the new cpu
>
> The problem is that ipi_handler does this:
>
> static void ipi_handler(void *info)
> {
> #ifdef CONFIG_SMP
>        struct set_mtrr_data *data = info;
>        unsigned long flags;
>
>        local_irq_save(flags);
>
>        atomic_dec(&data->count); << global value that each processor entering
> ipi_handler decrements
>        while (!atomic_read(&data->gate)) << 1 when data->count != 0
>                cpu_relax();
>
> So what happens is that CPU 2 is in _read_lock and has acquired a lock.  CPU 14
> is waiting for the release of that lock with IRQs *off*.
>
> CPU 6 launches smp_call_function, and CPU 2 answers and runs the ipi_handler()
> and waits (as do all other processors).
>
> CPU 14, however, does not see the IPI because it is waiting with interrupts off
> for the lock that CPU 2 is holding.
>
> Boom.  Deadlock.

Hmmm.. lockdep code is supposed to be able to detect it, any lockdep
warnning before
a dead lock happens?
