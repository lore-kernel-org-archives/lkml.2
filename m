Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932398Ab0EYWhx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 18:37:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4504 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759044Ab0EYWhu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 18:37:50 -0400
Date: Tue, 25 May 2010 18:37:48 -0400
From: Prarit Bhargava <prarit@redhat.com>
To: linux-kernel@vger.kernel.org, hpa@zytor.com, ebiederm@xmission.com,
       vgoyal@redhat.com, mjg@redhat.com, arozansk@redhat.com
Cc: Prarit Bhargava <prarit@redhat.com>
Message-Id: <20100525223406.9446.46193.sendpatchset@prarit.bos.redhat.com>
Subject: [PATCH]: Fix checkstack warning in bunzip2 library
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix checkstack error:

lib/decompress_bunzip2.c: In function ‘get_next_block’:
lib/decompress_bunzip2.c:511: warning: the frame size of 1932 bytes is larger than 1024 bytes

byteCount, symToByte, and mtfSymbol cannot be declared static or allocated
dynamically so place them in the bunzip_data struct.

Signed-off-by: Prarit Bhargava <prarit@redhat.com>

diff --git a/lib/decompress_bunzip2.c b/lib/decompress_bunzip2.c
index a4e971d..81c8bb1 100644
--- a/lib/decompress_bunzip2.c
+++ b/lib/decompress_bunzip2.c
@@ -107,6 +107,8 @@ struct bunzip_data {
 	unsigned char selectors[32768];		/* nSelectors = 15 bits */
 	struct group_data groups[MAX_GROUPS];	/* Huffman coding tables */
 	int io_error;			/* non-zero if we have IO error */
+	int byteCount[256];
+	unsigned char symToByte[256], mtfSymbol[256];
 };
 
 
@@ -158,14 +160,16 @@ static int INIT get_next_block(struct bunzip_data *bd)
 	int *base = NULL;
 	int *limit = NULL;
 	int dbufCount, nextSym, dbufSize, groupCount, selector,
-		i, j, k, t, runPos, symCount, symTotal, nSelectors,
-		byteCount[256];
-	unsigned char uc, symToByte[256], mtfSymbol[256], *selectors;
+		i, j, k, t, runPos, symCount, symTotal, nSelectors, *byteCount;
+	unsigned char uc, *symToByte, *mtfSymbol, *selectors;
 	unsigned int *dbuf, origPtr;
 
 	dbuf = bd->dbuf;
 	dbufSize = bd->dbufSize;
 	selectors = bd->selectors;
+	byteCount = bd->byteCount;
+	symToByte = bd->symToByte;
+	mtfSymbol = bd->mtfSymbol;
 
 	/* Read in header signature and CRC, then validate signature.
 	   (last block signature means CRC is for whole file, return now) */
