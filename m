Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754534Ab2ADLtb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jan 2012 06:49:31 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:1152 "EHLO SMTP02.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752785Ab2ADLt3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jan 2012 06:49:29 -0500
X-Greylist: delayed 570 seconds by postgrey-1.27 at vger.kernel.org; Wed, 04 Jan 2012 06:49:29 EST
X-IronPort-AV: E=Sophos;i="4.71,455,1320642000"; 
   d="scan'208";a="176211441"
From: Ian Campbell <ian.campbell@citrix.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Ian Campbell <ian.campbell@citrix.com>,
        Haogang Chen <haogangchen@gmail.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>, xen-devel@lists.xensource.com,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] xen/xenbus: don't reimplement kvasprintf via a fixed size buffer
Date: Wed, 4 Jan 2012 11:39:52 +0000
Message-ID: <1325677192-10459-2-git-send-email-ian.campbell@citrix.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1325677158.25206.244.camel@zakaz.uk.xensource.com>
References: <1325677158.25206.244.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
Cc: Haogang Chen <haogangchen@gmail.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: xen-devel@lists.xensource.com
Cc: virtualization@lists.linux-foundation.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/xen/xenbus/xenbus_xs.c |   17 +++++++----------
 1 files changed, 7 insertions(+), 10 deletions(-)

diff --git a/drivers/xen/xenbus/xenbus_xs.c b/drivers/xen/xenbus/xenbus_xs.c
index 6f0121e..226d1ac 100644
--- a/drivers/xen/xenbus/xenbus_xs.c
+++ b/drivers/xen/xenbus/xenbus_xs.c
@@ -532,21 +532,18 @@ int xenbus_printf(struct xenbus_transaction t,
 {
 	va_list ap;
 	int ret;
-#define PRINTF_BUFFER_SIZE 4096
-	char *printf_buffer;
-
-	printf_buffer = kmalloc(PRINTF_BUFFER_SIZE, GFP_NOIO | __GFP_HIGH);
-	if (printf_buffer == NULL)
-		return -ENOMEM;
+	char *buf;
 
 	va_start(ap, fmt);
-	ret = vsnprintf(printf_buffer, PRINTF_BUFFER_SIZE, fmt, ap);
+	buf = kvasprintf(GFP_NOIO | __GFP_HIGH, fmt, ap);
 	va_end(ap);
 
-	BUG_ON(ret > PRINTF_BUFFER_SIZE-1);
-	ret = xenbus_write(t, dir, node, printf_buffer);
+	if (!buf)
+		return -ENOMEM;
+
+	ret = xenbus_write(t, dir, node, buf);
 
-	kfree(printf_buffer);
+	kfree(buf);
 
 	return ret;
 }
-- 
1.7.2.5

