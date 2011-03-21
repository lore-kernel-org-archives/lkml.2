Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754069Ab1CUTSJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 15:18:09 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:17902 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751541Ab1CUTSF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 15:18:05 -0400
Date: Mon, 21 Mar 2011 20:17:55 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: linux-kbuild@vger.kernel.org
cc: linux-kernel@vger.kernel.org, WANG Cong <xiyou.wangcong@gmail.com>,
        James Morris <jmorris@intercode.com.au>,
        James Morris <jmorris@namei.org>, "David S. Miller" <davem@redhat.com>,
        David Miller <davem@davemloft.net>, Steve French <sfrench@us.ibm.com>,
        Steve French <smfrench@gmail.com>, Andrew Tridgell <tridge@samba.org>
Subject: [PATCH][resend] Do not potentially overflow string in sumversion
Message-ID: <alpine.LNX.2.00.1103212013060.15815@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In scripts/mod/sumversion.c (in get_src_version()) we call 
getenv("MODVERDIR"). This returns a pointer to a string of unknown length. 
This string of unknown length we then pass on as an argument to sprintf() 
and tell it to write the result to 'filelist' which has a, very much 
fixed, size of 'PATH_MAX + 1'. If the string returned by getenv() is too 
long we'll overrun the statically allocated buffer.
This patch prevents the buffer overrun by using snprintf() and telling it 
to copy a maximum of 'PATH_MAX + 1' bytes (including the terminating \0).

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
Acked-by: WANG Cong <xiyou.wangcong@gmail.com>
---
 sumversion.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

 compile tested only. Patch against Linus' tree as of right now.

diff --git 
a/scripts/mod/sumversion.c 
b/scripts/mod/sumversion.c
index 9dfcd6d..522c675 100644
--- a/scripts/mod/sumversion.c
+++ b/scripts/mod/sumversion.c
@@ -416,7 +416,7 @@ void get_src_version(const char *modname, char sum[], unsigned sumlen)
 		basename = strrchr(modname, '/') + 1;
 	else
 		basename = modname;
-	sprintf(filelist, "%s/%.*s.mod", modverdir,
+	snprintf(filelist, PATH_MAX + 1, "%s/%.*s.mod", modverdir,
 		(int) strlen(basename) - 2, basename);
 
 	file = grab_file(filelist, &len);


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

