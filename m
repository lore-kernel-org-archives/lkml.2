Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758387Ab2DXWyl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 18:54:41 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:38637 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932436Ab2DXWfk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 18:35:40 -0400
Message-Id: <20120424223244.206782703@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Tue, 24 Apr 2012 15:33:07 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Alexey Khoroshilov <khoroshilov@ispras.ru>,
        Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [ 26/62] media: drxk: Does not unlock mutex if sanity check failed in scu_command()
In-Reply-To: <20120424223305.GA7748@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexey Khoroshilov <khoroshilov@ispras.ru>

commit e4459e1682c107d7ee1bf102c1ba534230e9b50b upstream.

If sanity check fails in scu_command(), goto error leads to unlock of
an unheld mutex. The check should not fail in reality, but it nevertheless
worth fixing.

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/media/dvb/frontends/drxk_hard.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/media/dvb/frontends/drxk_hard.c
+++ b/drivers/media/dvb/frontends/drxk_hard.c
@@ -1525,8 +1525,10 @@ static int scu_command(struct drxk_state
 	dprintk(1, "\n");
 
 	if ((cmd == 0) || ((parameterLen > 0) && (parameter == NULL)) ||
-	    ((resultLen > 0) && (result == NULL)))
-		goto error;
+	    ((resultLen > 0) && (result == NULL))) {
+		printk(KERN_ERR "drxk: Error %d on %s\n", status, __func__);
+		return status;
+	}
 
 	mutex_lock(&state->mutex);
 


