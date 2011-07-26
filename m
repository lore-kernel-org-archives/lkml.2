Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754004Ab1GZWge (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 18:36:34 -0400
Received: from mta21.charter.net ([216.33.127.81]:35739 "EHLO
	mta21.charter.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753552Ab1GZWgc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 18:36:32 -0400
X-Authority-Analysis: v=1.1 cv=1b2X7W/SifksZeClH/haT1SUt4udqxFGF00pZw2/jJk=
 c=1 sm=1 a=rCW5EqJiSQUA:10 a=lDGNyK2vIvEA:10 a=xzrYXqw+0zwiO4gHSXHcAg==:17
 a=lOJ6EeQOOqWRJFn9WD4A:9 a=xzrYXqw+0zwiO4gHSXHcAg==:117
From: Greg Dietsche <Gregory.Dietsche@cuw.edu>
To: Nicolas.Palix@inria.fr
Cc: joe@perches.com, julia@diku.dk, Gilles.Muller@lip6.fr,
        rdunlap@xenotime.net, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, cocci@diku.dk, mmarek@suse.cz,
        Greg Dietsche <Gregory.Dietsche@cuw.edu>
Subject: [PATCH v2] coccicheck: add parallel execution
Date: Tue, 26 Jul 2011 17:36:57 -0500
Message-Id: <1311719817-11336-1-git-send-email-Gregory.Dietsche@cuw.edu>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <CAAxaTiNJNXnn3PAcKWBSZ2wbMKBDD9yL6pyediEEBHnjNH-uaA@mail.gmail.com>
References: <CAAxaTiNJNXnn3PAcKWBSZ2wbMKBDD9yL6pyediEEBHnjNH-uaA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For example to process 6 SmPL patches at the same time:
	make coccicheck PARALLEL=6

Results are held in /tmp until the scripts finish. By doing this the
script is able to collate the results from each SmPL patch instead of
interleaving them in the output.

Version 2: change pkill -P $$ to pkill -s 0

Signed-off-by: Greg Dietsche <Gregory.Dietsche@cuw.edu>
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
1.7.2.5

