Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757424Ab1DIMli (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Apr 2011 08:41:38 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:62770 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757119Ab1DIMle (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Apr 2011 08:41:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer;
        b=XmytxeWBzQCPwXr2iMXKW519PAB5UOp7sdZXRu85jxFFZOJ0Uv3oOSQ56yQ64iaYWU
         E3zMMA/VLkYTBa2qZxoSbBNsplOvI+XZyLxJJYVhFSjuYVjm8DRpT3rM2lmn6DJcMADh
         sQZSzIB7lgXYDZZZyRffEvdGki8qN7Bfc73/A=
From: Vasiliy Kulikov <segoon@openwall.com>
To: linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH] char: genrtc: fix infoleak to userspace
Date: Sat,  9 Apr 2011 16:41:30 +0400
Message-Id: <1302352890-20892-1-git-send-email-segoon@openwall.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

struct pll is copied to userspace.  It is filled in "multiplexing" function
get_rtc_pll().  At least one implementator, q40_get_rtc_pll(), doesn't
fill .pll_ctrl field.  It's hard to understand whether either the caller
or the callee must zero the unused struct fields, however, on another
ioctl commands the caller already zeroes the structure.  So, let's the
caller use memset().

Signed-off-by: Vasiliy Kulikov <segoon@openwall.com>
---
 drivers/char/genrtc.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/char/genrtc.c b/drivers/char/genrtc.c
index f773a9d..65cd683 100644
--- a/drivers/char/genrtc.c
+++ b/drivers/char/genrtc.c
@@ -273,6 +273,7 @@ static int gen_rtc_ioctl(struct file *file,
 	switch (cmd) {
 
 	case RTC_PLL_GET:
+	    memset(&pll, 0, sizeof(pll));
 	    if (get_rtc_pll(&pll))
 	 	    return -EINVAL;
 	    else
-- 
1.7.0.4

