Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755644Ab2IYXhj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 19:37:39 -0400
Received: from nm21.bullet.mail.bf1.yahoo.com ([98.139.212.180]:26397 "HELO
	nm21.bullet.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752889Ab2IYXhh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 19:37:37 -0400
X-Greylist: delayed 356 seconds by postgrey-1.27 at vger.kernel.org; Tue, 25 Sep 2012 19:37:36 EDT
X-Yahoo-Newman-Id: 279280.5558.bm@smtp115.sbc.mail.bf1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: T9yhZ6oVM1nlzIC.CDwp725R3p2jMOWVrrt6R_z.wNF0JGI
 YKAvQAyWzELU1qtwJ2FvKCycfBe6wZNQAqv83Fhf0DD861JsXQkEuacVPTWD
 DD8NM18Uq3sWxh4MLAfSJtaEEJsnb7JU3SHQ9HTQOmQBhqFlheNmK5ZTkTPs
 JsfHymPhLrUWP1SnVHQiqWaVok3PxYvFmkdx951_CcnqVzMznnVoxUOz.rnW
 HXanVTzs7pmo3.xZayZK6UqZsvjXgSuk3umKyyyfqXLrd3klT6KsNbjHvnZ1
 wXTc8nNRidNe70Orye37u.gW05.6vcW3mlD6rg_KuhGV7CZJpfunuMFAWCgY
 CqkE4OTDceBEzXpaS_zFlJV7_nx1NTTrACjPp4_0yagrzT77PJLPQFK8iNbq
 X2WfpJSBgoJjza6HBJ7WdnWTUg5X5k9AeOel8DqzyyVysmvx.uvHM
X-Yahoo-SMTP: xXkkXk6swBBAi.5wfkIWFW3ugxbrqyhyk_b4Z25Sfu.XGQ--
From: Daniel Santos <daniel.santos@pobox.com>
To: Randy Dunlap <rdunlap@xenotime.net>, Pavel Pisa <pisa@cmp.felk.cvut.cz>,
        Richard Weinberger <richard@nod.at>,
        LKML <linux-kernel@vger.kernel.org>,
        Michel Lespinasse <walken@google.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Rik van Riel <riel@redhat.com>
Cc: Daniel Santos <daniel.santos@pobox.com>
Subject: [PATCH v5 15/25] kernel-doc: bugfix - multi-line macros
Date: Tue, 25 Sep 2012 18:31:33 -0500
Message-Id: <1348615893-10457-1-git-send-email-daniel.santos@pobox.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1348615467-9850-1-git-send-email-daniel.santos@pobox.com>
References: <1348615467-9850-1-git-send-email-daniel.santos@pobox.com>
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
index 9b0c0b8..55ab5e4 100755
--- a/scripts/kernel-doc
+++ b/scripts/kernel-doc
@@ -2045,6 +2045,9 @@ sub process_file($) {
 
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

