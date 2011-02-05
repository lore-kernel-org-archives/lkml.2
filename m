Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752803Ab1BETwi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Feb 2011 14:52:38 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:28758 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752259Ab1BETwh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Feb 2011 14:52:37 -0500
Date: Sat, 5 Feb 2011 20:51:53 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: David Airlie <airlied@linux.ie>
cc: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: [PATCH] radeon mkregtable: Add missing fclose() calls
Message-ID: <alpine.LNX.2.00.1102052047130.12305@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

drivers/gpu/drm/radeon/mkregtable.c:parser_auth() almost always remembers 
to fclose(file) before returning, but it misses two spots.

This is not really important since the process will exit shortly after and 
thus close the file for us, but being explicit prevents static analysis 
tools from complaining about leaked memory and missing fclose() calls and 
it also seems to be the prefered style of the existing code to explicitly 
close the file.

So, here's a patch to add the two missing fclose() calls.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 mkregtable.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/radeon/mkregtable.c b/drivers/gpu/drm/radeon/mkregtable.c
index 607241c..5a82b6b 100644
--- a/drivers/gpu/drm/radeon/mkregtable.c
+++ b/drivers/gpu/drm/radeon/mkregtable.c
@@ -673,8 +673,10 @@ static int parser_auth(struct table *t, const char *filename)
 	last_reg = strtol(last_reg_s, NULL, 16);
 
 	do {
-		if (fgets(buf, 1024, file) == NULL)
+		if (fgets(buf, 1024, file) == NULL) {
+			fclose(file);
 			return -1;
+		}
 		len = strlen(buf);
 		if (ftell(file) == end)
 			done = 1;
@@ -685,6 +687,7 @@ static int parser_auth(struct table *t, const char *filename)
 				fprintf(stderr,
 					"Error matching regular expression %d in %s\n",
 					r, filename);
+				fclose(file);
 				return -1;
 			} else {
 				buf[match[0].rm_eo] = 0;


-- 
Jesper Juhl <jj@chaosbits.net>            http://www.chaosbits.net/
Don't top-post http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please.

