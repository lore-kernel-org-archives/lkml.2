Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933930Ab0EZQyq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 12:54:46 -0400
Received: from mail3.microsoft.com ([131.107.115.214]:52334 "EHLO
	smtp.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932401Ab0EZQyp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 12:54:45 -0400
From: Haiyang Zhang <haiyangz@microsoft.com>
To: "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
       "'devel@driverdev.osuosl.org'" <devel@driverdev.osuosl.org>,
       "'virtualization@lists.osdl.org'" <virtualization@lists.osdl.org>,
       "'gregkh@suse.de'" <gregkh@suse.de>
CC: Hank Janssen <hjanssen@microsoft.com>
Subject: [PATCH 1/1] staging: hv: Fix race condition on IC channel
 initialization (modified)
Thread-Topic: [PATCH 1/1] staging: hv: Fix race condition on IC channel
 initialization (modified)
Thread-Index: AQHK/PQk4Q0BKOsjtUu1BYK6E0Db2w==
Date: Wed, 26 May 2010 16:54:39 +0000
Message-ID: <1FB5E1D5CA062146B38059374562DF7266B8C4AC@TK5EX14MBXC128.redmond.corp.microsoft.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
Content-Type: multipart/mixed;
	boundary="_002_1FB5E1D5CA062146B38059374562DF7266B8C4ACTK5EX14MBXC128r_"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--_002_1FB5E1D5CA062146B38059374562DF7266B8C4ACTK5EX14MBXC128r_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

From: Haiyang Zhang <haiyangz@microsoft.com>

Subject: [PATCH] staging: hv: Fix race condition on IC channel initializati=
on
There is a possible race condition when hv_utils starts to load immediately
after hv_vmbus is loading - null pointer error could happen.
This patch added an event waiting to ensure all channels are ready before
vmbus_init() returns. So another module won't have any uninitialized channe=
l.

Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>

---
 drivers/staging/hv/channel_mgmt.c  |   23 +++++++++++++----------
 drivers/staging/hv/vmbus_drv.c     |   10 ++++++++++
 drivers/staging/hv/vmbus_private.h |    1 +
 3 files changed, 24 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/hv/channel_mgmt.c b/drivers/staging/hv/channel=
_mgmt.c
index 3f53b4d..f99db1b 100644
--- a/drivers/staging/hv/channel_mgmt.c
+++ b/drivers/staging/hv/channel_mgmt.c
@@ -305,6 +305,7 @@ static void VmbusChannelProcessOffer(void *context)
 	int ret;
 	int cnt;
 	unsigned long flags;
+	static atomic_t ic_channel_initcnt =3D ATOMIC_INIT(0);
=20
 	DPRINT_ENTER(VMBUS);
=20
@@ -373,22 +374,24 @@ static void VmbusChannelProcessOffer(void *context)
 		 * can cleanup properly
 		 */
 		newChannel->State =3D CHANNEL_OPEN_STATE;
-		cnt =3D 0;
=20
-		while (cnt !=3D MAX_MSG_TYPES) {
+		/* Open IC channels */
+		for (cnt =3D 0; cnt < MAX_MSG_TYPES; cnt++) {
 			if (memcmp(&newChannel->OfferMsg.Offer.InterfaceType,
 				   &hv_cb_utils[cnt].data,
-				   sizeof(struct hv_guid)) =3D=3D 0) {
+				   sizeof(struct hv_guid)) =3D=3D 0 &&
+			    VmbusChannelOpen(newChannel, 2 * PAGE_SIZE,
+					     2 * PAGE_SIZE, NULL, 0,
+					     hv_cb_utils[cnt].callback,
+					     newChannel) =3D=3D 0) {
+				hv_cb_utils[cnt].channel =3D newChannel;
+				mb();
 				DPRINT_INFO(VMBUS, "%s",
 					    hv_cb_utils[cnt].log_msg);
-
-				if (VmbusChannelOpen(newChannel, 2 * PAGE_SIZE,
-						    2 * PAGE_SIZE, NULL, 0,
-						    hv_cb_utils[cnt].callback,
-						    newChannel) =3D=3D 0)
-					hv_cb_utils[cnt].channel =3D newChannel;
+				if (atomic_inc_return(&ic_channel_initcnt) =3D=3D
+				   MAX_MSG_TYPES)
+					osd_WaitEventSet(ic_channel_ready);
 			}
-			cnt++;
 		}
 	}
 	DPRINT_EXIT(VMBUS);
diff --git a/drivers/staging/hv/vmbus_drv.c b/drivers/staging/hv/vmbus_drv.=
c
index c21731a..3ae8981 100644
--- a/drivers/staging/hv/vmbus_drv.c
+++ b/drivers/staging/hv/vmbus_drv.c
@@ -989,6 +989,8 @@ static struct dmi_system_id __initdata microsoft_hv_dmi=
_table[] =3D {
 };
 MODULE_DEVICE_TABLE(dmi, microsoft_hv_dmi_table);
=20
+struct osd_waitevent *ic_channel_ready;
+
 static int __init vmbus_init(void)
 {
 	int ret =3D 0;
@@ -1003,8 +1005,16 @@ static int __init vmbus_init(void)
 	if (!dmi_check_system(microsoft_hv_dmi_table))
 		return -ENODEV;
=20
+	ic_channel_ready =3D osd_WaitEventCreate();
+	if (ic_channel_ready =3D=3D NULL)
+		return -ENOMEM;
+
 	ret =3D vmbus_bus_init(VmbusInitialize);
=20
+	/* Wait until all IC channels are initialized */
+	osd_WaitEventWait(ic_channel_ready);
+
+	kfree(ic_channel_ready);
 	DPRINT_EXIT(VMBUS_DRV);
 	return ret;
 }
diff --git a/drivers/staging/hv/vmbus_private.h b/drivers/staging/hv/vmbus_=
private.h
index 588c667..3fb8dad 100644
--- a/drivers/staging/hv/vmbus_private.h
+++ b/drivers/staging/hv/vmbus_private.h
@@ -130,5 +130,6 @@ int VmbusSetEvent(u32 childRelId);
=20
 void VmbusOnEvents(void);
=20
+extern struct osd_waitevent *ic_channel_ready;
=20
 #endif /* _VMBUS_PRIVATE_H_ */
--=20
1.6.3.2


--_002_1FB5E1D5CA062146B38059374562DF7266B8C4ACTK5EX14MBXC128r_
Content-Type: application/octet-stream;
	name="0525-Fix-race-condition-on-IC-channel-initialization.patch"
Content-Description: 0525-Fix-race-condition-on-IC-channel-initialization.patch
Content-Disposition: attachment;
	filename="0525-Fix-race-condition-on-IC-channel-initialization.patch";
	size=3454; creation-date="Tue, 25 May 2010 22:56:01 GMT";
	modification-date="Tue, 25 May 2010 23:54:28 GMT"
Content-Transfer-Encoding: base64

RnJvbTogSGFpeWFuZyBaaGFuZyA8aGFpeWFuZ3pAbWljcm9zb2Z0LmNvbT4KClN1YmplY3Q6IFtQ
QVRDSF0gc3RhZ2luZzogaHY6IEZpeCByYWNlIGNvbmRpdGlvbiBvbiBJQyBjaGFubmVsIGluaXRp
YWxpemF0aW9uClRoZXJlIGlzIGEgcG9zc2libGUgcmFjZSBjb25kaXRpb24gd2hlbiBodl91dGls
cyBzdGFydHMgdG8gbG9hZCBpbW1lZGlhdGVseQphZnRlciBodl92bWJ1cyBpcyBsb2FkaW5nIC0g
bnVsbCBwb2ludGVyIGVycm9yIGNvdWxkIGhhcHBlbi4KVGhpcyBwYXRjaCBhZGRlZCBhbiBldmVu
dCB3YWl0aW5nIHRvIGVuc3VyZSBhbGwgY2hhbm5lbHMgYXJlIHJlYWR5IGJlZm9yZQp2bWJ1c19p
bml0KCkgcmV0dXJucy4gU28gYW5vdGhlciBtb2R1bGUgd29uJ3QgaGF2ZSBhbnkgdW5pbml0aWFs
aXplZCBjaGFubmVsLgoKU2lnbmVkLW9mZi1ieTogSGFpeWFuZyBaaGFuZyA8aGFpeWFuZ3pAbWlj
cm9zb2Z0LmNvbT4KU2lnbmVkLW9mZi1ieTogSGFuayBKYW5zc2VuIDxoamFuc3NlbkBtaWNyb3Nv
ZnQuY29tPgoKLS0tCiBkcml2ZXJzL3N0YWdpbmcvaHYvY2hhbm5lbF9tZ210LmMgIHwgICAyMyAr
KysrKysrKysrKysrLS0tLS0tLS0tLQogZHJpdmVycy9zdGFnaW5nL2h2L3ZtYnVzX2Rydi5jICAg
ICB8ICAgMTAgKysrKysrKysrKwogZHJpdmVycy9zdGFnaW5nL2h2L3ZtYnVzX3ByaXZhdGUuaCB8
ICAgIDEgKwogMyBmaWxlcyBjaGFuZ2VkLCAyNCBpbnNlcnRpb25zKCspLCAxMCBkZWxldGlvbnMo
LSkKCmRpZmYgLS1naXQgYS9kcml2ZXJzL3N0YWdpbmcvaHYvY2hhbm5lbF9tZ210LmMgYi9kcml2
ZXJzL3N0YWdpbmcvaHYvY2hhbm5lbF9tZ210LmMKaW5kZXggM2Y1M2I0ZC4uZjk5ZGIxYiAxMDA2
NDQKLS0tIGEvZHJpdmVycy9zdGFnaW5nL2h2L2NoYW5uZWxfbWdtdC5jCisrKyBiL2RyaXZlcnMv
c3RhZ2luZy9odi9jaGFubmVsX21nbXQuYwpAQCAtMzA1LDYgKzMwNSw3IEBAIHN0YXRpYyB2b2lk
IFZtYnVzQ2hhbm5lbFByb2Nlc3NPZmZlcih2b2lkICpjb250ZXh0KQogCWludCByZXQ7CiAJaW50
IGNudDsKIAl1bnNpZ25lZCBsb25nIGZsYWdzOworCXN0YXRpYyBhdG9taWNfdCBpY19jaGFubmVs
X2luaXRjbnQgPSBBVE9NSUNfSU5JVCgwKTsKIAogCURQUklOVF9FTlRFUihWTUJVUyk7CiAKQEAg
LTM3MywyMiArMzc0LDI0IEBAIHN0YXRpYyB2b2lkIFZtYnVzQ2hhbm5lbFByb2Nlc3NPZmZlcih2
b2lkICpjb250ZXh0KQogCQkgKiBjYW4gY2xlYW51cCBwcm9wZXJseQogCQkgKi8KIAkJbmV3Q2hh
bm5lbC0+U3RhdGUgPSBDSEFOTkVMX09QRU5fU1RBVEU7Ci0JCWNudCA9IDA7CiAKLQkJd2hpbGUg
KGNudCAhPSBNQVhfTVNHX1RZUEVTKSB7CisJCS8qIE9wZW4gSUMgY2hhbm5lbHMgKi8KKwkJZm9y
IChjbnQgPSAwOyBjbnQgPCBNQVhfTVNHX1RZUEVTOyBjbnQrKykgewogCQkJaWYgKG1lbWNtcCgm
bmV3Q2hhbm5lbC0+T2ZmZXJNc2cuT2ZmZXIuSW50ZXJmYWNlVHlwZSwKIAkJCQkgICAmaHZfY2Jf
dXRpbHNbY250XS5kYXRhLAotCQkJCSAgIHNpemVvZihzdHJ1Y3QgaHZfZ3VpZCkpID09IDApIHsK
KwkJCQkgICBzaXplb2Yoc3RydWN0IGh2X2d1aWQpKSA9PSAwICYmCisJCQkgICAgVm1idXNDaGFu
bmVsT3BlbihuZXdDaGFubmVsLCAyICogUEFHRV9TSVpFLAorCQkJCQkgICAgIDIgKiBQQUdFX1NJ
WkUsIE5VTEwsIDAsCisJCQkJCSAgICAgaHZfY2JfdXRpbHNbY250XS5jYWxsYmFjaywKKwkJCQkJ
ICAgICBuZXdDaGFubmVsKSA9PSAwKSB7CisJCQkJaHZfY2JfdXRpbHNbY250XS5jaGFubmVsID0g
bmV3Q2hhbm5lbDsKKwkJCQltYigpOwogCQkJCURQUklOVF9JTkZPKFZNQlVTLCAiJXMiLAogCQkJ
CQkgICAgaHZfY2JfdXRpbHNbY250XS5sb2dfbXNnKTsKLQotCQkJCWlmIChWbWJ1c0NoYW5uZWxP
cGVuKG5ld0NoYW5uZWwsIDIgKiBQQUdFX1NJWkUsCi0JCQkJCQkgICAgMiAqIFBBR0VfU0laRSwg
TlVMTCwgMCwKLQkJCQkJCSAgICBodl9jYl91dGlsc1tjbnRdLmNhbGxiYWNrLAotCQkJCQkJICAg
IG5ld0NoYW5uZWwpID09IDApCi0JCQkJCWh2X2NiX3V0aWxzW2NudF0uY2hhbm5lbCA9IG5ld0No
YW5uZWw7CisJCQkJaWYgKGF0b21pY19pbmNfcmV0dXJuKCZpY19jaGFubmVsX2luaXRjbnQpID09
CisJCQkJICAgTUFYX01TR19UWVBFUykKKwkJCQkJb3NkX1dhaXRFdmVudFNldChpY19jaGFubmVs
X3JlYWR5KTsKIAkJCX0KLQkJCWNudCsrOwogCQl9CiAJfQogCURQUklOVF9FWElUKFZNQlVTKTsK
ZGlmZiAtLWdpdCBhL2RyaXZlcnMvc3RhZ2luZy9odi92bWJ1c19kcnYuYyBiL2RyaXZlcnMvc3Rh
Z2luZy9odi92bWJ1c19kcnYuYwppbmRleCBjMjE3MzFhLi4zYWU4OTgxIDEwMDY0NAotLS0gYS9k
cml2ZXJzL3N0YWdpbmcvaHYvdm1idXNfZHJ2LmMKKysrIGIvZHJpdmVycy9zdGFnaW5nL2h2L3Zt
YnVzX2Rydi5jCkBAIC05ODksNiArOTg5LDggQEAgc3RhdGljIHN0cnVjdCBkbWlfc3lzdGVtX2lk
IF9faW5pdGRhdGEgbWljcm9zb2Z0X2h2X2RtaV90YWJsZVtdID0gewogfTsKIE1PRFVMRV9ERVZJ
Q0VfVEFCTEUoZG1pLCBtaWNyb3NvZnRfaHZfZG1pX3RhYmxlKTsKIAorc3RydWN0IG9zZF93YWl0
ZXZlbnQgKmljX2NoYW5uZWxfcmVhZHk7CisKIHN0YXRpYyBpbnQgX19pbml0IHZtYnVzX2luaXQo
dm9pZCkKIHsKIAlpbnQgcmV0ID0gMDsKQEAgLTEwMDMsOCArMTAwNSwxNiBAQCBzdGF0aWMgaW50
IF9faW5pdCB2bWJ1c19pbml0KHZvaWQpCiAJaWYgKCFkbWlfY2hlY2tfc3lzdGVtKG1pY3Jvc29m
dF9odl9kbWlfdGFibGUpKQogCQlyZXR1cm4gLUVOT0RFVjsKIAorCWljX2NoYW5uZWxfcmVhZHkg
PSBvc2RfV2FpdEV2ZW50Q3JlYXRlKCk7CisJaWYgKGljX2NoYW5uZWxfcmVhZHkgPT0gTlVMTCkK
KwkJcmV0dXJuIC1FTk9NRU07CisKIAlyZXQgPSB2bWJ1c19idXNfaW5pdChWbWJ1c0luaXRpYWxp
emUpOwogCisJLyogV2FpdCB1bnRpbCBhbGwgSUMgY2hhbm5lbHMgYXJlIGluaXRpYWxpemVkICov
CisJb3NkX1dhaXRFdmVudFdhaXQoaWNfY2hhbm5lbF9yZWFkeSk7CisKKwlrZnJlZShpY19jaGFu
bmVsX3JlYWR5KTsKIAlEUFJJTlRfRVhJVChWTUJVU19EUlYpOwogCXJldHVybiByZXQ7CiB9CmRp
ZmYgLS1naXQgYS9kcml2ZXJzL3N0YWdpbmcvaHYvdm1idXNfcHJpdmF0ZS5oIGIvZHJpdmVycy9z
dGFnaW5nL2h2L3ZtYnVzX3ByaXZhdGUuaAppbmRleCA1ODhjNjY3Li4zZmI4ZGFkIDEwMDY0NAot
LS0gYS9kcml2ZXJzL3N0YWdpbmcvaHYvdm1idXNfcHJpdmF0ZS5oCisrKyBiL2RyaXZlcnMvc3Rh
Z2luZy9odi92bWJ1c19wcml2YXRlLmgKQEAgLTEzMCw1ICsxMzAsNiBAQCBpbnQgVm1idXNTZXRF
dmVudCh1MzIgY2hpbGRSZWxJZCk7CiAKIHZvaWQgVm1idXNPbkV2ZW50cyh2b2lkKTsKIAorZXh0
ZXJuIHN0cnVjdCBvc2Rfd2FpdGV2ZW50ICppY19jaGFubmVsX3JlYWR5OwogCiAjZW5kaWYgLyog
X1ZNQlVTX1BSSVZBVEVfSF8gKi8KLS0gCjEuNi4zLjIKCg==

--_002_1FB5E1D5CA062146B38059374562DF7266B8C4ACTK5EX14MBXC128r_--
