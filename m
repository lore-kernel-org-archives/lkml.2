Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933077Ab0EJXC5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 19:02:57 -0400
Received: from kroah.org ([198.145.64.141]:51876 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932905Ab0EJW6S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 18:58:18 -0400
X-Mailbox-Line: From gregkh@kvm.kroah.org Mon May 10 15:35:40 2010
Message-Id: <20100510223540.339613458@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Mon, 10 May 2010 15:35:18 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Christian Lamparter <chunkeey@googlemail.com>,
       "John W. Linville" <linville@tuxdriver.com>
Subject: [66/98] p54pci: rx frame length check
In-Reply-To: <20100510223714.GA18416@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Christian Lamparter <chunkeey@googlemail.com>

commit f5300e04df78feae8107c1846dd3a9e27c071b2f upstream.

A long time ago, a user reported several crashes due to
data corruptions which are likely the result of a
not-100%-supported, or faulty? PCI bridge.
( http://patchwork.kernel.org/patch/53004/ )

This patch fixes entry #1.
"1.  p54p_check_rx_ring - skb_over_panic: Under a ping flood
or just left running for a bit would panic with a skb_over_panic."
As described in the mail: The invalid frame length causes
skb_put to bailout and trigger a crash.

Note:
Simply dropping the frame is problematic, because if its content
contains a tx feedback we would lose some portion of the device
memory space.... And the driver/mac80211 should handle all other
invalid data.

Reported-by: Quintin Pitts <geek4linux@gmail.com>
Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/p54/p54pci.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/net/wireless/p54/p54pci.c
+++ b/drivers/net/wireless/p54/p54pci.c
@@ -205,6 +205,14 @@ static void p54p_check_rx_ring(struct ie
 			i %= ring_limit;
 			continue;
 		}
+
+		if (unlikely(len > priv->common.rx_mtu)) {
+			if (net_ratelimit())
+				dev_err(&priv->pdev->dev, "rx'd frame size "
+					"exceeds length threshold.\n");
+
+			len = priv->common.rx_mtu;
+		}
 		skb_put(skb, len);
 
 		if (p54_rx(dev, skb)) {


