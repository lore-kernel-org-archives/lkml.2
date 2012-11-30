Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993254Ab2K3TFh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 14:05:37 -0500
Received: from mail.kernel.org ([198.145.19.201]:59925 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757236Ab2K3TDA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 14:03:00 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [ 32/54] PM / QoS: fix wrong error-checking condition
Date: Fri, 30 Nov 2012 10:56:03 -0800
Message-Id: <20121130185211.163696376@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.197.g5a90748
In-Reply-To: <20121130185207.894301294@linuxfoundation.org>
References: <20121130185207.894301294@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>

commit a7227a0faa117d0bc532aea546ae5ac5f89e8ed7 upstream.

dev_pm_qos_add_request() can return 0, 1, or a negative error code,
therefore the correct error test is "if (error < 0)." Checking just for
non-zero return code leads to erroneous setting of the req->dev pointer
to NULL, which then leads to a repeated call to
dev_pm_qos_add_ancestor_request() in st1232_ts_irq_handler(). This in turn
leads to an Oops, when the I2C host adapter is unloaded and reloaded again
because of the inconsistent state of its QoS request list.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/base/power/qos.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/base/power/qos.c
+++ b/drivers/base/power/qos.c
@@ -451,7 +451,7 @@ int dev_pm_qos_add_ancestor_request(stru
 	if (ancestor)
 		error = dev_pm_qos_add_request(ancestor, req, value);
 
-	if (error)
+	if (error < 0)
 		req->dev = NULL;
 
 	return error;


