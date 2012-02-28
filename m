Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932198Ab2B1AaA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 19:30:00 -0500
Received: from mail.windriver.com ([147.11.1.11]:58699 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932185Ab2B1A37 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 19:29:59 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: apw@canonical.com
Cc: akpm@linux-foundation.org, joe@perches.com, linux-kernel@vger.kernel.org,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [PATCH] checkpatch: do not try to sanity test cover letters
Date: Mon, 27 Feb 2012 19:29:36 -0500
Message-Id: <1330388976-30633-1-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

One possibly common workflow is this:

	git format-patch -o mypatches --cover-letter ^start end
	./scripts/checkpatch.pl mypatches/*

The problem with the above is that checkpatch.pl will try to
parse the cover-letter, and of course complain that it can not
find any unified diff within.

It is pretty safe for us to assume "0000-cover-letter.patch" is
not in fact a patch and simply skip processing of it.

Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---

[what I know about perl could be written on the back of a postage
 stamp in crayon, so please feel free to reimplement the overall
 concept of this change as you see fit.... ]

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index a3b9782..fc22f4b 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -6,6 +6,7 @@
 # Licensed under the terms of the GNU GPL License version 2
 
 use strict;
+use File::Basename;
 
 my $P = $0;
 $P =~ s@.*/@@g;
@@ -382,6 +383,10 @@ for my $filename (@ARGV) {
 		open($FILE, '<', "$filename") ||
 			die "$P: $filename: open failed - $!\n";
 	}
+	if (basename($filename) eq '0000-cover-letter.patch') {
+		print "Skipping cover letter $filename\n";
+		next;
+	}
 	if ($filename eq '-') {
 		$vname = 'Your patch';
 	} else {
-- 
1.7.9.1

