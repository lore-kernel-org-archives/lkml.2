Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759538Ab2HIUEs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 16:04:48 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:33816 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750848Ab2HIUEq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 16:04:46 -0400
Message-ID: <5024179D.30308@inktank.com>
Date: Thu, 09 Aug 2012 13:03:41 -0700
From: Alex Elder <elder@inktank.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: [PATCH]  lib/parser.c: avoid overflow in match_number()
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The result of converting an integer value to another signed integer
type that's unable to represent the original value is implementation
defined.  (See notes in section 6.3.1.3 of the C standard.)

In match_number(), the result of simple_strtol() (which returns type
long) is assigned to a value of type int.

Instead, handle the result of simple_strtol() in a well-defined way,
and return -ERANGE if the result won't fit in the int variable used
to hold the parsed result.

No current callers pay attention to the particular error value
returned, so this additional return code shouldn't do any harm.

Signed-off-by: Alex Elder <elder@inktank.com>
---
  lib/parser.c |   10 ++++++++--
  1 file changed, 8 insertions(+), 2 deletions(-)

Index: b/lib/parser.c
===================================================================
--- a/lib/parser.c
+++ b/lib/parser.c
@@ -122,13 +122,14 @@ int match_token(char *s, const match_tab
   *
   * Description: Given a &substring_t and a base, attempts to parse the 
substring
   * as a number in that base. On success, sets @result to the integer 
represented
- * by the string and returns 0. Returns either -ENOMEM or -EINVAL on 
failure.
+ * by the string and returns 0. Returns -ENOMEM, -EINVAL, or -ERANGE on 
failure.
   */
  static int match_number(substring_t *s, int *result, int base)
  {
  	char *endp;
  	char *buf;
  	int ret;
+	long val;
  	size_t len = s->to - s->from;

  	buf = kmalloc(len + 1, GFP_KERNEL);
@@ -136,10 +137,15 @@ static int match_number(substring_t *s,
  		return -ENOMEM;
  	memcpy(buf, s->from, len);
  	buf[len] = '\0';
-	*result = simple_strtol(buf, &endp, base);
+
  	ret = 0;
+	val = simple_strtol(buf, &endp, base);
  	if (endp == buf)
  		ret = -EINVAL;
+	else if (val < (long) INT_MIN || val > (long) INT_MAX)
+		ret = -ERANGE;
+	else
+		*result = (int) val;
  	kfree(buf);
  	return ret;
  }
