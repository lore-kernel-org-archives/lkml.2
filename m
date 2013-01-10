Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752302Ab3AJGFJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 01:05:09 -0500
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:55251 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751735Ab3AJGFH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 01:05:07 -0500
X-AuditID: 9c930179-b7c7fae00000255c-60-50ee5a1177c0
From: Minchan Kim <minchan@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Minchan Kim <minchan@kernel.org>, Mel Gorman <mgorman@suse.de>,
        Andy Whitcroft <apw@shadowen.org>, Alexander Nyberg <alexn@dsv.su.se>
Subject: [PATCH] Fix wrong EOF compare
Date: Thu, 10 Jan 2013 15:05:04 +0900
Message-Id: <1357797904-11194-1-git-send-email-minchan@kernel.org>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

getc returns "int" so EOF could be -1 but storing getc's return
value to char directly makes the vaule to 255 so below condition
is always false.

It happens in my ARM system so loop is not ended, then segfaulted.
This patch fixes it.

                *curr = getc(fin); // *curr = 255
                if (*curr == EOF) return -1; // if ( 255 == -1)

Cc: Mel Gorman <mgorman@suse.de>
Cc: Andy Whitcroft <apw@shadowen.org>
Cc: Alexander Nyberg <alexn@dsv.su.se>
Signed-off-by: Minchan Kim <minchan@kernel.org>
---
 Documentation/page_owner.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/Documentation/page_owner.c b/Documentation/page_owner.c
index f0156e1..b777fb6 100644
--- a/Documentation/page_owner.c
+++ b/Documentation/page_owner.c
@@ -32,12 +32,14 @@ int read_block(char *buf, FILE *fin)
 {
 	int ret = 0;
 	int hit = 0;
+	int vaule;
 	char *curr = buf;
 
 	for (;;) {
-		*curr = getc(fin);
-		if (*curr == EOF) return -1;
+		value = getc(fin);
+		if (value == EOF) return -1;
 
+		*curr = value;
 		ret++;
 		if (*curr == '\n' && hit == 1)
 			return ret - 1;
-- 
1.7.9.5

