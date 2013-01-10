Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754580Ab3AJPdD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 10:33:03 -0500
Received: from multi.imgtec.com ([194.200.65.239]:56857 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754507Ab3AJPcz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 10:32:55 -0500
From: James Hogan <james.hogan@imgtec.com>
To: <linux-kernel@vger.kernel.org>, <linux-arch@vger.kernel.org>
CC: James Hogan <james.hogan@imgtec.com>
Subject: [PATCH v3 40/44] scripts/checkstack.pl: Add metag support
Date: Thu, 10 Jan 2013 15:31:08 +0000
Message-ID: <1357831872-29451-41-git-send-email-james.hogan@imgtec.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1357831872-29451-1-git-send-email-james.hogan@imgtec.com>
References: <1357831872-29451-1-git-send-email-james.hogan@imgtec.com>
MIME-Version: 1.0
Content-Type: text/plain
X-SEF-Processed: 7_3_0_01181__2013_01_10_15_32_38
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adapt checkstack.pl so that it works for metag.

Signed-off-by: James Hogan <james.hogan@imgtec.com>
---
 scripts/checkstack.pl |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/scripts/checkstack.pl b/scripts/checkstack.pl
index 17e3843..544aa56 100755
--- a/scripts/checkstack.pl
+++ b/scripts/checkstack.pl
@@ -34,7 +34,7 @@ use strict;
 # $1 (first bracket) matches the dynamic amount of the stack growth
 #
 # use anything else and feel the pain ;)
-my (@stack, $re, $dre, $x, $xs);
+my (@stack, $re, $dre, $x, $xs, $funcre);
 {
 	my $arch = shift;
 	if ($arch eq "") {
@@ -44,6 +44,7 @@ my (@stack, $re, $dre, $x, $xs);
 
 	$x	= "[0-9a-f]";	# hex character
 	$xs	= "[0-9a-f ]";	# hex character or space
+	$funcre = qr/^$x* <(.*)>:$/;
 	if ($arch eq 'arm') {
 		#c0008ffc:	e24dd064	sub	sp, sp, #100	; 0x64
 		$re = qr/.*sub.*sp, sp, #(([0-9]{2}|[3-9])[0-9]{2})/o;
@@ -66,6 +67,10 @@ my (@stack, $re, $dre, $x, $xs);
 		#    2b6c:       4e56 fb70       linkw %fp,#-1168
 		#  1df770:       defc ffe4       addaw #-28,%sp
 		$re = qr/.*(?:linkw %fp,|addaw )#-([0-9]{1,4})(?:,%sp)?$/o;
+	} elsif ($arch eq 'metag') {
+		#400026fc:       40 00 00 82     ADD       A0StP,A0StP,#0x8
+		$re = qr/.*ADD.*A0StP,A0StP,\#(0x$x{1,8})/o;
+		$funcre = qr/^$x* <[^\$](.*)>:$/;
 	} elsif ($arch eq 'mips64') {
 		#8800402c:       67bdfff0        daddiu  sp,sp,-16
 		$re = qr/.*daddiu.*sp,sp,-(([0-9]{2}|[3-9])[0-9]{2})/o;
@@ -109,7 +114,6 @@ my (@stack, $re, $dre, $x, $xs);
 #
 # main()
 #
-my $funcre = qr/^$x* <(.*)>:$/;
 my ($func, $file, $lastslash);
 
 while (my $line = <STDIN>) {
-- 
1.7.7.6


