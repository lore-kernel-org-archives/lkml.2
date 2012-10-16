Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754235Ab2JPOEH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 10:04:07 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:59744 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753423Ab2JPOEF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 10:04:05 -0400
MIME-Version: 1.0
Date: Tue, 16 Oct 2012 10:04:03 -0400
Message-ID: <CALurfZULPK_tXpqGpGcXM53wCBXf0VCds-E1iKCKZcw2OWoqvg@mail.gmail.com>
Subject: PROBLEM: CPUFreq BIOS limit
From: Yclept Nemo <orbisvicis@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: multipart/mixed; boundary=20cf3074d89e63eed004cc2da084
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--20cf3074d89e63eed004cc2da084
Content-Type: text/plain; charset=UTF-8

[1.] One line summary of the problem:

    CPUFreq BIOS limit problems


[2.] Full description of the problem/report:

The frequency steps of my laptop range from 1GHz to 1.83GHz. When I
disconnect my AC adapter the BIOS enforces an upper frequency limit of
1GHz for a 'settling' period of around 15 seconds. After these
15-or-so seconds have elapsed, the BIOS limit is lifted, and the cpu
frequency is restored to its previous setting - the original policy
without any CPUFREQ_ADJUST/CPUFREQ_INCOMPATIBLE notification
adjustments.

Example:
    1GHz-1.83GHz-performance ->
    (disconnect AC Adapter) 1GHz-1GHz-performance ->
    (approx. 15 seconds later) 1GHz-1.83GHz-performance

There are two problems with how CPUFreq handles the BIOS limit:

[2.1]

Unable to restore the previous limits if (previous_limit->min >
bios_limit->max). When this occurs my laptop is effectively
permanently stuck in the lowest operating frequency even though the
BIOS limit has been lifted.

The problem is at: cpufreq.c:__cpufreq_set_policy:1674
	if (policy->min > data->max || policy->max < data->min) {
		ret = -EINVAL;
		goto error_out;
	}

Debugging excerpt from the CPUFreq module:
Also available as attachment "dmesg.filter.test.bug.reset.txt".
# description:
#   governor:   performance
#   limits:     1.83GHz - 1.83GHz
#   test:       remove AC, triggering BIOS limit
#               wait till BIOS limit lifted
#   result:     fail to reset correct limits

[ 1817.701944] starting test
[ 1824.463248] cpufreq:cpufreq_update_policy:1770: updating policy for CPU 0
[ 1824.463258] cpufreq:__cpufreq_set_policy:1669: setting new policy
for CPU 0: 1830000 - 1830000 kHz
[ 1824.463265] cpufreq:__cpufreq_set_policy:1706: new min and max
freqs are 1000000 - 1000000 kHz
[ 1824.463279] cpufreq:__cpufreq_set_policy:1739: governor: change or
update limits
[ 1824.463282] cpufreq:__cpufreq_governor:1562: __cpufreq_governor for
CPU 0, event 3
[ 1824.463286] cpufreq:__cpufreq_driver_target:1476: target for CPU 0:
1000000 kHz, relation 1
[ 1824.463291] cpufreq:cpufreq_notify_transition:267: notification 0
of frequency transition to 1000000 kHz
[ 1824.463295] cpufreq:cpufreq_notify_transition:267: notification 1
of frequency transition to 1000000 kHz
[ 1824.463310] cpufreq:cpufreq_notify_transition:294: FREQ: 1000000 - CPU: 0
[ 1824.463544] cpufreq:cpufreq_update_policy:1770: updating policy for CPU 1
[ 1824.463552] cpufreq:__cpufreq_set_policy:1669: setting new policy
for CPU 1: 1830000 - 1830000 kHz
[ 1824.463567] cpufreq:__cpufreq_set_policy:1706: new min and max
freqs are 1000000 - 1000000 kHz
[ 1824.463570] cpufreq:__cpufreq_set_policy:1739: governor: change or
update limits
[ 1824.463573] cpufreq:__cpufreq_governor:1562: __cpufreq_governor for
CPU 1, event 3
[ 1824.463576] cpufreq:__cpufreq_driver_target:1476: target for CPU 1:
1000000 kHz, relation 1
[ 1824.463580] cpufreq:cpufreq_notify_transition:267: notification 0
of frequency transition to 1000000 kHz
[ 1824.463609] cpufreq:cpufreq_notify_transition:267: notification 1
of frequency transition to 1000000 kHz
[ 1824.463614] cpufreq:cpufreq_notify_transition:294: FREQ: 1000000 - CPU: 1
[ 1826.285314] cpufreq:cpufreq_update_policy:1770: updating policy for CPU 0
[ 1826.285328] cpufreq:__cpufreq_set_policy:1669: setting new policy
for CPU 0: 1830000 - 1830000 kHz
[ 1826.285551] cpufreq:cpufreq_update_policy:1770: updating policy for CPU 1
[ 1826.285564] cpufreq:__cpufreq_set_policy:1669: setting new policy
for CPU 1: 1830000 - 1830000 kHz
[ 1835.187612] ending   test

[2.2]

Race condition between kernel and userspace code when BIOS limit is
lifted. If a single event triggers both an ACPI event and a change in
the BIOS limit, both the kernel (cpufreq:cpufreq_update_policy) and
userspace code (any CPUFreq daemon listening to ACPI events) will
adjust the cpu frequency policy.

For example I run the cpu frequency scaling daemon cpufreqd which
responds to ACPI events. In the following sequence of events:
    1GHz-1.83GHz-performance ->
    (disconnect AC Adapter) 1GHz-1GHz-performance (BIOS limit) ->
    (reconnect AC Adapter before BIOS limit lifted)
reconnecting the AC adapter lifts the BIOS limit and triggers an ACPI
event. The daemon cpufreqd reacts almost instantaneously and sets a
new policy. The kernel, most likely due to calling
blocking_notifier_call_chain three times with CPUFREQ_ADJUST,
CPUFREQ_INCOMPATIBLE, and CPUFREQ_NOTIFY, responds much more slowly
and overrides the new policy cpufreqd set. Cpufreqd is unaware of this
change and thus the wrong policy has been set.

Some possible solutions:
    * write lock on the cpu policy
    * kernel->userspace notifier


[3.] Keywords (i.e., modules, networking, kernel):
[4.] Kernel information
[4.1.] Kernel version (from /proc/version):
[4.2.] Kernel .config file:
[5.] Most recent kernel version which did not have the bug:
[6.] Output of Oops.. message (if applicable) with symbolic information
     resolved (see Documentation/oops-tracing.txt)
[7.] A small shell script or example program which triggers the
     problem (if possible)
[8.] Environment
[8.1.] Software (add the output of the ver_linux script here)


Linux 3.6.2-1-ARCH #1 SMP PREEMPT Mon Oct 15 02:54:09 EDT 2012 i686 GNU/Linux

Gnu C                  4.7.2
Gnu make               3.82
binutils               2.22.0.20120323
util-linux             2.22
mount                  debug
module-init-tools      10
e2fsprogs              1.42.5
jfsutils               1.1.15
reiserfsprogs          3.6.21
xfsprogs               3.1.8
pcmciautils            018
quota-tools            4.01.
PPP                    2.4.5
Linux C Library        2.16
Dynamic linker (ldd)   2.16
Linux C++ Library      6.0.17
Procps                 3.3.3
Net-tools              1.60
Kbd                    1.15.3
oprofile               0.9.7
Sh-utils               8.19
wireless-tools         29
Modules Loaded         fuse act_police cls_basic cls_flow cls_fw
cls_u32 sch_tbf sch_prio sch_htb sch_hfsc sch_ingress sch_sfq
ipt_rpfilter ip6t_rpfilter xt_statistic xt_CT xt_LOG xt_connlimit
xt_realm xt_addrtype xt_comment ipt_ULOG ipt_REJECT ipt_REDIRECT
ipt_NETMAP aes_i586 xt_recent ipt_MASQUERADE ipt_ECN ipt_CLUSTERIP
ipt_ah ablk_helper cryptd aes_generic nf_nat_tftp nf_nat_snmp_basic
nf_conntrack_snmp nf_nat_sip nf_nat_pptp nf_nat_proto_gre nf_nat_irc
nf_nat_h323 nf_nat_ftp xt_set ip_set nf_nat_amanda nf_conntrack_sane
nf_conntrack_tftp nf_conntrack_sip nf_conntrack_proto_udplite
nf_conntrack_proto_sctp ts_kmp nf_conntrack_pptp
nf_conntrack_proto_gre nf_conntrack_amanda nf_conntrack_netlink
nf_conntrack_netbios_ns nf_conntrack_broadcast nf_conntrack_irc
nf_conntrack_h323 nf_conntrack_ftp xt_time xt_TCPMSS xt_sctp xt_TPROXY
nf_tproxy_core xt_tcpmss xt_policy xt_pkttype xt_physdev xt_NFLOG
xt_owner nfnetlink_log xt_NFQUEUE xt_multiport xt_mark xt_mac xt_limit
xt_length xt_iprange xt_helper xt_hashlimit xt_DSCP xt_dscp xt_dccp
xt_connmark xt_CLASSIFY xt_AUDIT ip6t_REJECT xt_tcpudp xt_state
iptable_raw nf_conntrack_ipv6 nf_defrag_ipv6 iptable_nat nf_nat
xt_conntrack nf_conntrack_ipv4 nf_defrag_ipv4 ip6table_raw
nf_conntrack ip6table_mangle iptable_mangle nfnetlink ip6table_filter
iptable_filter ip6_tables ip_tables x_tables ext4 jbd2 mbcache arc4
snd_usb_audio snd_usbmidi_lib snd_rawmidi iwl3945 iTCO_wdt
snd_seq_device iTCO_vendor_support iwlegacy btusb nvidia gpio_ich
joydev serio_raw b44 bluetooth acpi_cpufreq mac80211 microcode
kvm_intel kvm mperf crc16 dell_wmi sparse_keymap ssb pcmcia mii
snd_hda_codec_idt coretemp evdev lpc_ich pcmcia_core sr_mod cdrom
firewire_ohci firewire_core crc_itu_t dell_laptop dcdbas cfg80211
rfkill psmouse r852 sm_common nand snd_hda_intel nand_ecc
snd_hda_codec nand_ids intel_agp snd_pcm intel_gtt agpgart mtd
snd_page_alloc snd_hwdep sdhci_pci sdhci mmc_core snd_timer snd
soundcore r592 memstick i2c_i801 i2c_core wmi button ac thermal
processor video battery nfs lockd sunrpc fscache i8k hid_generic
usbhid hid xfs sd_mod ata_piix uhci_hcd libata scsi_mod ehci_hcd
usbcore usb_common


[8.2.] Processor information (from /proc/cpuinfo):

Intel(R) CPU T2400 @ 1.83GHz


[8.3.] Module information (from /proc/modules):
[8.4.] Loaded driver and hardware information (/proc/ioports, /proc/iomem)
[8.5.] PCI information ('lspci -vvv' as root)
[8.6.] SCSI information (from /proc/scsi/scsi)
[8.7.] Other information that might be relevant to the problem
       (please look in /proc and include all information that you
       think to be relevant):

    laptop model: DELL E1705/9400


[X.] Other notes, patches, fixes, workarounds:

--20cf3074d89e63eed004cc2da084
Content-Type: text/plain; charset=US-ASCII; name="dmesg.filter.test.bug.reset.txt"
Content-Disposition: attachment; filename="dmesg.filter.test.bug.reset.txt"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_h8cghj0v0

IyBkZXNjcmlwdGlvbjoKIyAgIGdvdmVybm9yOiAgIHBlcmZvcm1hbmNlCiMgICBsaW1pdHM6ICAg
ICAxLjgzR0h6IC0gMS44M0dIegojICAgdGVzdDogICAgICAgcmVtb3ZlIEFDLCB0cmlnZ2VyaW5n
IEJJT1MgbGltaXQKIyAgICAgICAgICAgICAgIHdhaXQgdGlsbCBCSU9TIGxpbWl0IGxpZnRlZAoj
ICAgcmVzdWx0OiAgICAgZmFpbCB0byByZXNldCBjb3JyZWN0IGxpbWl0cwoKWyAxODE3LjcwMTk0
NF0gc3RhcnRpbmcgdGVzdApbIDE4MjQuNDYzMjQ4XSBjcHVmcmVxOmNwdWZyZXFfdXBkYXRlX3Bv
bGljeToxNzcwOiB1cGRhdGluZyBwb2xpY3kgZm9yIENQVSAwClsgMTgyNC40NjMyNThdIGNwdWZy
ZXE6X19jcHVmcmVxX3NldF9wb2xpY3k6MTY2OTogc2V0dGluZyBuZXcgcG9saWN5IGZvciBDUFUg
MDogMTgzMDAwMCAtIDE4MzAwMDAga0h6ClsgMTgyNC40NjMyNjVdIGNwdWZyZXE6X19jcHVmcmVx
X3NldF9wb2xpY3k6MTcwNjogbmV3IG1pbiBhbmQgbWF4IGZyZXFzIGFyZSAxMDAwMDAwIC0gMTAw
MDAwMCBrSHoKWyAxODI0LjQ2MzI3OV0gY3B1ZnJlcTpfX2NwdWZyZXFfc2V0X3BvbGljeToxNzM5
OiBnb3Zlcm5vcjogY2hhbmdlIG9yIHVwZGF0ZSBsaW1pdHMKWyAxODI0LjQ2MzI4Ml0gY3B1ZnJl
cTpfX2NwdWZyZXFfZ292ZXJub3I6MTU2MjogX19jcHVmcmVxX2dvdmVybm9yIGZvciBDUFUgMCwg
ZXZlbnQgMwpbIDE4MjQuNDYzMjg2XSBjcHVmcmVxOl9fY3B1ZnJlcV9kcml2ZXJfdGFyZ2V0OjE0
NzY6IHRhcmdldCBmb3IgQ1BVIDA6IDEwMDAwMDAga0h6LCByZWxhdGlvbiAxClsgMTgyNC40NjMy
OTFdIGNwdWZyZXE6Y3B1ZnJlcV9ub3RpZnlfdHJhbnNpdGlvbjoyNjc6IG5vdGlmaWNhdGlvbiAw
IG9mIGZyZXF1ZW5jeSB0cmFuc2l0aW9uIHRvIDEwMDAwMDAga0h6ClsgMTgyNC40NjMyOTVdIGNw
dWZyZXE6Y3B1ZnJlcV9ub3RpZnlfdHJhbnNpdGlvbjoyNjc6IG5vdGlmaWNhdGlvbiAxIG9mIGZy
ZXF1ZW5jeSB0cmFuc2l0aW9uIHRvIDEwMDAwMDAga0h6ClsgMTgyNC40NjMzMTBdIGNwdWZyZXE6
Y3B1ZnJlcV9ub3RpZnlfdHJhbnNpdGlvbjoyOTQ6IEZSRVE6IDEwMDAwMDAgLSBDUFU6IDAKWyAx
ODI0LjQ2MzU0NF0gY3B1ZnJlcTpjcHVmcmVxX3VwZGF0ZV9wb2xpY3k6MTc3MDogdXBkYXRpbmcg
cG9saWN5IGZvciBDUFUgMQpbIDE4MjQuNDYzNTUyXSBjcHVmcmVxOl9fY3B1ZnJlcV9zZXRfcG9s
aWN5OjE2Njk6IHNldHRpbmcgbmV3IHBvbGljeSBmb3IgQ1BVIDE6IDE4MzAwMDAgLSAxODMwMDAw
IGtIegpbIDE4MjQuNDYzNTY3XSBjcHVmcmVxOl9fY3B1ZnJlcV9zZXRfcG9saWN5OjE3MDY6IG5l
dyBtaW4gYW5kIG1heCBmcmVxcyBhcmUgMTAwMDAwMCAtIDEwMDAwMDAga0h6ClsgMTgyNC40NjM1
NzBdIGNwdWZyZXE6X19jcHVmcmVxX3NldF9wb2xpY3k6MTczOTogZ292ZXJub3I6IGNoYW5nZSBv
ciB1cGRhdGUgbGltaXRzClsgMTgyNC40NjM1NzNdIGNwdWZyZXE6X19jcHVmcmVxX2dvdmVybm9y
OjE1NjI6IF9fY3B1ZnJlcV9nb3Zlcm5vciBmb3IgQ1BVIDEsIGV2ZW50IDMKWyAxODI0LjQ2MzU3
Nl0gY3B1ZnJlcTpfX2NwdWZyZXFfZHJpdmVyX3RhcmdldDoxNDc2OiB0YXJnZXQgZm9yIENQVSAx
OiAxMDAwMDAwIGtIeiwgcmVsYXRpb24gMQpbIDE4MjQuNDYzNTgwXSBjcHVmcmVxOmNwdWZyZXFf
bm90aWZ5X3RyYW5zaXRpb246MjY3OiBub3RpZmljYXRpb24gMCBvZiBmcmVxdWVuY3kgdHJhbnNp
dGlvbiB0byAxMDAwMDAwIGtIegpbIDE4MjQuNDYzNjA5XSBjcHVmcmVxOmNwdWZyZXFfbm90aWZ5
X3RyYW5zaXRpb246MjY3OiBub3RpZmljYXRpb24gMSBvZiBmcmVxdWVuY3kgdHJhbnNpdGlvbiB0
byAxMDAwMDAwIGtIegpbIDE4MjQuNDYzNjE0XSBjcHVmcmVxOmNwdWZyZXFfbm90aWZ5X3RyYW5z
aXRpb246Mjk0OiBGUkVROiAxMDAwMDAwIC0gQ1BVOiAxClsgMTgyNi4yODUzMTRdIGNwdWZyZXE6
Y3B1ZnJlcV91cGRhdGVfcG9saWN5OjE3NzA6IHVwZGF0aW5nIHBvbGljeSBmb3IgQ1BVIDAKWyAx
ODI2LjI4NTMyOF0gY3B1ZnJlcTpfX2NwdWZyZXFfc2V0X3BvbGljeToxNjY5OiBzZXR0aW5nIG5l
dyBwb2xpY3kgZm9yIENQVSAwOiAxODMwMDAwIC0gMTgzMDAwMCBrSHoKWyAxODI2LjI4NTU1MV0g
Y3B1ZnJlcTpjcHVmcmVxX3VwZGF0ZV9wb2xpY3k6MTc3MDogdXBkYXRpbmcgcG9saWN5IGZvciBD
UFUgMQpbIDE4MjYuMjg1NTY0XSBjcHVmcmVxOl9fY3B1ZnJlcV9zZXRfcG9saWN5OjE2Njk6IHNl
dHRpbmcgbmV3IHBvbGljeSBmb3IgQ1BVIDE6IDE4MzAwMDAgLSAxODMwMDAwIGtIegpbIDE4MzUu
MTg3NjEyXSBlbmRpbmcgICB0ZXN0Cg==
--20cf3074d89e63eed004cc2da084--
