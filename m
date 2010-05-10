Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756150Ab0EJSMK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 14:12:10 -0400
Received: from mail3.microsoft.com ([131.107.115.214]:22403 "EHLO
	smtp.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755280Ab0EJSMH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 14:12:07 -0400
From: Haiyang Zhang <haiyangz@microsoft.com>
To: "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
       "'devel@driverdev.osuosl.org'" <devel@driverdev.osuosl.org>,
       "'virtualization@lists.osdl.org'" <virtualization@lists.osdl.org>,
       "'gregkh@suse.de'" <gregkh@suse.de>
CC: Hank Janssen <hjanssen@microsoft.com>
Subject: [PATCH 1/1] staging: hv: Optimize adj_guesttime function and add
 more detailed comments
Thread-Topic: [PATCH 1/1] staging: hv: Optimize adj_guesttime function and
 add more detailed comments
Thread-Index: AQHK8GxLqokTG3dHi0SQCMmChJ3HSw==
Date: Mon, 10 May 2010 18:12:02 +0000
Message-ID: <1FB5E1D5CA062146B38059374562DF72662AA29C@TK5EX14MBXC130.redmond.corp.microsoft.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
Content-Type: multipart/mixed;
	boundary="_002_1FB5E1D5CA062146B38059374562DF72662AA29CTK5EX14MBXC130r_"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--_002_1FB5E1D5CA062146B38059374562DF72662AA29CTK5EX14MBXC130r_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

From: Haiyang Zhang <haiyangz@microsoft.com>

Subject: Optimize adj_guesttime function and add more detailed comments
Credits go to Joe Perches [joe@perches.com] for suggesting the changes.

Cc: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>

---
 drivers/staging/hv/hv_utils.c |   33 +++++++++++++++++++++++++--------
 1 files changed, 25 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/hv/hv_utils.c b/drivers/staging/hv/hv_utils.c
index 8f1d3ba..c0f57a1 100644
--- a/drivers/staging/hv/hv_utils.c
+++ b/drivers/staging/hv/hv_utils.c
@@ -106,28 +106,45 @@ static void shutdown_onchannelcallback(void *context)
 		orderly_poweroff(false);
 }
=20
-
 /*
- * Synchronize time with host after reboot, restore, etc.
+ * Set guest time to host UTC time.
  */
-static void adj_guesttime(u64 hosttime, u8 flags)
+static inline void do_adj_guesttime(u64 hosttime)
 {
 	s64 host_tns;
 	struct timespec host_ts;
-	static s32 scnt =3D 50;
=20
 	host_tns =3D (hosttime - WLTIMEDELTA) * 100;
 	host_ts =3D ns_to_timespec(host_tns);
=20
+	do_settimeofday(&host_ts);
+
+	return;
+}
+
+/*
+ * Synchronize time with host after reboot, restore, etc.
+ *
+ * ICTIMESYNCFLAG_SYNC flag bit indicates reboot, restore events of the VM=
.
+ * After reboot the flag ICTIMESYNCFLAG_SYNC is included in the first time
+ * message after the timesync channel is opened. Since the hv_utils module=
 is
+ * loaded after hv_vmbus, the first message is usually missed. The other
+ * thing is, systime is automatically set to emulated hardware clock which=
 may
+ * not be UTC time or in the same time zone. So, to override these effects=
, we
+ * use the first 50 time samples for initial system time setting.
+ */
+static inline void adj_guesttime(u64 hosttime, u8 flags)
+{
+	static s32 scnt =3D 50;
+
 	if ((flags & ICTIMESYNCFLAG_SYNC) !=3D 0) {
-		do_settimeofday(&host_ts);
+		do_adj_guesttime(hosttime);
 		return;
 	}
=20
-	if ((flags & ICTIMESYNCFLAG_SAMPLE) !=3D 0 &&
-	    scnt > 0) {
+	if ((flags & ICTIMESYNCFLAG_SAMPLE) !=3D 0 && scnt > 0) {
 		scnt--;
-		do_settimeofday(&host_ts);
+		do_adj_guesttime(hosttime);
 	}
=20
 	return;
--=20
1.6.3.2


--_002_1FB5E1D5CA062146B38059374562DF72662AA29CTK5EX14MBXC130r_
Content-Type: application/octet-stream; name="0507-timesync-optimize.patch"
Content-Description: 0507-timesync-optimize.patch
Content-Disposition: attachment; filename="0507-timesync-optimize.patch";
	size=2202; creation-date="Fri, 07 May 2010 17:23:54 GMT";
	modification-date="Fri, 07 May 2010 18:21:58 GMT"
Content-Transfer-Encoding: base64

RnJvbTogSGFpeWFuZyBaaGFuZyA8aGFpeWFuZ3pAbWljcm9zb2Z0LmNvbT4KClN1YmplY3Q6IE9w
dGltaXplIGFkal9ndWVzdHRpbWUgZnVuY3Rpb24gYW5kIGFkZCBtb3JlIGRldGFpbGVkIGNvbW1l
bnRzCkNyZWRpdHMgZ28gdG8gSm9lIFBlcmNoZXMgW2pvZUBwZXJjaGVzLmNvbV0gZm9yIHN1Z2dl
c3RpbmcgdGhlIGNoYW5nZXMuCgpDYzogR3JlZyBLcm9haC1IYXJ0bWFuIDxncmVna2hAc3VzZS5k
ZT4KU2lnbmVkLW9mZi1ieTogSGFuayBKYW5zc2VuIDxoamFuc3NlbkBtaWNyb3NvZnQuY29tPgpT
aWduZWQtb2ZmLWJ5OiBIYWl5YW5nIFpoYW5nIDxoYWl5YW5nekBtaWNyb3NvZnQuY29tPgoKLS0t
CiBkcml2ZXJzL3N0YWdpbmcvaHYvaHZfdXRpbHMuYyB8ICAgMzMgKysrKysrKysrKysrKysrKysr
KysrKysrKy0tLS0tLS0tCiAxIGZpbGVzIGNoYW5nZWQsIDI1IGluc2VydGlvbnMoKyksIDggZGVs
ZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvZHJpdmVycy9zdGFnaW5nL2h2L2h2X3V0aWxzLmMgYi9k
cml2ZXJzL3N0YWdpbmcvaHYvaHZfdXRpbHMuYwppbmRleCA4ZjFkM2JhLi5jMGY1N2ExIDEwMDY0
NAotLS0gYS9kcml2ZXJzL3N0YWdpbmcvaHYvaHZfdXRpbHMuYworKysgYi9kcml2ZXJzL3N0YWdp
bmcvaHYvaHZfdXRpbHMuYwpAQCAtMTA2LDI4ICsxMDYsNDUgQEAgc3RhdGljIHZvaWQgc2h1dGRv
d25fb25jaGFubmVsY2FsbGJhY2sodm9pZCAqY29udGV4dCkKIAkJb3JkZXJseV9wb3dlcm9mZihm
YWxzZSk7CiB9CiAKLQogLyoKLSAqIFN5bmNocm9uaXplIHRpbWUgd2l0aCBob3N0IGFmdGVyIHJl
Ym9vdCwgcmVzdG9yZSwgZXRjLgorICogU2V0IGd1ZXN0IHRpbWUgdG8gaG9zdCBVVEMgdGltZS4K
ICAqLwotc3RhdGljIHZvaWQgYWRqX2d1ZXN0dGltZSh1NjQgaG9zdHRpbWUsIHU4IGZsYWdzKQor
c3RhdGljIGlubGluZSB2b2lkIGRvX2Fkal9ndWVzdHRpbWUodTY0IGhvc3R0aW1lKQogewogCXM2
NCBob3N0X3RuczsKIAlzdHJ1Y3QgdGltZXNwZWMgaG9zdF90czsKLQlzdGF0aWMgczMyIHNjbnQg
PSA1MDsKIAogCWhvc3RfdG5zID0gKGhvc3R0aW1lIC0gV0xUSU1FREVMVEEpICogMTAwOwogCWhv
c3RfdHMgPSBuc190b190aW1lc3BlYyhob3N0X3Rucyk7CiAKKwlkb19zZXR0aW1lb2ZkYXkoJmhv
c3RfdHMpOworCisJcmV0dXJuOworfQorCisvKgorICogU3luY2hyb25pemUgdGltZSB3aXRoIGhv
c3QgYWZ0ZXIgcmVib290LCByZXN0b3JlLCBldGMuCisgKgorICogSUNUSU1FU1lOQ0ZMQUdfU1lO
QyBmbGFnIGJpdCBpbmRpY2F0ZXMgcmVib290LCByZXN0b3JlIGV2ZW50cyBvZiB0aGUgVk0uCisg
KiBBZnRlciByZWJvb3QgdGhlIGZsYWcgSUNUSU1FU1lOQ0ZMQUdfU1lOQyBpcyBpbmNsdWRlZCBp
biB0aGUgZmlyc3QgdGltZQorICogbWVzc2FnZSBhZnRlciB0aGUgdGltZXN5bmMgY2hhbm5lbCBp
cyBvcGVuZWQuIFNpbmNlIHRoZSBodl91dGlscyBtb2R1bGUgaXMKKyAqIGxvYWRlZCBhZnRlciBo
dl92bWJ1cywgdGhlIGZpcnN0IG1lc3NhZ2UgaXMgdXN1YWxseSBtaXNzZWQuIFRoZSBvdGhlcgor
ICogdGhpbmcgaXMsIHN5c3RpbWUgaXMgYXV0b21hdGljYWxseSBzZXQgdG8gZW11bGF0ZWQgaGFy
ZHdhcmUgY2xvY2sgd2hpY2ggbWF5CisgKiBub3QgYmUgVVRDIHRpbWUgb3IgaW4gdGhlIHNhbWUg
dGltZSB6b25lLiBTbywgdG8gb3ZlcnJpZGUgdGhlc2UgZWZmZWN0cywgd2UKKyAqIHVzZSB0aGUg
Zmlyc3QgNTAgdGltZSBzYW1wbGVzIGZvciBpbml0aWFsIHN5c3RlbSB0aW1lIHNldHRpbmcuCisg
Ki8KK3N0YXRpYyBpbmxpbmUgdm9pZCBhZGpfZ3Vlc3R0aW1lKHU2NCBob3N0dGltZSwgdTggZmxh
Z3MpCit7CisJc3RhdGljIHMzMiBzY250ID0gNTA7CisKIAlpZiAoKGZsYWdzICYgSUNUSU1FU1lO
Q0ZMQUdfU1lOQykgIT0gMCkgewotCQlkb19zZXR0aW1lb2ZkYXkoJmhvc3RfdHMpOworCQlkb19h
ZGpfZ3Vlc3R0aW1lKGhvc3R0aW1lKTsKIAkJcmV0dXJuOwogCX0KIAotCWlmICgoZmxhZ3MgJiBJ
Q1RJTUVTWU5DRkxBR19TQU1QTEUpICE9IDAgJiYKLQkgICAgc2NudCA+IDApIHsKKwlpZiAoKGZs
YWdzICYgSUNUSU1FU1lOQ0ZMQUdfU0FNUExFKSAhPSAwICYmIHNjbnQgPiAwKSB7CiAJCXNjbnQt
LTsKLQkJZG9fc2V0dGltZW9mZGF5KCZob3N0X3RzKTsKKwkJZG9fYWRqX2d1ZXN0dGltZShob3N0
dGltZSk7CiAJfQogCiAJcmV0dXJuOwotLSAKMS42LjMuMgoK

--_002_1FB5E1D5CA062146B38059374562DF72662AA29CTK5EX14MBXC130r_--
