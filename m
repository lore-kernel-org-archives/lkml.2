Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755029Ab0KFM2N (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Nov 2010 08:28:13 -0400
Received: from mail.perches.com ([173.55.12.10]:4423 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754139Ab0KFM2M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Nov 2010 08:28:12 -0400
Subject: [PATCH] scripts/get_maintainer.pl:  Use --git-fallback more often
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20101105135038.7ea63465.akpm@linux-foundation.org>
References: <201010262122.o9QLMwpM016799@imap1.linux-foundation.org>
	 <1288133540.4145.37.camel@Joe-Laptop> <1288987842.19564.1.camel@Joe-Laptop>
	 <20101105131817.b794b123.akpm@linux-foundation.org>
	 <1288989274.19564.4.camel@Joe-Laptop>
	 <20101105135038.7ea63465.akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 06 Nov 2010 05:28:10 -0700
Message-ID: <1289046490.29216.23.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-11-05 at 13:50 -0700, Andrew Morton wrote:
> z:/usr/src/git26> perl scripts/get_maintainer.pl -file mm/mempolicy.c  
> linux-mm@kvack.org
> linux-kernel@vger.kernel.org

Turns out this is an arguable defect in the script.

The MAINTAINERS entry for mm is:

MEMORY MANAGEMENT
L:	linux-mm@kvack.org
W:	http://www.linux-mm.org
S:	Maintained
F:	include/linux/mm.h
F:	mm/

There's a maintainer entry, but no named individual, so
the script doesn't use git history via --git-fallback.

This is also a defect for MAINTAINERS with status
entries marked "Orphan" or "Odd fixes".

The script now checks a section for any "M:" entry and
that an "S:" entry is supported or maintained.  If both
those conditions are not satisified, use --git-fallback
as appropriate.

Signed-off-by: Joe Perches <joe@perches.com>
---
 scripts/get_maintainer.pl |   38 +++++++++++++++++++++++++++++++++++++-
 1 files changed, 37 insertions(+), 1 deletions(-)

diff --git a/scripts/get_maintainer.pl b/scripts/get_maintainer.pl
index 43bace2..139e0ff 100755
--- a/scripts/get_maintainer.pl
+++ b/scripts/get_maintainer.pl
@@ -494,6 +494,40 @@ if ($web) {
 
 exit($exit);
 
+sub range_is_maintained {
+    my ($start, $end) = @_;
+
+    for (my $i = $start; $i < $end; $i++) {
+	my $line = $typevalue[$i];
+	if ($line =~ m/^(\C):\s*(.*)/) {
+	    my $type = $1;
+	    my $value = $2;
+	    if ($type eq 'S') {
+		if ($value =~ /(maintain|support)/i) {
+		    return 1;
+		}
+	    }
+	}
+    }
+    return 0;
+}
+
+sub range_has_maintainer {
+    my ($start, $end) = @_;
+
+    for (my $i = $start; $i < $end; $i++) {
+	my $line = $typevalue[$i];
+	if ($line =~ m/^(\C):\s*(.*)/) {
+	    my $type = $1;
+	    my $value = $2;
+	    if ($type eq 'M') {
+		return 1;
+	    }
+	}
+    }
+    return 0;
+}
+
 sub get_maintainers {
     %email_hash_name = ();
     %email_hash_address = ();
@@ -556,7 +590,9 @@ sub get_maintainers {
 				my $file_pd = ($file  =~ tr@/@@);
 				$value_pd++ if (substr($value,-1,1) ne "/");
 				$value_pd = -1 if ($value =~ /^\.\*/);
-				if ($value_pd >= $file_pd) {
+				if ($value_pd >= $file_pd &&
+				    range_is_maintained($start, $end) &&
+				    range_has_maintainer($start, $end)) {
 				    $exact_pattern_match_hash{$file} = 1;
 				}
 				if ($pattern_depth == 0 ||


