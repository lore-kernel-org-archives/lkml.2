Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752736Ab0GNIGF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 04:06:05 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:64879 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752267Ab0GNIF6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 04:05:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=shvqX5ZBzmOuXLBfFWflOW6s2k7lqLuHFbcD5MC3yH6RyQROCfgoH9jptsDAqLVvAW
         M4TlF3Jx2Hsw2A8FLgzCy0a+1X1w6DN+IIEAHSzHIODWfIsSjW5i1nZNNZh0BHSKEA5u
         rsmDppG/wFTqCsRlHLJhYY2/ZcDHcpRh6Z6eE=
MIME-Version: 1.0
In-Reply-To: <AANLkTil6opQmTVVxuP1ngz72_ijpLzdlSFWDSyi4whOt@mail.gmail.com>
References: <AANLkTil6opQmTVVxuP1ngz72_ijpLzdlSFWDSyi4whOt@mail.gmail.com>
Date: Wed, 14 Jul 2010 11:05:56 +0300
X-Google-Sender-Auth: 0XP_V3alR7oXOAWzByKhbwNUtmk
Message-ID: <AANLkTinGoUml9PQ8w7flukqwF9V1ae-YafiDVQy6Q8gC@mail.gmail.com>
Subject: Re: kmemleak, cpu usage jump out of nowhere
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Zeno Davatz <zdavatz@gmail.com>
Cc: linux-kernel@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 14, 2010 at 9:12 AM, Zeno Davatz <zdavatz@gmail.com> wrote:
> I got a new Intel core-8 i7 processor.
>
> I am on kernel uname -a
>
> Linux zenogentoo 2.6.35-rc5 #97 SMP Tue Jul 13 16:13:25 CEST 2010 i686
> Intel(R) Core(TM) i7 CPU 960 @ 3.20GHz GenuineIntel GNU/Linux
>
> Sometimes in the middle of nowhere all of a sudden all of my 8-cores
> are at 100% CPU usage and my machine really lags and hangs and is not
> useable anymore. Some random process just grabs a bunch CPUs according
> to htop.

Why did you enable CONFIG_DEBUG_KMEMLEAK? Memory leak scanning is
likely the source of these pauses.

> dmesg tell me that
>
> kmemleak: 38 new suspected memory leaks (see /sys/kernel/debug/kmemleak)
> kmemleak: 2 new suspected memory leaks (see /sys/kernel/debug/kmemleak)
> kmemleak: 1 new suspected memory leaks (see /sys/kernel/debug/kmemleak)
> kmemleak: 2 new suspected memory leaks (see /sys/kernel/debug/kmemleak)
> kmemleak: 2 new suspected memory leaks (see /sys/kernel/debug/kmemleak)
> kmemleak: 1 new suspected memory leaks (see /sys/kernel/debug/kmemleak)
>
> I am attaching you the file from /sys/kernel/debug/kmemleak

Zeno, can you post your dmesg and .config, please?

We have a bunch of suspected leaks here. The first class of leaks is
related to reserve_region():

unreferenced object 0xf6d80740 (size 64):
  comm "swapper", pid 1, jiffies 4294892590 (age 57258.752s)
  hex dump (first 32 bytes):
    00 00 ee c7 00 00 00 00 ff b7 ee c7 00 00 00 00  ................
    7c 09 52 c1 00 00 00 80 00 f2 5e c1 20 ac 6f c1  |.R.......^. .o.
  backtrace:
    [<c145d4eb>] kmemleak_alloc+0x27/0x4d
    [<c10ad53f>] kmem_cache_alloc+0xa3/0xd4
    [<c163b782>] __reserve_region_with_split+0x29/0x149
    [<c163b86a>] __reserve_region_with_split+0x111/0x149
    [<c163b89a>] __reserve_region_with_split+0x141/0x149
    [<c163b89a>] __reserve_region_with_split+0x141/0x149
    [<c163b89a>] __reserve_region_with_split+0x141/0x149
    [<c163b8de>] reserve_region_with_split+0x3c/0x4f
    [<c162e307>] e820_reserve_resources_late+0xea/0x108
    [<c16504e6>] pcibios_resource_survey+0x23/0x2a
    [<c1652022>] pcibios_init+0x61/0x73
    [<c165172b>] pci_subsys_init+0x43/0x48
    [<c1001114>] do_one_initcall+0x27/0x178
    [<c162b357>] kernel_init+0x129/0x1c7
    [<c10238b6>] kernel_thread_helper+0x6/0x10
    [<ffffffff>] 0xffffffff

unreferenced object 0xf6d232a0 (size 32):
  comm "swapper", pid 1, jiffies 4294892601 (age 57258.708s)
  hex dump (first 32 bytes):
    70 6e 70 20 30 30 3a 30 31 00 d2 f6 fa 00 0b c1  pnp 00:01.......
    00 00 00 00 04 aa dc f6 2c 00 00 00 01 00 00 00  ........,.......
  backtrace:
    [<c145d4eb>] kmemleak_alloc+0x27/0x4d
    [<c10ad53f>] kmem_cache_alloc+0xa3/0xd4
    [<c123040b>] reserve_range+0x3b/0x13f
    [<c1230597>] system_pnp_probe+0x88/0xb0
    [<c122b0f7>] pnp_device_probe+0x67/0xaf
    [<c12d5246>] driver_probe_device+0x5b/0x148
    [<c12d539a>] __driver_attach+0x67/0x69
    [<c12d4c33>] bus_for_each_dev+0x46/0x64
    [<c12d512c>] driver_attach+0x19/0x1b
    [<c12d46f5>] bus_add_driver+0x17a/0x225
    [<c12d55b8>] driver_register+0x65/0x110
    [<c122af44>] pnp_register_driver+0x17/0x19
    [<c1647a91>] pnp_system_init+0xd/0xf
    [<c1001114>] do_one_initcall+0x27/0x178
    [<c162b357>] kernel_init+0x129/0x1c7
    [<c10238b6>] kernel_thread_helper+0x6/0x10

I scanned through both call sites briefly but didn't find anything obvious.

The second class of leaks seems to be related to kobjects:

unreferenced object 0xf6951920 (size 32):
  comm "swapper", pid 1, jiffies 4294892614 (age 57258.656s)
  hex dump (first 32 bytes):
    63 70 75 69 64 6c 65 00 2f 76 69 72 74 75 61 6c  cpuidle./virtual
    2f 67 72 61 70 68 69 63 73 2f 66 62 63 6f 6e 00  /graphics/fbcon.
  backtrace:
    [<c11e33c6>] kvasprintf+0x2a/0x47
    [<c11db5d7>] kobject_set_name_vargs+0x17/0x52
    [<c11db629>] kobject_add_varg+0x17/0x41
    [<c11db67a>] kobject_init_and_add+0x27/0x2d
    [<c1389b0c>] cpuidle_add_sysfs+0x3e/0x56
    [<c138944e>] __cpuidle_register_device+0xfb/0x116
    [<c13895fc>] cpuidle_register_device+0x18/0x54
    [<c1645397>] intel_idle_init+0x2b9/0x327
    [<c1001114>] do_one_initcall+0x27/0x178
    [<c162b357>] kernel_init+0x129/0x1c7
    [<c10238b6>] kernel_thread_helper+0x6/0x10
    [<ffffffff>] 0xffffffff

unreferenced object 0xf60045c0 (size 32):
  comm "swapper", pid 1, jiffies 4294893885 (age 57253.572s)
  hex dump (first 32 bytes):
    30 00 64 4b bc a3 bc a3 80 f5 80 f5 a7 15 a7 15  0.dK............
    34 07 34 07 69 4f 69 4f f4 47 f4 47 ef 27 ef 27  4.4.iOiO.G.G.'.'
  backtrace:
    [<c145d4eb>] kmemleak_alloc+0x27/0x4d
    [<c10adb0c>] __kmalloc+0xd4/0x10d
    [<c11e33c6>] kvasprintf+0x2a/0x47
    [<c11db5d7>] kobject_set_name_vargs+0x17/0x52
    [<c11db629>] kobject_add_varg+0x17/0x41
    [<c11db6ac>] kobject_add+0x2c/0x54
    [<c138ad14>] add_sysfs_fw_map_entry+0x43/0x7c
    [<c164f00f>] memmap_init+0x16/0x30
    [<c1001114>] do_one_initcall+0x27/0x178
    [<c162b357>] kernel_init+0x129/0x1c7
    [<c10238b6>] kernel_thread_helper+0x6/0x10
    [<ffffffff>] 0xffffffff

The third class of leaks is relateed to drm_setversion():

unreferenced object 0xf6b10620 (size 32):
  comm "X", pid 2268, jiffies 4294894722 (age 57250.228s)
  hex dump (first 32 bytes):
    6e 6f 75 76 65 61 75 40 70 63 69 3a 30 30 30 30  nouveau@pci:0000
    3a 30 35 3a 30 30 2e 30 00 00 00 00 00 00 00 00  :05:00.0........
  backtrace:
    [<c145d4eb>] kmemleak_alloc+0x27/0x4d
    [<c10adb0c>] __kmalloc+0xd4/0x10d
    [<c125315e>] drm_setversion+0x140/0x1bf
    [<c12514f2>] drm_ioctl+0x258/0x3d7
    [<c10bdd42>] vfs_ioctl+0x27/0x9b
    [<c10bdee2>] do_vfs_ioctl+0x66/0x54b
    [<c10be3fa>] sys_ioctl+0x33/0x4f
    [<c102339c>] sysenter_do_call+0x12/0x2c
    [<ffffffff>] 0xffffffff

for which I wasn't able to find the allocation call-site. Maybe Zeno
has some out-of-tree DRM module?

The fourth class of leaks is related to per-CPU allocations in the block layer:

unreferenced object 0xf6681400 (size 1024):
  comm "async/2", pid 1307, jiffies 4294894138 (age 57252.564s)
  hex dump (first 32 bytes):
    80 87 ff ff c4 ff ff ff c4 ff ff ff c4 ff ff ff  ................
    fc ff ff ff fc ff ff ff fc ff ff ff fc ff ff ff  ................
  backtrace:
    [<c145d4eb>] kmemleak_alloc+0x27/0x4d
    [<c10adb0c>] __kmalloc+0xd4/0x10d
    [<c10ae982>] pcpu_mem_alloc+0x18/0x3a
    [<c10af239>] pcpu_extend_area_map+0x1a/0xad
    [<c10af578>] pcpu_alloc+0x2ac/0x82b
    [<c10afb10>] __alloc_percpu+0xa/0xc
    [<c11d4518>] alloc_disk_node+0x2e/0xbf
    [<c11d45b6>] alloc_disk+0xd/0xf
    [<c130260c>] sd_probe+0x54/0x298
    [<c12d5246>] driver_probe_device+0x5b/0x148
    [<c12d53ca>] __device_attach+0x2e/0x32
    [<c12d49f3>] bus_for_each_drv+0x46/0x64
    [<c12d5449>] device_attach+0x5c/0x60
    [<c12d484d>] bus_probe_device+0x1a/0x30
    [<c12d358a>] device_add+0x448/0x509
    [<c12fb881>] scsi_sysfs_add_sdev+0x54/0x212

for which I didn't find anything obvious that could explain it.

I suspect most of the reports are false positives. Catalin, what do
you make out of them?

                        Pekka
