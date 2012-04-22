Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752261Ab2DVSkv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Apr 2012 14:40:51 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:11167 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751298Ab2DVSku (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Apr 2012 14:40:50 -0400
Date: Sun, 22 Apr 2012 20:40:49 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: linux-kernel@vger.kernel.org
cc: Rusty Russell <rusty@rustcorp.com.au>,
        Alessio Igor Bogani <abogani@kernel.org>,
        Tony Lindgren <tony@atomide.com>, Ben Hutchings <ben@decadent.org.uk>,
        Russell King <rmk+kernel@arm.linux.org.uk>
Subject: [PATCH] modpost: Stop grab_file() from leaking filedescriptors if
 fstat() fails
Message-ID: <alpine.LNX.2.00.1204222039010.27455@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In case the open() call succeeds but the subsequent fstat() call
fails, then we'll return without close()'ing the filedescriptor.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 scripts/mod/modpost.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/scripts/mod/modpost.c b/scripts/mod/modpost.c
index c4e7d15..ea0eaca 100644
--- a/scripts/mod/modpost.c
+++ b/scripts/mod/modpost.c
@@ -337,17 +337,20 @@ static void sym_update_crc(const char *name, struct module *mod,
 void *grab_file(const char *filename, unsigned long *size)
 {
 	struct stat st;
-	void *map;
+	void *map = MAP_FAILED;
 	int fd;
 
 	fd = open(filename, O_RDONLY);
-	if (fd < 0 || fstat(fd, &st) != 0)
+	if (fd < 0)
 		return NULL;
+	if (fstat(fd, &st))
+		goto failed;
 
 	*size = st.st_size;
 	map = mmap(NULL, *size, PROT_READ|PROT_WRITE, MAP_PRIVATE, fd, 0);
-	close(fd);
 
+failed:
+	close(fd);
 	if (map == MAP_FAILED)
 		return NULL;
 	return map;
-- 
1.7.10


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

