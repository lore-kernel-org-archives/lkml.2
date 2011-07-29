Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751330Ab1G2OcX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jul 2011 10:32:23 -0400
Received: from SMTP.ANDREW.CMU.EDU ([128.2.11.95]:49724 "EHLO
	smtp.andrew.cmu.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750861Ab1G2OcW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jul 2011 10:32:22 -0400
Date: Fri, 29 Jul 2011 10:28:43 -0400
From: Ben Blum <bblum@andrew.cmu.edu>
To: NeilBrown <neilb@suse.de>
Cc: Ben Blum <bblum@andrew.cmu.edu>, paulmck@linux.vnet.ibm.com,
        Paul Menage <menage@google.com>, Li Zefan <lizf@cn.fujitsu.com>,
        Oleg Nesterov <oleg@tv-sign.ru>, containers@lists.linux-foundation.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH][BUGFIX] cgroups: more safe tasklist locking in
 cgroup_attach_proc
Message-ID: <20110729142842.GA8462@unix33.andrew.cmu.edu>
References: <20110727171101.5e32d8eb@notabene.brown>
 <20110727150710.GB5242@unix33.andrew.cmu.edu>
 <20110727234235.GA2318@linux.vnet.ibm.com>
 <20110728110813.7ff84b13@notabene.brown>
 <20110728062616.GC15204@unix33.andrew.cmu.edu>
 <20110728171345.67d3797d@notabene.brown>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110728171345.67d3797d@notabene.brown>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-PMX-Version: 5.5.9.388399, Antispam-Engine: 2.7.2.376379, Antispam-Data: 2011.5.19.222118
X-SMTP-Spam-Clean: 8% (
 BODYTEXTP_SIZE_3000_LESS 0, BODY_SIZE_1400_1499 0, BODY_SIZE_2000_LESS 0, BODY_SIZE_5000_LESS 0, BODY_SIZE_7000_LESS 0, __ANY_URI 0, __CD 0, __CT 0, __CT_TEXT_PLAIN 0, __HAS_MSGID 0, __MIME_TEXT_ONLY 0, __MIME_VERSION 0, __SANE_MSGID 0, __TO_MALFORMED_2 0, __URI_NO_PATH 0, __URI_NO_WWW 0, __USER_AGENT 0)
X-SMTP-Spam-Score: 8%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix unstable tasklist locking in cgroup_attach_proc.

From: Ben Blum <bblum@andrew.cmu.edu>

According to this thread - https://lkml.org/lkml/2011/7/27/243 - RCU is
not sufficient to guarantee the tasklist is stable w.r.t. de_thread and
exit. Taking tasklist_lock for reading, instead of rcu_read_lock,
ensures proper exclusion.

Signed-off-by: Ben Blum <bblum@andrew.cmu.edu>
---
 kernel/cgroup.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff a/kernel/cgroup.c b/kernel/cgroup.c
--- a/kernel/cgroup.c	2011-07-21 19:17:23.000000000 -0700
+++ b/kernel/cgroup.c	2011-07-29 06:17:47.000000000 -0700
@@ -2024,7 +2024,7 @@
 		goto out_free_group_list;
 
 	/* prevent changes to the threadgroup list while we take a snapshot. */
-	rcu_read_lock();
+	read_lock(&tasklist_lock);
 	if (!thread_group_leader(leader)) {
 		/*
 		 * a race with de_thread from another thread's exec() may strip
@@ -2033,7 +2033,7 @@
 		 * throw this task away and try again (from cgroup_procs_write);
 		 * this is "double-double-toil-and-trouble-check locking".
 		 */
-		rcu_read_unlock();
+		read_unlock(&tasklist_lock);
 		retval = -EAGAIN;
 		goto out_free_group_list;
 	}
@@ -2054,7 +2054,7 @@
 	} while_each_thread(leader, tsk);
 	/* remember the number of threads in the array for later. */
 	group_size = i;
-	rcu_read_unlock();
+	read_unlock(&tasklist_lock);
 
 	/*
 	 * step 1: check that we can legitimately attach to the cgroup.
