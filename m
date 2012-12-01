Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752510Ab2LAOXo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Dec 2012 09:23:44 -0500
Received: from p3plsmtps2ded03.prod.phx3.secureserver.net ([208.109.80.60]:42637
	"EHLO p3plsmtps2ded03.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752007Ab2LAOXj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Dec 2012 09:23:39 -0500
x-originating-ip: 72.167.245.219
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, olaf@aepfle.de, apw@canonical.com,
        jasowang@redhat.com
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH 03/28] Drivers: hv: Turn off batched reading for util drivers
Date: Sat,  1 Dec 2012 06:46:34 -0800
Message-Id: <1354373219-31374-3-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1354373219-31374-1-git-send-email-kys@microsoft.com>
References: <1354373160-31332-1-git-send-email-kys@microsoft.com>
 <1354373219-31374-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Util driver is not a performance critical driver and furthermore some
util services such as KVP can only handle one outstanding message
from the host. Turn off batched reading for util drivers.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Reviewed-by: Haiyang Zhang <haiyangz@microsoft.com>
---
 drivers/hv/hv_util.c |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/drivers/hv/hv_util.c b/drivers/hv/hv_util.c
index a0667de..a62a760 100644
--- a/drivers/hv/hv_util.c
+++ b/drivers/hv/hv_util.c
@@ -274,6 +274,16 @@ static int util_probe(struct hv_device *dev,
 		}
 	}
 
+	/*
+	 * The set of services managed by the util driver are not performance
+	 * critical and do not need batched reading. Furthermore, some services
+	 * such as KVP can only handle one message from the host at a time.
+	 * Turn off batched reading for all util drivers before we open the
+	 * channel.
+	 */
+
+	set_channel_read_state(dev->channel, false);
+
 	ret = vmbus_open(dev->channel, 4 * PAGE_SIZE, 4 * PAGE_SIZE, NULL, 0,
 			srv->util_cb, dev->channel);
 	if (ret)
-- 
1.7.4.1

