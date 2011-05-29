Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756417Ab1E2Tye (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 May 2011 15:54:34 -0400
Received: from mail-ww0-f42.google.com ([74.125.82.42]:65053 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752468Ab1E2Tyd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 May 2011 15:54:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=NYxkVZ+FTF4uNi/DldQ74GauI+Ab6B1UA7u1RhKJcEQJvuAZxMKCljwdFz6IxGr/EK
         ohWeST5wiaOo41/KtcF3jTS8GN4lilB6jz9htjdNSNGKGvV3eakDN7dGw3hkHe3XC5KH
         MnKdL7vrk0UxivKy+mFs8AtAUgG5bEZCwTh00=
Date: Sun, 29 May 2011 22:54:07 +0300
From: Dan Carpenter <error27@gmail.com>
To: Richard Cochran <richard.cochran@omicron.at>
Cc: "David S. Miller" <davem@davemloft.net>,
        John Stultz <john.stultz@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        open list <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
Subject: [patch 2/2] ptp: fix some locking bugs in ptp_read()
Message-ID: <20110529195407.GB3099@shale.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There was an unlock missing on an error path, and a double unlock on
another error path.

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/drivers/ptp/ptp_chardev.c b/drivers/ptp/ptp_chardev.c
index 93fa22d..e7f301da2 100644
--- a/drivers/ptp/ptp_chardev.c
+++ b/drivers/ptp/ptp_chardev.c
@@ -130,8 +130,10 @@ ssize_t ptp_read(struct posix_clock *pc,
 		return -ERESTARTSYS;
 	}
 
-	if (ptp->defunct)
+	if (ptp->defunct) {
+		mutex_unlock(&ptp->tsevq_mux);
 		return -ENODEV;
+	}
 
 	spin_lock_irqsave(&queue->lock, flags);
 
@@ -151,10 +153,8 @@ ssize_t ptp_read(struct posix_clock *pc,
 
 	mutex_unlock(&ptp->tsevq_mux);
 
-	if (copy_to_user(buf, event, cnt)) {
-		mutex_unlock(&ptp->tsevq_mux);
+	if (copy_to_user(buf, event, cnt))
 		return -EFAULT;
-	}
 
 	return cnt;
 }
