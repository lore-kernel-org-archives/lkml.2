Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932752Ab0KSWNs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 17:13:48 -0500
Received: from kroah.org ([198.145.64.141]:52949 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758088Ab0KSWES (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 17:04:18 -0500
X-Mailbox-Line: From gregkh@clark.site Fri Nov 19 14:01:24 2010
Message-Id: <20101119220124.713387293@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 19 Nov 2010 14:01:02 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Julia Lawall <julia@diku.dk>,
        Christian Lamparter <chunkeey@googlemail.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [31/66] drivers/net/wireless/p54/eeprom.c: Return -ENOMEM on memory allocation failure
In-Reply-To: <20101119220309.GA15562@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Julia Lawall <julia@diku.dk>

commit 0d91f22b75347d9503b17a42b6c74d3f7750acd6 upstream.

In this code, 0 is returned on memory allocation failure, even though other
failures return -ENOMEM or other similar values.

A simplified version of the semantic match that finds this problem is as
follows: (http://coccinelle.lip6.fr/)

// <smpl>
@@
expression ret;
expression x,e1,e2,e3;
@@

ret = 0
... when != ret = e1
*x = \(kmalloc\|kcalloc\|kzalloc\)(...)
... when != ret = e2
if (x == NULL) { ... when != ret = e3
  return ret;
}
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>
Acked-by: Christian Lamparter <chunkeey@googlemail.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/p54/eeprom.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/net/wireless/p54/eeprom.c
+++ b/drivers/net/wireless/p54/eeprom.c
@@ -260,8 +260,10 @@ static int p54_generate_channel_lists(st
 	list->max_entries = max_channel_num;
 	list->channels = kzalloc(sizeof(struct p54_channel_entry) *
 				 max_channel_num, GFP_KERNEL);
-	if (!list->channels)
+	if (!list->channels) {
+		ret = -ENOMEM;
 		goto free;
+	}
 
 	for (i = 0; i < max_channel_num; i++) {
 		if (i < priv->iq_autocal_len) {


