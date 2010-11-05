Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754968Ab0KEWZc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Nov 2010 18:25:32 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46869 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752641Ab0KEWZa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Nov 2010 18:25:30 -0400
MIME-Version: 1.0
In-Reply-To: <20101103161837.fad11d79.randy.dunlap@oracle.com>
References: <AANLkTimr3rW67HxgOUyReEW8dmmSsd4b7-Ns57mXzS1w@mail.gmail.com> <20101103161837.fad11d79.randy.dunlap@oracle.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 5 Nov 2010 15:24:36 -0700
Message-ID: <AANLkTimnHFHJq13xpJ0ZgLmpd+cHmHH5sQ4HWtL_MrMT@mail.gmail.com>
Subject: Re: Linux 2.6.37-rc1 (libipw remove_proc_entry warning)
To: Randy Dunlap <randy.dunlap@oracle.com>, Pavel Roskin <proski@gnu.org>,
        "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: multipart/mixed; boundary=0003255747468cf32a049455beed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--0003255747468cf32a049455beed
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

This bug seems to be due to commit 27ae60f8f7aac ("ipw2x00: replace
"ieee80211" with "libipw" where appropriate"), where Pavel did this:

-       libipw_proc =3D proc_mkdir(DRV_NAME, init_net.proc_net);
+       libipw_proc =3D proc_mkdir("ieee80211", init_net.proc_net);

but then the cleanup was kept as

        remove_proc_entry(DRV_NAME, init_net.proc_net);

in both places (both in the failure case and in the unload case). The
error string is also total crap, and says

     "Unable to create " DRV_NAME " proc directory\n");

Even though it doesn't actually create a proc directory named DRV_NAME at a=
ll.

So that patch looks like total and utter crap to me. The commit message say=
s

  "Keep /proc/net/ieee80211 under the original name to avoid breaking user
    interface."

but the thing is, it really didn't fix anything but that one create
thing. It needs to fix all the other cases too.

Totally UNTESTED patch attached. It may or may not compile. And maybe
it doesn't catch all cases, but it should catch the obvious ones.

                           Linus

On Wed, Nov 3, 2010 at 4:18 PM, Randy Dunlap <randy.dunlap@oracle.com> wrot=
e:
>
> Nov =A03 16:03:11 control kernel: [ =A0 74.701367] =A0 =A0 (5170000[ =A0 =
74.846676] calling =A0libipw_init+0x0/0xe4 [libipw] @ 2992
> [ =A0 74.852356] libipw: 802.11 data/management/control stack, git-1.1.13
> [ =A0 74.858790] libipw: Copyright (C) 2004-2005 Intel Corporation <jketr=
eno@linux.intel.com>
> [ =A0 74.866977] initcall libipw_init+0x0/0xe4 [libipw] returned 0 after =
14318 usecs
> Nov =A03 16:03:11 control kernel: [ =A0 74.846676] calling =A0libipw_iNov=
 =A03 16:03:11 control kernel: [ =A0 74.852356] libipw: 802.11 data/managem=
ent/control stack, git-1.1.13
> Nov =A03 16:03:11 control kernel: [ =A0 74.858790] libipw: C
>
>
> [ =A0 78.273409] ------------[ cut here ]------------
> [ =A0 78.278210] WARNING: at /local/linsrc/lnx-2637-rc1/fs/proc/generic.c=
:816 remove_proc_entry+0x156/0x35e()
> Nov =A03 16:03:14 [ =A0 78.288314] Hardware name: OptiPlex GX620
> control kernel: [ =A0 78.294870] name 'libipw'
> [ =A0 78.298520] Modules linked in: libipw(-) lib80211 cfg80211 ipt_MASQU=
ERADE iptable_nat nf_nat af_packet nfsd lockd nfs_acl auth_rpcgss exportfs =
sco bridge stp llc bnep l2cap crc16 bluetoothNov =A03 16:03:14 =A0rfkillcon=
trol kernel: =A0sunrpc[ =A0 78.278210] W ipt_REJECTARNING: at /loca nf_conn=
track_ipv4l/linsrc/lnx-263 nf_defrag_ipv47-rc1/fs/proc/ge iptable_filterner=
ic.c:816 remo ip_tablesve_proc_entry+0x ip6t_REJECT156/0x35e()
> Nov =A0xt_tcpudp 3 16:03:14 cont nf_conntrack_ipv6rol kernel: [ =A0 =A0nf=
_defrag_ipv678.288314] Hardw xt_stateare name: OptiPl nf_conntrackex GX620 =
=A0 =A0 =A0 =A0 ip6table_filter
> Nov =A03 1 ip6_tables6:03:14 control =A0x_tableskernel: [ =A0 78.2 ipv694=
870] name 'lib p4_clockmodipw'
> =A0freq_table speedstep_lib binfmt_misc dm_mirror dm_region_hash dm_log d=
m_multipath scsi_dh dm_mod kvm uinput mousedev joydev snd_intel8x0 snd_ac97=
_codec ac97_bus ppdev snd_seq snd_seq_device usbmouse snd_pcm led_class usb=
kbd snd_timer usbhid iTCO_wdt hid snd iTCO_vendor_support tg3 sr_mod dcdbas=
 cdrom soundcore i2c_i801 rtc_cmos sg pcspkr rng_core parport_pc snd_page_a=
lloc rtc_core shpchp evdev rtc_lib parport 8250_pnp pci_hotplug mac_hid uni=
x ide_pci_generic ide_core ata_generic pata_acpi ata_piix sd_mod crc_t10dif=
 ext3 jbd mbcache uhci_hcd ohci_hcd ssb mmc_core pcmcia pcmcia_core firmwar=
e_class ehci_hcd usbcore nls_base i915 drm_kms_helper intel_agp button inte=
l_gtt video thermal_sys hwmon output [last unloaded: mperf]
> [ =A0 78.429364] Pid: 3067, comm: rmmod Not tainted 2.6.37-rc1 #10
> [ =A0 78.435209] Call Trace:
> [ =A0 78.437982] =A0[<ffffffff8107e1ed>] warn_slowpath_common+0xc6/0xf3
> [ =A0 78.444119] =A0[<ffffffff8107e30a>] warn_slowpath_fmt+0x5b/0x6b
> [ =A0 78.449973] =A0[<ffffffff81550dbb>] ? _raw_spin_unlock+0x40/0x4b
> [ =A0 78.456247] =A0[<ffffffff8123d37e>] remove_proc_entry+0x156/0x35e
> Nov =A03 16:03:14 [ =A0 78.462289] =A0[<ffffffff81017d29>] ? native_sched=
_clock+0x3b/0x6d
> control kernel: [ =A0 78.470047] =A0[<ffffffff810b067f>] ? sched_clock_cp=
u+0x147/0x160
> [ =A0 78.298520] M[ =A0 78.477041] =A0[<ffffffff81137479>] ? trace_hardir=
qs_off+0x10/0x4a
> odules linked in: libipw(-) lib80211 cfg80211 ip[ =A0 78.487138] =A0[<fff=
fffff810b0742>] ? local_clock+0xaa/0xf4
> t_MASQUERADE iptable_nat nf_nat [ =A0 78.496297] =A0[<ffffffff810c0ab9>] =
? lock_release_holdtime+0x41/0x177
> Nov =A03 16:03:14 [ =A0 78.505725] =A0[<ffffffff810c3a1b>] ? lock_release=
_nested+0xfb/0x133
> Nov =A03 16:03:14 [ =A0 78.514477] =A0[<ffffffffa0c39cad>] libipw_exit+0x=
49/0x5d [libipw]
> Nov =A03 16:03:14 [ =A0 78.523311] =A0[<ffffffff810d3310>] sys_delete_mod=
ule+0x2d6/0x368
> [ =A0 78.531755] =A0[<ffffffff8154f9cb>] ? lockdep_sys_exit_thunk+0x35/0x=
67
> Nov =A03 16:03:14 Nov =A03 16:03:14 [ =A0 78.540954] =A0[<ffffffff810fd60=
f>] ? audit_syscall_entry+0x172/0x1a5
> Nov =A03 16:03:14 [ =A0 78.550029] =A0[<ffffffff8154f955>] ? trace_hardir=
qs_on_thunk+0x3a/0x3f
> Nov =A03 16:03:14 [ =A0 78.559196] =A0[<ffffffff8100ea72>] system_call_fa=
stpath+0x16/0x1b
> Nov =A03 16:03:14 [ =A0 78.567700] ---[ end trace b9ae9f3ab8d89ea5 ]---
>
>
> ---
> ~Randy
> *** Remember to use Documentation/SubmitChecklist when testing your code =
***
>

--0003255747468cf32a049455beed
Content-Type: text/x-patch; charset=US-ASCII; name="patch.diff"
Content-Disposition: attachment; filename="patch.diff"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gg5mteeg0

IGRyaXZlcnMvbmV0L3dpcmVsZXNzL2lwdzJ4MDAvbGliaXB3X21vZHVsZS5jIHwgICAgOSArKysr
Ky0tLS0KIDEgZmlsZXMgY2hhbmdlZCwgNSBpbnNlcnRpb25zKCspLCA0IGRlbGV0aW9ucygtKQoK
ZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L3dpcmVsZXNzL2lwdzJ4MDAvbGliaXB3X21vZHVsZS5j
IGIvZHJpdmVycy9uZXQvd2lyZWxlc3MvaXB3MngwMC9saWJpcHdfbW9kdWxlLmMKaW5kZXggMzJk
ZWUyYy4uZDVlZjY5NiAxMDA2NDQKLS0tIGEvZHJpdmVycy9uZXQvd2lyZWxlc3MvaXB3MngwMC9s
aWJpcHdfbW9kdWxlLmMKKysrIGIvZHJpdmVycy9uZXQvd2lyZWxlc3MvaXB3MngwMC9saWJpcHdf
bW9kdWxlLmMKQEAgLTU0LDYgKzU0LDcgQEAKIAogI2RlZmluZSBEUlZfREVTQ1JJUFRJT04gIjgw
Mi4xMSBkYXRhL21hbmFnZW1lbnQvY29udHJvbCBzdGFjayIKICNkZWZpbmUgRFJWX05BTUUgICAg
ICAgICJsaWJpcHciCisjZGVmaW5lIERSVl9QUk9DTkFNRQkiaWVlZTgwMjExIgogI2RlZmluZSBE
UlZfVkVSU0lPTglMSUJJUFdfVkVSU0lPTgogI2RlZmluZSBEUlZfQ09QWVJJR0hUICAgIkNvcHly
aWdodCAoQykgMjAwNC0yMDA1IEludGVsIENvcnBvcmF0aW9uIDxqa2V0cmVub0BsaW51eC5pbnRl
bC5jb20+IgogCkBAIC0yOTMsMTYgKzI5NCwxNiBAQCBzdGF0aWMgaW50IF9faW5pdCBsaWJpcHdf
aW5pdCh2b2lkKQogCXN0cnVjdCBwcm9jX2Rpcl9lbnRyeSAqZTsKIAogCWxpYmlwd19kZWJ1Z19s
ZXZlbCA9IGRlYnVnOwotCWxpYmlwd19wcm9jID0gcHJvY19ta2RpcigiaWVlZTgwMjExIiwgaW5p
dF9uZXQucHJvY19uZXQpOworCWxpYmlwd19wcm9jID0gcHJvY19ta2RpcihEUlZfUFJPQ05BTUUs
IGluaXRfbmV0LnByb2NfbmV0KTsKIAlpZiAobGliaXB3X3Byb2MgPT0gTlVMTCkgewotCQlMSUJJ
UFdfRVJST1IoIlVuYWJsZSB0byBjcmVhdGUgIiBEUlZfTkFNRQorCQlMSUJJUFdfRVJST1IoIlVu
YWJsZSB0byBjcmVhdGUgIiBEUlZfUFJPQ05BTUUKIAkJCQkiIHByb2MgZGlyZWN0b3J5XG4iKTsK
IAkJcmV0dXJuIC1FSU87CiAJfQogCWUgPSBwcm9jX2NyZWF0ZSgiZGVidWdfbGV2ZWwiLCBTX0lS
VUdPIHwgU19JV1VTUiwgbGliaXB3X3Byb2MsCiAJCQkmZGVidWdfbGV2ZWxfcHJvY19mb3BzKTsK
IAlpZiAoIWUpIHsKLQkJcmVtb3ZlX3Byb2NfZW50cnkoRFJWX05BTUUsIGluaXRfbmV0LnByb2Nf
bmV0KTsKKwkJcmVtb3ZlX3Byb2NfZW50cnkoRFJWX1BST0NOQU1FLCBpbml0X25ldC5wcm9jX25l
dCk7CiAJCWxpYmlwd19wcm9jID0gTlVMTDsKIAkJcmV0dXJuIC1FSU87CiAJfQpAQCAtMzE5LDcg
KzMyMCw3IEBAIHN0YXRpYyB2b2lkIF9fZXhpdCBsaWJpcHdfZXhpdCh2b2lkKQogI2lmZGVmIENP
TkZJR19MSUJJUFdfREVCVUcKIAlpZiAobGliaXB3X3Byb2MpIHsKIAkJcmVtb3ZlX3Byb2NfZW50
cnkoImRlYnVnX2xldmVsIiwgbGliaXB3X3Byb2MpOwotCQlyZW1vdmVfcHJvY19lbnRyeShEUlZf
TkFNRSwgaW5pdF9uZXQucHJvY19uZXQpOworCQlyZW1vdmVfcHJvY19lbnRyeShEUlZfUFJPQ05B
TUUsIGluaXRfbmV0LnByb2NfbmV0KTsKIAkJbGliaXB3X3Byb2MgPSBOVUxMOwogCX0KICNlbmRp
ZgkJCQkvKiBDT05GSUdfTElCSVBXX0RFQlVHICovCg==
--0003255747468cf32a049455beed--
