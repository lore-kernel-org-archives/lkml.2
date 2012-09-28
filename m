Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758727Ab2I1SyK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 14:54:10 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:64534 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758685Ab2I1SyG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 14:54:06 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Alexey Khoroshilov <khoroshilov@ispras.ru>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 008/262] net/core: Fix potential memory leak in dev_set_alias()
Date: Fri, 28 Sep 2012 11:48:57 -0700
Message-Id: <20120928182958.954871631@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120928182957.993484211@linuxfoundation.org>
References: <20120928182957.993484211@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.5-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Alexey Khoroshilov <khoroshilov@ispras.ru>

[ Upstream commit 7364e445f62825758fa61195d237a5b8ecdd06ec ]

Do not leak memory by updating pointer with potentially NULL realloc return value.

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/core/dev.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -1055,6 +1055,8 @@ rollback:
  */
 int dev_set_alias(struct net_device *dev, const char *alias, size_t len)
 {
+	char *new_ifalias;
+
 	ASSERT_RTNL();
 
 	if (len >= IFALIASZ)
@@ -1068,9 +1070,10 @@ int dev_set_alias(struct net_device *dev
 		return 0;
 	}
 
-	dev->ifalias = krealloc(dev->ifalias, len + 1, GFP_KERNEL);
-	if (!dev->ifalias)
+	new_ifalias = krealloc(dev->ifalias, len + 1, GFP_KERNEL);
+	if (!new_ifalias)
 		return -ENOMEM;
+	dev->ifalias = new_ifalias;
 
 	strlcpy(dev->ifalias, alias, len+1);
 	return len;


