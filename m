Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752023Ab0HMEzs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Aug 2010 00:55:48 -0400
Received: from eu1sys200aog119.obsmtp.com ([207.126.144.147]:38917 "EHLO
	eu1sys200aog119.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751391Ab0HMEzr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Aug 2010 00:55:47 -0400
Date: Fri, 13 Aug 2010 10:25:29 +0530
From: Rabin VINCENT <rabin.vincent@stericsson.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andy Whitcroft <apw@canonical.com>,
        Linus WALLEIJ <linus.walleij@stericsson.com>
Subject: Re: [PATCH] checkpatch: check for incorrect permissions
Message-ID: <20100813045528.GA32350@bnru01.bnr.st.com>
References: <1281590145-30708-1-git-send-email-rabin.vincent@stericsson.com>
 <20100812140222.d3dedf91.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20100812140222.d3dedf91.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 12, 2010 at 23:02:22 +0200, Andrew Morton wrote:
> On Thu, 12 Aug 2010 10:45:45 +0530
> Rabin Vincent <rabin.vincent@stericsson.com> wrote:
> >  		# extract the filename as it passes
> > -		if ($line=~/^\+\+\+\s+(\S+)/) {
> > +		if ($line=~/^\+\+\+\s+(\S+)/ || $line=~/^diff\s.*?(\S+)$/) {
> 
> Breakage.  This causes the false warning:
> 
> WARNING: patch prefix 'drivers' exists, appears to be a -p0 patch

I've fixed this by matching for the filename in the diff line only when
it's "diff --git".  Also prevented a double-print of the "do not modify
file in include/asm" error.

>From b854ea24f1bd5391a63d8d4e2aa63e1c10870816 Mon Sep 17 00:00:00 2001
From: Rabin Vincent <rabin.vincent@stericsson.com>
Date: Wed, 11 Aug 2010 14:45:45 +0530
Subject: [PATCHv2] checkpatch: check for incorrect permissions

Throw an error when a source file has been given execute permissions
using the mode change line present in git diffs.  Also alow the filename
matching to use the "diff" line in addition to the "+++" line, since the
mode change lines appear before any "+++" lines.

Cc: Andy Whitcroft <apw@canonical.com>
Acked-by: Linus Walleij <linus.walleij@stericsson.com>
Signed-off-by: Rabin Vincent <rabin.vincent@stericsson.com>
---
 scripts/checkpatch.pl |   14 +++++++++++++-
 1 files changed, 13 insertions(+), 1 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 2039acd..a6858be 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -1308,7 +1308,7 @@ sub process {
 		$here = "#$realline: " if ($file);
 
 		# extract the filename as it passes
-		if ($line=~/^\+\+\+\s+(\S+)/) {
+		if ($line =~ /^\+\+\+\s+(\S+)/ || $line =~ /^diff --git.*?(\S+)$/) {
 			$realfile = $1;
 			$realfile =~ s@^([^/]*)/@@;
 
@@ -1318,6 +1318,10 @@ sub process {
 				WARN("patch prefix '$p1_prefix' exists, appears to be a -p0 patch\n");
 			}
 
+			# filename based errors will anyway get printed when we
+			# get to the context lines
+			next if ($line =~ /^diff/);
+
 			if ($realfile =~ m@^include/asm/@) {
 				ERROR("do not modify files in include/asm, change architecture specific files in include/asm-<architecture>\n" . "$here$rawline\n");
 			}
@@ -1332,6 +1336,14 @@ sub process {
 
 		$cnt_lines++ if ($realcnt != 0);
 
+# Check for incorrect file permissions
+		if ($line =~ /^new (file )?mode.*[7531]\d{0,2}$/) {
+			my $permhere = $here . "FILE: $realfile\n";
+			if ($realfile =~ /(Makefile|Kconfig|\.c|\.h|\.S|\.tmpl)$/) {
+				ERROR("do not set execute permissions for source files\n" . $permhere);
+			}
+		}
+
 #check the patch for a signoff:
 		if ($line =~ /^\s*signed-off-by:/i) {
 			# This is a signoff, if ugly, so do not double report.
-- 
1.7.2.dirty

