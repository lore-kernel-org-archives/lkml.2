Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934295Ab0EZJ4v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 05:56:51 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:53695 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932728Ab0EZJ4u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 05:56:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=JuVlgr2vlG6R7sM5eIO1XDHlet4eqGfqxaPBsUkj0QVpJweeL9HEM4E/VIvSrOSCEC
         CKQsZb+6/KKeAPQNdmWdzlAVM+/5++FQzMsjn2vboHT1u/W0sKO+Tv5viOFmhE5VHhDr
         wNdNjYibnYvdK4RwG2G67oUFUfhGIAPa4A1KU=
From: Changli Gao <xiaosuo@gmail.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Changli Gao <xiaosuo@gmail.com>
Subject: [PATCH 2/3] splice: allow non-block splice only when in file is seekable
Date: Wed, 26 May 2010 17:56:08 +0800
Message-Id: <1274867768-3011-1-git-send-email-xiaosuo@gmail.com>
X-Mailer: git-send-email 1.6.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

allow non-block splice only when in file is seekable.

do_splice_to() is split to two parts: read data from in file to spd, and move
data from spd to pipe. If there isn't much space in pipe for the data in spd,
and the splice is called with non-block flag, the data dropped due to non
enough space in pipe will be lost forever when in file isn't seekable.

Signed-off-by: Changli Gao <xiaosuo@gmail.com>
----
 fs/splice.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)
diff --git a/fs/splice.c b/fs/splice.c
index 9e52de5..8137e23 100644
--- a/fs/splice.c
+++ b/fs/splice.c
@@ -1346,8 +1346,12 @@ static long do_splice(struct file *in, loff_t __user *off_in,
 			if (copy_from_user(&offset, off_in, sizeof(loff_t)))
 				return -EFAULT;
 			off = &offset;
-		} else
+		} else {
+			if ((flags & SPLICE_F_NONBLOCK) &&
+			    !(in->f_mode & FMODE_PREAD))
+				return -EINVAL;
 			off = &in->f_pos;
+		}
 
 		ret = do_splice_to(in, off, opipe, len, flags);
 
