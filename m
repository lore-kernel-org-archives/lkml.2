Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933781Ab1AMUVU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 15:21:20 -0500
Received: from mail.perches.com ([173.55.12.10]:3148 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933703Ab1AMUVO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 15:21:14 -0500
Subject: [PATCH] vsprintf: Neaten %pK kptr_restrict, save a bit of code
 space
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Dan Rosenberg <drosenberg@vsecurity.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 13 Jan 2011 12:21:12 -0800
Message-ID: <1294950072.4114.172.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If kptr restrictions are on, just set the passed pointer to NULL.

$ size lib/vsprintf.o.*
   text	   data	    bss	    dec	    hex	filename
   8247	      4	      2	   8253	   203d	lib/vsprintf.o.new
   8282	      4	      2	   8288	   2060	lib/vsprintf.o.old

Signed-off-by: Joe Perches <joe@perches.com>

---

 lib/vsprintf.c |   14 +++++---------
 1 files changed, 5 insertions(+), 9 deletions(-)

diff --git a/lib/vsprintf.c b/lib/vsprintf.c
index d3023df..070d134 100644
--- a/lib/vsprintf.c
+++ b/lib/vsprintf.c
@@ -1047,16 +1047,12 @@ char *pointer(const char *fmt, char *buf, char *end, void *ptr,
 			if (spec.field_width == -1)
 				spec.field_width = 2 * sizeof(void *);
 			return string(buf, end, "pK-error", spec);
-		} else if ((kptr_restrict == 0) ||
-			 (kptr_restrict == 1 &&
-			  has_capability_noaudit(current, CAP_SYSLOG)))
-			break;
-
-		if (spec.field_width == -1) {
-			spec.field_width = 2 * sizeof(void *);
-			spec.flags |= ZEROPAD;
 		}
-		return number(buf, end, 0, spec);
+		if (!((kptr_restrict == 0) ||
+		      (kptr_restrict == 1 &&
+		       has_capability_noaudit(current, CAP_SYSLOG))))
+			ptr = NULL;
+		break;
 	}
 	spec.flags |= SMALL;
 	if (spec.field_width == -1) {


