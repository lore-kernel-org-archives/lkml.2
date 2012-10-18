Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754951Ab2JRJRE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 05:17:04 -0400
Received: from cyclops.biessmann.org ([134.0.25.77]:49560 "EHLO
	cyclops.biessmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753491Ab2JRJRB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 05:17:01 -0400
X-Greylist: delayed 482 seconds by postgrey-1.27 at vger.kernel.org; Thu, 18 Oct 2012 05:17:01 EDT
From: =?UTF-8?q?Andreas=20Bie=C3=9Fmann?= <andreas@biessmann.de>
To: linux-kernel@vger.kernel.org
Cc: =?UTF-8?q?Andreas=20Bie=C3=9Fmann?= <andreas@biessmann.de>
Subject: [PATCH] scripts/pnmtologo: fix for plain PBM
Date: Thu, 18 Oct 2012 11:08:49 +0200
Message-Id: <1350551329-3521-1-git-send-email-andreas@biessmann.de>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

PBM generated with current tools do not have a whitespace between the digits.
Therefore the pnmtologo tool fails to gernerate the required C-Array for these
images.  This patch fixes that behaviour and can handle both 'old style' and
'new style' PBM files.

Signed-off-by: Andreas Bießmann <andreas@biessmann.de>
---
 scripts/pnmtologo.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/scripts/pnmtologo.c b/scripts/pnmtologo.c
index 5c11312..66f8d7a 100644
--- a/scripts/pnmtologo.c
+++ b/scripts/pnmtologo.c
@@ -74,6 +74,7 @@ static unsigned int logo_height;
 static struct color **logo_data;
 static struct color logo_clut[MAX_LINUX_LOGO_COLORS];
 static unsigned int logo_clutsize;
+static int is_plain_pbm = 0;
 
 static void die(const char *fmt, ...)
     __attribute__ ((noreturn)) __attribute ((format (printf, 1, 2)));
@@ -103,6 +104,11 @@ static unsigned int get_number(FILE *fp)
     val = 0;
     while (isdigit(c)) {
 	val = 10*val+c-'0';
+	/* some PBM are 'broken'; GiMP for example exports a PBM without space
+	 * between the digits. This is Ok cause we know a PBM can only have a '1'
+	 * or a '0' for the digit. */
+	if (is_plain_pbm)
+		break;
 	c = fgetc(fp);
 	if (c == EOF)
 	    die("%s: end of file\n", filename);
@@ -167,6 +173,7 @@ static void read_image(void)
     switch (magic) {
 	case '1':
 	    /* Plain PBM */
+	    is_plain_pbm = 1;
 	    for (i = 0; i < logo_height; i++)
 		for (j = 0; j < logo_width; j++)
 		    logo_data[i][j].red = logo_data[i][j].green =
-- 
1.7.10.4

