Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756177Ab0EKPMU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 11:12:20 -0400
Received: from smtp.microsoft.com ([131.107.115.214]:9259 "EHLO
	smtp.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755128Ab0EKPMR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 11:12:17 -0400
From: Haiyang Zhang <haiyangz@microsoft.com>
To: "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
       "'devel@driverdev.osuosl.org'" <devel@driverdev.osuosl.org>,
       "'virtualization@lists.osdl.org'" <virtualization@lists.osdl.org>,
       "'gregkh@suse.de'" <gregkh@suse.de>
CC: Hank Janssen <hjanssen@microsoft.com>
Subject: [PATCH 1/1] staging: hv: Optimize adj_guesttime function and add
 more detailed comments (Resubmit with some cleanups)
Thread-Topic: [PATCH 1/1] staging: hv: Optimize adj_guesttime function and
 add more detailed comments (Resubmit with some cleanups)
Thread-Index: AcrxHDjiOxDc16OyTJa8qQNdodg7Rw==
Date: Tue, 11 May 2010 15:11:24 +0000
Message-ID: <1FB5E1D5CA062146B38059374562DF72662AA645@TK5EX14MBXC130.redmond.corp.microsoft.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
Content-Type: multipart/mixed;
	boundary="_002_1FB5E1D5CA062146B38059374562DF72662AA645TK5EX14MBXC130r_"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--_002_1FB5E1D5CA062146B38059374562DF72662AA645TK5EX14MBXC130r_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

From: Haiyang Zhang <haiyangz@microsoft.com>

Subject: Optimize adj_guesttime function and add more detailed comments
Credits go to Joe Perches [joe@perches.com] for suggesting the changes.

Cc: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>

---
 drivers/staging/hv/hv_utils.c |   33 +++++++++++++++++++++++----------
 1 files changed, 23 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/hv/hv_utils.c b/drivers/staging/hv/hv_utils.c
index 8f1d3ba..db45d97 100644
--- a/drivers/staging/hv/hv_utils.c
+++ b/drivers/staging/hv/hv_utils.c
@@ -106,31 +106,44 @@ static void shutdown_onchannelcallback(void *context)
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
-
-	return;
 }
=20
 /*
--=20
1.6.3.2


--_002_1FB5E1D5CA062146B38059374562DF72662AA645TK5EX14MBXC130r_
Content-Type: application/octet-stream; name="0511-timesync-optimize.patch"
Content-Description: 0511-timesync-optimize.patch
Content-Disposition: attachment; filename="0511-timesync-optimize.patch";
	size=2200; creation-date="Tue, 11 May 2010 15:08:15 GMT";
	modification-date="Tue, 11 May 2010 16:03:34 GMT"
Content-Transfer-Encoding: base64

RnJvbTogSGFpeWFuZyBaaGFuZyA8aGFpeWFuZ3pAbWljcm9zb2Z0LmNvbT4KClN1YmplY3Q6IE9w
dGltaXplIGFkal9ndWVzdHRpbWUgZnVuY3Rpb24gYW5kIGFkZCBtb3JlIGRldGFpbGVkIGNvbW1l
bnRzCkNyZWRpdHMgZ28gdG8gSm9lIFBlcmNoZXMgW2pvZUBwZXJjaGVzLmNvbV0gZm9yIHN1Z2dl
c3RpbmcgdGhlIGNoYW5nZXMuCgpDYzogR3JlZyBLcm9haC1IYXJ0bWFuIDxncmVna2hAc3VzZS5k
ZT4KU2lnbmVkLW9mZi1ieTogSGFuayBKYW5zc2VuIDxoamFuc3NlbkBtaWNyb3NvZnQuY29tPgpT
aWduZWQtb2ZmLWJ5OiBIYWl5YW5nIFpoYW5nIDxoYWl5YW5nekBtaWNyb3NvZnQuY29tPgoKLS0t
CiBkcml2ZXJzL3N0YWdpbmcvaHYvaHZfdXRpbHMuYyB8ICAgMzMgKysrKysrKysrKysrKysrKysr
KysrKystLS0tLS0tLS0tCiAxIGZpbGVzIGNoYW5nZWQsIDIzIGluc2VydGlvbnMoKyksIDEwIGRl
bGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2RyaXZlcnMvc3RhZ2luZy9odi9odl91dGlscy5jIGIv
ZHJpdmVycy9zdGFnaW5nL2h2L2h2X3V0aWxzLmMKaW5kZXggOGYxZDNiYS4uZGI0NWQ5NyAxMDA2
NDQKLS0tIGEvZHJpdmVycy9zdGFnaW5nL2h2L2h2X3V0aWxzLmMKKysrIGIvZHJpdmVycy9zdGFn
aW5nL2h2L2h2X3V0aWxzLmMKQEAgLTEwNiwzMSArMTA2LDQ0IEBAIHN0YXRpYyB2b2lkIHNodXRk
b3duX29uY2hhbm5lbGNhbGxiYWNrKHZvaWQgKmNvbnRleHQpCiAJCW9yZGVybHlfcG93ZXJvZmYo
ZmFsc2UpOwogfQogCi0KIC8qCi0gKiBTeW5jaHJvbml6ZSB0aW1lIHdpdGggaG9zdCBhZnRlciBy
ZWJvb3QsIHJlc3RvcmUsIGV0Yy4KKyAqIFNldCBndWVzdCB0aW1lIHRvIGhvc3QgVVRDIHRpbWUu
CiAgKi8KLXN0YXRpYyB2b2lkIGFkal9ndWVzdHRpbWUodTY0IGhvc3R0aW1lLCB1OCBmbGFncykK
K3N0YXRpYyBpbmxpbmUgdm9pZCBkb19hZGpfZ3Vlc3R0aW1lKHU2NCBob3N0dGltZSkKIHsKIAlz
NjQgaG9zdF90bnM7CiAJc3RydWN0IHRpbWVzcGVjIGhvc3RfdHM7Ci0Jc3RhdGljIHMzMiBzY250
ID0gNTA7CiAKIAlob3N0X3RucyA9IChob3N0dGltZSAtIFdMVElNRURFTFRBKSAqIDEwMDsKIAlo
b3N0X3RzID0gbnNfdG9fdGltZXNwZWMoaG9zdF90bnMpOwogCisJZG9fc2V0dGltZW9mZGF5KCZo
b3N0X3RzKTsKK30KKworLyoKKyAqIFN5bmNocm9uaXplIHRpbWUgd2l0aCBob3N0IGFmdGVyIHJl
Ym9vdCwgcmVzdG9yZSwgZXRjLgorICoKKyAqIElDVElNRVNZTkNGTEFHX1NZTkMgZmxhZyBiaXQg
aW5kaWNhdGVzIHJlYm9vdCwgcmVzdG9yZSBldmVudHMgb2YgdGhlIFZNLgorICogQWZ0ZXIgcmVi
b290IHRoZSBmbGFnIElDVElNRVNZTkNGTEFHX1NZTkMgaXMgaW5jbHVkZWQgaW4gdGhlIGZpcnN0
IHRpbWUKKyAqIG1lc3NhZ2UgYWZ0ZXIgdGhlIHRpbWVzeW5jIGNoYW5uZWwgaXMgb3BlbmVkLiBT
aW5jZSB0aGUgaHZfdXRpbHMgbW9kdWxlIGlzCisgKiBsb2FkZWQgYWZ0ZXIgaHZfdm1idXMsIHRo
ZSBmaXJzdCBtZXNzYWdlIGlzIHVzdWFsbHkgbWlzc2VkLiBUaGUgb3RoZXIKKyAqIHRoaW5nIGlz
LCBzeXN0aW1lIGlzIGF1dG9tYXRpY2FsbHkgc2V0IHRvIGVtdWxhdGVkIGhhcmR3YXJlIGNsb2Nr
IHdoaWNoIG1heQorICogbm90IGJlIFVUQyB0aW1lIG9yIGluIHRoZSBzYW1lIHRpbWUgem9uZS4g
U28sIHRvIG92ZXJyaWRlIHRoZXNlIGVmZmVjdHMsIHdlCisgKiB1c2UgdGhlIGZpcnN0IDUwIHRp
bWUgc2FtcGxlcyBmb3IgaW5pdGlhbCBzeXN0ZW0gdGltZSBzZXR0aW5nLgorICovCitzdGF0aWMg
aW5saW5lIHZvaWQgYWRqX2d1ZXN0dGltZSh1NjQgaG9zdHRpbWUsIHU4IGZsYWdzKQoreworCXN0
YXRpYyBzMzIgc2NudCA9IDUwOworCiAJaWYgKChmbGFncyAmIElDVElNRVNZTkNGTEFHX1NZTkMp
ICE9IDApIHsKLQkJZG9fc2V0dGltZW9mZGF5KCZob3N0X3RzKTsKKwkJZG9fYWRqX2d1ZXN0dGlt
ZShob3N0dGltZSk7CiAJCXJldHVybjsKIAl9CiAKLQlpZiAoKGZsYWdzICYgSUNUSU1FU1lOQ0ZM
QUdfU0FNUExFKSAhPSAwICYmCi0JICAgIHNjbnQgPiAwKSB7CisJaWYgKChmbGFncyAmIElDVElN
RVNZTkNGTEFHX1NBTVBMRSkgIT0gMCAmJiBzY250ID4gMCkgewogCQlzY250LS07Ci0JCWRvX3Nl
dHRpbWVvZmRheSgmaG9zdF90cyk7CisJCWRvX2Fkal9ndWVzdHRpbWUoaG9zdHRpbWUpOwogCX0K
LQotCXJldHVybjsKIH0KIAogLyoKLS0gCjEuNi4zLjIKCg==

--_002_1FB5E1D5CA062146B38059374562DF72662AA645TK5EX14MBXC130r_--
