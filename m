Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753297Ab0K0PY3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Nov 2010 10:24:29 -0500
Received: from mail-ew0-f46.google.com ([209.85.215.46]:35259 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752679Ab0K0PY0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Nov 2010 10:24:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=tnXE6mQ+nhn+G5KIAQFPR6PqYGUISfEaL17hJd9+90Vm9ATB5pczFAKuJNKkl+HAdP
         3lSLcQ1BDBTncuU/neXhdwEu6scP8G6HuIk7td/jR6Nyoh6Jg7Wx8tYmhbFj+EZH4U83
         1rg5NqrzeNQwZGxg64hlWmZBaHLmXlTkrDFTc=
Date: Sat, 27 Nov 2010 17:24:21 +0200
From: Alexey Dobriyan <adobriyan@gmail.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] proc: less LOCK/UNLOCK in remove_proc_entry()
Message-ID: <20101127152420.GA9514@core2.telecom.by>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For the common case, when proc entry is being removed and nobody is in
the process of using it, save LOCK/UNLOCK pair.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 fs/proc/generic.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

--- a/fs/proc/generic.c
+++ b/fs/proc/generic.c
@@ -834,12 +834,9 @@ void remove_proc_entry(const char *name, struct proc_dir_entry *parent)
 
 		wait_for_completion(de->pde_unload_completion);
 
-		goto continue_removing;
+		spin_lock(&de->pde_unload_lock);
 	}
-	spin_unlock(&de->pde_unload_lock);
 
-continue_removing:
-	spin_lock(&de->pde_unload_lock);
 	while (!list_empty(&de->pde_openers)) {
 		struct pde_opener *pdeo;
 
