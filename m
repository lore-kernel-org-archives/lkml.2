Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756614Ab2DEWxk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2012 18:53:40 -0400
Received: from smtp.ispras.ru ([83.149.198.202]:49082 "EHLO smtp.ispras.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755783Ab2DEWxi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2012 18:53:38 -0400
From: Alexey Khoroshilov <khoroshilov@ispras.ru>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Alexey Khoroshilov <khoroshilov@ispras.ru>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, ldv-project@ispras.ru
Subject: [PATCH] drxk: Does not unlock mutex if sanity check failed in scu_command()
Date: Thu,  5 Apr 2012 15:53:20 -0700
Message-Id: <1333666400-29357-1-git-send-email-khoroshilov@ispras.ru>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If sanity check fails in scu_command(), goto error leads to unlock of
an unheld mutex. The check should not fail in reality, but it nevertheless
worth fixing.

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
---
 drivers/media/dvb/frontends/drxk_hard.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/media/dvb/frontends/drxk_hard.c b/drivers/media/dvb/frontends/drxk_hard.c
index 6980ed7..3cce362 100644
--- a/drivers/media/dvb/frontends/drxk_hard.c
+++ b/drivers/media/dvb/frontends/drxk_hard.c
@@ -1525,8 +1525,10 @@ static int scu_command(struct drxk_state *state,
 	dprintk(1, "\n");
 
 	if ((cmd == 0) || ((parameterLen > 0) && (parameter == NULL)) ||
-	    ((resultLen > 0) && (result == NULL)))
-		goto error;
+	    ((resultLen > 0) && (result == NULL))) {
+		printk(KERN_ERR "drxk: Error %d on %s\n", status, __func__);
+		return status;
+	}
 
 	mutex_lock(&state->mutex);
 
-- 
1.7.4.1

