Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965508Ab2EOCaG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 22:30:06 -0400
Received: from mail1.windriver.com ([147.11.146.13]:53547 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965483Ab2EOCSL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 22:18:11 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [34-longterm 161/179] hwmon: (ibmaem) add missing kfree
Date: Mon, 14 May 2012 22:14:17 -0400
Message-ID: <1337048075-6132-162-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.6
In-Reply-To: <1337048075-6132-1-git-send-email-paul.gortmaker@windriver.com>
References: <1337048075-6132-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 66a89b2164e2d30661edbd1953eacf0594d8203a upstream.

rs_resp is dynamically allocated in aem_read_sensor(), so it should be freed
before exiting in every case.  This collects the kfree and the return at
the end of the function.

Signed-off-by: Julia Lawall <julia@diku.dk>
Signed-off-by: Guenter Roeck <guenter.roeck@ericsson.com>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/hwmon/ibmaem.c |   15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/hwmon/ibmaem.c b/drivers/hwmon/ibmaem.c
index eaee546..fd4dbef 100644
--- a/drivers/hwmon/ibmaem.c
+++ b/drivers/hwmon/ibmaem.c
@@ -430,13 +430,15 @@ static int aem_read_sensor(struct aem_data *data, u8 elt, u8 reg,
 	aem_send_message(ipmi);
 
 	res = wait_for_completion_timeout(&ipmi->read_complete, IPMI_TIMEOUT);
-	if (!res)
-		return -ETIMEDOUT;
+	if (!res) {
+		res = -ETIMEDOUT;
+		goto out;
+	}
 
 	if (ipmi->rx_result || ipmi->rx_msg_len != rs_size ||
 	    memcmp(&rs_resp->id, &system_x_id, sizeof(system_x_id))) {
-		kfree(rs_resp);
-		return -ENOENT;
+		res = -ENOENT;
+		goto out;
 	}
 
 	switch (size) {
@@ -461,8 +463,11 @@ static int aem_read_sensor(struct aem_data *data, u8 elt, u8 reg,
 		break;
 	}
 	}
+	res = 0;
 
-	return 0;
+out:
+	kfree(rs_resp);
+	return res;
 }
 
 /* Update AEM energy registers */
-- 
1.7.9.6

