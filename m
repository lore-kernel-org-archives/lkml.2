Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755782Ab2F0JCc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 05:02:32 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:21333 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755731Ab2F0JCa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 05:02:30 -0400
Date: Wed, 27 Jun 2012 12:02:15 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [patch -resend] spi/spidev: handle integer wrap in spidev_message()
Message-ID: <20120627090215.GG31212@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120627085800.GA3007@mwanda>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"k_tmp->len" and "total" are unsigned integers.  The first message
could be close to "bufsiz" (4096) and then the next message could be
4GB which would cause an integer overflow.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
I don't have a way to test this.  I originally sent this message on Tue,
18 Oct 2011.  I'm not totally sure what the implications are but it
seemed like there might be security implications.  I honestly don't
know.  I never received any feedback on the patch.

diff --git a/drivers/spi/spidev.c b/drivers/spi/spidev.c
index 830adbe..aab05e1 100644
--- a/drivers/spi/spidev.c
+++ b/drivers/spi/spidev.c
@@ -241,7 +241,7 @@ static int spidev_message(struct spidev_data *spidev,
 		k_tmp->len = u_tmp->len;
 
 		total += k_tmp->len;
-		if (total > bufsiz) {
+		if (total > bufsiz || total < k_tmp->len) {
 			status = -EMSGSIZE;
 			goto done;
 		}
