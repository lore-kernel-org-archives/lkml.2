Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756242Ab0LROOn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Dec 2010 09:14:43 -0500
Received: from mga02.intel.com ([134.134.136.20]:20958 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756195Ab0LROOm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Dec 2010 09:14:42 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,193,1291622400"; 
   d="scan'208";a="688453619"
From: "R, Durgadoss" <durgadoss.r@intel.com>
To: "Yu, Fenghua" <fenghua.yu@intel.com>,
        "khali@linux-fr.org" <khali@linux-fr.org>,
        Guenter Roeck <guenter.roeck@ericsson.com>,
        "Brown, Len" <len.brown@intel.com>,
        "mingo@redhat.com" <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>
CC: "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Sat, 18 Dec 2010 19:44:37 +0530
Subject: Patch[2/2] Adding_Notification_Support_to_Coretemp
Thread-Topic: Patch[2/2] Adding_Notification_Support_to_Coretemp
Thread-Index: Acuevebn4gbhrJ3VQS+r6nB4P+9uBg==
Message-ID: <D6D887BA8C9DFF48B5233887EF04654105C1173BCE@bgsmsx502.gar.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: multipart/mixed;
	boundary="_002_D6D887BA8C9DFF48B5233887EF04654105C1173BCEbgsmsx502garc_"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--_002_D6D887BA8C9DFF48B5233887EF04654105C1173BCEbgsmsx502garc_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Hi,

This is the second patch in the series.
This patch adds support for coretemp to notify the
threshold violations using netlink events.

This patch has a dependency on the patch=20
"Adding Notification support to the thermal framework"
which can be downloaded from here:
https://patchwork.kernel.org/patch/282042/

Kindly review and merge.
------------------------------------------------------
From: Durgadoss R <durgadoss.r@intel.com>

Date: Sat, 18 Dec 2010 07:23:21 +0530
Subject: [PATCH 2/2] Adding_Notification_Support_to_Coretemp

Thos patch adds event notification support to coretemp.
Whenever a threshold interrupt occurs, it is notified to
the user space by a netlink event.

Signed-off-by: Durgadoss R <durgadoss.r@intel.com>

---
 drivers/hwmon/coretemp.c |   45 ++++++++++++++++++++++++++++++++++++++++++=
+--
 1 files changed, 43 insertions(+), 2 deletions(-)

diff --git a/drivers/hwmon/coretemp.c b/drivers/hwmon/coretemp.c
index 025902f..c28a61f 100644
--- a/drivers/hwmon/coretemp.c
+++ b/drivers/hwmon/coretemp.c
@@ -37,9 +37,16 @@
 #include <asm/processor.h>
 #include <asm/smp.h>
 #include <asm/mce.h>
+#include <linux/thermal.h>
=20
 #define DRVNAME	"coretemp"
=20
+/* An identification number to the DTS sensor.
+ * This will help the user space to figure out which
+ * sensor caused the event
+ */
+#define DTS_ID 0
+
 enum attributes { SHOW_TEMP, SHOW_TJMAX, CORE_TTARGET, CORE_TMIN, SHOW_LAB=
EL,
 		SHOW_NAME, SHOW_CRIT_ALARM, SHOW_MAX_ALARM } attrs;
=20
@@ -68,6 +75,22 @@ struct coretemp_data {
 static void update_alarm(struct coretemp_data *data);
 static int set_core_threshold(struct coretemp_data *data, int temp, int th=
res);
=20
+/* Interrupt Handlers for core/package thresholds */
+struct work_struct *t0_netlink_handlr;
+struct work_struct *t1_netlink_handlr;
+
+/* Send netlink event for DTS sensor reaching threshold0 */
+static void gen_netlink_t0(struct work_struct *work)
+{
+	generate_netlink_event(DTS_ID, THERMAL_AUX0);
+}
+
+/* Send netlink event for DTS sensor reaching threshold1 */
+static void gen_netlink_t1(struct work_struct *work)
+{
+	generate_netlink_event(DTS_ID, THERMAL_AUX1);
+}
+
 /*
  * Sysfs stuff
  */
@@ -368,15 +391,19 @@ static int coretemp_interrupt(__u64 msr_val)
 {
=20
 	if (msr_val & THERM_LOG_THRESHOLD0) {
-		if (!(msr_val & THERM_STATUS_THRESHOLD0))
+		if (!(msr_val & THERM_STATUS_THRESHOLD0)) {
 			pr_info("%s:Lower Threshold Reached\n", __func__);
+			schedule_work(t0_netlink_handlr);
+		}
 		/* Reset the Threshold0 interrupt */
 		wrmsrl(MSR_IA32_THERM_STATUS, msr_val & ~THERM_LOG_THRESHOLD0);
 	}
=20
 	if (msr_val & THERM_LOG_THRESHOLD1) {
-		if (msr_val & THERM_STATUS_THRESHOLD1)
+		if (msr_val & THERM_STATUS_THRESHOLD1) {
 			pr_info("%s:Upper Threshold Reached\n", __func__);
+			schedule_work(t1_netlink_handlr);
+		}
 		/* Reset the Threshold1 interrupt */
 		wrmsrl(MSR_IA32_THERM_STATUS, msr_val & ~THERM_LOG_THRESHOLD1);
 	}
@@ -743,6 +770,20 @@ static int __init coretemp_init(void)
 #endif
=20
 	register_hotcpu_notifier(&coretemp_cpu_notifier);
+
+	/* Initialize the Interrupt Handlers */
+	t0_netlink_handlr =3D kzalloc(sizeof(struct work_struct), GFP_KERNEL);
+	if (!t0_netlink_handlr)
+		return -ENOMEM;
+
+	t1_netlink_handlr =3D kzalloc(sizeof(struct work_struct), GFP_KERNEL);
+	if (!t1_netlink_handlr) {
+		kfree(t0_netlink_handlr);
+		return -ENOMEM;
+	}
+	INIT_WORK(t0_netlink_handlr, (void *)gen_netlink_t0);
+	INIT_WORK(t1_netlink_handlr, (void *)gen_netlink_t1);
+
 	return 0;
=20
 #ifndef CONFIG_HOTPLUG_CPU
--=20
1.6.5.2


--_002_D6D887BA8C9DFF48B5233887EF04654105C1173BCEbgsmsx502garc_
Content-Type: application/octet-stream;
	name="0002-Adding_Notification_Support_to_Coretemp.patch"
Content-Description: 0002-Adding_Notification_Support_to_Coretemp.patch
Content-Disposition: attachment;
	filename="0002-Adding_Notification_Support_to_Coretemp.patch"; size=3112;
	creation-date="Sat, 18 Dec 2010 19:27:26 GMT";
	modification-date="Sat, 18 Dec 2010 07:25:44 GMT"
Content-Transfer-Encoding: base64

RnJvbTogRHVyZ2Fkb3NzIFIgPGR1cmdhZG9zcy5yQGludGVsLmNvbT4KRGF0ZTogU2F0LCAxOCBE
ZWMgMjAxMCAwNzoyMzoyMSArMDUzMApTdWJqZWN0OiBbUEFUQ0ggMi8yXSBBZGRpbmdfTm90aWZp
Y2F0aW9uX1N1cHBvcnRfdG9fQ29yZXRlbXAKClRob3MgcGF0Y2ggYWRkcyBldmVudCBub3RpZmlj
YXRpb24gc3VwcG9ydCB0byBjb3JldGVtcC4KV2hlbmV2ZXIgYSB0aHJlc2hvbGQgaW50ZXJydXB0
IG9jY3VycywgaXQgaXMgbm90aWZpZWQgdG8KdGhlIHVzZXIgc3BhY2UgYnkgYSBuZXRsaW5rIGV2
ZW50LgoKU2lnbmVkLW9mZi1ieTogRHVyZ2Fkb3NzIFIgPGR1cmdhZG9zcy5yQGludGVsLmNvbT4K
LS0tCiBkcml2ZXJzL2h3bW9uL2NvcmV0ZW1wLmMgfCAgIDQ1ICsrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKystLQogMSBmaWxlcyBjaGFuZ2VkLCA0MyBpbnNlcnRpb25z
KCspLCAyIGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2RyaXZlcnMvaHdtb24vY29yZXRlbXAu
YyBiL2RyaXZlcnMvaHdtb24vY29yZXRlbXAuYwppbmRleCAwMjU5MDJmLi5jMjhhNjFmIDEwMDY0
NAotLS0gYS9kcml2ZXJzL2h3bW9uL2NvcmV0ZW1wLmMKKysrIGIvZHJpdmVycy9od21vbi9jb3Jl
dGVtcC5jCkBAIC0zNyw5ICszNywxNiBAQAogI2luY2x1ZGUgPGFzbS9wcm9jZXNzb3IuaD4KICNp
bmNsdWRlIDxhc20vc21wLmg+CiAjaW5jbHVkZSA8YXNtL21jZS5oPgorI2luY2x1ZGUgPGxpbnV4
L3RoZXJtYWwuaD4KIAogI2RlZmluZSBEUlZOQU1FCSJjb3JldGVtcCIKIAorLyogQW4gaWRlbnRp
ZmljYXRpb24gbnVtYmVyIHRvIHRoZSBEVFMgc2Vuc29yLgorICogVGhpcyB3aWxsIGhlbHAgdGhl
IHVzZXIgc3BhY2UgdG8gZmlndXJlIG91dCB3aGljaAorICogc2Vuc29yIGNhdXNlZCB0aGUgZXZl
bnQKKyAqLworI2RlZmluZSBEVFNfSUQgMAorCiBlbnVtIGF0dHJpYnV0ZXMgeyBTSE9XX1RFTVAs
IFNIT1dfVEpNQVgsIENPUkVfVFRBUkdFVCwgQ09SRV9UTUlOLCBTSE9XX0xBQkVMLAogCQlTSE9X
X05BTUUsIFNIT1dfQ1JJVF9BTEFSTSwgU0hPV19NQVhfQUxBUk0gfSBhdHRyczsKIApAQCAtNjgs
NiArNzUsMjIgQEAgc3RydWN0IGNvcmV0ZW1wX2RhdGEgewogc3RhdGljIHZvaWQgdXBkYXRlX2Fs
YXJtKHN0cnVjdCBjb3JldGVtcF9kYXRhICpkYXRhKTsKIHN0YXRpYyBpbnQgc2V0X2NvcmVfdGhy
ZXNob2xkKHN0cnVjdCBjb3JldGVtcF9kYXRhICpkYXRhLCBpbnQgdGVtcCwgaW50IHRocmVzKTsK
IAorLyogSW50ZXJydXB0IEhhbmRsZXJzIGZvciBjb3JlL3BhY2thZ2UgdGhyZXNob2xkcyAqLwor
c3RydWN0IHdvcmtfc3RydWN0ICp0MF9uZXRsaW5rX2hhbmRscjsKK3N0cnVjdCB3b3JrX3N0cnVj
dCAqdDFfbmV0bGlua19oYW5kbHI7CisKKy8qIFNlbmQgbmV0bGluayBldmVudCBmb3IgRFRTIHNl
bnNvciByZWFjaGluZyB0aHJlc2hvbGQwICovCitzdGF0aWMgdm9pZCBnZW5fbmV0bGlua190MChz
dHJ1Y3Qgd29ya19zdHJ1Y3QgKndvcmspCit7CisJZ2VuZXJhdGVfbmV0bGlua19ldmVudChEVFNf
SUQsIFRIRVJNQUxfQVVYMCk7Cit9CisKKy8qIFNlbmQgbmV0bGluayBldmVudCBmb3IgRFRTIHNl
bnNvciByZWFjaGluZyB0aHJlc2hvbGQxICovCitzdGF0aWMgdm9pZCBnZW5fbmV0bGlua190MShz
dHJ1Y3Qgd29ya19zdHJ1Y3QgKndvcmspCit7CisJZ2VuZXJhdGVfbmV0bGlua19ldmVudChEVFNf
SUQsIFRIRVJNQUxfQVVYMSk7Cit9CisKIC8qCiAgKiBTeXNmcyBzdHVmZgogICovCkBAIC0zNjgs
MTUgKzM5MSwxOSBAQCBzdGF0aWMgaW50IGNvcmV0ZW1wX2ludGVycnVwdChfX3U2NCBtc3JfdmFs
KQogewogCiAJaWYgKG1zcl92YWwgJiBUSEVSTV9MT0dfVEhSRVNIT0xEMCkgewotCQlpZiAoISht
c3JfdmFsICYgVEhFUk1fU1RBVFVTX1RIUkVTSE9MRDApKQorCQlpZiAoIShtc3JfdmFsICYgVEhF
Uk1fU1RBVFVTX1RIUkVTSE9MRDApKSB7CiAJCQlwcl9pbmZvKCIlczpMb3dlciBUaHJlc2hvbGQg
UmVhY2hlZFxuIiwgX19mdW5jX18pOworCQkJc2NoZWR1bGVfd29yayh0MF9uZXRsaW5rX2hhbmRs
cik7CisJCX0KIAkJLyogUmVzZXQgdGhlIFRocmVzaG9sZDAgaW50ZXJydXB0ICovCiAJCXdybXNy
bChNU1JfSUEzMl9USEVSTV9TVEFUVVMsIG1zcl92YWwgJiB+VEhFUk1fTE9HX1RIUkVTSE9MRDAp
OwogCX0KIAogCWlmIChtc3JfdmFsICYgVEhFUk1fTE9HX1RIUkVTSE9MRDEpIHsKLQkJaWYgKG1z
cl92YWwgJiBUSEVSTV9TVEFUVVNfVEhSRVNIT0xEMSkKKwkJaWYgKG1zcl92YWwgJiBUSEVSTV9T
VEFUVVNfVEhSRVNIT0xEMSkgewogCQkJcHJfaW5mbygiJXM6VXBwZXIgVGhyZXNob2xkIFJlYWNo
ZWRcbiIsIF9fZnVuY19fKTsKKwkJCXNjaGVkdWxlX3dvcmsodDFfbmV0bGlua19oYW5kbHIpOwor
CQl9CiAJCS8qIFJlc2V0IHRoZSBUaHJlc2hvbGQxIGludGVycnVwdCAqLwogCQl3cm1zcmwoTVNS
X0lBMzJfVEhFUk1fU1RBVFVTLCBtc3JfdmFsICYgflRIRVJNX0xPR19USFJFU0hPTEQxKTsKIAl9
CkBAIC03NDMsNiArNzcwLDIwIEBAIHN0YXRpYyBpbnQgX19pbml0IGNvcmV0ZW1wX2luaXQodm9p
ZCkKICNlbmRpZgogCiAJcmVnaXN0ZXJfaG90Y3B1X25vdGlmaWVyKCZjb3JldGVtcF9jcHVfbm90
aWZpZXIpOworCisJLyogSW5pdGlhbGl6ZSB0aGUgSW50ZXJydXB0IEhhbmRsZXJzICovCisJdDBf
bmV0bGlua19oYW5kbHIgPSBremFsbG9jKHNpemVvZihzdHJ1Y3Qgd29ya19zdHJ1Y3QpLCBHRlBf
S0VSTkVMKTsKKwlpZiAoIXQwX25ldGxpbmtfaGFuZGxyKQorCQlyZXR1cm4gLUVOT01FTTsKKwor
CXQxX25ldGxpbmtfaGFuZGxyID0ga3phbGxvYyhzaXplb2Yoc3RydWN0IHdvcmtfc3RydWN0KSwg
R0ZQX0tFUk5FTCk7CisJaWYgKCF0MV9uZXRsaW5rX2hhbmRscikgeworCQlrZnJlZSh0MF9uZXRs
aW5rX2hhbmRscik7CisJCXJldHVybiAtRU5PTUVNOworCX0KKwlJTklUX1dPUksodDBfbmV0bGlu
a19oYW5kbHIsICh2b2lkICopZ2VuX25ldGxpbmtfdDApOworCUlOSVRfV09SSyh0MV9uZXRsaW5r
X2hhbmRsciwgKHZvaWQgKilnZW5fbmV0bGlua190MSk7CisKIAlyZXR1cm4gMDsKIAogI2lmbmRl
ZiBDT05GSUdfSE9UUExVR19DUFUKLS0gCjEuNi41LjIKCg==

--_002_D6D887BA8C9DFF48B5233887EF04654105C1173BCEbgsmsx502garc_--
