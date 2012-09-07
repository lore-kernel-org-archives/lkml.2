Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933189Ab2IGMHK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 08:07:10 -0400
Received: from mga09.intel.com ([134.134.136.24]:13434 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760365Ab2IGMHH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 08:07:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,385,1344236400"; 
   d="scan'208,223";a="190246903"
From: "Liu, Jinsong" <jinsong.liu@intel.com>
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, kvm <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] KVM: tsc deadline timer works only when hrtimer high
 resolution configured
Thread-Topic: [PATCH] KVM: tsc deadline timer works only when hrtimer high
 resolution configured
Thread-Index: AQHNjDezEaLQ0dDCRmG5O7fBmMDyI5d+yBIw
Date: Fri, 7 Sep 2012 12:07:02 +0000
Message-ID: <DE8DF0795D48FD4CA783C40EC8292335322311@SHSMSX101.ccr.corp.intel.com>
References: <DE8DF0795D48FD4CA783C40EC829233531F0E4@SHSMSX101.ccr.corp.intel.com>
 <5048AC08.5050100@redhat.com>
In-Reply-To: <5048AC08.5050100@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: multipart/mixed;
	boundary="_002_DE8DF0795D48FD4CA783C40EC8292335322311SHSMSX101ccrcorpi_"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--_002_DE8DF0795D48FD4CA783C40EC8292335322311SHSMSX101ccrcorpi_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Avi Kivity wrote:
>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>> index 148ed66..0e64997 100644
>> --- a/arch/x86/kvm/x86.c
>> +++ b/arch/x86/kvm/x86.c
>> @@ -2210,7 +2210,11 @@ int kvm_dev_ioctl_check_extension(long ext)=20
>>  		r =3D kvm_has_tsc_control; break;
>>  	case KVM_CAP_TSC_DEADLINE_TIMER:
>> +#ifdef CONFIG_HIGH_RES_TIMERS
>>  		r =3D boot_cpu_has(X86_FEATURE_TSC_DEADLINE_TIMER); +#else
>> +		r =3D 0;
>> +#endif
>>  		break;
>=20
> I prefer a patch making kvm for x86 depend on hrtimers.  kvm already
> provides a high resolution timer to the guest in the local apic,
> backing it with the jiffies event source will likely cause some
> guests to malfunction.

Yep, I did a draft test for kvm lapic timer, it also worked fail when CONFI=
G_HIGH_RES_TIMERS disabled.

Attached is the udpated patch.

Thanks,
Jinsong

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>From 64d0458ec50a7d6917adf1e9735ba6e6ae6024ad Mon Sep 17 00:00:00 2001
From: Liu, Jinsong <jinsong.liu@intel.com>
Date: Sat, 8 Sep 2012 03:32:31 +0800
Subject: [PATCH] KVM: select HIGH_RES_TIMERS when KVM enabled

This is for 2 reasons:
1. it's pointless for kvm lapic timer and tsc deadline timer
when kernel hrtimer not configured as high resolution, since
that would be not accurate based on wheel;
2. kvm lapic timer and tsc deadline timer based on hrtimer,
setting a leftmost node to rb tree and then do hrtimer reprogram.
If hrtimer not configured as high resolution, hrtimer_enqueue_reprogram
do nothing and then make kvm lapic timer and tsc deadline timer fail.

Signed-off-by: Liu, Jinsong <jinsong.liu@intel.com>
---
 arch/x86/kvm/Kconfig |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
index a28f338..5f861ca 100644
--- a/arch/x86/kvm/Kconfig
+++ b/arch/x86/kvm/Kconfig
@@ -24,6 +24,8 @@ config KVM
 	depends on PCI
 	# for TASKSTATS/TASK_DELAY_ACCT:
 	depends on NET
+	# for HIGH_RES_TIMERS
+	depends on !ARCH_USES_GETTIMEOFFSET
 	select PREEMPT_NOTIFIERS
 	select MMU_NOTIFIER
 	select ANON_INODES
@@ -37,6 +39,8 @@ config KVM
 	select TASK_DELAY_ACCT
 	select PERF_EVENTS
 	select HAVE_KVM_MSI
+	select GENERIC_CLOCKEVENTS
+	select HIGH_RES_TIMERS
 	---help---
 	  Support hosting fully virtualized guest machines using hardware
 	  virtualization extensions.  You will need a fairly recent
--=20
1.7.1

--_002_DE8DF0795D48FD4CA783C40EC8292335322311SHSMSX101ccrcorpi_
Content-Type: application/octet-stream;
	name="0001-KVM-select-HIGH_RES_TIMERS-when-KVM-enabled.patch"
Content-Description: 0001-KVM-select-HIGH_RES_TIMERS-when-KVM-enabled.patch
Content-Disposition: attachment;
	filename="0001-KVM-select-HIGH_RES_TIMERS-when-KVM-enabled.patch"; size=1488;
	creation-date="Fri, 07 Sep 2012 11:58:20 GMT";
	modification-date="Fri, 07 Sep 2012 19:50:06 GMT"
Content-Transfer-Encoding: base64

RnJvbSA2NGQwNDU4ZWM1MGE3ZDY5MTdhZGYxZTk3MzViYTZlNmFlNjAyNGFkIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBMaXUsIEppbnNvbmcgPGppbnNvbmcubGl1QGludGVsLmNvbT4K
RGF0ZTogU2F0LCA4IFNlcCAyMDEyIDAzOjMyOjMxICswODAwClN1YmplY3Q6IFtQQVRDSF0gS1ZN
OiBzZWxlY3QgSElHSF9SRVNfVElNRVJTIHdoZW4gS1ZNIGVuYWJsZWQKClRoaXMgaXMgZm9yIDIg
cmVhc29uczoKMS4gaXQncyBwb2ludGxlc3MgZm9yIGt2bSBsYXBpYyB0aW1lciBhbmQgdHNjIGRl
YWRsaW5lIHRpbWVyCndoZW4ga2VybmVsIGhydGltZXIgbm90IGNvbmZpZ3VyZWQgYXMgaGlnaCBy
ZXNvbHV0aW9uLCBzaW5jZQp0aGF0IHdvdWxkIGJlIG5vdCBhY2N1cmF0ZSBiYXNlZCBvbiB3aGVl
bDsKMi4ga3ZtIGxhcGljIHRpbWVyIGFuZCB0c2MgZGVhZGxpbmUgdGltZXIgYmFzZWQgb24gaHJ0
aW1lciwKc2V0dGluZyBhIGxlZnRtb3N0IG5vZGUgdG8gcmIgdHJlZSBhbmQgdGhlbiBkbyBocnRp
bWVyIHJlcHJvZ3JhbS4KSWYgaHJ0aW1lciBub3QgY29uZmlndXJlZCBhcyBoaWdoIHJlc29sdXRp
b24sIGhydGltZXJfZW5xdWV1ZV9yZXByb2dyYW0KZG8gbm90aGluZyBhbmQgdGhlbiBtYWtlIGt2
bSBsYXBpYyB0aW1lciBhbmQgdHNjIGRlYWRsaW5lIHRpbWVyIGZhaWwuCgpTaWduZWQtb2ZmLWJ5
OiBMaXUsIEppbnNvbmcgPGppbnNvbmcubGl1QGludGVsLmNvbT4KLS0tCiBhcmNoL3g4Ni9rdm0v
S2NvbmZpZyB8ICAgIDQgKysrKwogMSBmaWxlcyBjaGFuZ2VkLCA0IGluc2VydGlvbnMoKyksIDAg
ZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvYXJjaC94ODYva3ZtL0tjb25maWcgYi9hcmNoL3g4
Ni9rdm0vS2NvbmZpZwppbmRleCBhMjhmMzM4Li41Zjg2MWNhIDEwMDY0NAotLS0gYS9hcmNoL3g4
Ni9rdm0vS2NvbmZpZworKysgYi9hcmNoL3g4Ni9rdm0vS2NvbmZpZwpAQCAtMjQsNiArMjQsOCBA
QCBjb25maWcgS1ZNCiAJZGVwZW5kcyBvbiBQQ0kKIAkjIGZvciBUQVNLU1RBVFMvVEFTS19ERUxB
WV9BQ0NUOgogCWRlcGVuZHMgb24gTkVUCisJIyBmb3IgSElHSF9SRVNfVElNRVJTCisJZGVwZW5k
cyBvbiAhQVJDSF9VU0VTX0dFVFRJTUVPRkZTRVQKIAlzZWxlY3QgUFJFRU1QVF9OT1RJRklFUlMK
IAlzZWxlY3QgTU1VX05PVElGSUVSCiAJc2VsZWN0IEFOT05fSU5PREVTCkBAIC0zNyw2ICszOSw4
IEBAIGNvbmZpZyBLVk0KIAlzZWxlY3QgVEFTS19ERUxBWV9BQ0NUCiAJc2VsZWN0IFBFUkZfRVZF
TlRTCiAJc2VsZWN0IEhBVkVfS1ZNX01TSQorCXNlbGVjdCBHRU5FUklDX0NMT0NLRVZFTlRTCisJ
c2VsZWN0IEhJR0hfUkVTX1RJTUVSUwogCS0tLWhlbHAtLS0KIAkgIFN1cHBvcnQgaG9zdGluZyBm
dWxseSB2aXJ0dWFsaXplZCBndWVzdCBtYWNoaW5lcyB1c2luZyBoYXJkd2FyZQogCSAgdmlydHVh
bGl6YXRpb24gZXh0ZW5zaW9ucy4gIFlvdSB3aWxsIG5lZWQgYSBmYWlybHkgcmVjZW50Ci0tIAox
LjcuMQoK

--_002_DE8DF0795D48FD4CA783C40EC8292335322311SHSMSX101ccrcorpi_--
