Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754875Ab1AUM6N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 07:58:13 -0500
Received: from ns.km10614-05.keymachine.de ([87.118.102.170]:37821 "EHLO
	km10614-05.keymachine.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754071Ab1AUM6K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 07:58:10 -0500
X-Greylist: delayed 610 seconds by postgrey-1.27 at vger.kernel.org; Fri, 21 Jan 2011 07:58:10 EST
Date: Fri, 21 Jan 2011 13:47:54 +0100
From: Harald Braumann <harry@unheit.net>
To: linux-kernel@vger.kernel.org
Subject: Deadlock on concurrent remount-ro and mdadm --stop (2.6.37)
Message-ID: <20110121124754.GA5233@nn.nn>
Mail-Followup-To: Harald Braumann <harry@unheit.net>,
	linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(please CC)

Hi,

my system sometimes completely locks up on shutdown and leaves the raid array 
in an unclean state. 

On shutdown `umountroot' and `mdadm-raid'  are executed concurrently. The 
actual commands are:
mount -o remount,ro /
mdadm --stop --scan

This seems to trigger a deadlock in the kernel. Dumping blocked tasks (sysrq-W)
gives:

md126_raid5: call trace:
  md_super_wait
  autoremove_wake_function
  bitmap_unplug
  ...

mount: call trace:
  sync_page
  io_schedule
  sync_page
  __wait_on_bit
  wake_bit_function
  pagevec_lookup_tag
  filemap_fdatawait_range
  filemap_write_and_wait
  dquot_quota_sync
  __sync_filesystem
  do_remount_sb
  do_mount
  memdup_user
  sys_mount
  system_call_fastpath

Sorry for not supplying a better trace, but while I could trigger the deadlock
some more times, it then always locked up so badly, that not even sysrq-W
would work. If more information is needed I could try again to get a full trace
and dump it over a serial console.

NB: md126_raid5's trace says `bitmap_unplug'. I've added a write-intent bitmap
to the array to speed up the resync. But I also had lockups before, without any
bitmap.

My disk setup is as follows:
sd{a,b,c}1 - raid1 (md127) - ext4
sd{a,b,c}2 - raid5 (md126) - LVM - dm-crypt - LVM - containing root-fs

Some more information, that might be useful:

scripts/ver_linux:
------------------

Gnu C                  4.4.5
Gnu make               3.81
binutils               2.20.1
util-linux             scripts/ver_linux: 23: fdformat: not found
mount                  support
module-init-tools      found
Linux C Library        2.11.2
Dynamic linker (ldd)   2.11.2
Procps                 3.2.8
Console-tools          0.2.3
Sh-utils               8.5
Modules Loaded         vboxnetadp vboxnetflt vboxdrv kvm_amd kvm
deflate zlib_deflate ctr twofish_generic twofish_x86_64 twofish_common
camellia serpent blowfish cast5 des_generic cbc xcbc rmd160
sha512_generic  sha256_generic sha1_generic hmac crypto_null af_key
fuse nfsd exportfs nfs lockd fscache nfs_acl auth_rpcgss sunrpc bridge
stp ipt_REJECT ipt_LOG xt_state xt_tcpudp xt_physdev iptable_mangle
iptable_nat nf_nat nf_conntrack_ipv4 nf_conntrack nf_defrag_ipv4
iptable_filter ip_tables x_tables ext2 powernow_k8 mperf it87
hwmon_vid snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_intel
snd_hda_codec snd_hwdep snd_pcm_oss snd_mixer_oss radeon snd_pcm
snd_seq_dummy snd_seq_oss snd_seq_midi snd_rawmidi ttm
snd_seq_midi_event snd_seq drm_kms_helper drm agpgart snd_timer
snd_seq_device i2c_algo_bit tpm_tis tpm parport_pc tpm_bios snd
parport shpchp processor button i2c_piix4 soundcore k8temp pci_hotplug
i2c_core pcspkr snd_page_alloc evdev edac_core thermal_sys ext4
mbcache jbd2 crc16 cryptd aes_x86_64 aes_generic xts gf128mul dm_crypt
dm_mod raid456 async_raid6_recov async_pq raid6_pq async_xor xor
async_memcpy async_tx raid1 md_mod lzo sd_mod usbhid crc_t10dif
ata_generic hid pata_acpi ahci libahci ohci_hcd pata_atiixp
firewire_ohci libata ehci_hcd firewire_core ssb usbcore scsi_mod
mmc_core r8169 crc_itu_t mii pcmcia pcmcia_core

/proc/cpuinfo:
--------------

processor	: 0
vendor_id	: AuthenticAMD
cpu family	: 15
model		: 107
model name	: AMD Athlon(tm) 64 X2 Dual Core Processor 4800+
stepping	: 2
cpu MHz		: 1000.000
cache size	: 512 KB
physical id	: 0
siblings	: 2
core id		: 0
cpu cores	: 2
apicid		: 0
initial apicid	: 0
fpu		: yes
fpu_exception	: yes
cpuid level	: 1
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext fxsr_opt rdtscp lm 3dnowext 3dnow rep_good nopl extd_apicid pni cx16 lahf_lm cmp_legacy svm extapic cr8_legacy 3dnowprefetch lbrv
bogomips	: 2005.26
TLB size	: 1024 4K pages
clflush size	: 64
cache_alignment	: 64
address sizes	: 40 bits physical, 48 bits virtual
power management: ts fid vid ttp tm stc 100mhzsteps

processor	: 1
vendor_id	: AuthenticAMD
cpu family	: 15
model		: 107
model name	: AMD Athlon(tm) 64 X2 Dual Core Processor 4800+
stepping	: 2
cpu MHz		: 1000.000
cache size	: 512 KB
physical id	: 0
siblings	: 2
core id		: 1
cpu cores	: 2
apicid		: 1
initial apicid	: 1
fpu		: yes
fpu_exception	: yes
cpuid level	: 1
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext fxsr_opt rdtscp lm 3dnowext 3dnow rep_good nopl extd_apicid pni cx16 lahf_lm cmp_legacy svm extapic cr8_legacy 3dnowprefetch lbrv
bogomips	: 2005.26
TLB size	: 1024 4K pages
clflush size	: 64
cache_alignment	: 64
address sizes	: 40 bits physical, 48 bits virtual
power management: ts fid vid ttp tm stc 100mhzsteps


lspci:
------

00:00.0 Host bridge: ATI Technologies Inc RS690 Host Bridge
00:02.0 PCI bridge: ATI Technologies Inc RS690 PCI to PCI Bridge (PCI Express Graphics Port 0)
00:12.0 SATA controller: ATI Technologies Inc SB600 Non-Raid-5 SATA
00:13.0 USB Controller: ATI Technologies Inc SB600 USB (OHCI0)
00:13.1 USB Controller: ATI Technologies Inc SB600 USB (OHCI1)
00:13.2 USB Controller: ATI Technologies Inc SB600 USB (OHCI2)
00:13.3 USB Controller: ATI Technologies Inc SB600 USB (OHCI3)
00:13.4 USB Controller: ATI Technologies Inc SB600 USB (OHCI4)
00:13.5 USB Controller: ATI Technologies Inc SB600 USB Controller (EHCI)
00:14.0 SMBus: ATI Technologies Inc SBx00 SMBus Controller (rev 14)
00:14.1 IDE interface: ATI Technologies Inc SB600 IDE
00:14.2 Audio device: ATI Technologies Inc SBx00 Azalia (Intel HDA)
00:14.3 ISA bridge: ATI Technologies Inc SB600 PCI to LPC Bridge
00:14.4 PCI bridge: ATI Technologies Inc SBx00 PCI to PCI Bridge
00:18.0 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] HyperTransport Technology Configuration
00:18.1 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] Address Map
00:18.2 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] DRAM Controller
00:18.3 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] Miscellaneous Control
01:00.0 VGA compatible controller: ATI Technologies Inc Radeon HD 3870
01:00.1 Audio device: ATI Technologies Inc Radeon HD 3870 Audio device
02:0e.0 FireWire (IEEE 1394): Texas Instruments TSB43AB23 IEEE-1394a-2000 Controller (PHY/Link)
02:0f.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL-8110SC/8169SC Gigabit Ethernet (rev 10)

Cheers,
harry
