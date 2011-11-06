Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753776Ab1KFCOd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Nov 2011 22:14:33 -0400
Received: from mta11.charter.net ([216.33.127.80]:38968 "EHLO
	mta11.charter.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752210Ab1KFCOb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Nov 2011 22:14:31 -0400
X-Greylist: delayed 851 seconds by postgrey-1.27 at vger.kernel.org; Sat, 05 Nov 2011 22:14:31 EDT
X-Authority-Analysis: v=1.1 cv=6DnK9SlspjQUafU6MzYmZAt1wpB1MUaNH28Mo/Kfxqk=
 c=1 sm=1 a=KS-gIzwgzq0A:10 a=lDGNyK2vIvEA:10 a=xzrYXqw+0zwiO4gHSXHcAg==:17
 a=pGLkceISAAAA:8 a=lOJ6EeQOOqWRJFn9WD4A:9 a=MSl-tDqOz04A:10
 a=xzrYXqw+0zwiO4gHSXHcAg==:117
From: Gregory.Dietsche@cuw.edu
To: julia@diku.dk, Gilles.Muller@lip6.fr, npalix.work@gmail.com,
        mmarek@suse.cz
Cc: rdunlap@xenotime.net, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, cocci@diku.dk,
        Greg Dietsche <Gregory.Dietsche@cuw.edu>
Subject: [RESEND 3/3] coccicheck: add parallel execution
Date: Sat,  5 Nov 2011 21:14:13 -0500
Message-Id: <1320545653-28249-4-git-send-email-Gregory.Dietsche@cuw.edu>
X-Mailer: git-send-email 1.7.6.4
In-Reply-To: <1320545653-28249-1-git-send-email-Gregory.Dietsche@cuw.edu>
References: <1320545653-28249-1-git-send-email-Gregory.Dietsche@cuw.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg Dietsche <Gregory.Dietsche@cuw.edu>

For example to process 6 SmPL patches at the same time:
	make coccicheck PARALLEL=6

Results are held in /tmp until the scripts finish. By doing this the
script is able to collate the results from each SmPL patch instead of
interleaving them in the output.

Version 2: change pkill -P $$ to pkill -s 0

Signed-off-by: Greg Dietsche <Gregory.Dietsche@cuw.edu>
Acked-by: Nicolas Palix <npalix.work@gmail.com>
---
 scripts/coccicheck |   27 ++++++++++++++++++++++++++-
 1 files changed, 26 insertions(+), 1 deletions(-)

diff --git a/scripts/coccicheck b/scripts/coccicheck
index 1bb1a1b..c2a04c2 100755
--- a/scripts/coccicheck
+++ b/scripts/coccicheck
@@ -97,10 +97,35 @@ coccinelle () {
 
 }
 
+parallel_cleanup () {
+	pkill -s 0 > /dev/null
+	rm /tmp/cocci_parallel_$$_* 2>/dev/null
+	exit
+}
+
+trap parallel_cleanup SIGINT
+PARALLEL_ID=0
+
 if [ "$COCCI" = "" ] ; then
     for f in `find $srctree/scripts/coccinelle/ -name '*.cocci' -type f | sort`; do
-	coccinelle $f
+	if [ "$PARALLEL" -eq "$PARALLEL" 2>/dev/null ] ; then
+		if [ "$ONLINE" = "0" ] ; then
+			echo Processing: `basename $f`
+		fi
+		coccinelle $f>/tmp/cocci_parallel_$$_$PARALLEL_ID 2>&1 &
+		PARALLEL_ID=$(($PARALLEL_ID + 1))
+		while [ "`jobs -p | wc -l`" -ge "$PARALLEL" ] ; do
+			sleep 3
+		done
+	else
+		coccinelle $f
+	fi
     done
+    wait
+    if [ "$PARALLEL_ID" -ge "0" ] ; then
+	cat /tmp/cocci_parallel_$$_*
+	parallel_cleanup
+    fi
 else
     coccinelle $COCCI
 fi
-- 
1.7.6.4

