Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753171Ab0LXTm0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Dec 2010 14:42:26 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:20335 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752736Ab0LXTmZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Dec 2010 14:42:25 -0500
Date: Fri, 24 Dec 2010 20:32:33 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: linux-kernel@vger.kernel.org
cc: Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>
Subject: [PATCH][RFC] HPFS: Don't use pointer to out-of-scope array
Message-ID: <alpine.LNX.2.00.1012242020090.28973@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

There's some suspicious code in fs/hpfs/ea.c::hpfs_read_ea().

First of all, in the 'while (pos < len)' loop a local char array 'ex' is 
defined and subsequently the pointer variable 'ea' is set to point to the 
array. Inside the loop we may jump to the 'indirect' label which is 
outside the loop scope. At the 'indirect' label 'ea' (which now points 
to a array that is no longer in scope) is dereferenced - that's not good. 
The patch below addresses that problem by moving the 'ex' array out of 
the loop scope and into function scope.
But please not that this patch is RFC, not intended to be applied just yet 
since I don't, yet, feel confident enough that I really know what's going 
on here.

Secondly I fail to see how this code inside the while loop can even work:

  if (hpfs_ea_read(s, a, ano, pos + 4, ea->namelen + 1 + (ea->indirect ? 8 : 0), ex + 4))

There is nothing initializing 'ex' which 'ea' points to, so 
'ea->namelen' and 'ea->indirect' are uninitialized.
Isn't this a problem?


Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 ea.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/hpfs/ea.c b/fs/hpfs/ea.c
index 45e53d9..4d6a90f 100644
--- a/fs/hpfs/ea.c
+++ b/fs/hpfs/ea.c
@@ -76,6 +76,7 @@ int hpfs_read_ea(struct super_block *s, struct fnode *fnode, char *key,
 	unsigned pos;
 	int ano, len;
 	secno a;
+	char ex[4 + 255 + 1 + 8];
 	struct extended_attribute *ea;
 	struct extended_attribute *ea_end = fnode_end_ea(fnode);
 	for (ea = fnode_ea(fnode); ea < ea_end; ea = next_ea(ea))
@@ -93,7 +94,6 @@ int hpfs_read_ea(struct super_block *s, struct fnode *fnode, char *key,
 	ano = fnode->ea_anode;
 	pos = 0;
 	while (pos < len) {
-		char ex[4 + 255 + 1 + 8];
 		ea = (struct extended_attribute *)ex;
 		if (pos + 4 > len) {
 			hpfs_error(s, "EAs don't end correctly, %s %08x, len %08x",



-- 
Jesper Juhl <jj@chaosbits.net>            http://www.chaosbits.net/
Don't top-post http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please.

