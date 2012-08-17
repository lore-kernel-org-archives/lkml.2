Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755515Ab2HQNmg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 09:42:36 -0400
Received: from mail.pripojeni.net ([178.22.112.14]:50614 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754927Ab2HQNm2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 09:42:28 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: davem@davemloft.net
Cc: jirislaby@gmail.com, linux-kernel@vger.kernel.org,
        Jiri Slaby <jslaby@suse.cz>, Joe Perches <joe@perches.com>
Subject: [PATCH] ratelimit: check the condition in WARN_RATELIMIT first
Date: Fri, 17 Aug 2012 15:42:22 +0200
Message-Id: <1345210942-26906-1-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.11.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Before calling __ratelimit in __WARN_RATELIMIT, check the condition
first. When this check was not there, we got constant income of:
tty_init_dev: 60 callbacks suppressed
tty_init_dev: 59 callbacks suppressed

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Joe Perches <joe@perches.com>
---
 include/linux/ratelimit.h | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/include/linux/ratelimit.h b/include/linux/ratelimit.h
index e11ccb4..966d35c 100644
--- a/include/linux/ratelimit.h
+++ b/include/linux/ratelimit.h
@@ -49,8 +49,9 @@ extern int ___ratelimit(struct ratelimit_state *rs, const char *func);
 #define __WARN_RATELIMIT(condition, state, format...)		\
 ({								\
 	int rtn = 0;						\
-	if (unlikely(__ratelimit(state)))			\
-		rtn = WARN(condition, format);			\
+	int __rtcond = !!condition;				\
+	if (unlikely(__rtcond && __ratelimit(state)))		\
+		rtn = WARN(__rtcond, format);			\
 	rtn;							\
 })
 
-- 
1.7.11.5


