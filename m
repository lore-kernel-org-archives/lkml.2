Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932548Ab1CWKGm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 06:06:42 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:65002 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932506Ab1CWKGf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 06:06:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=XEWe3zKfRJPRmX6z6xW6hh5nuaAdQKx+aQfqKmIIn4CSqyFCI1NfqC2QV/brnrDKoT
         acGZMP+Q7ao5FfvicxUkpLrhM2WCtEdZ3Jmxgqhz+sv6DQqSw+azmmZR0ZKqXy2Wn+Ic
         Z5qdSU6Z+fIdknvfUE5QdN72fzQEeIUH+xhAA=
From: Tejun Heo <tj@kernel.org>
To: oleg@redhat.com, jan.kratochvil@redhat.com, vda.linux@googlemail.com
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, indan@nul.nu, roland@hack.frob.com,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 14/20] job control: Small reorganization of wait_consider_task()
Date: Wed, 23 Mar 2011 11:06:00 +0100
Message-Id: <1300874766-12941-15-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1300874766-12941-1-git-send-email-tj@kernel.org>
References: <1300874766-12941-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move EXIT_DEAD test in wait_consider_task() above ptrace check.  As
ptraced tasks can't be EXIT_DEAD, this change doesn't cause any
behavior change.  This is to prepare for further changes.

Signed-off-by: Tejun Heo <tj@kernel.org>
Acked-by: Oleg Nesterov <oleg@redhat.com>
---
 kernel/exit.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/kernel/exit.c b/kernel/exit.c
index f9a45eb..b4a935c 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -1537,6 +1537,10 @@ static int wait_consider_task(struct wait_opts *wo, int ptrace,
 		return 0;
 	}
 
+	/* dead body doesn't have much to contribute */
+	if (p->exit_state == EXIT_DEAD)
+		return 0;
+
 	if (likely(!ptrace) && unlikely(task_ptrace(p))) {
 		/*
 		 * This child is hidden by ptrace.
@@ -1546,9 +1550,6 @@ static int wait_consider_task(struct wait_opts *wo, int ptrace,
 		return 0;
 	}
 
-	if (p->exit_state == EXIT_DEAD)
-		return 0;
-
 	/*
 	 * We don't reap group leaders with subthreads.
 	 */
-- 
1.7.1

