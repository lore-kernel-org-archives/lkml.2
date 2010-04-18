Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757527Ab0DRTIA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Apr 2010 15:08:00 -0400
Received: from mail-ew0-f220.google.com ([209.85.219.220]:38018 "EHLO
	mail-ew0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753040Ab0DRTH7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Apr 2010 15:07:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:mime-version
         :content-type:content-disposition:user-agent;
        b=K+1vJfMe3bU0dc4Ep8Q4FdF8/w+7LGEmqQILtB6mNs7QLbBtqMVlZoLszwtJzbFMsT
         yPmWUDfmtKuRoP/60UXHomXbFiUAn8jLk+M4pf0JV+TDTnU5usRyBB0yidWWulntE7ty
         Pd3Raj3lNzelUIn5/vDuhC4BpAvz5QDQjzj34=
Date: Sun, 18 Apr 2010 22:07:33 +0300
From: Dan Carpenter <error27@gmail.com>
To: Harald Welte <laforge@gnumonks.org>
Cc: Dominik Brodowski <linux@dominikbrodowski.net>,
       H Hartley Sweeten <hsweeten@visionengravers.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Roel Kluin <roel.kluin@gmail.com>, Jiri Slaby <jirislaby@gmail.com>,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] pcmcia: fix error handling in cm4000_cs.c
Message-ID: <20100418190732.GA7920@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Harald Welte <laforge@gnumonks.org>,
	Dominik Brodowski <linux@dominikbrodowski.net>,
	H Hartley Sweeten <hsweeten@visionengravers.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Roel Kluin <roel.kluin@gmail.com>, Jiri Slaby <jirislaby@gmail.com>,
	linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the original code we used -ENODEV as the number of bytes to
copy_to_user() and we didn't release the locks.

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/drivers/char/pcmcia/cm4000_cs.c b/drivers/char/pcmcia/cm4000_cs.c
index c9bc896..90b199f 100644
--- a/drivers/char/pcmcia/cm4000_cs.c
+++ b/drivers/char/pcmcia/cm4000_cs.c
@@ -1026,14 +1026,16 @@ static ssize_t cmm_read(struct file *filp, __user char *buf, size_t count,
 
 	xoutb(0, REG_FLAGS1(iobase));	/* clear detectCMM */
 	/* last check before exit */
-	if (!io_detect_cm4000(iobase, dev))
-		count = -ENODEV;
+	if (!io_detect_cm4000(iobase, dev)) {
+		rc = -ENODEV;
+		goto release_io;
+	}
 
 	if (test_bit(IS_INVREV, &dev->flags) && count > 0)
 		str_invert_revert(dev->rbuf, count);
 
 	if (copy_to_user(buf, dev->rbuf, count))
-		return -EFAULT;
+		rc = -EFAULT;
 
 release_io:
 	clear_bit(LOCK_IO, &dev->flags);
