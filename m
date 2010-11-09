Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755532Ab0KIMZc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 07:25:32 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:36085 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755167Ab0KIMZb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 07:25:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=XW5fx0MFvQN8BBvchMwX/+Z+1R3PjcbqRPBS2QgNIvrZO0VIjdYT5v2eXO/JNtOUl9
         Bw2wJLCRFZbxZYBuHxeCAOKr7l7LXxIf1FlRVEo5MW4I8KPpdp9qzyRGDO4vv5rjyPZV
         +bOvj2QTNKl7VlGztmhVxy5/mK71i5u3CJDjE=
Subject: [PATCH v2]mm/oom-kill: direct hardware access processes should get
 bonus
From: "Figo.zhang" <figo1802@gmail.com>
To: lkml <linux-kernel@vger.kernel.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>, Andrew Morton <akpm@osdl.org>,
        "rientjes@google.com" <rientjes@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <1288662213.10103.2.camel@localhost.localdomain>
References: <1288662213.10103.2.camel@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 09 Nov 2010 20:24:28 +0800
Message-ID: <1289305468.10699.2.camel@localhost.localdomain>
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

in v2, fix the incorrect comment.

Signed-off-by: Figo.zhang <figo1802@gmail.com>
Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
---
mm/oom_kill.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/mm/oom_kill.c b/mm/oom_kill.c
index 4029583..9b06f56 100644
--- a/mm/oom_kill.c
+++ b/mm/oom_kill.c
@@ -196,9 +196,12 @@ unsigned int oom_badness(struct task_struct *p, struct mem_cgroup *mem,
 
 	/*
 	 * Root processes get 3% bonus, just like the __vm_enough_memory()
-	 * implementation used by LSMs.
+	 * implementation used by LSMs. And direct hardware access processes
+	 * also get 3% bonus.
 	 */
-	if (has_capability_noaudit(p, CAP_SYS_ADMIN))
+	if (has_capability_noaudit(p, CAP_SYS_ADMIN) ||
+	    has_capability_noaudit(p, CAP_SYS_RESOURCE) ||
+	    has_capability_noaudit(p, CAP_SYS_RAWIO))
 		points -= 30;
 
 	/*


