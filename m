Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755347Ab0LJD3c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 22:29:32 -0500
Received: from mail.perches.com ([173.55.12.10]:2471 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754722Ab0LJD3X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 22:29:23 -0500
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 5/6] hid: Hoist assigns from ifs
Date: Thu,  9 Dec 2010 19:29:07 -0800
Message-Id: <6e8e73e7da66fe797ae11e6ff0a91541decddb27.1291951482.git.joe@perches.com>
X-Mailer: git-send-email 1.7.3.3.464.gf80b6
In-Reply-To: <alpine.LNX.2.00.1012091454010.508@pobox.suse.cz>
References: <alpine.LNX.2.00.1012091454010.508@pobox.suse.cz>
In-Reply-To: <cover.1291951482.git.joe@perches.com>
References: <cover.1291951482.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/hid/hid-core.c |   19 +++++++++++++------
 1 files changed, 13 insertions(+), 6 deletions(-)

diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index 932266a..796012e 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -61,7 +61,8 @@ struct hid_report *hid_register_report(struct hid_device *device, unsigned type,
 	if (report_enum->report_id_hash[id])
 		return report_enum->report_id_hash[id];
 
-	if (!(report = kzalloc(sizeof(struct hid_report), GFP_KERNEL)))
+	report = kzalloc(sizeof(struct hid_report), GFP_KERNEL);
+	if (!report)
 		return NULL;
 
 	if (id != 0)
@@ -92,8 +93,11 @@ static struct hid_field *hid_register_field(struct hid_report *report, unsigned
 		return NULL;
 	}
 
-	if (!(field = kzalloc(sizeof(struct hid_field) + usages * sizeof(struct hid_usage)
-		+ values * sizeof(unsigned), GFP_KERNEL))) return NULL;
+	field = kzalloc((sizeof(struct hid_field) +
+			 usages * sizeof(struct hid_usage) +
+			 values * sizeof(unsigned)), GFP_KERNEL);
+	if (!field)
+		return NULL;
 
 	field->index = report->maxfield++;
 	report->field[field->index] = field;
@@ -211,7 +215,8 @@ static int hid_add_field(struct hid_parser *parser, unsigned report_type, unsign
 	unsigned offset;
 	int i;
 
-	if (!(report = hid_register_report(parser->device, report_type, parser->global.report_id))) {
+	report = hid_register_report(parser->device, report_type, parser->global.report_id);
+	if (!report) {
 		dbg_hid("hid_register_report failed\n");
 		return -1;
 	}
@@ -229,7 +234,8 @@ static int hid_add_field(struct hid_parser *parser, unsigned report_type, unsign
 
 	usages = max_t(int, parser->local.usage_index, parser->global.report_count);
 
-	if ((field = hid_register_field(report, usages, parser->global.report_count)) == NULL)
+	field = hid_register_field(report, usages, parser->global.report_count);
+	if (!field)
 		return 0;
 
 	field->physical = hid_lookup_collection(parser, HID_COLLECTION_PHYSICAL);
@@ -891,7 +897,8 @@ static void hid_input_field(struct hid_device *hid, struct hid_field *field,
 	__s32 max = field->logical_maximum;
 	__s32 *value;
 
-	if (!(value = kmalloc(sizeof(__s32) * count, GFP_ATOMIC)))
+	value = kmalloc(sizeof(__s32) * count, GFP_ATOMIC);
+	if (!value)
 		return;
 
 	for (n = 0; n < count; n++) {
-- 
1.7.3.3.464.gf80b6

