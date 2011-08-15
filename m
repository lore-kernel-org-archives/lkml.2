Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752685Ab1HOXMN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 19:12:13 -0400
Received: from SMTP.ANDREW.CMU.EDU ([128.2.11.95]:35064 "EHLO
	smtp.andrew.cmu.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751091Ab1HOXMM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 19:12:12 -0400
Date: Mon, 15 Aug 2011 19:11:56 -0400
From: Ben Blum <bblum@andrew.cmu.edu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Oleg Nesterov <oleg@redhat.com>, Ben Blum <bblum@andrew.cmu.edu>,
        NeilBrown <neilb@suse.de>, paulmck@linux.vnet.ibm.com,
        Paul Menage <menage@google.com>, Li Zefan <lizf@cn.fujitsu.com>,
        containers@lists.linux-foundation.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH][BUGFIX] cgroups: fix ordering of calls in
 cgroup_attach_proc
Message-ID: <20110815231156.GC6867@unix33.andrew.cmu.edu>
References: <20110727171101.5e32d8eb@notabene.brown>
 <20110727150710.GB5242@unix33.andrew.cmu.edu>
 <20110727234235.GA2318@linux.vnet.ibm.com>
 <20110728110813.7ff84b13@notabene.brown>
 <20110728062616.GC15204@unix33.andrew.cmu.edu>
 <20110728171345.67d3797d@notabene.brown>
 <20110729142842.GA8462@unix33.andrew.cmu.edu>
 <20110815184957.GA16588@redhat.com>
 <20110815225003.GB29942@somewhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110815225003.GB29942@somewhere>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-PMX-Version: 5.5.9.388399, Antispam-Engine: 2.7.2.376379, Antispam-Data: 2011.5.19.222118
X-SMTP-Spam-Clean: 8% (
 BODYTEXTP_SIZE_3000_LESS 0, BODY_SIZE_1100_1199 0, BODY_SIZE_2000_LESS 0, BODY_SIZE_5000_LESS 0, BODY_SIZE_7000_LESS 0, __ANY_URI 0, __CD 0, __CT 0, __CT_TEXT_PLAIN 0, __HAS_MSGID 0, __MIME_TEXT_ONLY 0, __MIME_VERSION 0, __SANE_MSGID 0, __TO_MALFORMED_2 0, __URI_NO_PATH 0, __URI_NO_WWW 0, __USER_AGENT 0)
X-SMTP-Spam-Score: 8%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix ordering of cgroup_task_migrate and attach_task in cgroup_attach_proc.

Signed-off-by: Ben Blum <bblum@andrew.cmu.edu>

---
 kernel/cgroup.c |   15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff -u a/kernel/cgroup.c b/kernel/cgroup.c
--- a/kernel/cgroup.c	2011-08-15 19:05:37.308401219 -0400
+++ b/kernel/cgroup.c	2011-08-15 19:07:47.376775142 -0400
@@ -2132,14 +2132,17 @@
 		oldcgrp = task_cgroup_from_root(tsk, root);
 		if (cgrp == oldcgrp)
 			continue;
-		/* attach each task to each subsystem */
-		for_each_subsys(root, ss) {
-			if (ss->attach_task)
-				ss->attach_task(cgrp, tsk);
-		}
 		/* if the thread is PF_EXITING, it can just get skipped. */
 		retval = cgroup_task_migrate(cgrp, oldcgrp, tsk, true);
-		BUG_ON(retval != 0 && retval != -ESRCH);
+		if (retval == 0) {
+			/* attach each task to each subsystem */
+			for_each_subsys(root, ss) {
+				if (ss->attach_task)
+					ss->attach_task(cgrp, tsk);
+			}
+		} else {
+			BUG_ON(retval != -ESRCH);
+		}
 	}
 	/* nothing is sensitive to fork() after this point. */

