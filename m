Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753814Ab1EVKTO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 May 2011 06:19:14 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:45312 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753314Ab1EVKTD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 May 2011 06:19:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=KRNHeW+TsvsbfX5vdYGRBAuS6jNQSyJPjahuo9xZCqs6/VLhZcrFuNM4BOqlbAi3Wc
         8omjpZ5rE9NpOGLjkobopCflQ5PRb4dJv5duTz7/Nvdd1jdGjg5kZ38ZymcQSKGsvp/x
         HmQVLWHJohyK5rcczpD7a1/ZdrixX9BASikas=
Subject: [patch v2] checkpatch: Signature format verification
From: anish <anish198519851985@gmail.com>
To: joe@perches.com
Cc: davej@redhat.com, rostedt@goodmis.org, apw@shadowen.org,
        akpm@linux-foundation.org, vapier@gentoo.org,
        linux-kernel@vger.kernel.org, man.k1983@gmail.com
In-Reply-To: <1306006721.1622.18.camel@anish-desktop>
References: <1306006721.1622.18.camel@anish-desktop>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 22 May 2011 15:48:48 +0530
Message-ID: <1306059528.2761.3.camel@anish-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: anish kumar <anish198519851985@gmail.com>

This patch generates warning when there is no space between
the patch submitter and successive mail-id.

Modification:Suggested by Joe Perches(joe@perches.com) that
we can add this check for all signature types so added that
change and added logic to remove the inefficent looping so
that it can come out as soon as signature type is matched.

Signed-off-by: anish kumar <anish198519851985@gmail.com>
---
 scripts/checkpatch.pl |   30 +++++++++++++++++++++---------
 1 files changed, 21 insertions(+), 9 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index d867081..0622f41 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -29,6 +29,8 @@ my $summary_file = 0;
 my $root;
 my %debug;
 my $help = 0;
+my ($sign,$loop_brk);
+my @signs = ("Reviewed-by:","Acked-by:","Signed-off-by:","Tested-by:");
 
 sub help {
 	my ($exitcode) = @_;
@@ -1365,20 +1367,30 @@ sub process {
 			}
 		}
 
-#check the patch for a signoff:
-		if ($line =~ /^\s*signed-off-by:/i) {
-			# This is a signoff, if ugly, so do not double report.
-			$signoff++;
-			if (!($line =~ /^\s*Signed-off-by:/)) {
-				WARN("Signed-off-by: is the preferred form\n" .
+#check the patch for a signoff/Reviewed/Acked/Tested:
+foreach $sign (@signs) {
+	$loop_brk=0;
+	if ($line =~ /^\s*$sign/i) {
+		# This is a signoff, if ugly, so do not double report.
+		$signoff++;
+		$loop_brk++;
+		if (!($line =~ /^\s*$sign/)) {
+			WARN("$sign is the preferred form\n" .
+				$herecurr);
+		}
+		if ($line =~ /^\s*$sign(.*)/i) {
+			if($1 !~ /^\s*(\s[a-zA-Z]*.*)/i) {
+				WARN("Space required after $sign\n" .
 					$herecurr);
 			}
-			if ($line =~ /^\s*signed-off-by:\S/i) {
-				WARN("space required after Signed-off-by:\n" .
+			if($1 !~ /[\sa-zA-Z]+\s<.*>/i) {
+				WARN("Space required b/w Full Name & Mail-id:\n" .
 					$herecurr);
 			}
 		}
-
+	}
+last if ($loop_brk == 1);
+}
 # Check for wrappage within a valid hunk of the file
 		if ($realcnt != 0 && $line !~ m{^(?:\+|-| |\\ No newline|$)}) {
 			ERROR("patch seems to be corrupt (line wrapped?)\n" .
-- 
1.7.0.4


