Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753172Ab2LAOZ6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Dec 2012 09:25:58 -0500
Received: from p3plsmtps2ded02.prod.phx3.secureserver.net ([208.109.80.59]:49877
	"EHLO p3plsmtps2ded02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752156Ab2LAOXk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Dec 2012 09:23:40 -0500
x-originating-ip: 72.167.245.219
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, olaf@aepfle.de, apw@canonical.com,
        jasowang@redhat.com
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH 12/28] Drivers: hv: Change the signature of vmbus_set_event()
Date: Sat,  1 Dec 2012 06:46:43 -0800
Message-Id: <1354373219-31374-12-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1354373219-31374-1-git-send-email-kys@microsoft.com>
References: <1354373160-31332-1-git-send-email-kys@microsoft.com>
 <1354373219-31374-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In preparation for supporting a per-connection signaling mechanism,
change the signature of vmbus_set_event(). This change is also
needed to implement other aspects of the signaling optimization.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Reviewed-by: Haiyang Zhang <haiyangz@microsoft.com>
---
 drivers/hv/channel.c      |    2 +-
 drivers/hv/connection.c   |    3 ++-
 drivers/hv/hyperv_vmbus.h |    2 +-
 3 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/hv/channel.c b/drivers/hv/channel.c
index 727c5f1..70a34da 100644
--- a/drivers/hv/channel.c
+++ b/drivers/hv/channel.c
@@ -55,7 +55,7 @@ static void vmbus_setevent(struct vmbus_channel *channel)
 					[channel->monitor_grp].pending);
 
 	} else {
-		vmbus_set_event(channel->offermsg.child_relid);
+		vmbus_set_event(channel);
 	}
 }
 
diff --git a/drivers/hv/connection.c b/drivers/hv/connection.c
index 3f8ce7b..0d8b132 100644
--- a/drivers/hv/connection.c
+++ b/drivers/hv/connection.c
@@ -395,8 +395,9 @@ int vmbus_post_msg(void *buffer, size_t buflen)
 /*
  * vmbus_set_event - Send an event notification to the parent
  */
-int vmbus_set_event(u32 child_relid)
+int vmbus_set_event(struct vmbus_channel *channel)
 {
+	u32 child_relid = channel->offermsg.child_relid;
 	/* Each u32 represents 32 channels */
 	sync_set_bit(child_relid & 31,
 		(unsigned long *)vmbus_connection.send_int_page +
diff --git a/drivers/hv/hyperv_vmbus.h b/drivers/hv/hyperv_vmbus.h
index 61d2c4f..cd48ac3 100644
--- a/drivers/hv/hyperv_vmbus.h
+++ b/drivers/hv/hyperv_vmbus.h
@@ -660,7 +660,7 @@ int vmbus_connect(void);
 
 int vmbus_post_msg(void *buffer, size_t buflen);
 
-int vmbus_set_event(u32 child_relid);
+int vmbus_set_event(struct vmbus_channel *channel);
 
 void vmbus_on_event(unsigned long data);
 
-- 
1.7.4.1

