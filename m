Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754110Ab2HOLBC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 07:01:02 -0400
Received: from mail.x86-64.org ([217.9.48.20]:42982 "EHLO mail.x86-64.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751317Ab2HOLBA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 07:01:00 -0400
From: Borislav Petkov <bp@amd64.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Borislav Petkov <borislav.petkov@amd.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kbuild@vger.kernel.org
Subject: [PATCH] scripts/decodecode: Fixup trapping instruction marker
Date: Wed, 15 Aug 2012 13:00:51 +0200
Message-Id: <1345028451-14709-1-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.11.rc1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

When dumping "Code: " sections from an oops, the trapping instruction %rip
points to can be a string copy

  2b:*  f3 a5                   rep movsl %ds:(%rsi),%es:(%rdi)

and the line contain a bunch of ":". Current "cut" selects only the
and the second field output looks funnily overlaid this:

  2b:*  f3 a5                   rep movsl %ds     <-- trapping instruction:(%rsi),%es:(%rdi

Fix this by selecting the remaining fields too.

Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kbuild@vger.kernel.org
Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 scripts/decodecode | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/scripts/decodecode b/scripts/decodecode
index 18ba881c3415..4f8248d5a11f 100755
--- a/scripts/decodecode
+++ b/scripts/decodecode
@@ -89,7 +89,7 @@ echo $code >> $T.s
 disas $T
 cat $T.dis >> $T.aa
 
-faultline=`cat $T.dis | head -1 | cut -d":" -f2`
+faultline=`cat $T.dis | head -1 | cut -d":" -f2-`
 faultline=`echo "$faultline" | sed -e 's/\[/\\\[/g; s/\]/\\\]/g'`
 
 cat $T.oo | sed -e "s/\($faultline\)/\*\1     <-- trapping instruction/g"
-- 
1.7.11.rc1

