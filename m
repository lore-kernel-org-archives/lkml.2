Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754883Ab0KURkG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Nov 2010 12:40:06 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:39605 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754524Ab0KURkD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Nov 2010 12:40:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer;
        b=E4Wu7nT0C+9Ts9Y6WDeqLmK/qshKzr1sXXdm/Hv3U3jUH85uR6NPQ81+N3Ugs/lxwc
         MBVxSKtDe1l+coHHQCwTSkHOyH4pS0h2EsHgSucx2vlgmB26FMMfz9zTuazQMsHPbI0b
         dSkQgLeS46ZvjJ3riTKAOhu+5XIDmVd1QYO44=
From: Vasiliy Kulikov <segoon@openwall.com>
To: kernel-janitors@vger.kernel.org
Cc: Dave Airlie <airlied@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tiago Vignatti <tiago.vignatti@nokia.com>,
        Mike Travis <travis@sgi.com>, "H. Peter Anvin" <hpa@zytor.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] gpu: vga: fix ZERO_SIZE_PTR dereference
Date: Sun, 21 Nov 2010 20:39:54 +0300
Message-Id: <1290361196-14999-1-git-send-email-segoon@openwall.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

count is not checked before kmalloc() call, if it is -1 then
kmalloc() returns ZERO_SIZE_PTR. This pointer is then dereferenced.
Also one may pass too big count to generate OOM condition.
To prevent this limit 'count' maximum value.  PAGE_SIZE looks OK.

Signed-off-by: Vasiliy Kulikov <segoon@openwall.com>
---
 Compile tested only.

 drivers/gpu/vga/vgaarb.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/gpu/vga/vgaarb.c b/drivers/gpu/vga/vgaarb.c
index c380c65..09e3090 100644
--- a/drivers/gpu/vga/vgaarb.c
+++ b/drivers/gpu/vga/vgaarb.c
@@ -836,6 +836,8 @@ static ssize_t vga_arb_write(struct file *file, const char __user * buf,
 	int ret_val;
 	int i;
 
+	if (count > PAGE_SIZE)
+		count = PAGE_SIZE;
 
 	kbuf = kmalloc(count + 1, GFP_KERNEL);
 	if (!kbuf)
-- 
1.7.0.4

