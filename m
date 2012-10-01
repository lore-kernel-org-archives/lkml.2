Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757539Ab2JAWUb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 18:20:31 -0400
Received: from p3plsmtps2ded04.prod.phx3.secureserver.net ([208.109.80.198]:48190
	"EHLO p3plsmtps2ded04.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757467Ab2JAWUG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 18:20:06 -0400
X-Greylist: delayed 487 seconds by postgrey-1.27 at vger.kernel.org; Mon, 01 Oct 2012 18:20:01 EDT
x-originating-ip: 72.167.245.219
From: Haiyang Zhang <haiyangz@microsoft.com>
To: davem@davemloft.net, netdev@vger.kernel.org
Cc: haiyangz@microsoft.com, kys@microsoft.com, olaf@aepfle.de,
        jasowang@redhat.com, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org
Subject: [PATCH net,3/3] hyperv: Fix page buffer handling in rndis_filter_send_request()
Date: Mon,  1 Oct 2012 15:30:57 -0700
Message-Id: <1349130657-7987-3-git-send-email-haiyangz@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1349130657-7987-1-git-send-email-haiyangz@microsoft.com>
References: <1349130657-7987-1-git-send-email-haiyangz@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add another page buffer if the request message crossed page boundary.

Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Reviewed-by: K. Y. Srinivasan <kys@microsoft.com>

---
 drivers/net/hyperv/rndis_filter.c |   16 +++++++++++++++-
 1 files changed, 15 insertions(+), 1 deletions(-)

diff --git a/drivers/net/hyperv/rndis_filter.c b/drivers/net/hyperv/rndis_filter.c
index 2909dd8..1cd8d45 100644
--- a/drivers/net/hyperv/rndis_filter.c
+++ b/drivers/net/hyperv/rndis_filter.c
@@ -45,7 +45,9 @@ struct rndis_request {
 
 	/* Simplify allocation by having a netvsc packet inline */
 	struct hv_netvsc_packet	pkt;
-	struct hv_page_buffer buf;
+	/* Set 2 pages for rndis requests crossing page boundary */
+	struct hv_page_buffer buf[2];
+
 	/* FIXME: We assumed a fixed size request here. */
 	struct rndis_message request_msg;
 	u8 ext[100];
@@ -221,6 +223,18 @@ static int rndis_filter_send_request(struct rndis_device *dev,
 	packet->page_buf[0].offset =
 		(unsigned long)&req->request_msg & (PAGE_SIZE - 1);
 
+	/* Add one page_buf when request_msg crossing page boundary */
+	if (packet->page_buf[0].offset + packet->page_buf[0].len > PAGE_SIZE) {
+		packet->page_buf_cnt++;
+		packet->page_buf[0].len = PAGE_SIZE -
+			packet->page_buf[0].offset;
+		packet->page_buf[1].pfn = virt_to_phys((void *)&req->request_msg
+			+ packet->page_buf[0].len) >> PAGE_SHIFT;
+		packet->page_buf[1].offset = 0;
+		packet->page_buf[1].len = req->request_msg.msg_len -
+			packet->page_buf[0].len;
+	}
+
 	packet->completion.send.send_completion_ctx = req;/* packet; */
 	packet->completion.send.send_completion =
 		rndis_filter_send_request_completion;
-- 
1.7.4.1

