Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932223Ab2FUPXU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 11:23:20 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:52097 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759329Ab2FUPXT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 11:23:19 -0400
Message-ID: <1340292198.29885.69.camel@joe2Laptop>
Subject: [PATCH] checkpatch: Check usleep_range arguments
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Yuval Mintz <yuvalmin@broadcom.com>, linux-kernel@vger.kernel.org
Date: Thu, 21 Jun 2012 08:23:18 -0700
In-Reply-To: <1340204019.29885.9.camel@joe2Laptop>
References: <1340182175-916-1-git-send-email-yuvalmin@broadcom.com>
	 <1340182175-916-3-git-send-email-yuvalmin@broadcom.com>
	 <1340204019.29885.9.camel@joe2Laptop>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

usleep_range shouldn't use the same args for min and max.

Report it when it happens and when both args are decimal
and min > max.

Signed-off-by: Joe Perches <joe@perches.com>
---
 scripts/checkpatch.pl |   16 ++++++++++++++++
 1 files changed, 16 insertions(+), 0 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 630319a..d0c1a63 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -3309,6 +3309,22 @@ sub process {
 			}
 		}
 
+# check usleep_range arguments
+		if ($^V && $^V ge 5.10.0 &&
+		    defined $stat &&
+		    $stat =~ /^\+(?:.*?)\busleep_range\s*\(\s*($FuncArg)\s*,\s*($FuncArg)\s*\)/) {
+		 	my $min = $1;
+			my $max = $7;
+			if ($min eq $max) {
+				WARN("USLEEP_RANGE",
+				     "usleep_range should not use min == max args; see Documentation/timers/timers-howto.txt\n" . "$here\n$stat\n");
+			} elsif ($min =~ /^\d+$/ && $max =~ /^\d+$/ &&
+				 $min > $max) {
+				WARN("USLEEP_RANGE",
+				     "usleep_range args reversed, use min then max; see Documentation/timers/timers-howto.txt\n" . "$here\n$stat\n");
+			}
+		}
+
 # check for new externs in .c files.
 		if ($realfile =~ /\.c$/ && defined $stat &&
 		    $stat =~ /^.\s*(?:extern\s+)?$Type\s+($Ident)(\s*)\(/s)


