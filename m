Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753936Ab2LEOKT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2012 09:10:19 -0500
Received: from gibson.whatever-company.com ([87.98.251.113]:37851 "EHLO
	gibson.whatever-company.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752496Ab2LEOKS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2012 09:10:18 -0500
X-Greylist: delayed 444 seconds by postgrey-1.27 at vger.kernel.org; Wed, 05 Dec 2012 09:10:18 EST
From: Sylvain Munaut <s.munaut@whatever-company.com>
To: linux-kernel@vger.kernel.org
Cc: Sylvain Munaut <s.munaut@whatever-company.com>
Subject: [RFC] printk: Fix print_time length computation when no buffer is given
Date: Wed,  5 Dec 2012 15:02:47 +0100
Message-Id: <1354716167-438-1-git-send-email-s.munaut@whatever-company.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <CAF6-1L7qDULSvzaB2G=8y9Jkyd=SfcDBnNTxTuN0xSQxG94CHg@mail.gmail.com>
References: <CAF6-1L7qDULSvzaB2G=8y9Jkyd=SfcDBnNTxTuN0xSQxG94CHg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The "%5lu" part of the sprintf only guarantees a minimum length,
not a maximum one. This patch should make it correct for any
possible timestamp.

Signed-off-by: Sylvain Munaut <s.munaut@whatever-company.com>
---
 kernel/printk.c |   13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/kernel/printk.c b/kernel/printk.c
index 66a2ea3..2ceceea 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -847,8 +847,17 @@ static size_t print_time(u64 ts, char *buf)
 	if (!printk_time)
 		return 0;
 
-	if (!buf)
-		return 15;
+	if (!buf) {
+		size_t len = 15;
+		u64 ts_limit = (u64)100000 * (u64)1000000000;
+
+		while ((ts > ts_limit) && (len < 21)) {
+			len++;
+			ts_limit = 10 * ts_limit;
+		}
+
+		return len;
+	}
 
 	rem_nsec = do_div(ts, 1000000000);
 	return sprintf(buf, "[%5lu.%06lu] ",
-- 
1.7.10.4

