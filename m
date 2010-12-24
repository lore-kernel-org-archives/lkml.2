Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752980Ab0LXUis (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Dec 2010 15:38:48 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:21077 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752519Ab0LXUir (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Dec 2010 15:38:47 -0500
Date: Fri, 24 Dec 2010 21:28:56 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: linux-kernel@vger.kernel.org
cc: jgarzik@pobox.com
Subject: [PATCH] gen_init_cpio: Avoid race between call to stat() and call
 to open()
Message-ID: <alpine.LNX.2.00.1012242125170.28973@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

In usr/gen_init_cpio.c::cpio_mkfile() a call to stat() is made based on 
pathname, subsequently the file is open()'ed and then the value of the 
initial stat() call is used to allocate a buffer. This is not safe since 
the file may change between the call to stat() and the call to open().
Safer to just open() the file and then do fstat() using the filedescriptor 
returned by open.


Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 gen_init_cpio.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/usr/gen_init_cpio.c b/usr/gen_init_cpio.c
index b2b3c2d..7cd4538 100644
--- a/usr/gen_init_cpio.c
+++ b/usr/gen_init_cpio.c
@@ -303,18 +303,18 @@ static int cpio_mkfile(const char *name, const char *location,
 
 	mode |= S_IFREG;
 
-	retval = stat (location, &buf);
-	if (retval) {
-		fprintf (stderr, "File %s could not be located\n", location);
-		goto error;
-	}
-
 	file = open (location, O_RDONLY);
 	if (file < 0) {
 		fprintf (stderr, "File %s could not be opened for reading\n", location);
 		goto error;
 	}
 
+	retval = fstat (file, &buf);
+	if (retval) {
+		fprintf (stderr, "File %s could not be stat()'ed\n", location);
+		goto error;
+	}
+
 	filebuf = malloc(buf.st_size);
 	if (!filebuf) {
 		fprintf (stderr, "out of memory\n");




-- 
Jesper Juhl <jj@chaosbits.net>            http://www.chaosbits.net/
Don't top-post http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please.

