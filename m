Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752838Ab1JLIcE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Oct 2011 04:32:04 -0400
Received: from mtagate7.uk.ibm.com ([194.196.100.167]:58826 "EHLO
	mtagate7.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752639Ab1JLIcC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Oct 2011 04:32:02 -0400
Subject: [PATCH] Fix strim() semantics for strings that have only blanks
From: Michael Holzheu <holzheu@linux.vnet.ibm.com>
Reply-To: holzheu@linux.vnet.ibm.com
To: andre.goddard@gmail.com
Cc: akpm@linux-foundation.org, schwidefsky@de.ibm.com,
        heiko.carstens@de.ibm.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Organization: IBM
Date: Wed, 12 Oct 2011 10:31:57 +0200
Message-ID: <1318408317.2891.3.camel@br98xy6r>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Andre,

With git commit 84c95c9acf088c99d8793d78036b67faa5d0b851 a patch from
you went upstream where you wanted to improve the performance of the
strim() function.

Unfortunately this changed the semantics of strim() and broke my code. Before
the patch it was possible to use strim() without using the return value for
removing trailing spaces from strings that had either only blanks or only
trailing blanks.

Now this does not work any longer for strings that *only* have blanks.

Before patch: "   " -> ""    (empty string)
After patch:  "   " -> "   " (no change)

I think we should remove your patch to restore the old behavior.

>From the description (lib/string.c):

 * Note that the first trailing whitespace is replaced with a %NUL-terminator

=> The first trailing whitespace of a string that only has whitespace
   characters is the first whitespace

Also strim() explicitly does not have "__must_check", in order to use it
without using the return value.

I attached a patch that restores the old strim() semantics.

Signed-off-by: Michael Holzheu <holzheu@linux.vnet.ibm.com>
---
 lib/string.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/lib/string.c
+++ b/lib/string.c
@@ -360,7 +360,6 @@ char *strim(char *s)
 	size_t size;
 	char *end;
 
-	s = skip_spaces(s);
 	size = strlen(s);
 	if (!size)
 		return s;
@@ -370,7 +369,7 @@ char *strim(char *s)
 		end--;
 	*(end + 1) = '\0';
 
-	return s;
+	return skip_spaces(s);
 }
 EXPORT_SYMBOL(strim);
 


