Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756428Ab2ICTRX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2012 15:17:23 -0400
Received: from one.firstfloor.org ([213.235.205.2]:44207 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754947Ab2ICTRW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2012 15:17:22 -0400
Date: Mon, 3 Sep 2012 21:17:21 +0200
From: Andi Kleen <andi@firstfloor.org>
To: greg@kroah.com, linux-kernel@vger.kernel.org, rgujare@ozmodevices.com,
        ckelly@ozmodevices.com
Subject: [PATCH] staging/ozwpan: Fix zero address check in oz_set_active_pd
Message-ID: <20120903191721.GX16230@one.firstfloor.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


gcc 4.8 warns about the incorrect memcmp size. I think it's supposed to
be an ethernet address, so should be always 6 bytes.

The code was wrong, would either compare 4 or 8 bytes (32bit vs 64bit)

/backup/lsrc/git/linux-lto-2.6/drivers/staging/ozwpan/ozcdev.c: In function 'oz_set_active_pd':
/backup/lsrc/git/linux-lto-2.6/drivers/staging/ozwpan/ozcdev.c:216:43: warning: argument to 'sizeof' in 'memcmp' call is the same expression as the destination; did you mean to provide an explicit length? [-Wsizeof-pointer-memaccess]
   if (!memcmp(addr, "\0\0\0\0\0\0", sizeof(addr))) {
                                           ^
Signed-off-by: Andi Kleen <ak@linux.intel.com>

diff --git a/drivers/staging/ozwpan/ozcdev.c b/drivers/staging/ozwpan/ozcdev.c
index d983219..63c1b67 100644
--- a/drivers/staging/ozwpan/ozcdev.c
+++ b/drivers/staging/ozwpan/ozcdev.c
@@ -213,7 +213,7 @@ static int oz_set_active_pd(u8 *addr)
 		if (old_pd)
 			oz_pd_put(old_pd);
 	} else {
-		if (!memcmp(addr, "\0\0\0\0\0\0", sizeof(addr))) {
+		if (!memcmp(addr, "\0\0\0\0\0\0", ETH_ALEN)) {
 			spin_lock_bh(&g_cdev.lock);
 			pd = g_cdev.active_pd;
 			g_cdev.active_pd = 0;
