Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756327Ab0DNQ1n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Apr 2010 12:27:43 -0400
Received: from mail.perches.com ([173.55.12.10]:1477 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755535Ab0DNQ1l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Apr 2010 12:27:41 -0400
Subject: [REGRESSION PATCH V2] vsprintf: Change struct
 printf_spec.precision from s8 to s16
From: Joe Perches <joe@perches.com>
To: Eric Paris <eparis@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, fweisbec@gmail.com
In-Reply-To: <20100414011336.16139.68030.stgit@paris.rdu.redhat.com>
References: <20100414011336.16139.68030.stgit@paris.rdu.redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 14 Apr 2010 09:27:40 -0700
Message-ID: <1271262460.1578.53.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit ef0658f3de484bf9b173639cd47544584e01efa5 changed precision
from int to s8.

There is existing kernel code that uses a larger precision.

An example from the audit code:
	vsnprintf(...,..., " msg='%.1024s'", (char *)data);
which overflows precision and truncates to nothing.

Extending precision size fixes the audit system issue.

Other changes:

Change the size of the struct printf_spec.type from u16 to u8 so
sizeof(struct printf_spec) stays as small as possible.
Reorder the struct members so sizeof(struct printf_spec) remains 64 bits
without alignment holes.
Document the struct members a bit more.

Original-patch-by: Eric Paris <eparis@redhat.com>
Signed-off-by: Joe Perches <joe@perches.com>
---
 lib/vsprintf.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/lib/vsprintf.c b/lib/vsprintf.c
index 24112e5..7376b7c 100644
--- a/lib/vsprintf.c
+++ b/lib/vsprintf.c
@@ -408,12 +408,12 @@ enum format_type {
 };
 
 struct printf_spec {
-	u16	type;
-	s16	field_width;	/* width of output field */
+	u8	type;		/* format_type enum */
 	u8	flags;		/* flags to number() */
-	u8	base;
-	s8	precision;	/* # of digits/chars */
-	u8	qualifier;
+	u8	base;		/* number base, 8, 10 or 16 only */
+	u8	qualifier;	/* number qualifier, one of 'hHlLtzZ' */
+	s16	field_width;	/* width of output field */
+	s16	precision;	/* # of digits/chars */
 };
 
 static char *number(char *buf, char *end, unsigned long long num,


