Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932700Ab0GAWTa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 18:19:30 -0400
Received: from kroah.org ([198.145.64.141]:47214 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758339Ab0GAUtl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 16:49:41 -0400
X-Mailbox-Line: From gregkh@clark.site Thu Jul  1 10:34:29 2010
Message-Id: <20100701173428.976971810@clark.site>
User-Agent: quilt/0.48-10.1
Date: Thu, 01 Jul 2010 10:33:31 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Christian Lamparter <chunkeey@googlemail.com>,
       "John W. Linville" <linville@tuxdriver.com>
Subject: [patch 025/164] ar9170usb: fix panic triggered by undersized rxstream buffer
In-Reply-To: <20100701175152.GA2135@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Lamparter <chunkeey@googlemail.com>

commit 879999cec9489f8942ebce3ec1b5f23ef948dda7 upstream.

While ar9170's USB transport packet size is currently set to 8KiB,
the PHY is capable of receiving AMPDUs with up to 64KiB.
Such a large frame will be split over several rx URBs and
exceed the previously allocated space for rx stream reconstruction.

This patch increases the buffer size to 64KiB which is
in fact the phy & rx stream designed size limit.

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=15591
Reported-by: Christian Mehlis <mehlis@inf.fu-berlin.de>
Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/ath/ar9170/hw.h   |    1 +
 drivers/net/wireless/ath/ar9170/main.c |    2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/net/wireless/ath/ar9170/hw.h
+++ b/drivers/net/wireless/ath/ar9170/hw.h
@@ -424,5 +424,6 @@ enum ar9170_txq {
 
 #define AR9170_TXQ_DEPTH	32
 #define AR9170_TX_MAX_PENDING	128
+#define AR9170_RX_STREAM_MAX_SIZE 65535
 
 #endif /* __AR9170_HW_H */
--- a/drivers/net/wireless/ath/ar9170/main.c
+++ b/drivers/net/wireless/ath/ar9170/main.c
@@ -2538,7 +2538,7 @@ void *ar9170_alloc(size_t priv_size)
 	 * tends to split the streams into seperate rx descriptors.
 	 */
 
-	skb = __dev_alloc_skb(AR9170_MAX_RX_BUFFER_SIZE, GFP_KERNEL);
+	skb = __dev_alloc_skb(AR9170_RX_STREAM_MAX_SIZE, GFP_KERNEL);
 	if (!skb)
 		goto err_nomem;
 


