Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758152Ab0EETXx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 May 2010 15:23:53 -0400
Received: from mail1.microsoft.com ([131.107.115.212]:9163 "EHLO
	smtp.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751011Ab0EETXv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 May 2010 15:23:51 -0400
From: Haiyang Zhang <haiyangz@microsoft.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
       "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>,
       "gregkh@suse.de" <gregkh@suse.de>
CC: Hank Janssen <hjanssen@microsoft.com>
Subject: [PATCH 1/1] staging: hv: Add Time Sync feature to hv_utils module
Thread-Topic: [PATCH 1/1] staging: hv: Add Time Sync feature to hv_utils
 module
Thread-Index: AcrsiHvEWD8Nib2kTVmMdrg4l0obMg==
Date: Wed, 5 May 2010 19:23:46 +0000
Message-ID: <1FB5E1D5CA062146B38059374562DF72662A6D3B@TK5EX14MBXC130.redmond.corp.microsoft.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
Content-Type: multipart/mixed;
	boundary="_002_1FB5E1D5CA062146B38059374562DF72662A6D3BTK5EX14MBXC130r_"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--_002_1FB5E1D5CA062146B38059374562DF72662A6D3BTK5EX14MBXC130r_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

From: Haiyang Zhang <haiyangz@microsoft.com>

Subject: Add Time Sync feature to hv_utils module.
The Time Sync feature synchronizes guest time to host UTC time after reboot=
,
and restore from saved/paused state.

Cc: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>

---
 drivers/staging/hv/ChannelMgmt.c  |   24 ++++++++++-
 drivers/staging/hv/hyperv_utils.c |   84 +++++++++++++++++++++++++++++++++=
++++
 drivers/staging/hv/utils.h        |   25 ++++++++++-
 3 files changed, 130 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/hv/ChannelMgmt.c b/drivers/staging/hv/ChannelM=
gmt.c
index 445506d..71fe8dd 100644
--- a/drivers/staging/hv/ChannelMgmt.c
+++ b/drivers/staging/hv/ChannelMgmt.c
@@ -33,8 +33,8 @@ struct vmbus_channel_message_table_entry {
 	void (*messageHandler)(struct vmbus_channel_message_header *msg);
 };
=20
-#define MAX_MSG_TYPES                    1
-#define MAX_NUM_DEVICE_CLASSES_SUPPORTED 5
+#define MAX_MSG_TYPES                    2
+#define MAX_NUM_DEVICE_CLASSES_SUPPORTED 6
=20
 static const struct hv_guid
 	gSupportedDeviceClasses[MAX_NUM_DEVICE_CLASSES_SUPPORTED] =3D {
@@ -81,6 +81,14 @@ static const struct hv_guid
 			0x81, 0x8B, 0x38, 0XD9, 0x0C, 0xED, 0x39, 0xDB
 		}
 	},
+	/* {9527E630-D0AE-497b-ADCE-E80AB0175CAF} */
+	/* TimeSync */
+	{
+		.data =3D {
+			0x30, 0xe6, 0x27, 0x95, 0xae, 0xd0, 0x7b, 0x49,
+			0xad, 0xce, 0xe8, 0x0a, 0xb0, 0x17, 0x5c, 0xaf
+		}
+	},
 };
=20
=20
@@ -191,6 +199,18 @@ struct hyperv_service_callback hv_cb_utils[MAX_MSG_TYP=
ES] =3D {
 		.callback =3D chn_cb_negotiate,
 		.log_msg =3D "Shutdown channel functionality initialized"
 	},
+
+	/* {9527E630-D0AE-497b-ADCE-E80AB0175CAF} */
+	/* TimeSync */
+	{
+		.msg_type =3D HV_TIMESYNC_MSG,
+		.data =3D {
+			0x30, 0xe6, 0x27, 0x95, 0xae, 0xd0, 0x7b, 0x49,
+			0xad, 0xce, 0xe8, 0x0a, 0xb0, 0x17, 0x5c, 0xaf
+		},
+		.callback =3D chn_cb_negotiate,
+		.log_msg =3D "Timesync channel functionality initialized"
+	},
 };
 EXPORT_SYMBOL(hv_cb_utils);
=20
diff --git a/drivers/staging/hv/hyperv_utils.c b/drivers/staging/hv/hyperv_=
utils.c
index cbebad3..9174f79 100644
--- a/drivers/staging/hv/hyperv_utils.c
+++ b/drivers/staging/hv/hyperv_utils.c
@@ -106,6 +106,82 @@ static void shutdown_onchannelcallback(void *context)
 		orderly_poweroff(false);
 }
=20
+
+/*
+ * Synchronize time with host after reboot, restore, etc.
+ */
+static void adj_guesttime(winfiletime_t hosttime, u8 flags)
+{
+	s64 host_tns;
+	struct timespec host_ts;
+	static s32 scnt =3D 50;
+
+	host_tns =3D (hosttime - WLTIMEDELTA) * 100;
+	host_ts =3D ns_to_timespec(host_tns);
+
+	if ((flags & ICTIMESYNCFLAG_SYNC) !=3D 0) {
+		do_settimeofday(&host_ts);
+		return;
+	}
+
+	if ((flags & ICTIMESYNCFLAG_SAMPLE) !=3D 0 &&
+	    scnt > 0) {
+		scnt--;
+		do_settimeofday(&host_ts);
+	}
+
+	return;
+}
+
+/*
+ * Time Sync Channel message handler.
+ */
+static void timesync_onchannelcallback(void *context)
+{
+	struct vmbus_channel *channel =3D context;
+	u8 *buf;
+	u32 buflen, recvlen;
+	u64 requestid;
+	struct icmsg_hdr *icmsghdrp;
+	struct ictimesync_data *timedatap;
+
+	DPRINT_ENTER(VMBUS);
+
+	buflen =3D PAGE_SIZE;
+	buf =3D kmalloc(buflen, GFP_ATOMIC);
+
+	VmbusChannelRecvPacket(channel, buf, buflen, &recvlen, &requestid);
+
+	if (recvlen > 0) {
+		DPRINT_DBG(VMBUS, "timesync packet: recvlen=3D%d, requestid=3D%lld",
+			recvlen, requestid);
+
+		icmsghdrp =3D (struct icmsg_hdr *)&buf[
+				sizeof(struct vmbuspipe_hdr)];
+
+		if (icmsghdrp->icmsgtype =3D=3D ICMSGTYPE_NEGOTIATE) {
+			prep_negotiate_resp(icmsghdrp, NULL, buf);
+		} else {
+			timedatap =3D (struct ictimesync_data *)&buf[
+				sizeof(struct vmbuspipe_hdr) +
+				sizeof(struct icmsg_hdr)];
+			adj_guesttime(timedatap->parenttime, timedatap->flags);
+		}
+
+		icmsghdrp->icflags =3D ICMSGHDRFLAG_TRANSACTION
+			| ICMSGHDRFLAG_RESPONSE;
+
+		VmbusChannelSendPacket(channel, buf,
+				recvlen, requestid,
+				VmbusPacketTypeDataInBand, 0);
+	}
+
+	kfree(buf);
+
+	DPRINT_EXIT(VMBUS);
+}
+
+
 static int __init init_hyperv_utils(void)
 {
 	printk(KERN_INFO "Registering HyperV Utility Driver\n");
@@ -114,6 +190,10 @@ static int __init init_hyperv_utils(void)
 		&shutdown_onchannelcallback;
 	hv_cb_utils[HV_SHUTDOWN_MSG].callback =3D &shutdown_onchannelcallback;
=20
+	hv_cb_utils[HV_TIMESYNC_MSG].channel->OnChannelCallback =3D
+		&timesync_onchannelcallback;
+	hv_cb_utils[HV_TIMESYNC_MSG].callback =3D &timesync_onchannelcallback;
+
 	return 0;
 }
=20
@@ -124,6 +204,10 @@ static void exit_hyperv_utils(void)
 	hv_cb_utils[HV_SHUTDOWN_MSG].channel->OnChannelCallback =3D
 		&chn_cb_negotiate;
 	hv_cb_utils[HV_SHUTDOWN_MSG].callback =3D &chn_cb_negotiate;
+
+	hv_cb_utils[HV_TIMESYNC_MSG].channel->OnChannelCallback =3D
+		&chn_cb_negotiate;
+	hv_cb_utils[HV_TIMESYNC_MSG].callback =3D &chn_cb_negotiate;
 }
=20
 module_init(init_hyperv_utils);
diff --git a/drivers/staging/hv/utils.h b/drivers/staging/hv/utils.h
index e404b21..d1d2f28 100644
--- a/drivers/staging/hv/utils.h
+++ b/drivers/staging/hv/utils.h
@@ -75,7 +75,30 @@ struct shutdown_msg_data {
 	u8  display_message[2048];
 } __attribute__((packed));
=20
-#define HV_SHUTDOWN_MSG		0
+
+/* Time Sync IC defs */
+#define ICTIMESYNCFLAG_PROBE 0
+#define ICTIMESYNCFLAG_SYNC 1
+#define ICTIMESYNCFLAG_SAMPLE 2
+
+#ifdef __x86_64__
+#define WLTIMEDELTA 116444736000000000L  /* in 100ns unit */
+#else
+#define WLTIMEDELTA 116444736000000000LL
+#endif
+
+typedef u64 winfiletime_t; /* Windows FILETIME type */
+
+struct ictimesync_data{
+    winfiletime_t parenttime;
+    winfiletime_t childtime;
+    winfiletime_t roundtriptime;
+    u8 flags;
+} __attribute__((packed));
+
+/* Index for each IC struct in array hv_cb_utils[] */
+#define HV_SHUTDOWN_MSG 0
+#define HV_TIMESYNC_MSG 1
=20
 struct hyperv_service_callback {
 	u8 msg_type;
--=20
1.6.3.2


--_002_1FB5E1D5CA062146B38059374562DF72662A6D3BTK5EX14MBXC130r_
Content-Type: application/octet-stream; name="0505-timesync-ic.patch"
Content-Description: 0505-timesync-ic.patch
Content-Disposition: attachment; filename="0505-timesync-ic.patch"; size=5800;
	creation-date="Wed, 05 May 2010 19:14:45 GMT";
	modification-date="Wed, 05 May 2010 20:10:27 GMT"
Content-Transfer-Encoding: base64

RnJvbTogSGFpeWFuZyBaaGFuZyA8aGFpeWFuZ3pAbWljcm9zb2Z0LmNvbT4KClN1YmplY3Q6IEFk
ZCBUaW1lIFN5bmMgZmVhdHVyZSB0byBodl91dGlscyBtb2R1bGUuClRoZSBUaW1lIFN5bmMgZmVh
dHVyZSBzeW5jaHJvbml6ZXMgZ3Vlc3QgdGltZSB0byBob3N0IFVUQyB0aW1lIGFmdGVyIHJlYm9v
dCwKYW5kIHJlc3RvcmUgZnJvbSBzYXZlZC9wYXVzZWQgc3RhdGUuCgpDYzogR3JlZyBLcm9haC1I
YXJ0bWFuIDxncmVna2hAc3VzZS5kZT4KU2lnbmVkLW9mZi1ieTogSGFuayBKYW5zc2VuIDxoamFu
c3NlbkBtaWNyb3NvZnQuY29tPgpTaWduZWQtb2ZmLWJ5OiBIYWl5YW5nIFpoYW5nIDxoYWl5YW5n
ekBtaWNyb3NvZnQuY29tPgoKLS0tCiBkcml2ZXJzL3N0YWdpbmcvaHYvQ2hhbm5lbE1nbXQuYyAg
fCAgIDI0ICsrKysrKysrKystCiBkcml2ZXJzL3N0YWdpbmcvaHYvaHlwZXJ2X3V0aWxzLmMgfCAg
IDg0ICsrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysKIGRyaXZlcnMvc3RhZ2lu
Zy9odi91dGlscy5oICAgICAgICB8ICAgMjUgKysrKysrKysrKy0KIDMgZmlsZXMgY2hhbmdlZCwg
MTMwIGluc2VydGlvbnMoKyksIDMgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvZHJpdmVycy9z
dGFnaW5nL2h2L0NoYW5uZWxNZ210LmMgYi9kcml2ZXJzL3N0YWdpbmcvaHYvQ2hhbm5lbE1nbXQu
YwppbmRleCA0NDU1MDZkLi43MWZlOGRkIDEwMDY0NAotLS0gYS9kcml2ZXJzL3N0YWdpbmcvaHYv
Q2hhbm5lbE1nbXQuYworKysgYi9kcml2ZXJzL3N0YWdpbmcvaHYvQ2hhbm5lbE1nbXQuYwpAQCAt
MzMsOCArMzMsOCBAQCBzdHJ1Y3Qgdm1idXNfY2hhbm5lbF9tZXNzYWdlX3RhYmxlX2VudHJ5IHsK
IAl2b2lkICgqbWVzc2FnZUhhbmRsZXIpKHN0cnVjdCB2bWJ1c19jaGFubmVsX21lc3NhZ2VfaGVh
ZGVyICptc2cpOwogfTsKIAotI2RlZmluZSBNQVhfTVNHX1RZUEVTICAgICAgICAgICAgICAgICAg
ICAxCi0jZGVmaW5lIE1BWF9OVU1fREVWSUNFX0NMQVNTRVNfU1VQUE9SVEVEIDUKKyNkZWZpbmUg
TUFYX01TR19UWVBFUyAgICAgICAgICAgICAgICAgICAgMgorI2RlZmluZSBNQVhfTlVNX0RFVklD
RV9DTEFTU0VTX1NVUFBPUlRFRCA2CiAKIHN0YXRpYyBjb25zdCBzdHJ1Y3QgaHZfZ3VpZAogCWdT
dXBwb3J0ZWREZXZpY2VDbGFzc2VzW01BWF9OVU1fREVWSUNFX0NMQVNTRVNfU1VQUE9SVEVEXSA9
IHsKQEAgLTgxLDYgKzgxLDE0IEBAIHN0YXRpYyBjb25zdCBzdHJ1Y3QgaHZfZ3VpZAogCQkJMHg4
MSwgMHg4QiwgMHgzOCwgMFhEOSwgMHgwQywgMHhFRCwgMHgzOSwgMHhEQgogCQl9CiAJfSwKKwkv
KiB7OTUyN0U2MzAtRDBBRS00OTdiLUFEQ0UtRTgwQUIwMTc1Q0FGfSAqLworCS8qIFRpbWVTeW5j
ICovCisJeworCQkuZGF0YSA9IHsKKwkJCTB4MzAsIDB4ZTYsIDB4MjcsIDB4OTUsIDB4YWUsIDB4
ZDAsIDB4N2IsIDB4NDksCisJCQkweGFkLCAweGNlLCAweGU4LCAweDBhLCAweGIwLCAweDE3LCAw
eDVjLCAweGFmCisJCX0KKwl9LAogfTsKIAogCkBAIC0xOTEsNiArMTk5LDE4IEBAIHN0cnVjdCBo
eXBlcnZfc2VydmljZV9jYWxsYmFjayBodl9jYl91dGlsc1tNQVhfTVNHX1RZUEVTXSA9IHsKIAkJ
LmNhbGxiYWNrID0gY2huX2NiX25lZ290aWF0ZSwKIAkJLmxvZ19tc2cgPSAiU2h1dGRvd24gY2hh
bm5lbCBmdW5jdGlvbmFsaXR5IGluaXRpYWxpemVkIgogCX0sCisKKwkvKiB7OTUyN0U2MzAtRDBB
RS00OTdiLUFEQ0UtRTgwQUIwMTc1Q0FGfSAqLworCS8qIFRpbWVTeW5jICovCisJeworCQkubXNn
X3R5cGUgPSBIVl9USU1FU1lOQ19NU0csCisJCS5kYXRhID0geworCQkJMHgzMCwgMHhlNiwgMHgy
NywgMHg5NSwgMHhhZSwgMHhkMCwgMHg3YiwgMHg0OSwKKwkJCTB4YWQsIDB4Y2UsIDB4ZTgsIDB4
MGEsIDB4YjAsIDB4MTcsIDB4NWMsIDB4YWYKKwkJfSwKKwkJLmNhbGxiYWNrID0gY2huX2NiX25l
Z290aWF0ZSwKKwkJLmxvZ19tc2cgPSAiVGltZXN5bmMgY2hhbm5lbCBmdW5jdGlvbmFsaXR5IGlu
aXRpYWxpemVkIgorCX0sCiB9OwogRVhQT1JUX1NZTUJPTChodl9jYl91dGlscyk7CiAKZGlmZiAt
LWdpdCBhL2RyaXZlcnMvc3RhZ2luZy9odi9oeXBlcnZfdXRpbHMuYyBiL2RyaXZlcnMvc3RhZ2lu
Zy9odi9oeXBlcnZfdXRpbHMuYwppbmRleCBjYmViYWQzLi45MTc0Zjc5IDEwMDY0NAotLS0gYS9k
cml2ZXJzL3N0YWdpbmcvaHYvaHlwZXJ2X3V0aWxzLmMKKysrIGIvZHJpdmVycy9zdGFnaW5nL2h2
L2h5cGVydl91dGlscy5jCkBAIC0xMDYsNiArMTA2LDgyIEBAIHN0YXRpYyB2b2lkIHNodXRkb3du
X29uY2hhbm5lbGNhbGxiYWNrKHZvaWQgKmNvbnRleHQpCiAJCW9yZGVybHlfcG93ZXJvZmYoZmFs
c2UpOwogfQogCisKKy8qCisgKiBTeW5jaHJvbml6ZSB0aW1lIHdpdGggaG9zdCBhZnRlciByZWJv
b3QsIHJlc3RvcmUsIGV0Yy4KKyAqLworc3RhdGljIHZvaWQgYWRqX2d1ZXN0dGltZSh3aW5maWxl
dGltZV90IGhvc3R0aW1lLCB1OCBmbGFncykKK3sKKwlzNjQgaG9zdF90bnM7CisJc3RydWN0IHRp
bWVzcGVjIGhvc3RfdHM7CisJc3RhdGljIHMzMiBzY250ID0gNTA7CisKKwlob3N0X3RucyA9ICho
b3N0dGltZSAtIFdMVElNRURFTFRBKSAqIDEwMDsKKwlob3N0X3RzID0gbnNfdG9fdGltZXNwZWMo
aG9zdF90bnMpOworCisJaWYgKChmbGFncyAmIElDVElNRVNZTkNGTEFHX1NZTkMpICE9IDApIHsK
KwkJZG9fc2V0dGltZW9mZGF5KCZob3N0X3RzKTsKKwkJcmV0dXJuOworCX0KKworCWlmICgoZmxh
Z3MgJiBJQ1RJTUVTWU5DRkxBR19TQU1QTEUpICE9IDAgJiYKKwkgICAgc2NudCA+IDApIHsKKwkJ
c2NudC0tOworCQlkb19zZXR0aW1lb2ZkYXkoJmhvc3RfdHMpOworCX0KKworCXJldHVybjsKK30K
KworLyoKKyAqIFRpbWUgU3luYyBDaGFubmVsIG1lc3NhZ2UgaGFuZGxlci4KKyAqLworc3RhdGlj
IHZvaWQgdGltZXN5bmNfb25jaGFubmVsY2FsbGJhY2sodm9pZCAqY29udGV4dCkKK3sKKwlzdHJ1
Y3Qgdm1idXNfY2hhbm5lbCAqY2hhbm5lbCA9IGNvbnRleHQ7CisJdTggKmJ1ZjsKKwl1MzIgYnVm
bGVuLCByZWN2bGVuOworCXU2NCByZXF1ZXN0aWQ7CisJc3RydWN0IGljbXNnX2hkciAqaWNtc2do
ZHJwOworCXN0cnVjdCBpY3RpbWVzeW5jX2RhdGEgKnRpbWVkYXRhcDsKKworCURQUklOVF9FTlRF
UihWTUJVUyk7CisKKwlidWZsZW4gPSBQQUdFX1NJWkU7CisJYnVmID0ga21hbGxvYyhidWZsZW4s
IEdGUF9BVE9NSUMpOworCisJVm1idXNDaGFubmVsUmVjdlBhY2tldChjaGFubmVsLCBidWYsIGJ1
ZmxlbiwgJnJlY3ZsZW4sICZyZXF1ZXN0aWQpOworCisJaWYgKHJlY3ZsZW4gPiAwKSB7CisJCURQ
UklOVF9EQkcoVk1CVVMsICJ0aW1lc3luYyBwYWNrZXQ6IHJlY3ZsZW49JWQsIHJlcXVlc3RpZD0l
bGxkIiwKKwkJCXJlY3ZsZW4sIHJlcXVlc3RpZCk7CisKKwkJaWNtc2doZHJwID0gKHN0cnVjdCBp
Y21zZ19oZHIgKikmYnVmWworCQkJCXNpemVvZihzdHJ1Y3Qgdm1idXNwaXBlX2hkcildOworCisJ
CWlmIChpY21zZ2hkcnAtPmljbXNndHlwZSA9PSBJQ01TR1RZUEVfTkVHT1RJQVRFKSB7CisJCQlw
cmVwX25lZ290aWF0ZV9yZXNwKGljbXNnaGRycCwgTlVMTCwgYnVmKTsKKwkJfSBlbHNlIHsKKwkJ
CXRpbWVkYXRhcCA9IChzdHJ1Y3QgaWN0aW1lc3luY19kYXRhICopJmJ1ZlsKKwkJCQlzaXplb2Yo
c3RydWN0IHZtYnVzcGlwZV9oZHIpICsKKwkJCQlzaXplb2Yoc3RydWN0IGljbXNnX2hkcildOwor
CQkJYWRqX2d1ZXN0dGltZSh0aW1lZGF0YXAtPnBhcmVudHRpbWUsIHRpbWVkYXRhcC0+ZmxhZ3Mp
OworCQl9CisKKwkJaWNtc2doZHJwLT5pY2ZsYWdzID0gSUNNU0dIRFJGTEFHX1RSQU5TQUNUSU9O
CisJCQl8IElDTVNHSERSRkxBR19SRVNQT05TRTsKKworCQlWbWJ1c0NoYW5uZWxTZW5kUGFja2V0
KGNoYW5uZWwsIGJ1ZiwKKwkJCQlyZWN2bGVuLCByZXF1ZXN0aWQsCisJCQkJVm1idXNQYWNrZXRU
eXBlRGF0YUluQmFuZCwgMCk7CisJfQorCisJa2ZyZWUoYnVmKTsKKworCURQUklOVF9FWElUKFZN
QlVTKTsKK30KKworCiBzdGF0aWMgaW50IF9faW5pdCBpbml0X2h5cGVydl91dGlscyh2b2lkKQog
ewogCXByaW50ayhLRVJOX0lORk8gIlJlZ2lzdGVyaW5nIEh5cGVyViBVdGlsaXR5IERyaXZlclxu
Iik7CkBAIC0xMTQsNiArMTkwLDEwIEBAIHN0YXRpYyBpbnQgX19pbml0IGluaXRfaHlwZXJ2X3V0
aWxzKHZvaWQpCiAJCSZzaHV0ZG93bl9vbmNoYW5uZWxjYWxsYmFjazsKIAlodl9jYl91dGlsc1tI
Vl9TSFVURE9XTl9NU0ddLmNhbGxiYWNrID0gJnNodXRkb3duX29uY2hhbm5lbGNhbGxiYWNrOwog
CisJaHZfY2JfdXRpbHNbSFZfVElNRVNZTkNfTVNHXS5jaGFubmVsLT5PbkNoYW5uZWxDYWxsYmFj
ayA9CisJCSZ0aW1lc3luY19vbmNoYW5uZWxjYWxsYmFjazsKKwlodl9jYl91dGlsc1tIVl9USU1F
U1lOQ19NU0ddLmNhbGxiYWNrID0gJnRpbWVzeW5jX29uY2hhbm5lbGNhbGxiYWNrOworCiAJcmV0
dXJuIDA7CiB9CiAKQEAgLTEyNCw2ICsyMDQsMTAgQEAgc3RhdGljIHZvaWQgZXhpdF9oeXBlcnZf
dXRpbHModm9pZCkKIAlodl9jYl91dGlsc1tIVl9TSFVURE9XTl9NU0ddLmNoYW5uZWwtPk9uQ2hh
bm5lbENhbGxiYWNrID0KIAkJJmNobl9jYl9uZWdvdGlhdGU7CiAJaHZfY2JfdXRpbHNbSFZfU0hV
VERPV05fTVNHXS5jYWxsYmFjayA9ICZjaG5fY2JfbmVnb3RpYXRlOworCisJaHZfY2JfdXRpbHNb
SFZfVElNRVNZTkNfTVNHXS5jaGFubmVsLT5PbkNoYW5uZWxDYWxsYmFjayA9CisJCSZjaG5fY2Jf
bmVnb3RpYXRlOworCWh2X2NiX3V0aWxzW0hWX1RJTUVTWU5DX01TR10uY2FsbGJhY2sgPSAmY2hu
X2NiX25lZ290aWF0ZTsKIH0KIAogbW9kdWxlX2luaXQoaW5pdF9oeXBlcnZfdXRpbHMpOwpkaWZm
IC0tZ2l0IGEvZHJpdmVycy9zdGFnaW5nL2h2L3V0aWxzLmggYi9kcml2ZXJzL3N0YWdpbmcvaHYv
dXRpbHMuaAppbmRleCBlNDA0YjIxLi5kMWQyZjI4IDEwMDY0NAotLS0gYS9kcml2ZXJzL3N0YWdp
bmcvaHYvdXRpbHMuaAorKysgYi9kcml2ZXJzL3N0YWdpbmcvaHYvdXRpbHMuaApAQCAtNzUsNyAr
NzUsMzAgQEAgc3RydWN0IHNodXRkb3duX21zZ19kYXRhIHsKIAl1OCAgZGlzcGxheV9tZXNzYWdl
WzIwNDhdOwogfSBfX2F0dHJpYnV0ZV9fKChwYWNrZWQpKTsKIAotI2RlZmluZSBIVl9TSFVURE9X
Tl9NU0cJCTAKKworLyogVGltZSBTeW5jIElDIGRlZnMgKi8KKyNkZWZpbmUgSUNUSU1FU1lOQ0ZM
QUdfUFJPQkUgMAorI2RlZmluZSBJQ1RJTUVTWU5DRkxBR19TWU5DIDEKKyNkZWZpbmUgSUNUSU1F
U1lOQ0ZMQUdfU0FNUExFIDIKKworI2lmZGVmIF9feDg2XzY0X18KKyNkZWZpbmUgV0xUSU1FREVM
VEEgMTE2NDQ0NzM2MDAwMDAwMDAwTCAgLyogaW4gMTAwbnMgdW5pdCAqLworI2Vsc2UKKyNkZWZp
bmUgV0xUSU1FREVMVEEgMTE2NDQ0NzM2MDAwMDAwMDAwTEwKKyNlbmRpZgorCit0eXBlZGVmIHU2
NCB3aW5maWxldGltZV90OyAvKiBXaW5kb3dzIEZJTEVUSU1FIHR5cGUgKi8KKworc3RydWN0IGlj
dGltZXN5bmNfZGF0YXsKKyAgICB3aW5maWxldGltZV90IHBhcmVudHRpbWU7CisgICAgd2luZmls
ZXRpbWVfdCBjaGlsZHRpbWU7CisgICAgd2luZmlsZXRpbWVfdCByb3VuZHRyaXB0aW1lOworICAg
IHU4IGZsYWdzOworfSBfX2F0dHJpYnV0ZV9fKChwYWNrZWQpKTsKKworLyogSW5kZXggZm9yIGVh
Y2ggSUMgc3RydWN0IGluIGFycmF5IGh2X2NiX3V0aWxzW10gKi8KKyNkZWZpbmUgSFZfU0hVVERP
V05fTVNHIDAKKyNkZWZpbmUgSFZfVElNRVNZTkNfTVNHIDEKIAogc3RydWN0IGh5cGVydl9zZXJ2
aWNlX2NhbGxiYWNrIHsKIAl1OCBtc2dfdHlwZTsKLS0gCjEuNi4zLjIKCg==

--_002_1FB5E1D5CA062146B38059374562DF72662A6D3BTK5EX14MBXC130r_--
