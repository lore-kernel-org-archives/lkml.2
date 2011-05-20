Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756426Ab1ETATM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 20:19:12 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:50692 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934550Ab1ETAL2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 20:11:28 -0400
X-Sasl-enc: ijbzL91kiEwHPoyfLdqlVOQTg6gp6qQer6XLuhScjNPu 1305850287
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Kay Sievers <kay.sievers@vrfy.org>,
        Lennart Poettering <lennart@poettering.net>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 13/44] kmsg: properly support writev to avoid interleaved printk lines fix
Date: Thu, 19 May 2011 17:10:31 -0700
Message-Id: <1305850262-9575-13-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.4.2
In-Reply-To: <1305850262-9575-1-git-send-email-gregkh@suse.de>
References: <20110520000821.GA9367@kroah.com>
 <1305850262-9575-1-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrew Morton <akpm@linux-foundation.org>

make `len' size_t, avoid multiple-assignments.

Cc: Kay Sievers <kay.sievers@vrfy.org>
Cc: Lennart Poettering <lennart@poettering.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/char/mem.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/char/mem.c b/drivers/char/mem.c
index 78923a9..8fc04b4 100644
--- a/drivers/char/mem.c
+++ b/drivers/char/mem.c
@@ -810,11 +810,11 @@ static ssize_t kmsg_writev(struct kiocb *iocb, const struct iovec *iv,
 			   unsigned long count, loff_t pos)
 {
 	char *line, *p;
-	int len, i;
+	int i;
 	ssize_t ret = -EFAULT;
+	size_t len = iov_length(iv, count);
 
-	len = iov_length(iv, count);
-	line = p = kmalloc(len + 1, GFP_KERNEL);
+	line = kmalloc(len + 1, GFP_KERNEL);
 	if (line == NULL)
 		return -ENOMEM;
 
@@ -822,6 +822,7 @@ static ssize_t kmsg_writev(struct kiocb *iocb, const struct iovec *iv,
 	 * copy all vectors into a single string, to ensure we do
 	 * not interleave our log line with other printk calls
 	 */
+	p = line;
 	for (i = 0; i < count; i++) {
 		if (copy_from_user(p, iv[i].iov_base, iv[i].iov_len))
 			goto out;
-- 
1.7.4.2

