Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754387Ab0DNIsr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Apr 2010 04:48:47 -0400
Received: from mail.abisoft.spb.ru ([91.190.120.140]:55141 "EHLO
	mail.abisoft.spb.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753134Ab0DNIsm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Apr 2010 04:48:42 -0400
X-Greylist: delayed 740 seconds by postgrey-1.27 at vger.kernel.org; Wed, 14 Apr 2010 04:48:41 EDT
Date: Wed, 14 Apr 2010 12:36:18 +0400
From: Alexander Kolesnik <linux-kernel@abisoft.biz>
X-Mailer: The Bat! (v3.99.3) Home
Organization: ABISoft
X-Priority: 3 (Normal)
Message-ID: <1064253249.20100414123618@abisoft.biz>
To: linux-kernel@vger.kernel.org
Subject: PROBLEM: linux server halts while restarting VLC
MIME-Version: 1.0
Content-Type: text/plain; charset=windows-1251
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

We have a video camera which is connected to a capture card in a linux
server  (CentOS  5.4).  VLC  takes  video  data from the capture card,
streams  it  and writes to a file. A cron job checking the file's size
and  rotates  it  when  it comes to a configured limit. After file was
rotated, VLC process is restarted.
Rotating and restarting are done by means of logrotate script:
# cat /etc/logrotate.d/vlc
/opt3/cam-fx4/*.asf {
    size 300M
    rotate 16
    notifempty
    missingok
    prerotate
        killall vlc && sleep 1
    endscript
    postrotate
        sudo -u vlc /usr/local/bin/vlc_cam-fx4.shx
    endscript
}

# cat /usr/local/bin/vlc_cam-fx4.shx
nice -n 19 vlc --intf dummy v4l2:// :v4l2-dev="/dev/video0" :v4l2-standard=255 :v4l2-input=1 :v4l2-width=720 :v4l2-height=480 \
    --no-sout-audio \
    --marq-marquee="%d-%m-%Y %H:%M:%S" --marq-position=10 --marq-opacity=200 --marq-size=20 \
    --sout '#transcode{vcodec=mp4v,vb=2048,scale=1,sfilter=marq}:duplicate{dst=std{access=http,mux=ts,dst=.....},dst=std{access=file,mux=ps,dst=/opt3/cam-fx4/cam-fx4.asf}}' > /dev/null 2>&1 &

Once or twice a day, the server halts with the following in the system
log:
Apr 14 07:01:02 alto sudo:     root : TTY=unknown ; PWD=/ ; USER=vlc ; COMMAND=/usr/local/bin/vlc_cam-fx4.shx
Apr 14 07:01:06 alto kernel: vlc: page allocation failure. order:2, mode:0x8020
Apr 14 07:01:06 alto kernel: Pid: 3492, comm: vlc Not tainted 2.6.33.2 #1
Apr 14 07:01:06 alto kernel: Call Trace:
Apr 14 07:01:06 alto kernel:  [<c106b047>] ? __alloc_pages_nodemask+0x465/0x4dd
Apr 14 07:01:06 alto kernel:  [<c1004d69>] ? dma_generic_alloc_coherent+0x4d/0xa4
Apr 14 07:01:06 alto kernel:  [<c1004d1c>] ? dma_generic_alloc_coherent+0x0/0xa4
Apr 14 07:01:06 alto kernel:  [<e0fbf4de>] ? btcx_riscmem_alloc+0x9d/0xf3 [btcx_risc]
Apr 14 07:01:06 alto kernel:  [<e14fe4ae>] ? bttv_risc_planar+0x4f/0x2a3 [bttv]
Apr 14 07:01:06 alto kernel:  [<c10801b1>] ? map_vm_area+0x20/0x30
Apr 14 07:01:06 alto kernel:  [<e14feefa>] ? bttv_buffer_risc+0x31f/0x4b4 [bttv]
Apr 14 07:01:06 alto kernel:  [<e14fb503>] ? buffer_prepare+0x296/0x2c5 [bttv]
Apr 14 07:01:06 alto kernel:  [<e101f2fd>] ? videobuf_qbuf+0x235/0x2ed [videobuf_core]
Apr 14 07:01:06 alto kernel:  [<e14fd072>] ? bttv_qbuf+0x0/0x63 [bttv]
Apr 14 07:01:06 alto kernel:  [<e14fd072>] ? bttv_qbuf+0x0/0x63 [bttv]
Apr 14 07:01:06 alto kernel:  [<e134bb9b>] ? __video_do_ioctl+0x115b/0x3554 [videodev]
Apr 14 07:01:06 alto kernel:  [<c10e989a>] ? avc_has_perm_noaudit+0x1b6/0x2be
Apr 14 07:01:06 alto kernel:  [<c123f1ef>] ? schedule+0x29e/0x2c3
Apr 14 07:01:06 alto kernel:  [<c10e9b1b>] ? avc_has_perm+0x3c/0x46
Apr 14 07:01:06 alto kernel:  [<e134e221>] ? video_ioctl2+0x28d/0x34f [videodev]
Apr 14 07:01:06 alto kernel:  [<c1077083>] ? __do_fault+0x373/0x3ac
Apr 14 07:01:06 alto kernel:  [<c10ea80f>] ? file_has_perm+0x84/0x8d
Apr 14 07:01:06 alto kernel:  [<e134df94>] ? video_ioctl2+0x0/0x34f [videodev]
Apr 14 07:01:06 alto kernel:  [<e134a6c1>] ? v4l2_ioctl+0x31/0x34 [videodev]
Apr 14 07:01:06 alto kernel:  [<e134a690>] ? v4l2_ioctl+0x0/0x34 [videodev]
Apr 14 07:01:06 alto kernel:  [<c1096821>] ? vfs_ioctl+0x39/0x48
Apr 14 07:01:06 alto kernel:  [<c1096d98>] ? do_vfs_ioctl+0x4d8/0x525
Apr 14 07:01:06 alto kernel:  [<c1096e26>] ? sys_ioctl+0x41/0x58
Apr 14 07:01:06 alto kernel:  [<c100254c>] ? sysenter_do_call+0x12/0x22
Apr 14 07:01:06 alto kernel: Mem-Info:
Apr 14 07:01:06 alto kernel: DMA per-cpu:
Apr 14 07:01:06 alto kernel: CPU    0: hi:    0, btch:   1 usd:   0
Apr 14 07:01:06 alto kernel: Normal per-cpu:
Apr 14 07:01:06 alto kernel: CPU    0: hi:  186, btch:  31 usd: 198
Apr 14 07:01:06 alto kernel: active_anon:2701 inactive_anon:2754 isolated_anon:0
Apr 14 07:01:06 alto kernel:  active_file:37313 inactive_file:75024 isolated_file:0
Apr 14 07:01:06 alto kernel:  unevictable:0 dirty:951 writeback:0 unstable:0
Apr 14 07:01:06 alto kernel:  free:3474 slab_reclaimable:3837 slab_unreclaimable:1016
Apr 14 07:01:06 alto kernel:  mapped:4169 shmem:41 pagetables:156 bounce:0
Apr 14 07:01:06 alto kernel: DMA free:2008kB min:88kB low:108kB high:132kB active_anon:12kB inactive_anon:16kB active_file:177
2kB inactive_file:11988kB unevictable:0kB isolated(anon):0kB isolated(file):0kB present:15868kB mlocked:0kB dirty:0kB writebac
k:0kB mapped:0kB shmem:0kB slab_reclaimable:92kB slab_unreclaimable:4kB kernel_stack:0kB pagetables:0kB unstable:0kB bounce:0k
B writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no
Apr 14 07:01:06 alto kernel: lowmem_reserve[]: 0 491 491 491
Apr 14 07:01:06 alto kernel: Normal free:11888kB min:2788kB low:3484kB high:4180kB active_anon:10792kB inactive_anon:11000kB a
ctive_file:147480kB inactive_file:288108kB unevictable:0kB isolated(anon):0kB isolated(file):0kB present:502856kB mlocked:0kB
dirty:3804kB writeback:0kB mapped:16676kB shmem:164kB slab_reclaimable:15256kB slab_unreclaimable:4060kB kernel_stack:340kB pa
getables:624kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no
Apr 14 07:01:06 alto kernel: lowmem_reserve[]: 0 0 0 0
Apr 14 07:01:06 alto kernel: DMA: 0*4kB 1*8kB 1*16kB 0*32kB 1*64kB 1*128kB 1*256kB 1*512kB 1*1024kB 0*2048kB 0*4096kB = 2008kB
Apr 14 07:01:06 alto kernel: Normal: 1940*4kB 516*8kB 0*16kB 0*32kB 0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB
= 11888kB

# cat /proc/version
Linux version 2.6.33.2 (root@vm-centos5-test) (gcc version 4.1.2 20080704 (Red Hat 4.1.2-46)) #1 Wed Apr 7 23:21:34 MSD 2010

# sh scripts/ver_linux
If some fields are empty or look unusual you may have an old version.
Compare to the current minimal requirements in Documentation/Changes.

Linux alto 2.6.33.2 #1 Wed Apr 7 23:21:34 MSD 2010 i686 i686 i386 GNU/Linux

Gnu C                  4.1.2
Gnu make               3.81
binutils               2.17.50.0.6
util-linux             2.13-pre7
mount                  2.13-pre7
module-init-tools      3.3-pre2
e2fsprogs              1.39
quota-tools            3.13.
PPP                    2.4.4
Linux C Library        2.5
Dynamic linker (ldd)   2.5
Procps                 3.2.7
Net-tools              1.60
Kbd                    1.12
Sh-utils               5.97
udev                   095
wireless-tools         28
Modules Loaded         nfsd nfs_acl auth_rpcgss exportfs ipv6 lockd sunrpc sg dm_mirror dm_multipath lp nvram tuner_simple tuner_types snd_intel8x0 tuner snd_ac97_codec ac97_bus tvaudio snd_seq_dummy tda7432 snd_cs4236 msp3400 snd_wss_lib snd_opl3_lib snd_hwdep snd_mpu401_uart lnbp21 snd_rawmidi snd_seq_oss snd_seq_midi_event stb6100 snd_seq snd_seq_device stb0899 usb_storage bttv v4l2_common snd_pcm_oss videodev v4l1_compat budget_ci snd_mixer_oss ir_common budget_core e100 dvb_core snd_bt87x videobuf_dma_sg videobuf_core mii saa7146 btcx_risc ttpci_eeprom tveeprom snd_pcm parport_pc ir_core ns558 parport gameport floppy snd_timer snd soundcore snd_page_alloc shpchp pcspkr i2c_i801 rng_core dm_region_hash dm_log dm_mod ata_piix libata sd_mod scsi_mod ext3 jbd uhci_hcd ohci_hcd ehci_hcd

# cat /proc/cpuinfo
processor       : 0
vendor_id       : GenuineIntel
cpu family      : 6
model           : 11
model name      : Intel(R) Celeron(TM) CPU                1100MHz
stepping        : 1
cpu MHz         : 1110.719
cache size      : 256 KB
fdiv_bug        : no
hlt_bug         : no
f00f_bug        : no
coma_bug        : no
fpu             : yes
fpu_exception   : yes
cpuid level     : 2
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pse36 mmx fxsr sse
bogomips        : 2221.43
clflush size    : 32
cache_alignment : 32
address sizes   : 36 bits physical, 32 bits virtual
power management:

# cat /proc/modules
nfsd 195851 13 - Live 0xe2d1c000
nfs_acl 1711 1 nfsd, Live 0xe2a86000
auth_rpcgss 25980 1 nfsd, Live 0xe2a63000
exportfs 2490 1 nfsd, Live 0xe29d7000
ipv6 179735 12 - Live 0xe297f000
lockd 48590 1 nfsd, Live 0xe2469000
sunrpc 134111 13 nfsd,nfs_acl,auth_rpcgss,lockd, Live 0xe224e000
sg 20734 0 - Live 0xe1e67000
dm_mirror 9882 0 - Live 0xe1e1c000
dm_multipath 11439 0 - Live 0xe1dda000
lp 6393 0 - Live 0xe1d8c000
nvram 3805 0 - Live 0xe1d63000
tuner_simple 10320 1 - Live 0xe1d42000
tuner_types 7793 1 tuner_simple, Live 0xe1d33000
snd_intel8x0 18597 1 - Live 0xe1d20000
tuner 14982 1 - Live 0xe1ce0000
snd_ac97_codec 75934 1 snd_intel8x0, Live 0xe1cba000
ac97_bus 589 1 snd_ac97_codec, Live 0xe1c28000
tvaudio 19492 0 - Live 0xe1c09000
snd_seq_dummy 907 0 - Live 0xe1bda000
tda7432 2888 0 - Live 0xe1bba000
snd_cs4236 19037 0 - Live 0xe1baa000
msp3400 20036 0 - Live 0xe1b58000
snd_wss_lib 16450 1 snd_cs4236, Live 0xe1b41000
snd_opl3_lib 6198 1 snd_cs4236, Live 0xe1b05000
snd_hwdep 3983 1 snd_opl3_lib, Live 0xe1ac8000
snd_mpu401_uart 4115 1 snd_cs4236, Live 0xe1a9f000
lnbp21 1340 1 - Live 0xe1a7c000
snd_rawmidi 12491 1 snd_mpu401_uart, Live 0xe1a6d000
snd_seq_oss 19703 0 - Live 0xe1957000
snd_seq_midi_event 3748 1 snd_seq_oss, Live 0xe1862000
stb6100 5060 1 - Live 0xe1844000
snd_seq 32229 5 snd_seq_dummy,snd_seq_oss,snd_seq_midi_event, Live 0xe1734000
snd_seq_device 3673 5 snd_seq_dummy,snd_opl3_lib,snd_rawmidi,snd_seq_oss,snd_seq, Live 0xe1614000
stb0899 27223 1 - Live 0xe15e9000
usb_storage 29442 0 - Live 0xe15cb000
bttv 87866 1 - Live 0xe14b3000
v4l2_common 13460 5 tuner,tvaudio,tda7432,msp3400,bttv, Live 0xe1484000
snd_pcm_oss 29387 0 - Live 0xe1392000
videodev 28339 7 tuner,tvaudio,tda7432,msp3400,bttv,v4l2_common, Live 0xe1140000
v4l1_compat 10638 1 videodev, Live 0xe112a000
budget_ci 15673 0 - Live 0xe111a000
snd_mixer_oss 11378 1 snd_pcm_oss, Live 0xe10db000
ir_common 28286 2 bttv,budget_ci, Live 0xe109d000
budget_core 5128 1 budget_ci, Live 0xe1085000
e100 22215 0 - Live 0xe106f000
dvb_core 62556 2 budget_ci,budget_core, Live 0xe0fca000
snd_bt87x 6804 0 - Live 0xe0fa7000
videobuf_dma_sg 6959 1 bttv, Live 0xe0f75000
videobuf_core 10101 2 bttv,videobuf_dma_sg, Live 0xe0f65000
mii 2706 1 e100, Live 0xe0f57000
saa7146 10662 2 budget_ci,budget_core, Live 0xe0f2f000
btcx_risc 2395 1 bttv, Live 0xe0f20000
ttpci_eeprom 1240 1 budget_core, Live 0xe0f16000
tveeprom 9437 1 bttv, Live 0xe0e40000
snd_pcm 46598 7 snd_intel8x0,snd_ac97_codec,snd_cs4236,snd_wss_lib,snd_pcm_oss,snd_bt87x, Live 0xe0e24000
parport_pc 16518 1 - Live 0xe0d4d000
ir_core 4173 3 bttv,budget_ci,ir_common, Live 0xe0d06000
ns558 1739 0 - Live 0xe0cfb000
parport 22111 2 lp,parport_pc, Live 0xe0cdb000
gameport 5942 2 ns558, Live 0xe0c5e000
floppy 40093 0 - Live 0xe0c2d000
snd_timer 12452 4 snd_wss_lib,snd_opl3_lib,snd_seq,snd_pcm, Live 0xe0bd8000
snd 31852 17 snd_intel8x0,snd_ac97_codec,snd_cs4236,snd_wss_lib,snd_opl3_lib,snd_hwdep,snd_mpu401_uart,snd_rawmidi,snd_seq_oss,snd_seq,snd_seq_device,snd_pcm_oss,snd_mixer_oss,snd_bt87x,snd_pcm,snd_timer, Live 0xe0b94000
soundcore 3705 1 snd, Live 0xe0aa9000
snd_page_alloc 4881 4 snd_intel8x0,snd_wss_lib,snd_bt87x,snd_pcm, Live 0xe0a82000
shpchp 21797 0 - Live 0xe0a53000
pcspkr 1251 0 - Live 0xe09bd000
i2c_i801 5707 0 - Live 0xe09a1000
rng_core 2350 0 - Live 0xe097b000
dm_region_hash 5452 1 dm_mirror, Live 0xe0951000
dm_log 6607 2 dm_mirror,dm_region_hash, Live 0xe0944000
dm_mod 43829 3 dm_mirror,dm_multipath,dm_log, Live 0xe0929000
ata_piix 10601 0 - Live 0xe090a000
libata 106916 1 ata_piix, Live 0xe08d4000
sd_mod 23162 0 - Live 0xe0899000
scsi_mod 104604 4 sg,usb_storage,libata,sd_mod, Live 0xe0861000
ext3 94473 2 - Live 0xe0767000
jbd 32841 1 ext3, Live 0xe0756000
uhci_hcd 14221 0 - Live 0xe073b000
ohci_hcd 14434 0 - Live 0xe0728000
ehci_hcd 25165 0 - Live 0xe070f000

# cat /proc/ioports
0000-001f : dma1
0020-0021 : pic1
0040-0043 : timer0
0050-0053 : timer1
0060-0060 : keyboard
0064-0064 : keyboard
0070-0077 : rtc
0080-008f : dma page reg
00a0-00a1 : pic2
00c0-00df : dma2
00f0-00ff : fpu
0170-0177 : 0000:00:1f.1
  0170-0177 : piix
01f0-01f7 : 0000:00:1f.1
  01f0-01f7 : piix
0201-0201 : ns558-pnp
0376-0376 : 0000:00:1f.1
  0376-0376 : piix
0378-037a : parport0
03c0-03df : vga+
03f2-03f2 : floppy
03f4-03f5 : floppy
03f6-03f6 : 0000:00:1f.1
  03f6-03f6 : piix
03f7-03f7 : floppy
03f8-03ff : serial
0cf8-0cff : PCI conf1
4000-407f : 0000:00:1f.0
4080-40bf : 0000:00:1f.0
5000-500f : 0000:00:1f.3
  5000-500f : i801_smbus
c000-cfff : PCI Bus 0000:01
  c000-c01f : 0000:01:00.0
    c000-c01f : uhci_hcd
  c400-c41f : 0000:01:00.1
    c400-c41f : uhci_hcd
  c800-c83f : 0000:01:08.0
    c800-c83f : e100
d000-d01f : 0000:00:1f.2
  d000-d01f : uhci_hcd
d800-d81f : 0000:00:1f.4
  d800-d81f : uhci_hcd
dc00-dcff : 0000:00:1f.5
  dc00-dcff : Intel 82801BA-ICH2
e000-e03f : 0000:00:1f.5
  e000-e03f : Intel 82801BA-ICH2
f000-f00f : 0000:00:1f.1
  f000-f00f : piix

# cat /proc/iomem
00000000-0009fbff : System RAM
0009fc00-0009ffff : reserved
000a0000-000bffff : Video RAM area
000c0000-000c9fff : Video ROM
000ca000-000cbfff : pnp 00:09
000f0000-000fffff : reserved
  000f0000-000fffff : System ROM
00100000-1feeffff : System RAM
  01000000-01244714 : Kernel code
  01244715-01384987 : Kernel data
  013cb000-014446df : Kernel bss
1fef0000-1fef2fff : ACPI Non-volatile Storage
1fef3000-1fefffff : ACPI Tables
1ff00000-1fffffff : reserved
e0000000-e3ffffff : 0000:00:02.0
e4000000-e40fffff : PCI Bus 0000:01
  e4000000-e40000ff : 0000:01:00.2
    e4000000-e40000ff : ehci_hcd
  e4001000-e40011ff : 0000:01:01.0
    e4001000-e40011ff : saa7146
  e4002000-e4002fff : 0000:01:08.0
    e4002000-e4002fff : e100
e4100000-e41fffff : PCI Bus 0000:01
  e4100000-e4100fff : 0000:01:02.0
    e4100000-e4100fff : bttv0
  e4101000-e4101fff : 0000:01:02.1
    e4101000-e4101fff : Bt87x audio
e4200000-e427ffff : 0000:00:02.0
fec00000-ffffffff : reserved
  fec00000-fec0ffff : pnp 00:08
  fee00000-fee0ffff : pnp 00:08
    fee00000-fee00fff : Local APIC
  ffb00000-ffb7ffff : pnp 00:08
  fff00000-ffffffff : pnp 00:08

# lspci -vvv
00:00.0 Host bridge: Intel Corporation 82815 815 Chipset Host Bridge and Memory Controller Hub (rev 04)
        Subsystem: Intel Corporation 82815 815 Chipset Host Bridge and Memory Controller Hub
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort+ >SERR- <PERR-
        Latency: 0
        Capabilities: [88] Vendor Specific Information

00:02.0 VGA compatible controller: Intel Corporation 82815 Chipset Graphics Controller (CGC) (rev 04) (prog-if 00 [VGA controller])
        Subsystem: Intel Corporation 82815 Chipset Graphics Controller (CGC)
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
        Latency: 0
        Interrupt: pin A routed to IRQ 5
        Region 0: Memory at e0000000 (32-bit, prefetchable) [size=64M]
        Region 1: Memory at e4200000 (32-bit, non-prefetchable) [size=512K]
        Capabilities: [dc] Power Management version 2
                Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-

00:1e.0 PCI bridge: Intel Corporation 82801 PCI Bridge (rev 05) (prog-if 00 [Normal decode])
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B-
        Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-
        Latency: 0
        Bus: primary=00, secondary=01, subordinate=01, sec-latency=32
        I/O behind bridge: 0000c000-0000cfff
        Memory behind bridge: e4000000-e40fffff
        Prefetchable memory behind bridge: e4100000-e41fffff
        Secondary status: 66MHz- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort+ <SERR- <PERR-
        BridgeCtl: Parity- SERR+ NoISA+ VGA- MAbort- >Reset- FastB2B-

00:1f.0 ISA bridge: Intel Corporation 82801BA ISA Bridge (LPC) (rev 05)
        Control: I/O+ Mem+ BusMaster+ SpecCycle+ MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
        Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
        Latency: 0

00:1f.1 IDE interface: Intel Corporation 82801BA IDE U100 Controller (rev 05) (prog-if 80 [Master])
        Subsystem: Intel Corporation Unknown device 2442
        Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
        Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
        Latency: 0
        Region 0: [virtual] Memory at 000001f0 (32-bit, non-prefetchable) [disabled] [size=8]
        Region 1: [virtual] Memory at 000003f0 (type 3, non-prefetchable) [disabled] [size=1]
        Region 2: [virtual] Memory at 00000170 (32-bit, non-prefetchable) [disabled] [size=8]
        Region 3: [virtual] Memory at 00000370 (type 3, non-prefetchable) [disabled] [size=1]
        Region 4: I/O ports at f000 [size=16]

00:1f.2 USB Controller: Intel Corporation 82801BA/BAM USB Controller #1 (rev 05) (prog-if 00 [UHCI])
        Subsystem: Intel Corporation 82801BA/BAM USB Controller #1
        Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
        Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
        Latency: 0
        Interrupt: pin D routed to IRQ 11
        Region 4: I/O ports at d000 [size=32]

00:1f.3 SMBus: Intel Corporation 82801BA/BAM SMBus Controller (rev 05)
        Subsystem: Intel Corporation Unknown device 2442
        Control: I/O+ Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
        Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
        Interrupt: pin B routed to IRQ 9
        Region 4: I/O ports at 5000 [size=16]

00:1f.4 USB Controller: Intel Corporation 82801BA/BAM USB Controller #1 (rev 05) (prog-if 00 [UHCI])
        Subsystem: Intel Corporation Unknown device 2442
        Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
        Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
        Latency: 0
        Interrupt: pin C routed to IRQ 11
        Region 4: I/O ports at d800 [size=32]

00:1f.5 Multimedia audio controller: Intel Corporation 82801BA/BAM AC'97 Audio Controller (rev 05)
        Subsystem: Giga-byte Technology Unknown device a002
        Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
        Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
        Latency: 0
        Interrupt: pin B routed to IRQ 9
        Region 0: I/O ports at dc00 [size=256]
        Region 1: I/O ports at e000 [size=64]

01:00.0 USB Controller: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1 Controller (rev 61) (prog-if 00 [UHCI])
        Subsystem: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1 Controller
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
        Latency: 32, Cache Line Size: 32 bytes
        Interrupt: pin A routed to IRQ 11
        Region 4: I/O ports at c000 [size=32]
        Capabilities: [80] Power Management version 2
                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=375mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-

01:00.1 USB Controller: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1 Controller (rev 61) (prog-if 00 [UHCI])
        Subsystem: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1 Controller
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
        Latency: 32, Cache Line Size: 32 bytes
        Interrupt: pin B routed to IRQ 11
        Region 4: I/O ports at c400 [size=32]
        Capabilities: [80] Power Management version 2
                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=375mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-

01:00.2 USB Controller: VIA Technologies, Inc. USB 2.0 (rev 63) (prog-if 20 [EHCI])
        Subsystem: VIA Technologies, Inc. USB 2.0
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
        Latency: 32, Cache Line Size: 32 bytes
        Interrupt: pin C routed to IRQ 3
        Region 0: Memory at e4000000 (32-bit, non-prefetchable) [size=256]
        Capabilities: [80] Power Management version 2
                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=375mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-

01:01.0 Multimedia controller: Philips Semiconductors SAA7146 (rev 01)
        Subsystem: Technotrend Systemtechnik GmbH S2-3200
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
        Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
        Latency: 32 (3750ns min, 9500ns max)
        Interrupt: pin A routed to IRQ 11
        Region 0: Memory at e4001000 (32-bit, non-prefetchable) [size=512]

01:02.0 Multimedia video controller: Brooktree Corporation Bt878 Video Capture (rev 11)
        Subsystem: Avermedia Technologies Inc AverMedia UltraTV PCI 350
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
        Latency: 32 (4000ns min, 10000ns max)
        Interrupt: pin A routed to IRQ 3
        Region 0: Memory at e4100000 (32-bit, prefetchable) [size=4K]
        Capabilities: [44] Vital Product Data
        Capabilities: [4c] Power Management version 2
                Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-

01:02.1 Multimedia controller: Brooktree Corporation Bt878 Audio Capture (rev 11)
        Subsystem: Avermedia Technologies Inc UltraTV PCI 350
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
        Latency: 32 (1000ns min, 63750ns max)
        Interrupt: pin A routed to IRQ 3
        Region 0: Memory at e4101000 (32-bit, prefetchable) [size=4K]
        Capabilities: [44] Vital Product Data
        Capabilities: [4c] Power Management version 2
                Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-

01:08.0 Ethernet controller: Intel Corporation 82801BA/BAM/CA/CAM Ethernet Controller (rev 03)
        Subsystem: Intel Corporation EtherExpress PRO/100 VE
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
        Latency: 32 (2000ns min, 14000ns max), Cache Line Size: 32 bytes
        Interrupt: pin A routed to IRQ 11
        Region 0: Memory at e4002000 (32-bit, non-prefetchable) [size=4K]
        Region 1: I/O ports at c800 [size=64]
        Capabilities: [dc] Power Management version 2
                Flags: PMEClk- DSI+ D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=0 DScale=2 PME-

# cat /proc/scsi/scsi
Attached devices:
Host: scsi0 Channel: 00 Id: 00 Lun: 00
  Vendor: ST316002 Model: 0F8P             Rev:
  Type:   Direct-Access                    ANSI  SCSI revision: 02

# rpm -qi vlc
Name        : vlc                          Relocations: (not relocatable)
Version     : 0.9.9a                            Vendor: Dag Apt Repository, http://dag.wieers.com/apt/
Release     : 4.el5.rf                      Build Date: Ñáò 07 Íîÿ 2009 18:30:53
Install Date: Ñðä 07 Àïð 2010 20:31:06      Build Host: lisse.hasselt.wieers.com
Group       : Applications/Multimedia       Source RPM: vlc-0.9.9a-4.el5.rf.src.rpm
Size        : 56121907                         License: GPL
Signature   : DSA/SHA1, Ñáò 07 Íîÿ 2009 23:13:35, Key ID a20e52146b8d79e6
Packager    : Dag Wieers <dag@wieers.com>
URL         : http://www.videolan.org/
Summary     : The VideoLAN client, also a very good standalone video player
Description :
VideoLAN Client (VLC) is a highly portable multimedia player for various
audio and video formats (MPEG-1, MPEG-2, MPEG-4, DivX, mp3, ogg, ...) as
well as DVDs, VCDs, and various streaming protocols.

Available rpmbuild rebuild options :
--with mga pth mozilla
--without dvdread dvdnav dvbpsi v4l avi asf aac ogg mad ffmpeg cdio
          a52 vorbis mpeg2dec flac aa caca esd arts alsa wxwidgets xosd
          lsp lirc id3tag faad2 theora mkv modplug smb speex glx x264
          gnomevfs vcd daap upnp pvr live portaudio avahi hal glide
          ncurses qt4 opencv

Options that would need not yet existing add-on packages :
--with loader ggi tarkin tremor


# cat /etc/grub.conf
default=2
timeout=5
splashimage=(hd0,0)/grub/splash.xpm.gz
hiddenmenu
title CentOS (vmlinuz-2.6.33.2)
        root (hd0,0)
        kernel /vmlinuz-2.6.33.2 ro root=LABEL=/ rootflags=data=journal
        initrd /initrd-2.6.33.2.img

Also I tried changing the kernel line to:
        kernel /vmlinuz-2.6.33.2 ro root=LABEL=/ rootflags=data=journal pci=noacpi noapic acpi=ht
It didn't help.

Please, let me know how to fix or workaround that.

-- 
Best regards,
Alexander

