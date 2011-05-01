Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752365Ab1EADhV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Apr 2011 23:37:21 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:55279 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751107Ab1EADhP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Apr 2011 23:37:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:reply-to:mime-version:content-type
         :content-disposition:user-agent;
        b=b2VD2WEDZ0EbPrnXyr5YPK+masQBMatLGfr/HaQ6rN7BYye/+uuxzWx50uov7mRHYc
         KFWUk59fLblsrrTbPCGNIY9H0jluV/7wr/i4pAAoi7x0jo1KY72kto4AGinW1WiZx+BQ
         hSfA+qcfNzvNx4qtT7gbhWKZEAQTLTuc9i+Ac=
Date: Sun, 1 May 2011 11:41:41 +0800
From: Xiaochen Wang <wangxiaochen0@gmail.com>
To: Jean Sacren <sakiwit@gmail.com>, Michal Marek <mmarek@suse.cz>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] scripts/kallsyms.c: fix potential segfault
Message-ID: <20110501034141.GA13473@chii>
Reply-To: Xiaochen Wang <wangxiaochen0@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Description:
This bug hardly appears during real kernel compiling,
 because the vmlinux symbols table is huge.

But we can still catch it under strict condition , as follows.
   $ echo "c101b97b T do_fork" | ./scripts/kallsyms --all-symbols
   #include <asm/types.h>
   ......
   ......
   .globl kallsyms_token_table
           ALGN
   kallsyms_token_table:
   Segmentation fault (core dumped)
   $

If symbols table is small, all entries in token_profit[0x10000] may
decrease to 0 after several calls of compress_symbols() in optimize_result().
In that case, find_best_token() always return 0 and
best_table[i] is set to "\0\0" and best_table_len[i] is set to 2.

As a result, expand_symbol(best_table[0]="\0\0", best_table_len[0]=2, buf)
in write_src() will run in infinite recursion until stack overflows,
causing segfault.

This patch checks the find_best_token() return value. If all entries in
token_profit[0x10000] become 0 according to return value, it breaks the loop
in optimize_result().
And expand_symbol() works well when best_table_len[i] is 0.


Signed-off-by: Xiaochen Wang <wangxiaochen0@gmail.com>
---
 scripts/kallsyms.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/scripts/kallsyms.c b/scripts/kallsyms.c
index 60dd3eb..487ac6f 100644
--- a/scripts/kallsyms.c
+++ b/scripts/kallsyms.c
@@ -500,6 +500,8 @@ static void optimize_result(void)
 
 			/* find the token with the breates profit value */
 			best = find_best_token();
+			if (token_profit[best] == 0)
+				break;
 
 			/* place it in the "best" table */
 			best_table_len[i] = 2;
-- 
1.7.2.3

