Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755875Ab1EWPVp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 11:21:45 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:34191 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755330Ab1EWPVo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 11:21:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=F3nB4TCbVv3ehltcMFKSFz9VN8gJt+JR+blBPF1t4Zzix8HWWhCDudlAPOk+GmxfgO
         CkVgnH7r8DD7Zq/NyXFFj0z8SbA6/WGye5lhc7IZxpeCxUsePdjqLrrxSC0tXo9mYabG
         W2P5TiDzA62JmPunfDxz0cBQkRcXy/uQWmKNI=
Subject: [patch v3] checkpatch: Signature format verification
From: anish <anish198519851985@gmail.com>
To: joe@perches.com
Cc: davej@redhat.com, rostedt@goodmis.org, apw@shadowen.org,
        akpm@linux-foundation.org, vapier@gentoo.org,
        linux-kernel@vger.kernel.org, man.k1983@gmail.com
In-Reply-To: <1306059528.2761.3.camel@anish-desktop>
References: <1306006721.1622.18.camel@anish-desktop>
	 <1306059528.2761.3.camel@anish-desktop>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 23 May 2011 20:51:34 +0530
Message-ID: <1306164094.2292.25.camel@anish-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: anish kumar <anish198519851985@gmail.com>

This patch generates warning when there is no space between
the patch submitter and successive mail-id.

V2 Modification:Suggested by Joe Perches(joe@perches.com) that
we can add this check for all signature types so added that
change and added logic to remove the inefficent looping so
that it can come out as soon as signature type is matched.

V3 Modification:Moved the variable from global to local scope.

Signed-off-by: anish kumar <anish198519851985@gmail.com>
---
 scripts/checkpatch.pl |   36 ++++++++++++++++++++++++------------
 1 files changed, 24 insertions(+), 12 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index d867081..fbc0e62 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -1365,20 +1365,32 @@ sub process {
 			}
 		}
 
-#check the patch for a signoff:
-		if ($line =~ /^\s*signed-off-by:/i) {
-			# This is a signoff, if ugly, so do not double report.
-			$signoff++;
-			if (!($line =~ /^\s*Signed-off-by:/)) {
-				WARN("Signed-off-by: is the preferred form\n" .
-					$herecurr);
-			}
-			if ($line =~ /^\s*signed-off-by:\S/i) {
-				WARN("space required after Signed-off-by:\n" .
-					$herecurr);
+#check the patch for a signoff/Reviewed/Acked/Tested:
+		my ($sign,$loop_brk);
+		my @signs = ("Reviewed-by:","Acked-by:","Signed-off-by:","Tested-by:");
+		foreach $sign (@signs) {
+			$loop_brk=0;
+			if ($line =~ /^\s*$sign/i) {
+				# This is a signoff, if ugly, so do not double report.
+				$signoff++;
+				$loop_brk++;
+				if (!($line =~ /^\s*$sign/)) {
+					WARN("$sign is the preferred form\n" .
+						$herecurr);
+				}
+				if ($line =~ /^\s*$sign(.*)/i) {
+					if($1 !~ /^\s*(\s[a-zA-Z]*.*)/i) {
+						WARN("Space required after $sign\n" .
+							$herecurr);
+					}
+					if($1 !~ /[\sa-zA-Z]+\s<.*>/i) {
+						WARN("Space required b/w Full Name & Mail-id:\n" .
+							$herecurr);
+					}
+				}
 			}
+			last if ($loop_brk == 1);
 		}
-
 # Check for wrappage within a valid hunk of the file
 		if ($realcnt != 0 && $line !~ m{^(?:\+|-| |\\ No newline|$)}) {
 			ERROR("patch seems to be corrupt (line wrapped?)\n" .
-- 
1.7.0.4


