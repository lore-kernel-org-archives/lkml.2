Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758769Ab2I1XdP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 19:33:15 -0400
Received: from nm6-vm0.bullet.mail.sp2.yahoo.com ([98.139.91.206]:20148 "HELO
	nm6-vm0.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1758895Ab2I1XdL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 19:33:11 -0400
X-Yahoo-Newman-Id: 15991.60858.bm@omp1023.access.mail.sp2.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: rKmgGjsVM1kdoQvJvOeo6uGFFLPZWSdCSyCS4fjmJ89mbLY
 DNTsXww8FnjY9IL8KLKS5j3HytysnLBHh61h00MZCQOtS.NUyOyc30dwVrdI
 ZoKc1MKrAKFVSaYIZnUvJ0AeTm26fffIaV.3XYewiXMc.53Bnfk7izLxpm2t
 cLKS88kjUgQ0CyZBEX3K7d322Aw5jDJWjpg.F7SkyuXd_wL0qktUrikbPEr0
 tDV89Uee8lVmo6MSpYL2TeHnIERGm4cRN1p04f9Cgp9UnnK5927gpeHR4bJ8
 iWXFwWb1zW98HAG0rkFjQlpRc0qxeX8W49JRY2oegS0E.7PeSsZIIrL2rJ2.
 nEfNH2CSKi2lT_pwmhHV2u0RqhVG9C8sVvrnFMILX50Xe3rErEX7pP86xI0C
 uSajIbvzJG0rTTNkB_bwQd5uDeAJoevs5b6kvohM5c7EMfVuPJ48r
X-Yahoo-SMTP: xXkkXk6swBBAi.5wfkIWFW3ugxbrqyhyk_b4Z25Sfu.XGQ--
From: Daniel Santos <daniel.santos@pobox.com>
To: LKML <linux-kernel@vger.kernel.org>, linux-doc@vger.kernel.org,
        Randy Dunlap <rdunlap@xenotime.net>
Cc: Daniel Santos <daniel.santos@pobox.com>
Subject: [PATCH 1/3] kernel-doc: bugfix - multi-line macros
Date: Fri, 28 Sep 2012 18:32:56 -0500
Message-Id: <1348875178-28490-2-git-send-email-daniel.santos@pobox.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1348875178-28490-1-git-send-email-daniel.santos@pobox.com>
References: <1348875178-28490-1-git-send-email-daniel.santos@pobox.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Prior to this patch the following code breaks:

/**
 * multiline_example - this breaks kernel-doc
 */
 #define multiline_example( \
myparam)

Producing this error:

Error(somefile.h:983): cannot understand prototype: 'multiline_example( \ '

This patch fixes the issue by appending all lines ending in a blackslash
(optionally followed by whitespace), removing the backslash and any
whitespace after it prior to appending (just like the C pre-processor
would).

This fixes a break in kerel-doc introduced by the additions to rbtree.h.

Signed-off-by: Daniel Santos <daniel.santos@pobox.com>
---
 scripts/kernel-doc |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/scripts/kernel-doc b/scripts/kernel-doc
index 5ee8e91..e6bc9db 100755
--- a/scripts/kernel-doc
+++ b/scripts/kernel-doc
@@ -2305,6 +2305,9 @@ sub process_file($) {
 
     $section_counter = 0;
     while (<IN>) {
+	while (s/\\\s*$//) {
+	    $_ .= <IN>;
+	}
 	if ($state == 0) {
 	    if (/$doc_start/o) {
 		$state = 1;		# next line is always the function name
-- 
1.7.3.4

