Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751997Ab2DVMSh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Apr 2012 08:18:37 -0400
Received: from smtprelay-b21.telenor.se ([195.54.99.212]:39855 "EHLO
	smtprelay-b21.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751643Ab2DVMSf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Apr 2012 08:18:35 -0400
X-SENDER-IP: [85.230.169.225]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AlhUADL2k09V5qnhPGdsb2JhbABEiiqnFRkBAQEBHhkNJ4IKAQUnLxMBDxAIETg5ChQGE4gTuV8TkSAEm32DVYlR
X-IronPort-AV: E=Sophos;i="4.75,462,1330902000"; 
   d="scan'208";a="319451407"
From: "Henrik Rydberg" <rydberg@euromail.se>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, Henrik Rydberg <rydberg@euromail.se>,
        "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH 1/3] hid-hyperv: Do not use hid_parse_report() directly
Date: Sun, 22 Apr 2012 14:21:38 +0200
Message-Id: <1335097300-11881-2-git-send-email-rydberg@euromail.se>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1335097300-11881-1-git-send-email-rydberg@euromail.se>
References: <1335097300-11881-1-git-send-email-rydberg@euromail.se>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Upcoming changes will split the semantics of hid_parse_report()
and hid_parse(), so make sure drivers use hid_parse() in probe().

Compiled, not tested.

Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
---
 drivers/hid/hid-hyperv.c |   14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/hid/hid-hyperv.c b/drivers/hid/hid-hyperv.c
index 4066324..032e6c0 100644
--- a/drivers/hid/hid-hyperv.c
+++ b/drivers/hid/hid-hyperv.c
@@ -430,6 +430,15 @@ cleanup:
 	return ret;
 }
 
+static int mousevsc_hid_parse(struct hid_device *hid)
+{
+	struct hv_device *dev = hid_get_drvdata(hid);
+	struct mousevsc_dev *input_dev = hv_get_drvdata(dev);
+
+	return hid_parse_report(hid, input_dev->report_desc,
+				input_dev->report_desc_size);
+}
+
 static int mousevsc_hid_open(struct hid_device *hid)
 {
 	return 0;
@@ -449,6 +458,7 @@ static void mousevsc_hid_stop(struct hid_device *hid)
 }
 
 static struct hid_ll_driver mousevsc_ll_driver = {
+	.parse = mousevsc_hid_parse,
 	.open = mousevsc_hid_open,
 	.close = mousevsc_hid_close,
 	.start = mousevsc_hid_start,
@@ -510,9 +520,9 @@ static int mousevsc_probe(struct hv_device *device,
 	if (ret)
 		goto probe_err1;
 
-	ret = hid_parse_report(hid_dev, input_dev->report_desc,
-				input_dev->report_desc_size);
+	hid_set_drvdata(hid_dev, device);
 
+	ret = hid_parse(hid_dev);
 	if (ret) {
 		hid_err(hid_dev, "parse failed\n");
 		goto probe_err2;
-- 
1.7.10

