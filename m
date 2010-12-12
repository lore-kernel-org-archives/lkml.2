Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752786Ab0LLWYn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 17:24:43 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:23968 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752558Ab0LLWYm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 17:24:42 -0500
Date: Sun, 12 Dec 2010 23:18:15 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: linux-kernel@vger.kernel.org
cc: Jan Kara <jack@suse.cz>, Ben Fennema <bfennema@falcon.csc.calpoly.edu>
Subject: [PATCH] UDF: Close small mem leak in udf_find_entry()
Message-ID: <alpine.LNX.2.00.1012122313290.9206@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

There's a small memory leak in fs/udf/namei.c::udf_find_entry().

We dynamically allocate memory for 'fname' with kmalloc() and in most 
situations we free it before we leave the function, but there is one 
situation where we do not (but should). This patch closes the leak by 
jumping to the 'out_ok' label which does the correct cleanup rather than 
doing half the cleanup and returning directly.


Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 namei.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

 compile tested only

diff --git a/fs/udf/namei.c b/fs/udf/namei.c
index 6d8dc02..899ef91 100644
--- a/fs/udf/namei.c
+++ b/fs/udf/namei.c
@@ -228,10 +228,8 @@ static struct fileIdentDesc *udf_find_entry(struct inode *dir,
 		}
 
 		if ((cfi->fileCharacteristics & FID_FILE_CHAR_PARENT) &&
-		    isdotdot) {
-			brelse(epos.bh);
-			return fi;
-		}
+		    isdotdot)
+			goto out_ok;
 
 		if (!lfi)
 			continue;



-- 
Jesper Juhl <jj@chaosbits.net>            http://www.chaosbits.net/
Don't top-post http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please.

