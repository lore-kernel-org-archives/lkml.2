Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753110Ab1GUXP7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 19:15:59 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:33467 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752984Ab1GUXPx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 19:15:53 -0400
MIME-Version: 1.0
Date: Fri, 22 Jul 2011 01:15:52 +0200
Message-ID: <CAMc2VtRWibRKcq8kn6+gbpxs1xw3OJp2O=c0u61-T7bzVihO_w@mail.gmail.com>
Subject: PROBLEM: Contention in VFS when traversing symlinks
From: Francois <rigault.francois@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

installing a 2.6.39.3 kernel, replacing an old 2.6.32, we're seeing an
increased system time when timing compilations with 48 processes (on 48
cores machines).  We noticed that the headers directories given to the
compiler are written -I/bar/path1 -I/bar/path2 ... where /bar is a
symbolic link to a /data/foo directory.  Removing the symlink from the -I
divides the system time by 10 (and outperforms our older kernel).

This is an extract of a perf report

72.19%     cc1plus
--- _raw_spin_lock
   |--49.15%-- dput
   |          |--66.52%-- path_put
   |          |          |--50.08%-- link_path_walk
   |          |          |--46.28%-- path_openat
   |          |--33.46%-- link_path_walk
   |          |          |--99.94%-- link_path_walk
   |--32.87%-- path_get
   |          |--50.54%-- nameidata_dentry_drop_rcu
   |          |          |--99.98%-- link_path_walk
   |          |--49.36%-- link_path_walk
   |--16.71%-- nameidata_dentry_drop_rcu
   |          |--100.00%-- link_path_walk


Linux version 2.6.39.3-vanilla-frigo (frigault@lnx01) (gcc version
4.3.4 [gcc-4_3-branch revision 152973] (SUSE Linux) ) #1 SMP Thu Jul
21 21:54:49 MEST 2011
/dev/sda2 on / type ext3 (rw,acl,user_xattr)


Reproducing
-----------
within kernel sources

mkdir /foo/{a,b,c,d}
ln -s /foo /bar
time make -j 48
> 376.33s user 67.39s system 3920% cpu 11.317 total
time make NOSTDINC_FLAGS="-I/foo/a -I/foo/b -I/foo/c -I/foo/d" -j 48
> 341.43s user 68.94s system 3857% cpu 10.639 total
time make NOSTDINC_FLAGS="-I/bar/a -I/bar/b -I/bar/c -I/bar/d" -j 48
> [[[ 53.83s user 349.45s system ]]] 3618% cpu 11.145 total

System time increased a lot (30 times in proportion) when include
lookup is done through symlinks.


Environment
-----------

Linux lnx01 2.6.39.3-vanilla-frigo #1 SMP Thu Jul 21 21:54:49 MEST
2011 x86_64 x86_64 x86_64 GNU/Linux

Gnu C                  4.3
Gnu make               3.81
binutils               2.20.0.20100122
0.7.9
util-linux             ?
mount                  support
module-init-tools      3.11.1
e2fsprogs              1.41.9
reiserfsprogs          3.6.21
quota-tools            3.16.
Linux C Library        2.11.1
Dynamic linker (ldd)   2.11.1
Procps                 3.2.7
Net-tools              1.60
Kbd                    1.14.1
oprofile               0.9.6
Sh-utils               6.12
udev                   128
Modules Loaded         af_packet nls_iso8859_1 nls_cp437 vfat fat
iptable_filter ip_tables x_tables nfs lockd fscache auth_rpcgss
nfs_acl sunrpc mpt2sas s csi_transport_sas raid_class mptctl mptbase
ipv6 ipmi_devintf ipmi_si ipmi_msghandler dell_rbu mperf fuse loop
dm_mod usb_storage joydev tpm_tis tpm usbhi d amd64_edac_mod edac_core
edac_mce_amd dcdbas i2c_piix4 i2c_core tpm_bios hid bnx2 sr_mod ses
serio_raw rtc_cmos rtc_core rtc_lib cdrom pcspkr enclosure  button sg
power_meter ohci_hcd ehci_hcd usbcore sd_mod crc_t10dif edd ext3
mbcache jbd fan thermal processor thermal_sys hwmon ahci libahci
libata megarai d_sas scsi_mod


processor       : 47
vendor_id       : AuthenticAMD
cpu family      : 16
model           : 9
model name      : AMD Opteron(tm) Processor 6174
stepping        : 1
cpu MHz         : 2199.913
cache size      : 512 KB
physical id     : 1
siblings        : 12
core id         : 5
cpu cores       : 12
apicid          : 27
initial apicid  : 27
fpu             : yes
fpu_exception   : yes
cpuid level     : 5
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge
mca cmov pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext
fxsr_opt pdpe1gb rdtscp lm 3dnowext 3dnow constant_tsc rep_good nopl
nonstop_tsc extd_apicid amd_dcm pni monitor cx16 popcnt lahf_lm
cmp_legacy svm extapic cr8_legacy abm sse4a misalignsse 3dnowprefetch
osvw ibs skinit wdt nodeid_msr npt lbrv svm_lock nrip_save pausefilter
bogomips        : 4400.13
TLB size        : 1024 4K pages
clflush size    : 64
cache_alignment : 64
address sizes   : 48 bits physical, 48 bits virtual
power management: ts ttp tm stc 100mhzsteps hwpstate
