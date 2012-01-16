Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756634Ab2APSt6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 13:49:58 -0500
Received: from cantor2.suse.de ([195.135.220.15]:43068 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756576Ab2APSty (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 13:49:54 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Mon Jan 16 10:45:19 2012
Message-Id: <20120116184519.503779012@clark.kroah.org>
User-Agent: quilt/0.50-25.1
Date: Mon, 16 Jan 2012 10:45:12 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Larry Finger <Larry.Finger@lwfinger.net>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [45/48] rtl8192se: Fix BUG caused by failure to check skb allocation
In-Reply-To: <20120116184527.GA11972@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Larry Finger <Larry.Finger@lwfinger.net>

commit d90db4b12bc1b9b8a787ef28550fdb767ee25a49 upstream.

When downloading firmware into the device, the driver fails to check the
return when allocating an skb. When the allocation fails, a BUG can be
generated, as seen in https://bugzilla.redhat.com/show_bug.cgi?id=771656.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/rtlwifi/rtl8192se/fw.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/net/wireless/rtlwifi/rtl8192se/fw.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192se/fw.c
@@ -196,6 +196,8 @@ static bool _rtl92s_firmware_downloadcod
 		/* Allocate skb buffer to contain firmware */
 		/* info and tx descriptor info. */
 		skb = dev_alloc_skb(frag_length);
+		if (!skb)
+			return false;
 		skb_reserve(skb, extra_descoffset);
 		seg_ptr = (u8 *)skb_put(skb, (u32)(frag_length -
 					extra_descoffset));
@@ -573,6 +575,8 @@ static bool _rtl92s_firmware_set_h2c_cmd
 
 	len = _rtl92s_get_h2c_cmdlen(MAX_TRANSMIT_BUFFER_SIZE, 1, &cmd_len);
 	skb = dev_alloc_skb(len);
+	if (!skb)
+		return false;
 	cb_desc = (struct rtl_tcb_desc *)(skb->cb);
 	cb_desc->queue_index = TXCMD_QUEUE;
 	cb_desc->cmd_or_init = DESC_PACKET_TYPE_NORMAL;


