Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758016Ab2AKT6W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jan 2012 14:58:22 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:45017 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757871Ab2AKT6V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jan 2012 14:58:21 -0500
Message-ID: <1326311897.3491.6.camel@joe2Laptop>
Subject: [RFC PATCH] checkpatch: Add warning for asymmetric brace use
From: Joe Perches <joe@perches.com>
To: Andy Whitcroft <apw@shadowen.org>,
        Dan Carpenter <dan.carpenter@oracle.com>
Cc: Julian Andres Klode <jak@jak-linux.org>, devel@driverdev.osuosl.org,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Date: Wed, 11 Jan 2012 11:58:17 -0800
In-Reply-To: <1326216615.26536.18.camel@joe2Laptop>
References: <1324918660-25708-1-git-send-email-jak@jak-linux.org>
	 <1324918660-25708-5-git-send-email-jak@jak-linux.org>
	 <20120110113552.GJ3644@mwanda> <20120110114835.GB6325@jak-linux.org>
	 <20120110121453.GC16258@mwanda> <1326216615.26536.18.camel@joe2Laptop>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-01-10 at 09:30 -0800, Joe Perches wrote:
> Here's a snippet where checkpatch does not emit
> a warning where it reasonably could:
> 
> int main(int argc, char **argv)
> {
> 	int a;
> 	if (a) {
> 		int foo;
> 		int bar;
> 	} else
> 		int foo;
> }
> 
> Maybe you could look at it?

Hey Andy.
Here's a possible checkpatch patch.
It seems to work on the test cases I've tried.
---
 scripts/checkpatch.pl |   28 ++++++++++++++++++++--------
 1 files changed, 20 insertions(+), 8 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index e3bfcbe..19f228c 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -2882,7 +2882,8 @@ sub process {
 			#print "chunks<$#chunks> linenr<$linenr> endln<$endln> level<$level>\n";
 			#print "APW: <<$chunks[1][0]>><<$chunks[1][1]>>\n";
 			if ($#chunks > 0 && $level == 0) {
-				my $allowed = 0;
+				my @allowed = ();
+				my $allow = 0;
 				my $seen = 0;
 				my $herectx = $here . "\n";
 				my $ln = $linenr - 1;
@@ -2893,6 +2894,7 @@ sub process {
 					my ($whitespace) = ($cond =~ /^((?:\s*\n[+-])*\s*)/s);
 					my $offset = statement_rawlines($whitespace) - 1;
 
+					$allowed[$allow] = 0;
 					#print "COND<$cond> whitespace<$whitespace> offset<$offset>\n";
 
 					# We have looked at and allowed this specific line.
@@ -2905,23 +2907,33 @@ sub process {
 
 					$seen++ if ($block =~ /^\s*{/);
 
-					#print "cond<$cond> block<$block> allowed<$allowed>\n";
+					#print "cond<$cond> block<$block> allowed<$allowed[$allow]>\n";
 					if (statement_lines($cond) > 1) {
 						#print "APW: ALLOWED: cond<$cond>\n";
-						$allowed = 1;
+						$allowed[$allow] = 1;
 					}
 					if ($block =~/\b(?:if|for|while)\b/) {
 						#print "APW: ALLOWED: block<$block>\n";
-						$allowed = 1;
+						$allowed[$allow] = 1;
 					}
 					if (statement_block_size($block) > 1) {
 						#print "APW: ALLOWED: lines block<$block>\n";
-						$allowed = 1;
+						$allowed[$allow] = 1;
 					}
+					$allow++;
 				}
-				if ($seen && !$allowed) {
-					WARN("BRACES",
-					     "braces {} are not necessary for any arm of this statement\n" . $herectx);
+				if ($seen) {
+					my $sum_allowed = 0;
+					foreach (@allowed) {
+						$sum_allowed += $_;
+					}
+					if ($sum_allowed == 0) {
+						WARN("BRACES",
+						     "braces {} are not necessary for any arm of this statement\n" . $herectx);
+					} elsif ($sum_allowed != $allow) {
+						WARN("BRACES",
+						     "braces {} should be used on all arms of this statement\n" . $herectx);
+					}
 				}
 			}
 		}


