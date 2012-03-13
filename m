Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758963Ab2CMAXh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 20:23:37 -0400
Received: from mail.windriver.com ([147.11.1.11]:48185 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758928Ab2CMAX2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 20:23:28 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Dmitry Torokhov <dtor@mail.ru>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 115/196] Input: elantech - relax signature checks
Date: Mon, 12 Mar 2012 20:20:28 -0400
Message-Id: <1331598109-31424-70-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.3
In-Reply-To: <1331598109-31424-1-git-send-email-paul.gortmaker@windriver.com>
References: <1331597724-31358-1-git-send-email-paul.gortmaker@windriver.com>
 <1331598109-31424-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit a083632eaf6231162b33e40561cfec6a9c156945 upstream.

Apparently there are Elantech touchpads that report non-zero in the 2nd byte
of their signature. Adjust the detection routine so that if 2nd byte is
zero and 3rd byte contains value that is not a valid report rate, we still
assume that signature is valid.

Tested-by: Eric Piel <eric.piel@tremplin-utc.net>
Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/input/mouse/elantech.c |   20 +++++++++++++++++++-
 1 file changed, 19 insertions(+), 1 deletion(-)

diff --git a/drivers/input/mouse/elantech.c b/drivers/input/mouse/elantech.c
index 112b4ee..4400369 100644
--- a/drivers/input/mouse/elantech.c
+++ b/drivers/input/mouse/elantech.c
@@ -575,6 +575,24 @@ static struct attribute_group elantech_attr_group = {
 	.attrs = elantech_attrs,
 };
 
+static bool elantech_is_signature_valid(const unsigned char *param)
+{
+	static const unsigned char rates[] = { 200, 100, 80, 60, 40, 20, 10 };
+	int i;
+
+	if (param[0] == 0)
+		return false;
+
+	if (param[1] == 0)
+		return true;
+
+	for (i = 0; i < ARRAY_SIZE(rates); i++)
+		if (param[2] == rates[i])
+			return false;
+
+	return true;
+}
+
 /*
  * Use magic knock to detect Elantech touchpad
  */
@@ -618,7 +636,7 @@ int elantech_detect(struct psmouse *psmouse, bool set_properties)
 	pr_debug("elantech.c: Elantech version query result 0x%02x, 0x%02x, 0x%02x.\n",
 		 param[0], param[1], param[2]);
 
-	if (param[0] == 0 || param[1] != 0) {
+	if (!elantech_is_signature_valid(param)) {
 		if (!force_elantech) {
 			pr_debug("elantech.c: Probably not a real Elantech touchpad. Aborting.\n");
 			return -1;
-- 
1.7.9.3

