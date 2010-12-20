Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933184Ab0LTUIo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 15:08:44 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:58156 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933116Ab0LTUIl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 15:08:41 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6203"; a="67599773"
From: Stephen Boyd <sboyd@codeaurora.org>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Daniel Walker <dwalker@codeaurora.org>
Subject: [PATCH 2/3] hvc_dcc: Simplify put_chars()/get_chars() loops
Date: Mon, 20 Dec 2010 12:08:37 -0800
Message-Id: <1292875718-7980-3-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.7.3.4.516.g15368e
In-Reply-To: <1292875718-7980-1-git-send-email-sboyd@codeaurora.org>
References: <1292649385-28771-1-git-send-email-sboyd@codeaurora.org>
 <1292875718-7980-1-git-send-email-sboyd@codeaurora.org>
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
 drivers/char/hvc_dcc.c |   12 ++++--------
 1 files changed, 4 insertions(+), 8 deletions(-)

diff --git a/drivers/char/hvc_dcc.c b/drivers/char/hvc_dcc.c
index 155ec10..ad23cc8 100644
--- a/drivers/char/hvc_dcc.c
+++ b/drivers/char/hvc_dcc.c
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

