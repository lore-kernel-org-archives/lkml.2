Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756033Ab1CRCwa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 22:52:30 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:49828 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755987Ab1CRCw2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 22:52:28 -0400
X-Authority-Analysis: v=1.1 cv=qyUSAyc82z9xLljZQc9ErY9Tl2GSEfqK/XYZS35I9d8= c=1 sm=0 a=Am4aEdVPdz0A:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=meVymXHHAAAA:8 a=tIxMMX8wLqbJvhF53sYA:9 a=EVB_3QDeGsj_0RUaJz-iwjdQXGAA:4 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: [PATCH] checkpatch: Test for kmalloc/memset(0) pairs
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andy Whitcroft <apw@shadowen.org>, Dave Jones <davej@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Thu, 17 Mar 2011 22:52:24 -0400
Message-ID: <1300416744.16880.904.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The use of kzalloc() is preferred over kmalloc/memset(0) pairs.

When a match is made with "memset(p, 0, s);" a search back through the
patch hunk is made looking for "p = kmalloc(s,". If that is found, then
a warning is given, suggesting to use kzalloc() instead.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 58848e3..f28f0e3 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -2902,6 +2902,22 @@ sub process {
 		    $line =~ /DEVICE_ATTR.*S_IWUGO/ ) {
 			WARN("Exporting world writable files is usually an error. Consider more restrictive permissions.\n" . $herecurr);
 		}
+
+# The use of kzalloc() is preferred over kmalloc/memset(0) pairs.
+		if ($line =~ /\smemset\s*\((\S*)\s*,\s*(?:0x0|0)\s*,\s*(\S*)\s*\);/) {
+		    my $ptr = $1;
+		    my $size = $2;
+
+		    for (my $i = $linenr-2; $i >= 0; $i--) {
+			next if ($lines[$i] =~ /^-/); # ignore deletions
+			last if ($lines[$i] =~ /^\@\@/);
+			if ($lines[$i] =~ /\s(\S*)\s*=\s*kmalloc\((\S*)\,/ &&
+			    $1 eq $ptr && $2 eq $size) {
+			    WARN("use kzalloc() instead of kmalloc/memset(p,0,size) pair\n"
+				 . $herecurr);
+			}
+		    }
+		}
 	}
 
 	# If we have no input at all, then there is nothing to report on


