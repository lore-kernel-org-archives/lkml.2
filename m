Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756453Ab1E2Txt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 May 2011 15:53:49 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:63531 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756389Ab1E2Txs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 May 2011 15:53:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=GCMX6u56njRHEdKBEI4lAWgztMi8cqgn8Jj+iN2PvkvikwWGMSHkswoYrqSKi0h4Z4
         1Bnb4nk9C2DFr7DWPAKkdshDbZANJMDJkEtVsGxXdRWyrdFzb/pczmyX9MPJdgwHREgK
         QynX5Kw60MP2l99RBAaA1gghD2aFTqXGOdyxI=
Date: Sun, 29 May 2011 22:53:12 +0300
From: Dan Carpenter <error27@gmail.com>
To: Richard Cochran <richard.cochran@omicron.at>
Cc: "David S. Miller" <davem@davemloft.net>,
        John Stultz <john.stultz@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        open list <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
Subject: [patch 1/2] ptp: return -EFAULT on copy_to_user() errors
Message-ID: <20110529195312.GA3099@shale.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

copy_to_user() returns the number of bytes remaining, but we want a
negative error code here.

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/drivers/ptp/ptp_chardev.c b/drivers/ptp/ptp_chardev.c
index a8d03ae..93fa22d 100644
--- a/drivers/ptp/ptp_chardev.c
+++ b/drivers/ptp/ptp_chardev.c
@@ -46,7 +46,8 @@ long ptp_ioctl(struct posix_clock *pc, unsigned int cmd, unsigned long arg)
 		caps.n_ext_ts = ptp->info->n_ext_ts;
 		caps.n_per_out = ptp->info->n_per_out;
 		caps.pps = ptp->info->pps;
-		err = copy_to_user((void __user *)arg, &caps, sizeof(caps));
+		if (copy_to_user((void __user *)arg, &caps, sizeof(caps)))
+			err = -EFAULT;
 		break;
 
 	case PTP_EXTTS_REQUEST:
