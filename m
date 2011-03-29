Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751158Ab1C2EKS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 00:10:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36435 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750774Ab1C2EKQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 00:10:16 -0400
Date: Tue, 29 Mar 2011 00:09:40 -0400
From: Dave Jones <davej@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: vma corruption in today's -git
Message-ID: <20110329040939.GA32764@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Running a kernel that I built from a git pull from this afternoon,
I ran a barrage of stress tests, including some of the new syscall fuzzing
work that I've been working on.  Everything seemed just fine, except that
after I had stopped running everything, loadavg was still at 6, with
top showing kworker processes running at high % of cpu.

I ran perf top, and got this ..

 BUG: unable to handle kernel paging request at fffffffffffffff3
 IP: [<ffffffff8118d3e9>] vma_stop.clone.3+0x18/0x33
 PGD 1a05067 PUD 1a06067 PMD 0 
 Oops: 0000 [#1] SMP 
 last sysfs file: /sys/devices/LNXSYSTM:00/device:00/PNP0C0A:00/power_supply/BAT0/energy_full
 CPU 0 
 Modules linked in: ipx p8022 psnap llc p8023 sctp libcrc32c tun vfat fat usb_storage uas nfs fscache fuse nfsd lockd nfs_acl auth_rpcgss sunrpc cpufreq_ondemand acpi_cpufreq freq_table mperf ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 ip6table_filter ip6_tables ipv6 uinput arc4 iwlagn btusb bluetooth snd_hda_codec_hdmi snd_hda_codec_idt mac80211 snd_hda_intel snd_usb_audio snd_hda_codec dell_wmi snd_seq sparse_keymap uvcvideo snd_pcm dell_laptop snd_hwdep dcdbas snd_usbmidi_lib microcode videodev zaurus cfg80211 snd_rawmidi snd_seq_device cdc_ether v4l2_compat_ioctl32 usbnet snd_timer iTCO_wdt pcspkr joydev cdc_acm i2c_i801 cdc_wdm tg3 snd mii iTCO_vendor_support rfkill soundcore snd_page_alloc wmi i915 drm_kms_helper drm i2c_algo_bit i2c_core video [last unloaded: scsi_wait_scan]
 
 Pid: 324, comm: perf Tainted: G        W   2.6.38+ #5 Dell Inc. Adamo 13   /0N70T0
 RIP: 0010:[<ffffffff8118d3e9>]  [<ffffffff8118d3e9>] vma_stop.clone.3+0x18/0x33
 RSP: 0018:ffff880114de1e48  EFLAGS: 00010286
 RAX: 00000000fffffff3 RBX: ffff880007f44bc8 RCX: ffff8800b7216806
 RDX: ffffffff81618f50 RSI: fffffffffffffff3 RDI: ffff880007f44bd8
 RBP: ffff880114de1e58 R08: 0000000000000001 R09: 0000000000000000
 R10: ffffffff81a26870 R11: 0000000000000246 R12: ffff88000fe3d880
 R13: ffff8800b72168f8 R14: fffffffffffffff3 R15: 0000000000000000
 FS:  00007f59e738c720(0000) GS:ffff88013fa00000(0000) knlGS:0000000000000000
 CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
 CR2: fffffffffffffff3 CR3: 0000000136566000 CR4: 00000000000406f0
 DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
 DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
 Process perf (pid: 324, threadinfo ffff880114de0000, task ffff8800b43c23b0)
 Stack:
  0000000000000000 ffff880007f44bc8 ffff880114de1e78 ffffffff8118d46a
  0000000000000000 0000000000000400 ffff880114de1ef8 ffffffff81159a99
  0000000000000004 ffff8801fffffff3 0000000000000004 ffff8800b7216930
 Call Trace:
  [<ffffffff8118d46a>] m_stop+0x1e/0x30
  [<ffffffff81159a99>] seq_read+0x240/0x36e
  [<ffffffff8113dc28>] vfs_read+0xac/0xff
  [<ffffffff8113f0f8>] ? fget_light+0x3a/0xa1
  [<ffffffff8113dcc8>] sys_read+0x4d/0x74
  [<ffffffff814d6b42>] system_call_fastpath+0x16/0x1b
 Code: 8b 54 24 08 48 89 53 30 41 5d 5b 41 5c 31 c0 41 5d c9 c3 55 48 89 e5 53 48 83 ec 08 0f 1f 44 00 00 48 85 f6 74 1c 48 3b 37 74 17 
  8b 1e 48 8d bb a8 00 00 00 e8 d9 e6 ee ff 48 89 df e8 9a ab 
 RIP  [<ffffffff8118d3e9>] vma_stop.clone.3+0x18/0x33
  RSP <ffff880114de1e48>
 CR2: fffffffffffffff3
 ---[ end trace ea1a722d5e92836a ]---


it smells like something got corrupted, but I'm not sure where
to start.  I've got a bunch of debug options turned on, but nothing
else triggered, so I've got nothing other than this oops to go on.

Any thoughts ?

	Dave

