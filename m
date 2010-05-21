Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752081Ab0EUT6h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 15:58:37 -0400
Received: from smtp.microsoft.com ([131.107.115.214]:25684 "EHLO
	smtp.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751605Ab0EUT6f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 15:58:35 -0400
From: Haiyang Zhang <haiyangz@microsoft.com>
To: "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
       "'devel@driverdev.osuosl.org'" <devel@driverdev.osuosl.org>,
       "'virtualization@lists.osdl.org'" <virtualization@lists.osdl.org>,
       "'gregkh@suse.de'" <gregkh@suse.de>
CC: Hank Janssen <hjanssen@microsoft.com>
Subject: [PATCH 1/1] staging: hv: Fix race condition on IC channel
 initialization
Thread-Topic: [PATCH 1/1] staging: hv: Fix race condition on IC channel
 initialization
Thread-Index: Acr5H/mIA2ovCiH5RJSF72cnsl7mOg==
Date: Fri, 21 May 2010 19:58:26 +0000
Message-ID: <1FB5E1D5CA062146B38059374562DF7266B8AE7C@TK5EX14MBXC128.redmond.corp.microsoft.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
Content-Type: multipart/mixed;
	boundary="_002_1FB5E1D5CA062146B38059374562DF7266B8AE7CTK5EX14MBXC128r_"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--_002_1FB5E1D5CA062146B38059374562DF7266B8AE7CTK5EX14MBXC128r_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

From: Haiyang Zhang <haiyangz@microsoft.com>

Subject: staging: hv: Fix race condition on IC channel initialization
There is a possible race condition when hv_utils starts to load immediately
after hv_vmbus is loading - null pointer error could happen.
This patch added an atomic counter to ensure all channels are ready before
vmbus_init() returns. So another module won't have any uninitialized channe=
l.

Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>

---
 drivers/staging/hv/channel_mgmt.c |   25 ++++++++++++++-----------
 drivers/staging/hv/hv_utils.c     |    7 ++++---
 drivers/staging/hv/utils.h        |    5 +++++
 drivers/staging/hv/vmbus_drv.c    |    5 +++++
 4 files changed, 28 insertions(+), 14 deletions(-)

diff --git a/drivers/staging/hv/channel_mgmt.c b/drivers/staging/hv/channel=
_mgmt.c
index 3f53b4d..68dfa0f 100644
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
@@ -233,6 +232,10 @@ struct hyperv_service_callback hv_cb_utils[MAX_MSG_TYP=
ES] =3D {
 };
 EXPORT_SYMBOL(hv_cb_utils);
=20
+/* Counter of IC channels initialized */
+atomic_t hv_utils_initcnt =3D ATOMIC_INIT(0);
+
+
 /*
  * AllocVmbusChannel - Allocate and initialize a vmbus channel object
  */
@@ -373,22 +376,22 @@ static void VmbusChannelProcessOffer(void *context)
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
index 8a49aaf..22f6f4a 100644
--- a/drivers/staging/hv/hv_utils.c
+++ b/drivers/staging/hv/hv_utils.c
@@ -253,7 +253,7 @@ static void heartbeat_onchannelcallback(void *context)
=20
 static int __init init_hyperv_utils(void)
 {
-	printk(KERN_INFO "Registering HyperV Utility Driver\n");
+	printk(KERN_INFO "Registering HyperV Utility Driver...\n");
=20
 	hv_cb_utils[HV_SHUTDOWN_MSG].channel->OnChannelCallback =3D
 		&shutdown_onchannelcallback;
@@ -267,13 +267,12 @@ static int __init init_hyperv_utils(void)
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
@@ -285,6 +284,8 @@ static void exit_hyperv_utils(void)
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
diff --git a/drivers/staging/hv/vmbus_drv.c b/drivers/staging/hv/vmbus_drv.=
c
index c21731a..160ee92 100644
--- a/drivers/staging/hv/vmbus_drv.c
+++ b/drivers/staging/hv/vmbus_drv.c
@@ -31,6 +31,7 @@
 #include "osd.h"
 #include "logging.h"
 #include "vmbus.h"
+#include "utils.h"
=20
=20
 /* FIXME! We need to do this dynamically for PIC and APIC system */
@@ -1005,6 +1006,10 @@ static int __init vmbus_init(void)
=20
 	ret =3D vmbus_bus_init(VmbusInitialize);
=20
+	/* Wait until all IC channels are initialized */
+	while (atomic_read(&hv_utils_initcnt) < MAX_MSG_TYPES)
+		msleep(100);
+
 	DPRINT_EXIT(VMBUS_DRV);
 	return ret;
 }
--=20
1.6.3.2


--_002_1FB5E1D5CA062146B38059374562DF7266B8AE7CTK5EX14MBXC128r_
Content-Type: application/octet-stream;
	name="0521-Fix-race-condition-on-IC-channel-initialization.patch"
Content-Description: 0521-Fix-race-condition-on-IC-channel-initialization.patch
Content-Disposition: attachment;
	filename="0521-Fix-race-condition-on-IC-channel-initialization.patch";
	size=5166; creation-date="Fri, 21 May 2010 19:51:48 GMT";
	modification-date="Fri, 21 May 2010 20:48:44 GMT"
Content-Transfer-Encoding: base64

RnJvbTogSGFpeWFuZyBaaGFuZyA8aGFpeWFuZ3pAbWljcm9zb2Z0LmNvbT4KClN1YmplY3Q6IFtQ
QVRDSF0gRml4IHJhY2UgY29uZGl0aW9uIG9uIElDIGNoYW5uZWwgaW5pdGlhbGl6YXRpb24KVGhl
cmUgaXMgYSBwb3NzaWJsZSByYWNlIGNvbmRpdGlvbiB3aGVuIGh2X3V0aWxzIHN0YXJ0cyB0byBs
b2FkIGltbWVkaWF0ZWx5CmFmdGVyIGh2X3ZtYnVzIGlzIGxvYWRpbmcgLSBudWxsIHBvaW50ZXIg
ZXJyb3IgY291bGQgaGFwcGVuLgpUaGlzIHBhdGNoIGFkZGVkIGFuIGF0b21pYyBjb3VudGVyIHRv
IGVuc3VyZSBhbGwgY2hhbm5lbHMgYXJlIHJlYWR5IGJlZm9yZQp2bWJ1c19pbml0KCkgcmV0dXJu
cy4gU28gYW5vdGhlciBtb2R1bGUgd29uJ3QgaGF2ZSBhbnkgdW5pbml0aWFsaXplZCBjaGFubmVs
LgoKU2lnbmVkLW9mZi1ieTogSGFpeWFuZyBaaGFuZyA8aGFpeWFuZ3pAbWljcm9zb2Z0LmNvbT4K
U2lnbmVkLW9mZi1ieTogSGFuayBKYW5zc2VuIDxoamFuc3NlbkBtaWNyb3NvZnQuY29tPgoKLS0t
CiBkcml2ZXJzL3N0YWdpbmcvaHYvY2hhbm5lbF9tZ210LmMgfCAgIDI1ICsrKysrKysrKysrKysr
LS0tLS0tLS0tLS0KIGRyaXZlcnMvc3RhZ2luZy9odi9odl91dGlscy5jICAgICB8ICAgIDcgKysr
Ky0tLQogZHJpdmVycy9zdGFnaW5nL2h2L3V0aWxzLmggICAgICAgIHwgICAgNSArKysrKwogZHJp
dmVycy9zdGFnaW5nL2h2L3ZtYnVzX2Rydi5jICAgIHwgICAgNSArKysrKwogNCBmaWxlcyBjaGFu
Z2VkLCAyOCBpbnNlcnRpb25zKCspLCAxNCBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9kcml2
ZXJzL3N0YWdpbmcvaHYvY2hhbm5lbF9tZ210LmMgYi9kcml2ZXJzL3N0YWdpbmcvaHYvY2hhbm5l
bF9tZ210LmMKaW5kZXggM2Y1M2I0ZC4uNjhkZmEwZiAxMDA2NDQKLS0tIGEvZHJpdmVycy9zdGFn
aW5nL2h2L2NoYW5uZWxfbWdtdC5jCisrKyBiL2RyaXZlcnMvc3RhZ2luZy9odi9jaGFubmVsX21n
bXQuYwpAQCAtMzMsNyArMzMsNiBAQCBzdHJ1Y3Qgdm1idXNfY2hhbm5lbF9tZXNzYWdlX3RhYmxl
X2VudHJ5IHsKIAl2b2lkICgqbWVzc2FnZUhhbmRsZXIpKHN0cnVjdCB2bWJ1c19jaGFubmVsX21l
c3NhZ2VfaGVhZGVyICptc2cpOwogfTsKIAotI2RlZmluZSBNQVhfTVNHX1RZUEVTICAgICAgICAg
ICAgICAgICAgICAzCiAjZGVmaW5lIE1BWF9OVU1fREVWSUNFX0NMQVNTRVNfU1VQUE9SVEVEIDcK
IAogc3RhdGljIGNvbnN0IHN0cnVjdCBodl9ndWlkCkBAIC0yMzMsNiArMjMyLDEwIEBAIHN0cnVj
dCBoeXBlcnZfc2VydmljZV9jYWxsYmFjayBodl9jYl91dGlsc1tNQVhfTVNHX1RZUEVTXSA9IHsK
IH07CiBFWFBPUlRfU1lNQk9MKGh2X2NiX3V0aWxzKTsKIAorLyogQ291bnRlciBvZiBJQyBjaGFu
bmVscyBpbml0aWFsaXplZCAqLworYXRvbWljX3QgaHZfdXRpbHNfaW5pdGNudCA9IEFUT01JQ19J
TklUKDApOworCisKIC8qCiAgKiBBbGxvY1ZtYnVzQ2hhbm5lbCAtIEFsbG9jYXRlIGFuZCBpbml0
aWFsaXplIGEgdm1idXMgY2hhbm5lbCBvYmplY3QKICAqLwpAQCAtMzczLDIyICszNzYsMjIgQEAg
c3RhdGljIHZvaWQgVm1idXNDaGFubmVsUHJvY2Vzc09mZmVyKHZvaWQgKmNvbnRleHQpCiAJCSAq
IGNhbiBjbGVhbnVwIHByb3Blcmx5CiAJCSAqLwogCQluZXdDaGFubmVsLT5TdGF0ZSA9IENIQU5O
RUxfT1BFTl9TVEFURTsKLQkJY250ID0gMDsKIAotCQl3aGlsZSAoY250ICE9IE1BWF9NU0dfVFlQ
RVMpIHsKKwkJLyogT3BlbiBJQyBjaGFubmVscyAqLworCQlmb3IgKGNudCA9IDA7IGNudCA8IE1B
WF9NU0dfVFlQRVM7IGNudCsrKSB7CiAJCQlpZiAobWVtY21wKCZuZXdDaGFubmVsLT5PZmZlck1z
Zy5PZmZlci5JbnRlcmZhY2VUeXBlLAogCQkJCSAgICZodl9jYl91dGlsc1tjbnRdLmRhdGEsCi0J
CQkJICAgc2l6ZW9mKHN0cnVjdCBodl9ndWlkKSkgPT0gMCkgeworCQkJCSAgIHNpemVvZihzdHJ1
Y3QgaHZfZ3VpZCkpID09IDAgJiYKKwkJCSAgICBWbWJ1c0NoYW5uZWxPcGVuKG5ld0NoYW5uZWws
IDIgKiBQQUdFX1NJWkUsCisJCQkJCSAgICAgMiAqIFBBR0VfU0laRSwgTlVMTCwgMCwKKwkJCQkJ
ICAgICBodl9jYl91dGlsc1tjbnRdLmNhbGxiYWNrLAorCQkJCQkgICAgIG5ld0NoYW5uZWwpID09
IDApIHsKKwkJCQlodl9jYl91dGlsc1tjbnRdLmNoYW5uZWwgPSBuZXdDaGFubmVsOworCQkJCW1i
KCk7CiAJCQkJRFBSSU5UX0lORk8oVk1CVVMsICIlcyIsCiAJCQkJCSAgICBodl9jYl91dGlsc1tj
bnRdLmxvZ19tc2cpOwotCi0JCQkJaWYgKFZtYnVzQ2hhbm5lbE9wZW4obmV3Q2hhbm5lbCwgMiAq
IFBBR0VfU0laRSwKLQkJCQkJCSAgICAyICogUEFHRV9TSVpFLCBOVUxMLCAwLAotCQkJCQkJICAg
IGh2X2NiX3V0aWxzW2NudF0uY2FsbGJhY2ssCi0JCQkJCQkgICAgbmV3Q2hhbm5lbCkgPT0gMCkK
LQkJCQkJaHZfY2JfdXRpbHNbY250XS5jaGFubmVsID0gbmV3Q2hhbm5lbDsKKwkJCQlhdG9taWNf
aW5jKCZodl91dGlsc19pbml0Y250KTsKIAkJCX0KLQkJCWNudCsrOwogCQl9CiAJfQogCURQUklO
VF9FWElUKFZNQlVTKTsKZGlmZiAtLWdpdCBhL2RyaXZlcnMvc3RhZ2luZy9odi9odl91dGlscy5j
IGIvZHJpdmVycy9zdGFnaW5nL2h2L2h2X3V0aWxzLmMKaW5kZXggOGE0OWFhZi4uMjJmNmY0YSAx
MDA2NDQKLS0tIGEvZHJpdmVycy9zdGFnaW5nL2h2L2h2X3V0aWxzLmMKKysrIGIvZHJpdmVycy9z
dGFnaW5nL2h2L2h2X3V0aWxzLmMKQEAgLTI1Myw3ICsyNTMsNyBAQCBzdGF0aWMgdm9pZCBoZWFy
dGJlYXRfb25jaGFubmVsY2FsbGJhY2sodm9pZCAqY29udGV4dCkKIAogc3RhdGljIGludCBfX2lu
aXQgaW5pdF9oeXBlcnZfdXRpbHModm9pZCkKIHsKLQlwcmludGsoS0VSTl9JTkZPICJSZWdpc3Rl
cmluZyBIeXBlclYgVXRpbGl0eSBEcml2ZXJcbiIpOworCXByaW50ayhLRVJOX0lORk8gIlJlZ2lz
dGVyaW5nIEh5cGVyViBVdGlsaXR5IERyaXZlci4uLlxuIik7CiAKIAlodl9jYl91dGlsc1tIVl9T
SFVURE9XTl9NU0ddLmNoYW5uZWwtPk9uQ2hhbm5lbENhbGxiYWNrID0KIAkJJnNodXRkb3duX29u
Y2hhbm5lbGNhbGxiYWNrOwpAQCAtMjY3LDEzICsyNjcsMTIgQEAgc3RhdGljIGludCBfX2luaXQg
aW5pdF9oeXBlcnZfdXRpbHModm9pZCkKIAkJJmhlYXJ0YmVhdF9vbmNoYW5uZWxjYWxsYmFjazsK
IAlodl9jYl91dGlsc1tIVl9IRUFSVEJFQVRfTVNHXS5jYWxsYmFjayA9ICZoZWFydGJlYXRfb25j
aGFubmVsY2FsbGJhY2s7CiAKKwlwcmludGsoS0VSTl9JTkZPICJSZWdpc3RlcmVkIEh5cGVyViBV
dGlsaXR5IERyaXZlci5cbiIpOwogCXJldHVybiAwOwogfQogCiBzdGF0aWMgdm9pZCBleGl0X2h5
cGVydl91dGlscyh2b2lkKQogewotCXByaW50ayhLRVJOX0lORk8gIkRlLVJlZ2lzdGVyZWQgSHlw
ZXJWIFV0aWxpdHkgRHJpdmVyXG4iKTsKLQogCWh2X2NiX3V0aWxzW0hWX1NIVVRET1dOX01TR10u
Y2hhbm5lbC0+T25DaGFubmVsQ2FsbGJhY2sgPQogCQkmY2huX2NiX25lZ290aWF0ZTsKIAlodl9j
Yl91dGlsc1tIVl9TSFVURE9XTl9NU0ddLmNhbGxiYWNrID0gJmNobl9jYl9uZWdvdGlhdGU7CkBA
IC0yODUsNiArMjg0LDggQEAgc3RhdGljIHZvaWQgZXhpdF9oeXBlcnZfdXRpbHModm9pZCkKIAlo
dl9jYl91dGlsc1tIVl9IRUFSVEJFQVRfTVNHXS5jaGFubmVsLT5PbkNoYW5uZWxDYWxsYmFjayA9
CiAJCSZjaG5fY2JfbmVnb3RpYXRlOwogCWh2X2NiX3V0aWxzW0hWX0hFQVJUQkVBVF9NU0ddLmNh
bGxiYWNrID0gJmNobl9jYl9uZWdvdGlhdGU7CisKKwlwcmludGsoS0VSTl9JTkZPICJEZS1SZWdp
c3RlcmVkIEh5cGVyViBVdGlsaXR5IERyaXZlci5cbiIpOwogfQogCiBtb2R1bGVfaW5pdChpbml0
X2h5cGVydl91dGlscyk7CmRpZmYgLS1naXQgYS9kcml2ZXJzL3N0YWdpbmcvaHYvdXRpbHMuaCBi
L2RyaXZlcnMvc3RhZ2luZy9odi91dGlscy5oCmluZGV4IDdjMDc0OTkuLjMyOTFhYjQgMTAwNjQ0
Ci0tLSBhL2RyaXZlcnMvc3RhZ2luZy9odi91dGlscy5oCisrKyBiL2RyaXZlcnMvc3RhZ2luZy9o
di91dGlscy5oCkBAIC05OCw2ICs5OCwxMCBAQCBzdHJ1Y3QgaWN0aW1lc3luY19kYXRhewogCXU4
IGZsYWdzOwogfSBfX2F0dHJpYnV0ZV9fKChwYWNrZWQpKTsKIAorCisvKiBOdW1iZXIgb2YgSUMg
dHlwZXMgc3VwcG9ydGVkICovCisjZGVmaW5lIE1BWF9NU0dfVFlQRVMJMworCiAvKiBJbmRleCBm
b3IgZWFjaCBJQyBzdHJ1Y3QgaW4gYXJyYXkgaHZfY2JfdXRpbHNbXSAqLwogI2RlZmluZSBIVl9T
SFVURE9XTl9NU0cJCTAKICNkZWZpbmUgSFZfVElNRVNZTkNfTVNHCQkxCkBAIC0xMTUsNSArMTE5
LDYgQEAgZXh0ZXJuIHZvaWQgcHJlcF9uZWdvdGlhdGVfcmVzcChzdHJ1Y3QgaWNtc2dfaGRyICos
CiAJCQkJc3RydWN0IGljbXNnX25lZ290aWF0ZSAqLCB1OCAqKTsKIGV4dGVybiB2b2lkIGNobl9j
Yl9uZWdvdGlhdGUodm9pZCAqKTsKIGV4dGVybiBzdHJ1Y3QgaHlwZXJ2X3NlcnZpY2VfY2FsbGJh
Y2sgaHZfY2JfdXRpbHNbXTsKK2V4dGVybiBhdG9taWNfdCBodl91dGlsc19pbml0Y250OwogCiAj
ZW5kaWYgLyogX19IVl9VVElMU19IXyAqLwpkaWZmIC0tZ2l0IGEvZHJpdmVycy9zdGFnaW5nL2h2
L3ZtYnVzX2Rydi5jIGIvZHJpdmVycy9zdGFnaW5nL2h2L3ZtYnVzX2Rydi5jCmluZGV4IGMyMTcz
MWEuLjE2MGVlOTIgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvc3RhZ2luZy9odi92bWJ1c19kcnYuYwor
KysgYi9kcml2ZXJzL3N0YWdpbmcvaHYvdm1idXNfZHJ2LmMKQEAgLTMxLDYgKzMxLDcgQEAKICNp
bmNsdWRlICJvc2QuaCIKICNpbmNsdWRlICJsb2dnaW5nLmgiCiAjaW5jbHVkZSAidm1idXMuaCIK
KyNpbmNsdWRlICJ1dGlscy5oIgogCiAKIC8qIEZJWE1FISBXZSBuZWVkIHRvIGRvIHRoaXMgZHlu
YW1pY2FsbHkgZm9yIFBJQyBhbmQgQVBJQyBzeXN0ZW0gKi8KQEAgLTEwMDUsNiArMTAwNiwxMCBA
QCBzdGF0aWMgaW50IF9faW5pdCB2bWJ1c19pbml0KHZvaWQpCiAKIAlyZXQgPSB2bWJ1c19idXNf
aW5pdChWbWJ1c0luaXRpYWxpemUpOwogCisJLyogV2FpdCB1bnRpbCBhbGwgSUMgY2hhbm5lbHMg
YXJlIGluaXRpYWxpemVkICovCisJd2hpbGUgKGF0b21pY19yZWFkKCZodl91dGlsc19pbml0Y250
KSA8IE1BWF9NU0dfVFlQRVMpCisJCW1zbGVlcCgxMDApOworCiAJRFBSSU5UX0VYSVQoVk1CVVNf
RFJWKTsKIAlyZXR1cm4gcmV0OwogfQotLSAKMS42LjMuMgoK

--_002_1FB5E1D5CA062146B38059374562DF7266B8AE7CTK5EX14MBXC128r_--
