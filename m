Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992700Ab2K3S40 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 13:56:26 -0500
Received: from mail.kernel.org ([198.145.19.201]:58338 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992616Ab2K3S4X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 13:56:23 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Jianpeng Ma <majianpeng@gmail.com>, NeilBrown <neilb@suse.de>
Subject: [ 25/56] md: Avoid write invalid address if read_seqretry returned true.
Date: Fri, 30 Nov 2012 10:55:17 -0800
Message-Id: <20121130185120.834782969@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.197.g5a90748
In-Reply-To: <20121130185118.302752929@linuxfoundation.org>
References: <20121130185118.302752929@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: majianpeng <majianpeng@gmail.com>

commit 35f9ac2dcec8f79d7059ce174fd7b7ee3290d620 upstream.

If read_seqretry returned true and bbp was changed, it will write
invalid address which can cause some serious problem.

This bug was introduced by commit v3.0-rc7-130-g2699b67.
So fix is suitable for 3.0.y thru 3.6.y.

Reported-by: zhuwenfeng@kedacom.com
Tested-by: zhuwenfeng@kedacom.com
Signed-off-by: Jianpeng Ma <majianpeng@gmail.com>
Signed-off-by: NeilBrown <neilb@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/md/md.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -1805,10 +1805,10 @@ retry:
 			memset(bbp, 0xff, PAGE_SIZE);
 
 			for (i = 0 ; i < bb->count ; i++) {
-				u64 internal_bb = *p++;
+				u64 internal_bb = p[i];
 				u64 store_bb = ((BB_OFFSET(internal_bb) << 10)
 						| BB_LEN(internal_bb));
-				*bbp++ = cpu_to_le64(store_bb);
+				bbp[i] = cpu_to_le64(store_bb);
 			}
 			bb->changed = 0;
 			if (read_seqretry(&bb->lock, seq))


