Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756683Ab0KJPZ6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 10:25:58 -0500
Received: from mail-pv0-f174.google.com ([74.125.83.174]:34908 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756593Ab0KJPZ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 10:25:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=WZ4Ex7hylBYpI3yMMx2tWhOqlTWu2A7M7TNtk5RSB3dkSKLlu+45XwTZaD3MldHv9w
         z+2TtN4znN3rcRbbuA9hqbE3zvI970LUkmhCpflKshaq4UlZFkRu8BTmFW7/F1MAZIWw
         DIrS6nTwAPc7zrYclur/a+yfgV3VkN8Zox6QU=
Subject: [PATCH v3]mm/oom-kill: direct hardware access processes should get
 bonus
From: "Figo.zhang" <figo1802@gmail.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Andrew Morton <akpm@osdl.org>,
        "rientjes@google.com" <rientjes@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Figo.zhang" <zhangtianfei@leadcoretech.com>
In-Reply-To: <1289402093.10699.25.camel@localhost.localdomain>
References: <1288662213.10103.2.camel@localhost.localdomain>
	 <1289305468.10699.2.camel@localhost.localdomain>
	 <1289402093.10699.25.camel@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 10 Nov 2010 23:24:26 +0800
Message-ID: <1289402666.10699.28.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

the victim should not directly access hardware devices like Xorg server,
because the hardware could be left in an unpredictable state, although 
user-application can set /proc/pid/oom_score_adj to protect it. so i think
those processes should get bonus for protection.

in v2, fix the incorrect comment.
in v3, change the divided the badness score by 4, like old heuristic for protection. we just
want the oom_killer don't select Root/RESOURCE/RAWIO process as possible.

suppose that if a user process A such as email cleint "evolution" and a process B with
ditecly hareware access such as "Xorg", they have eat the equal memory (the badness score is 
the same),so which process are you want to kill? so in new heuristic, it will kill the process B.
but in reality, we want to kill process A.

Signed-off-by: Figo.zhang <figo1802@gmail.com>
Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
---
mm/oom_kill.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/mm/oom_kill.c b/mm/oom_kill.c
index 4029583..f43d759 100644
--- a/mm/oom_kill.c
+++ b/mm/oom_kill.c
@@ -202,6 +202,15 @@ unsigned int oom_badness(struct task_struct *p, struct mem_cgroup *mem,
 		points -= 30;
 
 	/*
+	 * Root and direct hareware access processes are usually more 
+	 * important, so they should get bonus for protection. 
+	 */
+	if (has_capability_noaudit(p, CAP_SYS_ADMIN) ||
+	    has_capability_noaudit(p, CAP_SYS_RESOURCE) ||
+	    has_capability_noaudit(p, CAP_SYS_RAWIO))
+		points /= 4;
+
+	/*
 	 * /proc/pid/oom_score_adj ranges from -1000 to +1000 such that it may
 	 * either completely disable oom killing or always prefer a certain
 	 * task.


