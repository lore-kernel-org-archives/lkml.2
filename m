Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758131Ab0JVRdN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 13:33:13 -0400
Received: from webhosting01.bon.m2soft.com ([195.38.20.32]:42447 "EHLO
	webhosting01.bon.m2soft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755746Ab0JVRdN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 13:33:13 -0400
Date: Fri, 22 Oct 2010 19:29:53 +0200
From: Nicolas Kaiser <nikai@nikai.net>
To: Linus Walleij <linus.walleij@stericsson.com>
Cc: Per Friden <per.friden@stericsson.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH] dma/coh901318: fix copy_to_user error path
Message-ID: <20101022192953.1f67b10a@absol.kitzblitz>
Organization: -
X-Face: "fF&[w2"Nws:JNH4'g|:gVhgGKLhj|X}}&w&V?]0=,7n`jy8D6e[Jh=7+ca|4~t5e[ItpL5
 N'y~Mvi-vJm`"1T5fi1^b!&EG]6nW~C!FN},=$G?^U2t~n[3;u\"5-|~H{-5]IQ2
X-Mailer: Claws Mail (Linux)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If copy_to_user fails, the assigned error code instantly gets
overwritten, and the failure apparently ignored. Moreover,
shouldn't the error code be -EFAULT instead of -EINVAL?

Signed-off-by: Nicolas Kaiser <nikai@nikai.net>
---
 drivers/dma/coh901318.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/dma/coh901318.c b/drivers/dma/coh901318.c
index ae2b871..eac8867 100644
--- a/drivers/dma/coh901318.c
+++ b/drivers/dma/coh901318.c
@@ -140,8 +140,10 @@ static int coh901318_debugfs_read(struct file *file, char __user *buf,
 	if (count > dev_size - *f_pos)
 		count = dev_size - *f_pos;
 
-	if (copy_to_user(buf, dev_buf + *f_pos, count))
-		ret = -EINVAL;
+	if (copy_to_user(buf, dev_buf + *f_pos, count)) {
+		ret = -EFAULT;
+		goto out;
+	}
 	ret = count;
 	*f_pos += count;
 
-- 
1.7.2.2
