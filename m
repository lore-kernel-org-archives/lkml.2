Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753285Ab1H0O4U (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Aug 2011 10:56:20 -0400
Received: from cantor2.suse.de ([195.135.220.15]:46431 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753208Ab1H0O4O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Aug 2011 10:56:14 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Aug 26 15:01:20 2011
Message-Id: <20110826220120.217204519@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Fri, 26 Aug 2011 14:58:27 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Julia Lawall <julia@diku.dk>,
        Guenter Roeck <guenter.roeck@ericsson.com>
Subject: [06/19] hwmon: (ibmaem) add missing kfree
In-Reply-To: <20110826220137.GA14059@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Julia Lawall <julia@diku.dk>

commit 66a89b2164e2d30661edbd1953eacf0594d8203a upstream.

rs_resp is dynamically allocated in aem_read_sensor(), so it should be freed
before exiting in every case.  This collects the kfree and the return at
the end of the function.

Signed-off-by: Julia Lawall <julia@diku.dk>
Signed-off-by: Guenter Roeck <guenter.roeck@ericsson.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/hwmon/ibmaem.c |   15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

--- a/drivers/hwmon/ibmaem.c
+++ b/drivers/hwmon/ibmaem.c
@@ -429,13 +429,15 @@ static int aem_read_sensor(struct aem_da
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
@@ -460,8 +462,11 @@ static int aem_read_sensor(struct aem_da
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


