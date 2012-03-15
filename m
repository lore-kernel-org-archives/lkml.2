Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761447Ab2COOgx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 10:36:53 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:61962 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761431Ab2COOgh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 10:36:37 -0400
From: Sasha Levin <levinsasha928@gmail.com>
To: johnstul@us.ibm.com, tglx@linutronix.de, linux-kernel@vger.kernel.org
Cc: Sasha Levin <levinsasha928@gmail.com>
Subject: [PATCH 2/2] ntp: Fix integer overflow when setting time
Date: Thu, 15 Mar 2012 12:36:14 -0400
Message-Id: <1331829374-31543-2-git-send-email-levinsasha928@gmail.com>
X-Mailer: git-send-email 1.7.8.4
In-Reply-To: <1331829374-31543-1-git-send-email-levinsasha928@gmail.com>
References: <1331829374-31543-1-git-send-email-levinsasha928@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

'long secs' was being passed as divisor to div_s64, which accepts a 32bit
divisor. On 64bit machines that value would be trimmed back from 8 bytes
back to 4, allowing a divide by zero when the number is bigger than
(1 << 32) - 1 and all 32 lower bits are 0.

Signed-off-by: Sasha Levin <levinsasha928@gmail.com>
---
 kernel/time/ntp.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/kernel/time/ntp.c b/kernel/time/ntp.c
index 17fb1b9..c83c228 100644
--- a/kernel/time/ntp.c
+++ b/kernel/time/ntp.c
@@ -289,7 +289,11 @@ static inline s64 ntp_update_offset_fll(s64 offset64, long secs)
 
 	time_status |= STA_MODE;
 
-	return div_s64(offset64 << (NTP_SCALE_SHIFT - SHIFT_FLL), secs);
+	/* 
+	 * secs is 8 bytes on 64bit systems, which means that it can
+	 * wrap around when dividing.
+	 */
+	return div64_long(offset64 << (NTP_SCALE_SHIFT - SHIFT_FLL), secs);
 }
 
 static void ntp_update_offset(long offset)
-- 
1.7.8.4

