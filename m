Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753629Ab0ESPyY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 11:54:24 -0400
Received: from smtp.microsoft.com ([131.107.115.212]:13548 "EHLO
	smtp.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753592Ab0ESPyX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 11:54:23 -0400
From: Haiyang Zhang <haiyangz@microsoft.com>
To: "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
       "'devel@driverdev.osuosl.org'" <devel@driverdev.osuosl.org>,
       "'virtualization@lists.osdl.org'" <virtualization@lists.osdl.org>,
       "'gregkh@suse.de'" <gregkh@suse.de>
CC: Hank Janssen <hjanssen@microsoft.com>
Subject: [PATCH 1/2] staging: hv: Fix race condition in hv_utils module
 initialization.
Thread-Topic: [PATCH 1/2] staging: hv: Fix race condition in hv_utils module
 initialization.
Thread-Index: AQHK92uLW80ITLq46EC/wvbFNLfG5Q==
Date: Wed, 19 May 2010 15:54:17 +0000
Message-ID: <1FB5E1D5CA062146B38059374562DF7266B8930E@TK5EX14MBXC128.redmond.corp.microsoft.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
Content-Type: multipart/mixed;
	boundary="_002_1FB5E1D5CA062146B38059374562DF7266B8930ETK5EX14MBXC128r_"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--_002_1FB5E1D5CA062146B38059374562DF7266B8930ETK5EX14MBXC128r_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

From: Haiyang Zhang <haiyangz@microsoft.com>

Subject: [PATCH 1/2] staging: hv: Fix race condition in hv_utils module ini=
tialization.
There is a possible race condition when hv_utils starts to load immediately
after hv_vmbus is loading - null pointer error could happen.
This patch added an atomic counter to ensure the hv_utils module initializa=
tion
happens after all vmbus IC channels are initialized.

Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>

---
 drivers/staging/hv/channel_mgmt.c |   26 +++++++++++++++-----------
 drivers/staging/hv/hv_utils.c     |   11 ++++++++---
 drivers/staging/hv/utils.h        |    5 +++++
 3 files changed, 28 insertions(+), 14 deletions(-)

diff --git a/drivers/staging/hv/channel_mgmt.c b/drivers/staging/hv/channel=
_mgmt.c
index 3f53b4d..b5b6a70 100644
--- a/drivers/staging/hv/channel_mgmt.c
+++ b/drivers/staging/hv/channel_mgmt.c
@@ -33,7 +33,6 @@ struct vmbus_channel_message_table_entry {
 	void (*messageHandler)(struct vmbus_channel_message_header *msg);
 };
=20
-#define MAX_MSG_TYPES                    3
 #define MAX_NUM_DEVICE_CLASSES_SUPPORTED 7
=20
 static const struct hv_guid
@@ -233,6 +232,11 @@ struct hyperv_service_callback hv_cb_utils[MAX_MSG_TYP=
ES] =3D {
 };
 EXPORT_SYMBOL(hv_cb_utils);
=20
+/* Counter of IC channels initialized */
+atomic_t hv_utils_initcnt =3D ATOMIC_INIT(0);
+EXPORT_SYMBOL(hv_utils_initcnt);
+
+
 /*
  * AllocVmbusChannel - Allocate and initialize a vmbus channel object
  */
@@ -373,22 +377,22 @@ static void VmbusChannelProcessOffer(void *context)
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
+				atomic_inc(&hv_utils_initcnt);
 			}
-			cnt++;
 		}
 	}
 	DPRINT_EXIT(VMBUS);
diff --git a/drivers/staging/hv/hv_utils.c b/drivers/staging/hv/hv_utils.c
index 8a49aaf..f9826c7 100644
--- a/drivers/staging/hv/hv_utils.c
+++ b/drivers/staging/hv/hv_utils.c
@@ -253,7 +253,11 @@ static void heartbeat_onchannelcallback(void *context)
=20
 static int __init init_hyperv_utils(void)
 {
-	printk(KERN_INFO "Registering HyperV Utility Driver\n");
+	printk(KERN_INFO "Registering HyperV Utility Driver...\n");
+
+	/* Wait until all IC channels are initialized */
+	while (atomic_read(&hv_utils_initcnt) < MAX_MSG_TYPES)
+		msleep(100);
=20
 	hv_cb_utils[HV_SHUTDOWN_MSG].channel->OnChannelCallback =3D
 		&shutdown_onchannelcallback;
@@ -267,13 +271,12 @@ static int __init init_hyperv_utils(void)
 		&heartbeat_onchannelcallback;
 	hv_cb_utils[HV_HEARTBEAT_MSG].callback =3D &heartbeat_onchannelcallback;
=20
+	printk(KERN_INFO "Registered HyperV Utility Driver.\n");
 	return 0;
 }
=20
 static void exit_hyperv_utils(void)
 {
-	printk(KERN_INFO "De-Registered HyperV Utility Driver\n");
-
 	hv_cb_utils[HV_SHUTDOWN_MSG].channel->OnChannelCallback =3D
 		&chn_cb_negotiate;
 	hv_cb_utils[HV_SHUTDOWN_MSG].callback =3D &chn_cb_negotiate;
@@ -285,6 +288,8 @@ static void exit_hyperv_utils(void)
 	hv_cb_utils[HV_HEARTBEAT_MSG].channel->OnChannelCallback =3D
 		&chn_cb_negotiate;
 	hv_cb_utils[HV_HEARTBEAT_MSG].callback =3D &chn_cb_negotiate;
+
+	printk(KERN_INFO "De-Registered HyperV Utility Driver.\n");
 }
=20
 module_init(init_hyperv_utils);
diff --git a/drivers/staging/hv/utils.h b/drivers/staging/hv/utils.h
index 7c07499..3291ab4 100644
--- a/drivers/staging/hv/utils.h
+++ b/drivers/staging/hv/utils.h
@@ -98,6 +98,10 @@ struct ictimesync_data{
 	u8 flags;
 } __attribute__((packed));
=20
+
+/* Number of IC types supported */
+#define MAX_MSG_TYPES	3
+
 /* Index for each IC struct in array hv_cb_utils[] */
 #define HV_SHUTDOWN_MSG		0
 #define HV_TIMESYNC_MSG		1
@@ -115,5 +119,6 @@ extern void prep_negotiate_resp(struct icmsg_hdr *,
 				struct icmsg_negotiate *, u8 *);
 extern void chn_cb_negotiate(void *);
 extern struct hyperv_service_callback hv_cb_utils[];
+extern atomic_t hv_utils_initcnt;
=20
 #endif /* __HV_UTILS_H_ */
--=20
1.6.3.2


--_002_1FB5E1D5CA062146B38059374562DF7266B8930ETK5EX14MBXC128r_
Content-Type: application/octet-stream;
	name="0518-1-Fix-race-condition-in-hv_utils-module-initialization.patch"
Content-Description: 0518-1-Fix-race-condition-in-hv_utils-module-initialization.patch
Content-Disposition: attachment; filename=
	"0518-1-Fix-race-condition-in-hv_utils-module-initialization.patch";
	size=4663; creation-date="Tue, 18 May 2010 22:22:31 GMT";
	modification-date="Tue, 18 May 2010 23:09:30 GMT"
Content-Transfer-Encoding: base64

RnJvbTogSGFpeWFuZyBaaGFuZyA8aGFpeWFuZ3pAbWljcm9zb2Z0LmNvbT4KClN1YmplY3Q6IFtQ
QVRDSCAxLzJdIHN0YWdpbmc6IGh2OiBGaXggcmFjZSBjb25kaXRpb24gaW4gaHZfdXRpbHMgbW9k
dWxlIGluaXRpYWxpemF0aW9uLgpUaGVyZSBpcyBhIHBvc3NpYmxlIHJhY2UgY29uZGl0aW9uIHdo
ZW4gaHZfdXRpbHMgc3RhcnRzIHRvIGxvYWQgaW1tZWRpYXRlbHkKYWZ0ZXIgaHZfdm1idXMgaXMg
bG9hZGluZyAtIG51bGwgcG9pbnRlciBlcnJvciBjb3VsZCBoYXBwZW4uClRoaXMgcGF0Y2ggYWRk
ZWQgYW4gYXRvbWljIGNvdW50ZXIgdG8gZW5zdXJlIHRoZSBodl91dGlscyBtb2R1bGUgaW5pdGlh
bGl6YXRpb24KaGFwcGVucyBhZnRlciBhbGwgdm1idXMgSUMgY2hhbm5lbHMgYXJlIGluaXRpYWxp
emVkLgoKU2lnbmVkLW9mZi1ieTogSGFpeWFuZyBaaGFuZyA8aGFpeWFuZ3pAbWljcm9zb2Z0LmNv
bT4KU2lnbmVkLW9mZi1ieTogSGFuayBKYW5zc2VuIDxoamFuc3NlbkBtaWNyb3NvZnQuY29tPgoK
LS0tCiBkcml2ZXJzL3N0YWdpbmcvaHYvY2hhbm5lbF9tZ210LmMgfCAgIDI2ICsrKysrKysrKysr
KysrKy0tLS0tLS0tLS0tCiBkcml2ZXJzL3N0YWdpbmcvaHYvaHZfdXRpbHMuYyAgICAgfCAgIDEx
ICsrKysrKysrLS0tCiBkcml2ZXJzL3N0YWdpbmcvaHYvdXRpbHMuaCAgICAgICAgfCAgICA1ICsr
KysrCiAzIGZpbGVzIGNoYW5nZWQsIDI4IGluc2VydGlvbnMoKyksIDE0IGRlbGV0aW9ucygtKQoK
ZGlmZiAtLWdpdCBhL2RyaXZlcnMvc3RhZ2luZy9odi9jaGFubmVsX21nbXQuYyBiL2RyaXZlcnMv
c3RhZ2luZy9odi9jaGFubmVsX21nbXQuYwppbmRleCAzZjUzYjRkLi5iNWI2YTcwIDEwMDY0NAot
LS0gYS9kcml2ZXJzL3N0YWdpbmcvaHYvY2hhbm5lbF9tZ210LmMKKysrIGIvZHJpdmVycy9zdGFn
aW5nL2h2L2NoYW5uZWxfbWdtdC5jCkBAIC0zMyw3ICszMyw2IEBAIHN0cnVjdCB2bWJ1c19jaGFu
bmVsX21lc3NhZ2VfdGFibGVfZW50cnkgewogCXZvaWQgKCptZXNzYWdlSGFuZGxlcikoc3RydWN0
IHZtYnVzX2NoYW5uZWxfbWVzc2FnZV9oZWFkZXIgKm1zZyk7CiB9OwogCi0jZGVmaW5lIE1BWF9N
U0dfVFlQRVMgICAgICAgICAgICAgICAgICAgIDMKICNkZWZpbmUgTUFYX05VTV9ERVZJQ0VfQ0xB
U1NFU19TVVBQT1JURUQgNwogCiBzdGF0aWMgY29uc3Qgc3RydWN0IGh2X2d1aWQKQEAgLTIzMyw2
ICsyMzIsMTEgQEAgc3RydWN0IGh5cGVydl9zZXJ2aWNlX2NhbGxiYWNrIGh2X2NiX3V0aWxzW01B
WF9NU0dfVFlQRVNdID0gewogfTsKIEVYUE9SVF9TWU1CT0woaHZfY2JfdXRpbHMpOwogCisvKiBD
b3VudGVyIG9mIElDIGNoYW5uZWxzIGluaXRpYWxpemVkICovCithdG9taWNfdCBodl91dGlsc19p
bml0Y250ID0gQVRPTUlDX0lOSVQoMCk7CitFWFBPUlRfU1lNQk9MKGh2X3V0aWxzX2luaXRjbnQp
OworCisKIC8qCiAgKiBBbGxvY1ZtYnVzQ2hhbm5lbCAtIEFsbG9jYXRlIGFuZCBpbml0aWFsaXpl
IGEgdm1idXMgY2hhbm5lbCBvYmplY3QKICAqLwpAQCAtMzczLDIyICszNzcsMjIgQEAgc3RhdGlj
IHZvaWQgVm1idXNDaGFubmVsUHJvY2Vzc09mZmVyKHZvaWQgKmNvbnRleHQpCiAJCSAqIGNhbiBj
bGVhbnVwIHByb3Blcmx5CiAJCSAqLwogCQluZXdDaGFubmVsLT5TdGF0ZSA9IENIQU5ORUxfT1BF
Tl9TVEFURTsKLQkJY250ID0gMDsKIAotCQl3aGlsZSAoY250ICE9IE1BWF9NU0dfVFlQRVMpIHsK
KwkJLyogT3BlbiBJQyBjaGFubmVscyAqLworCQlmb3IgKGNudCA9IDA7IGNudCA8IE1BWF9NU0df
VFlQRVM7IGNudCsrKSB7CiAJCQlpZiAobWVtY21wKCZuZXdDaGFubmVsLT5PZmZlck1zZy5PZmZl
ci5JbnRlcmZhY2VUeXBlLAogCQkJCSAgICZodl9jYl91dGlsc1tjbnRdLmRhdGEsCi0JCQkJICAg
c2l6ZW9mKHN0cnVjdCBodl9ndWlkKSkgPT0gMCkgeworCQkJCSAgIHNpemVvZihzdHJ1Y3QgaHZf
Z3VpZCkpID09IDAgJiYKKwkJCSAgICBWbWJ1c0NoYW5uZWxPcGVuKG5ld0NoYW5uZWwsIDIgKiBQ
QUdFX1NJWkUsCisJCQkJCSAgICAgMiAqIFBBR0VfU0laRSwgTlVMTCwgMCwKKwkJCQkJICAgICBo
dl9jYl91dGlsc1tjbnRdLmNhbGxiYWNrLAorCQkJCQkgICAgIG5ld0NoYW5uZWwpID09IDApIHsK
KwkJCQlodl9jYl91dGlsc1tjbnRdLmNoYW5uZWwgPSBuZXdDaGFubmVsOworCQkJCW1iKCk7CiAJ
CQkJRFBSSU5UX0lORk8oVk1CVVMsICIlcyIsCiAJCQkJCSAgICBodl9jYl91dGlsc1tjbnRdLmxv
Z19tc2cpOwotCi0JCQkJaWYgKFZtYnVzQ2hhbm5lbE9wZW4obmV3Q2hhbm5lbCwgMiAqIFBBR0Vf
U0laRSwKLQkJCQkJCSAgICAyICogUEFHRV9TSVpFLCBOVUxMLCAwLAotCQkJCQkJICAgIGh2X2Ni
X3V0aWxzW2NudF0uY2FsbGJhY2ssCi0JCQkJCQkgICAgbmV3Q2hhbm5lbCkgPT0gMCkKLQkJCQkJ
aHZfY2JfdXRpbHNbY250XS5jaGFubmVsID0gbmV3Q2hhbm5lbDsKKwkJCQlhdG9taWNfaW5jKCZo
dl91dGlsc19pbml0Y250KTsKIAkJCX0KLQkJCWNudCsrOwogCQl9CiAJfQogCURQUklOVF9FWElU
KFZNQlVTKTsKZGlmZiAtLWdpdCBhL2RyaXZlcnMvc3RhZ2luZy9odi9odl91dGlscy5jIGIvZHJp
dmVycy9zdGFnaW5nL2h2L2h2X3V0aWxzLmMKaW5kZXggOGE0OWFhZi4uZjk4MjZjNyAxMDA2NDQK
LS0tIGEvZHJpdmVycy9zdGFnaW5nL2h2L2h2X3V0aWxzLmMKKysrIGIvZHJpdmVycy9zdGFnaW5n
L2h2L2h2X3V0aWxzLmMKQEAgLTI1Myw3ICsyNTMsMTEgQEAgc3RhdGljIHZvaWQgaGVhcnRiZWF0
X29uY2hhbm5lbGNhbGxiYWNrKHZvaWQgKmNvbnRleHQpCiAKIHN0YXRpYyBpbnQgX19pbml0IGlu
aXRfaHlwZXJ2X3V0aWxzKHZvaWQpCiB7Ci0JcHJpbnRrKEtFUk5fSU5GTyAiUmVnaXN0ZXJpbmcg
SHlwZXJWIFV0aWxpdHkgRHJpdmVyXG4iKTsKKwlwcmludGsoS0VSTl9JTkZPICJSZWdpc3Rlcmlu
ZyBIeXBlclYgVXRpbGl0eSBEcml2ZXIuLi5cbiIpOworCisJLyogV2FpdCB1bnRpbCBhbGwgSUMg
Y2hhbm5lbHMgYXJlIGluaXRpYWxpemVkICovCisJd2hpbGUgKGF0b21pY19yZWFkKCZodl91dGls
c19pbml0Y250KSA8IE1BWF9NU0dfVFlQRVMpCisJCW1zbGVlcCgxMDApOwogCiAJaHZfY2JfdXRp
bHNbSFZfU0hVVERPV05fTVNHXS5jaGFubmVsLT5PbkNoYW5uZWxDYWxsYmFjayA9CiAJCSZzaHV0
ZG93bl9vbmNoYW5uZWxjYWxsYmFjazsKQEAgLTI2NywxMyArMjcxLDEyIEBAIHN0YXRpYyBpbnQg
X19pbml0IGluaXRfaHlwZXJ2X3V0aWxzKHZvaWQpCiAJCSZoZWFydGJlYXRfb25jaGFubmVsY2Fs
bGJhY2s7CiAJaHZfY2JfdXRpbHNbSFZfSEVBUlRCRUFUX01TR10uY2FsbGJhY2sgPSAmaGVhcnRi
ZWF0X29uY2hhbm5lbGNhbGxiYWNrOwogCisJcHJpbnRrKEtFUk5fSU5GTyAiUmVnaXN0ZXJlZCBI
eXBlclYgVXRpbGl0eSBEcml2ZXIuXG4iKTsKIAlyZXR1cm4gMDsKIH0KIAogc3RhdGljIHZvaWQg
ZXhpdF9oeXBlcnZfdXRpbHModm9pZCkKIHsKLQlwcmludGsoS0VSTl9JTkZPICJEZS1SZWdpc3Rl
cmVkIEh5cGVyViBVdGlsaXR5IERyaXZlclxuIik7Ci0KIAlodl9jYl91dGlsc1tIVl9TSFVURE9X
Tl9NU0ddLmNoYW5uZWwtPk9uQ2hhbm5lbENhbGxiYWNrID0KIAkJJmNobl9jYl9uZWdvdGlhdGU7
CiAJaHZfY2JfdXRpbHNbSFZfU0hVVERPV05fTVNHXS5jYWxsYmFjayA9ICZjaG5fY2JfbmVnb3Rp
YXRlOwpAQCAtMjg1LDYgKzI4OCw4IEBAIHN0YXRpYyB2b2lkIGV4aXRfaHlwZXJ2X3V0aWxzKHZv
aWQpCiAJaHZfY2JfdXRpbHNbSFZfSEVBUlRCRUFUX01TR10uY2hhbm5lbC0+T25DaGFubmVsQ2Fs
bGJhY2sgPQogCQkmY2huX2NiX25lZ290aWF0ZTsKIAlodl9jYl91dGlsc1tIVl9IRUFSVEJFQVRf
TVNHXS5jYWxsYmFjayA9ICZjaG5fY2JfbmVnb3RpYXRlOworCisJcHJpbnRrKEtFUk5fSU5GTyAi
RGUtUmVnaXN0ZXJlZCBIeXBlclYgVXRpbGl0eSBEcml2ZXIuXG4iKTsKIH0KIAogbW9kdWxlX2lu
aXQoaW5pdF9oeXBlcnZfdXRpbHMpOwpkaWZmIC0tZ2l0IGEvZHJpdmVycy9zdGFnaW5nL2h2L3V0
aWxzLmggYi9kcml2ZXJzL3N0YWdpbmcvaHYvdXRpbHMuaAppbmRleCA3YzA3NDk5Li4zMjkxYWI0
IDEwMDY0NAotLS0gYS9kcml2ZXJzL3N0YWdpbmcvaHYvdXRpbHMuaAorKysgYi9kcml2ZXJzL3N0
YWdpbmcvaHYvdXRpbHMuaApAQCAtOTgsNiArOTgsMTAgQEAgc3RydWN0IGljdGltZXN5bmNfZGF0
YXsKIAl1OCBmbGFnczsKIH0gX19hdHRyaWJ1dGVfXygocGFja2VkKSk7CiAKKworLyogTnVtYmVy
IG9mIElDIHR5cGVzIHN1cHBvcnRlZCAqLworI2RlZmluZSBNQVhfTVNHX1RZUEVTCTMKKwogLyog
SW5kZXggZm9yIGVhY2ggSUMgc3RydWN0IGluIGFycmF5IGh2X2NiX3V0aWxzW10gKi8KICNkZWZp
bmUgSFZfU0hVVERPV05fTVNHCQkwCiAjZGVmaW5lIEhWX1RJTUVTWU5DX01TRwkJMQpAQCAtMTE1
LDUgKzExOSw2IEBAIGV4dGVybiB2b2lkIHByZXBfbmVnb3RpYXRlX3Jlc3Aoc3RydWN0IGljbXNn
X2hkciAqLAogCQkJCXN0cnVjdCBpY21zZ19uZWdvdGlhdGUgKiwgdTggKik7CiBleHRlcm4gdm9p
ZCBjaG5fY2JfbmVnb3RpYXRlKHZvaWQgKik7CiBleHRlcm4gc3RydWN0IGh5cGVydl9zZXJ2aWNl
X2NhbGxiYWNrIGh2X2NiX3V0aWxzW107CitleHRlcm4gYXRvbWljX3QgaHZfdXRpbHNfaW5pdGNu
dDsKIAogI2VuZGlmIC8qIF9fSFZfVVRJTFNfSF8gKi8KLS0gCjEuNi4zLjIKCg==

--_002_1FB5E1D5CA062146B38059374562DF7266B8930ETK5EX14MBXC128r_--
