Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755287Ab2HQTi3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 15:38:29 -0400
Received: from 1010ds2-suoe.0.fullrate.dk ([90.184.90.115]:11216 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752944Ab2HQTiW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 15:38:22 -0400
Date: Fri, 17 Aug 2012 21:38:20 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: Tony Finch <dot@dotat.at>
cc: linux-kernel@vger.kernel.org
Subject: [PATCH] unifdef: set a secure umask before calling mkstemp()
Message-ID: <alpine.LNX.2.00.1208172136490.15699@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In newer glibc's (versions > 2.06) reasonably secure permissions of
0600 are used when creating a temporary file with mkstemp(). But for
older glibc's (versions <= 2.06) 0666 is used which is not secure.

To ensure that the temporary files created always have reasonably
secure permissions, add a call to umask() that ensures we always set
at most 0600 on the temporary file (and then restore the umask again
so we don't interfere with anything that hapens further on).

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 scripts/unifdef.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/scripts/unifdef.c b/scripts/unifdef.c
index 7493c0e..f9188fb 100644
--- a/scripts/unifdef.c
+++ b/scripts/unifdef.c
@@ -342,9 +342,10 @@ main(int argc, char *argv[])
 				    "%.*s/" TEMPLATE,
 				    (int)(dirsep - ofilename), ofilename);
 			else
-				snprintf(tempname, sizeof(tempname),
-				    TEMPLATE);
+				snprintf(tempname, sizeof(tempname), TEMPLATE);
+			mode_t mask = umask(S_IXUSR | S_IRWXG | S_IRWXO);
 			ofd = mkstemp(tempname);
+			umask(mask);
 			if (ofd != -1)
 				output = fdopen(ofd, "wb+");
 			if (output == NULL)
-- 
1.7.11.4


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

