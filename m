Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758227Ab2EaSD1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 14:03:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13759 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757352Ab2EaSDY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 14:03:24 -0400
Date: Thu, 31 May 2012 19:20:01 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Hugh Dickins <hughd@google.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        Martin Mokrejs <mmokrejs@fold.natur.cuni.cz>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] call complete_vfork_done() after
	put_user(clear_child_tid)
Message-ID: <20120531172001.GB17513@redhat.com>
References: <20120531171914.GA17505@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120531171914.GA17505@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Konstantin Khlebnikov <khlebnikov@openvz.org>

Child should wake up parent from vfork() only after finishing all operations with
shared mm. There is no sense to use CLONE_CHILD_CLEARTID together with CLONE_VFORK,
but it looks more accurate now.

Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 kernel/fork.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/fork.c b/kernel/fork.c
index 47b4e4f..ba0c0de 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -787,9 +787,6 @@ void mm_release(struct task_struct *tsk, struct mm_struct *mm)
 	/* Get rid of any cached register state */
 	deactivate_mm(tsk, mm);
 
-	if (tsk->vfork_done)
-		complete_vfork_done(tsk);
-
 	/*
 	 * If we're exiting normally, clear a user-space tid field if
 	 * requested.  We leave this alone when dying by signal, to leave
@@ -810,6 +807,9 @@ void mm_release(struct task_struct *tsk, struct mm_struct *mm)
 		}
 		tsk->clear_child_tid = NULL;
 	}
+
+	if (tsk->vfork_done)
+		complete_vfork_done(tsk);
 }
 
 /*
-- 
1.5.5.1


