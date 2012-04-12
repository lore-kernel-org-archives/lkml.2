Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762172Ab2DLIJ6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 04:09:58 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:44101 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762156Ab2DLIJx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 04:09:53 -0400
Subject: [PATCH 1/2] mm: set task exit code before complete_vfork_done()
To: Andrew Morton <akpm@linux-foundation.org>
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Hugh Dickins <hughd@google.com>, Oleg Nesterov <oleg@redhat.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Date: Thu, 12 Apr 2012 12:09:48 +0400
Message-ID: <20120412080948.26401.23572.stgit@zurg>
In-Reply-To: <20120409200336.8368.63793.stgit@zurg>
References: <20120409200336.8368.63793.stgit@zurg>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kthread_stop() uses task->vfork_done for synchronization. The exiting kthread
shouldn't do complete_vfork_done() until it sets ->exit_code.

fix for mm-correctly-synchronize-rss-counters-at-exit-exec.patch

Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Oleg Nesterov <oleg@redhat.com>
---
 kernel/exit.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/kernel/exit.c b/kernel/exit.c
index eb12719..70875a6 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -960,6 +960,9 @@ void do_exit(long code)
 
 	acct_update_integrals(tsk);
 
+	/* Set exit_code before complete_vfork_done() in mm_release() */
+	tsk->exit_code = code;
+
 	/* Release mm and sync mm's RSS info before statistics gathering */
 	mm_release(tsk, tsk->mm);
 
@@ -975,7 +978,6 @@ void do_exit(long code)
 		tty_audit_exit();
 	audit_free(tsk);
 
-	tsk->exit_code = code;
 	taskstats_exit(tsk, group_dead);
 
 	exit_mm(tsk);

