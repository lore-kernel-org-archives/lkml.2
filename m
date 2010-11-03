Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754681Ab0KCME7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Nov 2010 08:04:59 -0400
Received: from ist.d-labs.de ([213.239.218.44]:46460 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753795Ab0KCME6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Nov 2010 08:04:58 -0400
From: Florian Mickler <florian@mickler.org>
To: Andy Whitcroft <apw@canonical.com>
Cc: Audun Hoem <audun.hoem@gmail.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Florian Mickler <florian@mickler.org>
Subject: [PATCH] checkpatch.pl: fix CAST detection to not screw with parens handling
Date: Wed,  3 Nov 2010 13:04:33 +0100
Message-Id: <1288785873-16519-1-git-send-email-florian@mickler.org>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <AANLkTimA1d88FwGGE-BW4WvyuaFB7xewN_ubko+kj2+X@mail.gmail.com>
References: <AANLkTimA1d88FwGGE-BW4WvyuaFB7xewN_ubko+kj2+X@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Casts have to be handled after the last type that is followed by an
opening parenthesis is handled.

On Tue, 2 Nov 2010 23:57:36 +0100
Audun Hoem <audun.hoem@gmail.com> wrote:

> I have stumbled about a bug in checkpatch.pl while working on some
> code in drivers/staging. It seems to get confused when confronted with
> asterisks. For example, this snippe:
>
> kmalloc(sizeof(struct alphatrack_ocmd) * true_size, GFP_KERNEL);
>
> Here the asterisk is in it's binary form, obviously, and performs a
> multiplication, however checkpatch reports this:
>
> drivers/staging/frontier/alphatrack.c:772: ERROR: space prohibited
> after that '*' (ctx:WxW)
>
> So it's obviously thinking it's the unary operator, which should only
> be preceded by a variable name or another unary operator such as ++.

Reported-By: Audun Hoem <audun.hoem@gmail.com>

Signed-off-by: Florian Mickler <florian@mickler.org>
---
 scripts/checkpatch.pl |   11 +++++++----
 1 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 90b54d4..c1cbb09 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -859,10 +859,6 @@ sub annotate_values {
 				$av_preprocessor = 0;
 			}
 
-		} elsif ($cur =~ /^(\(\s*$Type\s*)\)/) {
-			print "CAST($1)\n" if ($dbg_values > 1);
-			push(@av_paren_type, $type);
-			$type = 'C';
 
 		} elsif ($cur =~ /^($Type)\s*(?:$Ident|,|\)|\(|\s*$)/) {
 			print "DECLARE($1)\n" if ($dbg_values > 1);
@@ -963,6 +959,13 @@ sub annotate_values {
 			$type = 'V';
 			$av_pending = 'V';
 
+		} elsif ($cur =~ /^(\(\s*$Type\s*)\)/) {
+			#casts handled after last type that opens a brace
+			#is handled, else it screws up the parens handling
+			print "CAST($1)\n" if ($dbg_values > 1);
+			push(@av_paren_type, $type);
+			$type = 'C';
+
 		} elsif ($cur =~ /^($Ident\s*):(?:\s*\d+\s*(,|=|;))?/) {
 			if (defined $2 && $type eq 'C' || $type eq 'T') {
 				$av_pend_colon = 'B';
-- 
1.7.3.1

