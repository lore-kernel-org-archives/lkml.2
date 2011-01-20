Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755847Ab1ATXAh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 18:00:37 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:24566 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755694Ab1ATXAg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 18:00:36 -0500
Date: Fri, 21 Jan 2011 00:00:56 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: linux-kernel@vger.kernel.org
cc: James Morris <jmorris@intercode.com.au>, James Morris <jmorris@namei.org>,
        "David S. Miller" <davem@redhat.com>,
        David Miller <davem@davemloft.net>, Steve French <sfrench@us.ibm.com>,
        Steve French <smfrench@gmail.com>, Andrew Tridgell <tridge@samba.org>
Subject: [PATCH] Do not potentially overflow string in sumversion
Message-ID: <alpine.LNX.2.00.1101202353010.11854@swampdragon.chaosbits.net>
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
---
 sumversion.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

  compile tested only

diff --git a/scripts/mod/sumversion.c b/scripts/mod/sumversion.c
index ecf9c7d..35e9404 100644
--- a/scripts/mod/sumversion.c
+++ b/scripts/mod/sumversion.c
@@ -401,7 +401,7 @@ void get_src_version(const char *modname, char sum[], unsigned sumlen)
 		basename = strrchr(modname, '/') + 1;
 	else
 		basename = modname;
-	sprintf(filelist, "%s/%.*s.mod", modverdir,
+	snprintf(filelist, PATH_MAX + 1, "%s/%.*s.mod", modverdir,
 		(int) strlen(basename) - 2, basename);
 
 	file = grab_file(filelist, &len);


-- 
Jesper Juhl <jj@chaosbits.net>            http://www.chaosbits.net/
Don't top-post http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please.

