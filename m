Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932978Ab2IGJ3q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 05:29:46 -0400
Received: from mail-gw3.nixu.fi ([193.209.237.7]:52829 "EHLO mail-gw3.nixu.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932109Ab2IGJ3n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 05:29:43 -0400
From: Pasi Savanainen <pasi.savanainen@nixu.com>
To: apw@canonical.com
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] checkpatch: check utf-8 content from a commit log when it's missing from charset
Date: Fri,  7 Sep 2012 12:33:07 +0300
Message-Id: <1347010387-4147-1-git-send-email-pasi.savanainen@nixu.com>
X-Mailer: git-send-email 1.7.9.5
Content-Type: text/plain; charset="us-ascii:utf-8"
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.7.7855,1.0.431,0.0.0000
 definitions=2012-09-07_03:2012-09-06,2012-09-07,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 ipscore=0 suspectscore=1
 phishscore=0 bulkscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=6.0.2-1203120001 definitions=main-1209070036
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Check that a commit log doesn't contain UTF-8 when a mail header
explicitly defines a different charset, like
'Content-Type: text/plain; charset="us-ascii"'

Signed-off-by: Pasi Savanainen <pasi.savanainen@nixu.com>
---
 scripts/checkpatch.pl |   15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index ca05ba2..5ae9188 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -1386,6 +1386,8 @@ sub process {
 	my $in_header_lines = 1;
 	my $in_commit_log = 0;		#Scanning lines before patch
 
+	my $non_utf8_charset = 0;
+
 	our @report = ();
 	our $cnt_lines = 0;
 	our $cnt_error = 0;
@@ -1686,10 +1688,17 @@ sub process {
 			$in_commit_log = 1;
 		}
 
-# Still not yet in a patch, check for any UTF-8
-		if ($in_commit_log && $realfile =~ /^$/ &&
+# Check if there is UTF-8 in a commit log when a mail header has explicitly
+# declined it, i.e defined some charset where it is missing.
+		if ($in_header_lines &&
+		    $rawline =~ /^Content-Type:.+charset="(.+)".*$/ &&
+		    $1 !~ /utf-8/i) {
+			$non_utf8_charset = 1;
+		}
+
+		if ($in_commit_log && $non_utf8_charset && $realfile =~ /^$/ &&
 		    $rawline =~ /$NON_ASCII_UTF8/) {
-			CHK("UTF8_BEFORE_PATCH",
+			WARN("UTF8_BEFORE_PATCH",
 			    "8-bit UTF-8 used in possible commit log\n" . $herecurr);
 		}
 
-- 
1.7.9.5

