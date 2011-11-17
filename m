Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752771Ab1KQU4J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Nov 2011 15:56:09 -0500
Received: from usindpps03.hds.com ([207.126.252.16]:47899 "EHLO
	usindpps03.hds.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751520Ab1KQU4H convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Nov 2011 15:56:07 -0500
From: Seiji Aguchi <seiji.aguchi@hds.com>
To: "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "lenb@kernel.org" <lenb@kernel.org>,
        "Luck, Tony" <tony.luck@intel.com>, "Chen, Gong" <gong.chen@intel.com>,
        Matthew Garrett <mjg@redhat.com>,
        "ying.huang@intel.com" <ying.huang@intel.com>
CC: "dle-develop@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>,
        Satoru Moriya <satoru.moriya@hds.com>
Date: Thu, 17 Nov 2011 15:47:37 -0500
Subject: [RFC][PATCH]ACPI,APEI,ERST, back end driver for NVRAM
Thread-Topic: [RFC][PATCH]ACPI,APEI,ERST, back end driver for NVRAM
Thread-Index: AcylaiQjEW+WWiV9QjO7mRoJNGJHNw==
Message-ID: <5C4C569E8A4B9B42A84A977CF070A35B2C57AC8046@USINDEVS01.corp.hds.com>
Accept-Language: ja-JP, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: ja-JP, en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Proofpoint-Spam-Details: rule=outbound_policy_notspam policy=outbound_policy score=0 spamscore=0
 ipscore=0 suspectscore=1 phishscore=0 bulkscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=6.0.2-1012030000
 definitions=main-1111170234
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I developed write/read/clear functions of ERST driver for NVRAM. 
According to ACPI 4.0 specification, we can use the same procedure as storage.

This patch is tested on DELL PowerEdge T310.

Any comments are welcome.

 Signed-off-by: Seiji Aguchi <seiji.aguchi@hds.com>

---
 drivers/acpi/apei/erst.c |  145 +++++++++++++++++++++++++++++++++++++---------
 1 files changed, 117 insertions(+), 28 deletions(-)

diff --git a/drivers/acpi/apei/erst.c b/drivers/acpi/apei/erst.c
index 1274080..4806283 100644
--- a/drivers/acpi/apei/erst.c
+++ b/drivers/acpi/apei/erst.c
@@ -755,30 +755,125 @@ static int __erst_clear_from_storage(u64 record_id)
 	return erst_errno(val);
 }
 
-/* NVRAM ERST Error Log Address Range is not supported yet */
-static void pr_unimpl_nvram(void)
+static int __erst_write_to_nvram(u64 offset)
 {
-	if (printk_ratelimit())
-		pr_warning(ERST_PFX
-		"NVRAM ERST Log Address Range is not implemented yet\n");
-}
+	struct apei_exec_context ctx;
+	u64 timeout = FIRMWARE_TIMEOUT;
+	u64 val;
+	int rc;
 
-static int __erst_write_to_nvram(const struct cper_record_header *record)
-{
-	/* do not print message, because printk is not safe for NMI */
-	return -ENOSYS;
+	erst_exec_ctx_init(&ctx);
+	rc = apei_exec_run_optional(&ctx, ACPI_ERST_BEGIN_WRITE);
+	if (rc)
+		return rc;
+	apei_exec_ctx_set_input(&ctx, offset);
+	rc = apei_exec_run(&ctx, ACPI_ERST_SET_RECORD_OFFSET);
+	if (rc)
+		return rc;
+	rc = apei_exec_run(&ctx, ACPI_ERST_EXECUTE_OPERATION);
+	if (rc)
+		return rc;
+	for (;;) {
+		rc = apei_exec_run(&ctx, ACPI_ERST_CHECK_BUSY_STATUS);
+		if (rc)
+			return rc;
+		val = apei_exec_ctx_get_output(&ctx);
+		if (!val)
+			break;
+		if (erst_timedout(&timeout, SPIN_UNIT))
+			return -EIO;
+	}
+	rc = apei_exec_run(&ctx, ACPI_ERST_GET_COMMAND_STATUS);
+	if (rc)
+		return rc;
+	val = apei_exec_ctx_get_output(&ctx);
+	rc = apei_exec_run_optional(&ctx, ACPI_ERST_END);
+	if (rc)
+		return rc;
+
+	return erst_errno(val);
 }
 
-static int __erst_read_to_erange_from_nvram(u64 record_id, u64 *offset)
+static int __erst_read_to_erange_from_nvram(u64 record_id, u64 offset)
 {
-	pr_unimpl_nvram();
-	return -ENOSYS;
+	struct apei_exec_context ctx;
+	u64 timeout = FIRMWARE_TIMEOUT;
+	u64 val;
+	int rc;
+
+	erst_exec_ctx_init(&ctx);
+	rc = apei_exec_run_optional(&ctx, ACPI_ERST_BEGIN_READ);
+	if (rc)
+		return rc;
+	apei_exec_ctx_set_input(&ctx, offset);
+	rc = apei_exec_run(&ctx, ACPI_ERST_SET_RECORD_OFFSET);
+	if (rc)
+		return rc;
+	apei_exec_ctx_set_input(&ctx, record_id);
+	rc = apei_exec_run(&ctx, ACPI_ERST_SET_RECORD_ID);
+	if (rc)
+		return rc;
+	rc = apei_exec_run(&ctx, ACPI_ERST_EXECUTE_OPERATION);
+	if (rc)
+		return rc;
+	for (;;) {
+		rc = apei_exec_run(&ctx, ACPI_ERST_CHECK_BUSY_STATUS);
+		if (rc)
+			return rc;
+		val = apei_exec_ctx_get_output(&ctx);
+		if (!val)
+			break;
+		if (erst_timedout(&timeout, SPIN_UNIT))
+			return -EIO;
+	}
+	rc = apei_exec_run(&ctx, ACPI_ERST_GET_COMMAND_STATUS);
+	if (rc)
+		return rc;
+	val = apei_exec_ctx_get_output(&ctx);
+	rc = apei_exec_run_optional(&ctx, ACPI_ERST_END);
+	if (rc)
+		return rc;
+
+	return erst_errno(val);
 }
 
 static int __erst_clear_from_nvram(u64 record_id)
 {
-	pr_unimpl_nvram();
-	return -ENOSYS;
+	struct apei_exec_context ctx;
+	u64 timeout = FIRMWARE_TIMEOUT;
+	u64 val;
+	int rc;
+
+	erst_exec_ctx_init(&ctx);
+	rc = apei_exec_run_optional(&ctx, ACPI_ERST_BEGIN_CLEAR);
+	if (rc)
+		return rc;
+	apei_exec_ctx_set_input(&ctx, record_id);
+	rc = apei_exec_run(&ctx, ACPI_ERST_SET_RECORD_ID);
+	if (rc)
+		return rc;
+	rc = apei_exec_run(&ctx, ACPI_ERST_EXECUTE_OPERATION);
+	if (rc)
+		return rc;
+	for (;;) {
+		rc = apei_exec_run(&ctx, ACPI_ERST_CHECK_BUSY_STATUS);
+		if (rc)
+			return rc;
+		val = apei_exec_ctx_get_output(&ctx);
+		if (!val)
+			break;
+		if (erst_timedout(&timeout, SPIN_UNIT))
+			return -EIO;
+	}
+	rc = apei_exec_run(&ctx, ACPI_ERST_GET_COMMAND_STATUS);
+	if (rc)
+		return rc;
+	val = apei_exec_ctx_get_output(&ctx);
+	rc = apei_exec_run_optional(&ctx, ACPI_ERST_END);
+	if (rc)
+		return rc;
+
+	return erst_errno(val);
 }
 
 int erst_write(const struct cper_record_header *record)
@@ -793,14 +888,6 @@ int erst_write(const struct cper_record_header *record)
 	if (memcmp(record->signature, CPER_SIG_RECORD, CPER_SIG_SIZE))
 		return -EINVAL;
 
-	if (erst_erange.attr & ERST_RANGE_NVRAM) {
-		if (!raw_spin_trylock_irqsave(&erst_lock, flags))
-			return -EBUSY;
-		rc = __erst_write_to_nvram(record);
-		raw_spin_unlock_irqrestore(&erst_lock, flags);
-		return rc;
-	}
-
 	if (record->record_length > erst_erange.size)
 		return -EINVAL;
 
@@ -811,7 +898,10 @@ int erst_write(const struct cper_record_header *record)
 	/* signature for serialization system */
 	memcpy(&rcd_erange->persistence_information, "ER", 2);
 
-	rc = __erst_write_to_storage(0);
+	if (erst_erange.attr & ERST_RANGE_NVRAM)
+		rc = __erst_write_to_nvram(0);
+	else
+		rc = __erst_write_to_storage(0);
 	raw_spin_unlock_irqrestore(&erst_lock, flags);
 
 	return rc;
@@ -823,10 +913,9 @@ static int __erst_read_to_erange(u64 record_id, u64 *offset)
 	int rc;
 
 	if (erst_erange.attr & ERST_RANGE_NVRAM)
-		return __erst_read_to_erange_from_nvram(
-			record_id, offset);
-
-	rc = __erst_read_from_storage(record_id, 0);
+		rc = __erst_read_to_erange_from_nvram(record_id, 0);
+	else
+		rc = __erst_read_from_storage(record_id, 0);
 	if (rc)
 		return rc;
 	*offset = 0;
-- 
1.7.1

