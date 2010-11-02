Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754805Ab0KBBpL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Nov 2010 21:45:11 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:52992 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754248Ab0KBBpJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Nov 2010 21:45:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:content-type:date:message-id:mime-version:x-mailer
         :content-transfer-encoding;
        b=K7usZPfOraPm0Fcu1DD+Bqzy6o0TkYtETtU0m6w2PWn3kgmWI26RsIMTMVbEvKtrZu
         6fgSJCSH98bnPjM6YbpmVqm2lKUydc89MOHRK5AcI+xV7gEEuZIuTuJrPHaM74/gmO1J
         U2bAPUam23ERMSw/YAPVnt5+q9kmzHeOzQvG4=
Subject: [PATCH]oom-kill: direct hardware access processes should get bonus
From: "Figo.zhang" <figo1802@gmail.com>
To: lkml <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Andrew Morton <akpm@osdl.org>,
        "rientjes@google.com" <rientjes@google.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 02 Nov 2010 09:43:33 +0800
Message-ID: <1288662213.10103.2.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


the victim should not directly access hardware devices like Xorg server,
because the hardware could be left in an unpredictable state, although 
user-application can set /proc/pid/oom_score_adj to protect it. so i think
those processes should get 3% bonus for protection.

Signed-off-by: Figo.zhang <figo1802@gmail.com>
---
mm/oom_kill.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/mm/oom_kill.c b/mm/oom_kill.c
index 4029583..df6a9da 100644
--- a/mm/oom_kill.c
+++ b/mm/oom_kill.c
@@ -195,10 +195,12 @@ unsigned int oom_badness(struct task_struct *p, struct mem_cgroup *mem,
 	task_unlock(p);
 
 	/*
-	 * Root processes get 3% bonus, just like the __vm_enough_memory()
-	 * implementation used by LSMs.
+	 * Root and direct hardware access processes get 3% bonus, just like the
+	 * __vm_enough_memory() implementation used by LSMs.
 	 */
-	if (has_capability_noaudit(p, CAP_SYS_ADMIN))
+	if (has_capability_noaudit(p, CAP_SYS_ADMIN) ||
+	    has_capability_noaudit(p, CAP_SYS_RESOURCE) ||
+	    has_capability_noaudit(p, CAP_SYS_RAWIO))
 		points -= 30;
 
 	/*


