Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753008Ab0LLXJX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 18:09:23 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:24703 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752726Ab0LLXJW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 18:09:22 -0500
Date: Mon, 13 Dec 2010 00:02:55 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: autofs@linux.kernel.org
cc: linux-kernel@vger.kernel.org, Ian Kent <raven@themaw.net>
Subject: [PATCH][RFC] autofs4: Do not potentially dereference null pointer
 returned by fget() in autofs_dev_ioctl_setpipefd()
Message-ID: <alpine.LNX.2.00.1012122357570.9206@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

In fs/autofs4/dev-ioctl.c::autofs_dev_ioctl_setpipefd() we call fget(), 
which may return NULL, but we do not explicitly test for that NULL return 
so we may end up dereferencing a NULL pointer - bad.

A comment in fget() says "File object ref couldn't be taken" when that 
function returns NULL, so I guess EBUSY is the proper error to return from 
autofs_dev_ioctl_setpipefd() when this happens, but I'm far from sure 
about this, so I'd like some feedback before this patch is merged.


Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 dev-ioctl.c |    4 ++++
 1 file changed, 4 insertions(+)

 compile tested only.

diff --git a/fs/autofs4/dev-ioctl.c b/fs/autofs4/dev-ioctl.c
index eff9a41..ab551ee 100644
--- a/fs/autofs4/dev-ioctl.c
+++ b/fs/autofs4/dev-ioctl.c
@@ -372,6 +372,10 @@ static int autofs_dev_ioctl_setpipefd(struct file *fp,
 		return -EBUSY;
 	} else {
 		struct file *pipe = fget(pipefd);
+		if (!pipe) {
+			err = -EBUSY;
+			goto out;
+		}
 		if (!pipe->f_op || !pipe->f_op->write) {
 			err = -EPIPE;
 			fput(pipe);



-- 
Jesper Juhl <jj@chaosbits.net>            http://www.chaosbits.net/
Don't top-post http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please.

