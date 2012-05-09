Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754703Ab2EIFwf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 01:52:35 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:38636 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754404Ab2EIFwc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 01:52:32 -0400
Message-Id: <20120509055032.360572129@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Wed, 09 May 2012 06:50:49 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Alexey Khoroshilov <khoroshilov@ispras.ru>,
        Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [ 020/167] [PATCH] [media] drxk: Does not unlock mutex if sanity check failed
 in scu_command()
In-Reply-To: <20120509055029.588587017@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexey Khoroshilov <khoroshilov@ispras.ru>

commit e4459e1682c107d7ee1bf102c1ba534230e9b50b upstream.

If sanity check fails in scu_command(), goto error leads to unlock of
an unheld mutex. The check should not fail in reality, but it nevertheless
worth fixing.

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/media/dvb/frontends/drxk_hard.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/media/dvb/frontends/drxk_hard.c b/drivers/media/dvb/frontends/drxk_hard.c
index 36d1175..a414b1f 100644
--- a/drivers/media/dvb/frontends/drxk_hard.c
+++ b/drivers/media/dvb/frontends/drxk_hard.c
@@ -1520,8 +1520,10 @@ static int scu_command(struct drxk_state *state,
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
1.7.10



