Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755459Ab0J3RbJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Oct 2010 13:31:09 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:28719 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754777Ab0J3RbI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Oct 2010 13:31:08 -0400
Date: Sat, 30 Oct 2010 19:20:51 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: linuxppc-dev@lists.ozlabs.org
cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, linux-kernel@vger.kernel.org
Subject: [PATCH] iSeries: Don't leak if allocations fail in
 mf_getSrcHistory
Message-ID: <alpine.LNX.2.00.1010301911220.1572@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

If memory is tight and a dynamic allocation fails there's no reason to 
make a bad situation worse by leaking memory.

mf_getSrcHistory potentially leaks pages[0-3]. I believe the right thing 
to do is to free that memory again before returning -ENOMEM - which is 
what this patch does.

I realize that the function is under '#if 0' so this probably doesn't 
matter much, but I assume that the function is still there for a reason 
(but I could be wrong, I don't know the powerpc code).
Anyway, I suggest we remove the leak.

Please keep me on CC when replying.


Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 mf.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/arch/powerpc/platforms/iseries/mf.c b/arch/powerpc/platforms/iseries/mf.c
index 42d0a88..f67522a 100644
--- a/arch/powerpc/platforms/iseries/mf.c
+++ b/arch/powerpc/platforms/iseries/mf.c
@@ -1058,8 +1058,13 @@ static void mf_getSrcHistory(char *buffer, int size)
 	pages[2] = kmalloc(4096, GFP_ATOMIC);
 	pages[3] = kmalloc(4096, GFP_ATOMIC);
 	if ((ev == NULL) || (pages[0] == NULL) || (pages[1] == NULL)
-			 || (pages[2] == NULL) || (pages[3] == NULL))
+			 || (pages[2] == NULL) || (pages[3] == NULL)) {
+		kfree(pages[3]);
+		kfree(pages[2]);
+		kfree(pages[1]);
+		kfree(pages[0]);
 		return -ENOMEM;
+	}
 
 	return_stuff.xType = 0;
 	return_stuff.xRc = 0;


-- 
Jesper Juhl <jj@chaosbits.net>             http://www.chaosbits.net/
Plain text mails only, please      http://www.expita.com/nomime.html
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html

