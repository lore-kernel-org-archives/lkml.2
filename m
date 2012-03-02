Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965314Ab2CBBpm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 20:45:42 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:39248 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965234Ab2CBBpl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 20:45:41 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of udknight@gmail.com designates 10.50.15.231 as permitted sender) smtp.mail=udknight@gmail.com; dkim=pass header.i=udknight@gmail.com
Date: Fri, 2 Mar 2012 09:45:31 +0800
From: Wang YanQing <udknight@gmail.com>
To: spock@gentoo.org
Cc: FlorianSchandinat@gmx.de, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] video:uvesafb: notice user when we failed to save hardware
 state
Message-ID: <20120302014531.GA3597@udknight>
Mail-Followup-To: Wang YanQing <Udknight@gmail.com>, spock@gentoo.org,
	FlorianSchandinat@gmx.de, linux-fbdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


uvesafb_open may failed to save hardware state when kmalloc failed
in uvesafb_vbe_state_save, we should check this and notice user.

Signed-off-by: Wang YanQing <udknight@gmail.com>
---
 drivers/video/uvesafb.c |   14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/drivers/video/uvesafb.c b/drivers/video/uvesafb.c
index e7f69ef..9db3de3 100644
--- a/drivers/video/uvesafb.c
+++ b/drivers/video/uvesafb.c
@@ -362,7 +362,7 @@ static u8 *uvesafb_vbe_state_save(struct uvesafb_par *par)
 
 	state = kmalloc(par->vbe_state_size, GFP_KERNEL);
 	if (!state)
-		return NULL;
+		return ERR_PTR(-ENOMEM);
 
 	task = uvesafb_prep();
 	if (!task) {
@@ -1172,9 +1172,17 @@ static int uvesafb_open(struct fb_info *info, int user)
 {
 	struct uvesafb_par *par = info->par;
 	int cnt = atomic_read(&par->ref_count);
+	u8 *buf = NULL;
 
-	if (!cnt && par->vbe_state_size)
-		par->vbe_state_orig = uvesafb_vbe_state_save(par);
+	if (!cnt && par->vbe_state_size) {
+		buf =  uvesafb_vbe_state_save(par);
+		if (IS_ERR(buf)) {
+			printk(KERN_WARNING "uvesafb: save hardware state"
+				"failed, error code is %ld!\n", PTR_ERR(buf));
+		} else {
+			par->vbe_state_orig = buf;
+		}
+	}
 
 	atomic_inc(&par->ref_count);
 	return 0;
-- 
1.7.9.2.315.g25a78
