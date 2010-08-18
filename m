Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754089Ab0HRUk1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 16:40:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3218 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751069Ab0HRUkX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 16:40:23 -0400
Date: Wed, 18 Aug 2010 16:40:17 -0400
From: Dave Jones <davej@redhat.com>
To: apw@canonical.com
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: add memset checks to checkpatch.pl
Message-ID: <20100818204016.GA29640@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>, apw@canonical.com,
	Linux Kernel <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Occasionally someone goofs the argument order to memset.
This patch makes checkpatch catch those.

I made memset with size of 0 an error, because it's never correct,
whereas memset with a size of 1 isn't technically an incorrect
thing to do so I left it as a warning. It may still be better to replace
it with a single variable assignment in the false positive cases.

Signed-off-by: Dave Jones <davej@redhat.com>

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 2039acd..3690173 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -2794,6 +2794,14 @@ sub process {
 			}
 		}
 
+# check for memset with reversed 2nd/3rd arguments.
+		if ($line =~ /memset.*\,(\ |)(0x|)0(\ |0|)\);/) {
+			ERROR("memset takes size as third argument, not the second.\n" . $herecurr);
+		}
+		if ($line =~ /memset.*\,(\ |)(0x|)1\);/) {
+			WARN("single byte memset is suspicious. Swapped 2nd/3rd argument?\n" . $herecurr);
+		}
+
 # check for lockdep_set_novalidate_class
 		if ($line =~ /^.\s*lockdep_set_novalidate_class\s*\(/ ||
 		    $line =~ /__lockdep_no_validate__\s*\)/ ) {
