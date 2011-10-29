Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754337Ab1J2HqS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Oct 2011 03:46:18 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:33700 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752947Ab1J2HqR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Oct 2011 03:46:17 -0400
From: Federico Vaga <federico.vaga@gmail.com>
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        fmhess@users.sourceforge.net, abbotti@mev.co.uk, rubini@gnudd.com,
        federico.vaga@gmail.com
Subject: [PATCH] Staging: comedi: fix signal handling in read and write
Date: Sat, 29 Oct 2011 09:47:39 +0200
Message-Id: <1319874459-8150-1-git-send-email-federico.vaga@gmail.com>
X-Mailer: git-send-email 1.7.6.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After sleeping on a wait queue, signal_pending(current) should be
checked (not before sleeping).

Acked-by: Alessandro Rubini <rubini@gnudd.com>
Signed-off-by: Federico Vaga <federico.vaga@gmail.com>
---
 drivers/staging/comedi/comedi_fops.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/comedi/comedi_fops.c b/drivers/staging/comedi/comedi_fops.c
index 21d8c1c..f4a60d5 100644
--- a/drivers/staging/comedi/comedi_fops.c
+++ b/drivers/staging/comedi/comedi_fops.c
@@ -1640,11 +1640,11 @@ static ssize_t comedi_write(struct file *file, const char __user *buf,
 				retval = -EAGAIN;
 				break;
 			}
+			schedule();
 			if (signal_pending(current)) {
 				retval = -ERESTARTSYS;
 				break;
 			}
-			schedule();
 			if (!s->busy)
 				break;
 			if (s->busy != file) {
@@ -1741,11 +1741,11 @@ static ssize_t comedi_read(struct file *file, char __user *buf, size_t nbytes,
 				retval = -EAGAIN;
 				break;
 			}
+			schedule();
 			if (signal_pending(current)) {
 				retval = -ERESTARTSYS;
 				break;
 			}
-			schedule();
 			if (!s->busy) {
 				retval = 0;
 				break;
-- 
1.5.6.5

