Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757518Ab0ELX6v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 19:58:51 -0400
Received: from mx1.HRZ.Uni-Dortmund.DE ([129.217.128.51]:40898 "EHLO
	unimail.uni-dortmund.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756086Ab0ELX6s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 19:58:48 -0400
Message-ID: <4BEB4096.6030400@udo.edu>
Date: Thu, 13 May 2010 01:58:14 +0200
From: Andrej Gelenberg <andrej.gelenberg@udo.edu>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Shredder/3.0.4
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux@brodo.de, ashok.raj@intel.com, jacob.shin@amd.com,
       linux-kernel@vger.kernel.org, cpufreq@vger.kernel.org
Subject: Re: [PATCH] [CPUFREQ] fix race condition in store_scaling_governor
References: <4BE967B9.5050107@udo.edu> <20100512150039.b5b2729d.akpm@linux-foundation.org>
In-Reply-To: <20100512150039.b5b2729d.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 05/13/2010 12:00 AM, Andrew Morton wrote:
>
> Looks sane, I guess.
>
> I am afraid of moving all those functions inside
> cpufreq_governor_mutex.  Not for any specific reason, apart from a long
> history of nasty deadlocks with cpufreq global locks :(
>
> Has this change been well-tested with lockdep enabled?

It prevent at least the kernel panic and warnings from sysfs,
but cause a deadlock. I can confirm the bug in 2.6.33-ARCH (last stable 
kernel in archlinux):

------------[ cut here ]------------
WARNING: at fs/sysfs/dir.c:487 sysfs_add_one+0xc5/0x150()
Hardware name: 287655G
sysfs: cannot create duplicate filename 
'/devices/system/cpu/cpu0/cpufreq/ondemand'
Modules linked in: cpufreq_conservative cpufreq_ondemand powernow_k8 
freq_table joydev radeon ttm drm_kms_helper snd_seq_dummy uvcvideo drm 
videodev rfkill i2c_algo_bit snd_seq_oss v4l1_compat usb_storage 
v4l2_compat_ioctl32 snd_seq_midi_event led_class snd_seq snd_seq_device 
nvram snd_hda_codec_conexant snd_hda_intel video snd_pcm_oss 
snd_mixer_oss output snd_hda_codec snd_hwdep snd_pcm snd_timer snd 
ohci_hcd soundcore shpchp ehci_hcd ac wmi battery sg thermal processor 
button snd_page_alloc psmouse i2c_piix4 edac_core pci_hotplug r8169 
usbcore mii edac_mce_amd serio_raw i2c_core k8temp evdev pcspkr rtc_cmos 
rtc_core rtc_lib ext4 mbcache jbd2 crc16 cryptd aes_x86_64 aes_generic 
xts gf128mul dm_crypt dm_mod sd_mod ahci libata scsi_mod
Pid: 3136, comm: test_cpu.sh Tainted: G        W  2.6.33-ARCH #1
Call Trace:
  [<ffffffff810529f6>] warn_slowpath_common+0x76/0xb0
  [<ffffffff81052a8c>] warn_slowpath_fmt+0x3c/0x40
  [<ffffffff81187f45>] sysfs_add_one+0xc5/0x150
  [<ffffffff81188033>] create_dir+0x63/0xc0
  [<ffffffff811880a6>] sysfs_create_subdir+0x16/0x20
  [<ffffffff8118950a>] internal_create_group+0x5a/0x190
  [<ffffffff8118966e>] sysfs_create_group+0xe/0x10
  [<ffffffffa056fcfc>] cpufreq_governor_dbs+0xac/0x3e0 [cpufreq_ondemand]
  [<ffffffff810788bd>] ? notifier_call_chain+0x4d/0x70
  [<ffffffff81293f25>] __cpufreq_governor+0xf5/0x1e0
  [<ffffffff812954ec>] __cpufreq_set_policy+0x13c/0x180
  [<ffffffff812958f8>] store_scaling_governor+0xe8/0x220
  [<ffffffff81296240>] ? handle_update+0x0/0x10
  [<ffffffff811cb7ba>] ? kobject_get+0x1a/0x30
  [<ffffffff81295382>] store+0x62/0x90
  [<ffffffff81186820>] sysfs_write_file+0xe0/0x160
  [<ffffffff81121576>] vfs_write+0xb6/0x190
  [<ffffffff8103175d>] ? do_page_fault+0x15d/0x320
  [<ffffffff811218ac>] sys_write+0x4c/0x80
  [<ffffffff81009f02>] system_call_fastpath+0x16/0x1b
---[ end trace 939cd7811bc2accf ]---

Here is my test script:

#!/bin/sh
for k in {1..4}
do
  for i in conservative ondemand performance
  do
   echo $i > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor &
  done
done

for k in {1..4}
do
  for i in conservative ondemand performance
  do
   echo $i > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor &
  done
done
echo ondemand > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
