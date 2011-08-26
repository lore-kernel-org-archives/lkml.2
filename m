Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754413Ab1H0O5a (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Aug 2011 10:57:30 -0400
Received: from cantor2.suse.de ([195.135.220.15]:46706 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753949Ab1H0O50 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Aug 2011 10:57:26 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Aug 26 15:04:19 2011
Message-Id: <20110826220419.552313708@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Fri, 26 Aug 2011 15:03:30 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Julia Lawall <julia@diku.dk>,
        Guenter Roeck <guenter.roeck@ericsson.com>
Subject: [07/20] hwmon: (ibmaem) add missing kfree
In-Reply-To: <20110826220431.GA15382@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-longterm review patch.  If anyone has any objections, please let us know.

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


