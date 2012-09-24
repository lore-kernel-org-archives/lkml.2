Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754811Ab2IXCGF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Sep 2012 22:06:05 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:16223 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754737Ab2IXCGD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Sep 2012 22:06:03 -0400
Date: Mon, 24 Sep 2012 11:05:50 +0900
From: Jonghwa Lee <jonghwa3.lee@samsung.com>
Subject: [PATCH] Thermal: Fix bug on generic thermal framework.
To: linux-pml@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Len Brown <len.brown@intel.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Andrew Morton <akpm@linux-foundation.org>,
        Amit Kachhap <amit.kachhap@linaro.org>,
        Durgadoss R <durgadoss.r@intel.com>,
        Jonghwa Lee <jonghwa3.lee@samsung.com>
Message-id: <1348452350-1021-1-git-send-email-jonghwa3.lee@samsung.com>
X-Mailer: git-send-email 1.7.4.1
X-AuditID: cbfee61a-b7f726d000000ec7-07-505fc00975f6
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrLJMWRmVeSWpSXmKPExsVy+t9jQV3OA/EBBt/nCllc3jWHzWLzrR/s
	DkwenzfJBTBGcdmkpOZklqUW6dslcGWsODGPreABR8XDLeUNjCvZuxg5OSQETCRevGpkhbDF
	JC7cW8/WxcjFISQwnVHiY9d6ZginhUlizstmsA42AR2J//tugtkiArISNyZNYAcpYhboYpJ4
	PesoUAc7h7CAvcQHT5ASFgFVib9HJ4Et4BVwl3g+dTvUMgWJBffesk1g5F7AyLCKUTS1ILmg
	OCk911CvODG3uDQvXS85P3cTI9iTz6R2MK5ssDjEKMDBqMTD61kYHyDEmlhWXJl7iFGCg1lJ
	hJfrVlyAEG9KYmVValF+fFFpTmrxIUZpDhYlcV7hT4EBQgLpiSWp2ampBalFMFkmDk6pBkY1
	vn9m9pr/9s5e7Cr/7dSl6Bc3p8X4f5h1eWXy8Xm3p261CxT53LA8dcHC5iaxa1cj0zZNa2ws
	fzb33cXy3m/t/UqzJaRN7/z60XFk5RfeYP+gv6x90uwV0uJBD29N3pD8ctbcnVG7E555tR/R
	LurPnGpv5mV7v5jJbN5l7i/hRR5OD4UfnxRWYinOSDTUYi4qTgQAEkBcreABAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When system fails to bind cooling devices to thermal zone device during
registering thermal zone device, it leaves registering without canceling
delayed work. It probably makes panic if polling rate is not enough to release
that work from workqueue. So it is better to ignore initialization of polling
work to prevent that unexpected state.

Signed-off-by: Jonghwa Lee <jonghwa3.lee@samsung.com>
---
 drivers/thermal/thermal_sys.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/thermal/thermal_sys.c b/drivers/thermal/thermal_sys.c
index 2ab31e4..744e69d 100644
--- a/drivers/thermal/thermal_sys.c
+++ b/drivers/thermal/thermal_sys.c
@@ -1351,12 +1351,14 @@ struct thermal_zone_device *thermal_zone_device_register(const char *type,
 		}
 	mutex_unlock(&thermal_list_lock);
 
+	if (result)
+		goto unregister;
+
 	INIT_DELAYED_WORK(&(tz->poll_queue), thermal_zone_device_check);
 
 	thermal_zone_device_update(tz);
 
-	if (!result)
-		return tz;
+	return tz;
 
 unregister:
 	release_idr(&thermal_tz_idr, &thermal_idr_lock, tz->id);
-- 
1.7.4.1

