Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754593Ab1CUVYK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 17:24:10 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:19599 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754360Ab1CUVYG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 17:24:06 -0400
Date: Mon, 21 Mar 2011 22:23:57 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
cc: Justin Mattock <justinmattock@gmail.com>,
        Stephen Smalley <sds@tycho.nsa.gov>, James Morris <jmorris@namei.org>,
        Eric Paris <eparis@parisplace.org>,
        linux-security-module@vger.kernel.org
Subject: [PATCH][RFC] Null short-circuit for selinux_cred_free()
Message-ID: <alpine.LNX.2.00.1103212215230.23432@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Let selinux_cred_free accept NULL pointers.
If we don't do this, then we can crash if someone manages to pass NULL to 
cred_free. Seems to me it's better to just do nothing in that case rather 
than crash.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 hooks.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index 6475e1f..d2216cf 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -3232,13 +3232,16 @@ static int selinux_cred_alloc_blank(struct cred *cred, gfp_t gfp)
  */
 static void selinux_cred_free(struct cred *cred)
 {
-	struct task_security_struct *tsec = cred->security;
+	struct task_security_struct *tsec;
 
+	if (!cred)
+		return;
 	/*
 	 * cred->security == NULL if security_cred_alloc_blank() or
 	 * security_prepare_creds() returned an error.
 	 */
-	BUG_ON(cred->security && (unsigned long) cred->security < PAGE_SIZE);
+	BUG_ON(cred->security && (unsigned long)cred->security < PAGE_SIZE);
+	tsec = cred->security;
 	cred->security = (void *) 0x7UL;
 	kfree(tsec);
 }


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

