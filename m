Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757878Ab1IAThB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Sep 2011 15:37:01 -0400
Received: from p3plsmtps2ded02.prod.phx3.secureserver.net ([208.109.80.59]:37989
	"HELO p3plsmtps2ded02-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1757822Ab1IATgj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Sep 2011 15:36:39 -0400
From: Haiyang Zhang <haiyangz@microsoft.com>
To: haiyangz@microsoft.com, hjanssen@microsoft.com, kys@microsoft.com,
        gregkh@suse.de, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, virtualization@lists.osdl.org
Subject: [PATCH 09/10] staging: hv: fix the page buffer when rndis data go across page boundary
Date: Thu,  1 Sep 2011 12:19:47 -0700
Message-Id: <1314904788-32746-10-git-send-email-haiyangz@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1314904788-32746-1-git-send-email-haiyangz@microsoft.com>
References: <1314904788-32746-1-git-send-email-haiyangz@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In rndis_filter_receive_data(), we need to drop the 0th page and move the
rest of pages forward if the rndis data go across page boundary, otherwise
the page offset will overflow.

Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
---
 drivers/staging/hv/rndis_filter.c |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/hv/rndis_filter.c b/drivers/staging/hv/rndis_filter.c
index 20e673d..b325345 100644
--- a/drivers/staging/hv/rndis_filter.c
+++ b/drivers/staging/hv/rndis_filter.c
@@ -323,6 +323,7 @@ static void rndis_filter_receive_data(struct rndis_device *dev,
 {
 	struct rndis_packet *rndis_pkt;
 	u32 data_offset;
+	int i;
 
 	rndis_pkt = &msg->msg.pkt;
 
@@ -338,6 +339,15 @@ static void rndis_filter_receive_data(struct rndis_device *dev,
 	pkt->page_buf[0].offset += data_offset;
 	pkt->page_buf[0].len -= data_offset;
 
+	/* Drop the 0th page, if rndis data go beyond page boundary */
+	if (pkt->page_buf[0].offset >= PAGE_SIZE) {
+		pkt->page_buf[1].offset = pkt->page_buf[0].offset - PAGE_SIZE;
+		pkt->page_buf[1].len -= pkt->page_buf[1].offset;
+		pkt->page_buf_cnt--;
+		for (i = 0; i < pkt->page_buf_cnt; i++)
+			pkt->page_buf[i] = pkt->page_buf[i+1];
+	}
+
 	pkt->is_data_pkt = true;
 
 	netvsc_recv_callback(dev->net_dev->dev, pkt);
-- 
1.6.3.2

