Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758500Ab2CSQLy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 12:11:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7709 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758231Ab2CSQLv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 12:11:51 -0400
Date: Mon, 19 Mar 2012 17:04:01 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Al Viro <viro@zeniv.linux.org.uk>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        James Morris <james.l.morris@oracle.com>,
        Greg KH <gregkh@linuxfoundation.org>, Ingo Molnar <mingo@elte.hu>,
        Roland McGrath <roland@hack.frob.com>,
        Solar Designer <solar@openwall.com>,
        Djalal Harouni <tixxdz@opendz.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] exec: move de_thread()->setmax_mm_hiwater_rss() into
	exec_mmap()
Message-ID: <20120319160401.GD4910@redhat.com>
References: <1331421919-15499-1-git-send-email-tixxdz@opendz.org> <1331421919-15499-2-git-send-email-tixxdz@opendz.org> <20120311172512.GA2729@redhat.com> <20120311174953.GB2729@redhat.com> <CA+55aFx43nZmhRg5Qv5x-4BdgcM-y80ECrgC8mCWc0RqU+_8rQ@mail.gmail.com> <20120314185510.GA14172@redhat.com> <20120314190939.GC14172@redhat.com> <20120319160249.GA4910@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120319160249.GA4910@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Minor cleanup. de_thread()->setmax_mm_hiwater_rss() looks a bit
strange, move it into exec_mmap() which plays with old_mm.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 fs/exec.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/fs/exec.c b/fs/exec.c
index 218d074..7f84e86 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -848,6 +848,7 @@ static int exec_mmap(struct mm_struct *mm)
 	if (old_mm) {
 		up_read(&old_mm->mmap_sem);
 		BUG_ON(active_mm != old_mm);
+		setmax_mm_hiwater_rss(&tsk->signal->maxrss, old_mm);
 		mm_update_next_owner(old_mm);
 		mmput(old_mm);
 		return 0;
@@ -978,9 +979,6 @@ no_thread_group:
 	/* we have changed execution domain */
 	tsk->exit_signal = SIGCHLD;
 
-	if (current->mm)
-		setmax_mm_hiwater_rss(&sig->maxrss, current->mm);
-
 	exit_itimers(sig);
 	flush_itimer_signals();
 
-- 
1.5.5.1


