Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754784Ab1BCXtO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Feb 2011 18:49:14 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:12177 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754453Ab1BCXsj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Feb 2011 18:48:39 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6245"; a="72915108"
From: Stephen Boyd <sboyd@codeaurora.org>
To: Greg KH <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Daniel Walker <dwalker@codeaurora.org>
Subject: [PATCHv2 2/3] hvc_dcc: Simplify put_chars()/get_chars() loops
Date: Thu,  3 Feb 2011 15:48:35 -0800
Message-Id: <1296776916-21018-3-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.7.4.2.g597a6
In-Reply-To: <1296776916-21018-1-git-send-email-sboyd@codeaurora.org>
References: <20110203221742.GA4159@kroah.com>
 <1296776916-21018-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Casting and anding with 0xff is unnecessary in
hvc_dcc_put_chars() since buf is already a char[].
__dcc_get_char() can't return an int less than 0 since it only
returns a char. Simplify the if statement in hvc_dcc_get_chars()
to take this into account.

Cc: Daniel Walker <dwalker@codeaurora.org>
Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 drivers/tty/hvc/hvc_dcc.c |   12 ++++--------
 1 files changed, 4 insertions(+), 8 deletions(-)

diff --git a/drivers/tty/hvc/hvc_dcc.c b/drivers/tty/hvc/hvc_dcc.c
index 155ec10..ad23cc8 100644
--- a/drivers/tty/hvc/hvc_dcc.c
+++ b/drivers/tty/hvc/hvc_dcc.c
@@ -89,7 +89,7 @@ static int hvc_dcc_put_chars(uint32_t vt, const char *buf, int count)
 		while (__dcc_getstatus() & DCC_STATUS_TX)
 			cpu_relax();
 
-		__dcc_putchar((char)(buf[i] & 0xFF));
+		__dcc_putchar(buf[i]);
 	}
 
 	return count;
@@ -99,15 +99,11 @@ static int hvc_dcc_get_chars(uint32_t vt, char *buf, int count)
 {
 	int i;
 
-	for (i = 0; i < count; ++i) {
-		int c = -1;
-
+	for (i = 0; i < count; ++i)
 		if (__dcc_getstatus() & DCC_STATUS_RX)
-			c = __dcc_getchar();
-		if (c < 0)
+			buf[i] = __dcc_getchar();
+		else
 			break;
-		buf[i] = c;
-	}
 
 	return i;
 }
-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

