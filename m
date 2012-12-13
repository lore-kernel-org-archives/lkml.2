Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932737Ab2LMOJ3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 09:09:29 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44651 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932623Ab2LMOJZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 09:09:25 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 140/241] PM / QoS: fix wrong error-checking condition
Date: Thu, 13 Dec 2012 11:58:25 -0200
Message-Id: <1355407206-17100-141-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
References: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.2 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/base/power/qos.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/base/power/qos.c b/drivers/base/power/qos.c
index fd849a2..b95ebf2 100644
--- a/drivers/base/power/qos.c
+++ b/drivers/base/power/qos.c
@@ -451,7 +451,7 @@ int dev_pm_qos_add_ancestor_request(struct device *dev,
 	if (ancestor)
 		error = dev_pm_qos_add_request(ancestor, req, value);
 
-	if (error)
+	if (error < 0)
 		req->dev = NULL;
 
 	return error;
-- 
1.7.9.5

