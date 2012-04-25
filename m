Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758781Ab2DYUPv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 16:15:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61115 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758558Ab2DYUPt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 16:15:49 -0400
Date: Wed, 25 Apr 2012 16:15:40 -0400
From: Dave Jones <davej@redhat.com>
To: Robert =?utf-8?B?xZp3acSZY2tp?= <robert@swiecki.net>
Cc: linux-kernel@vger.kernel.org, Christoph Lameter <cl@linux.com>,
        linux-mm@kvack.org
Subject: Re: NULL-ptr deref in mmput via sys_migrate_pages in 3.4-rc4 (proly
 missing mm==NULL check)
Message-ID: <20120425201540.GA1560@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Robert =?utf-8?B?xZp3acSZY2tp?= <robert@swiecki.net>,
	linux-kernel@vger.kernel.org, Christoph Lameter <cl@linux.com>,
	linux-mm@kvack.org
References: <CAP145pgsaAN7uvj29Di6Qwtgrr54WvGL6X4rqU-fre8z_zJh4Q@mail.gmail.com>
 <CAP145pjuQ=Ja6bQLBFdOptzRG29qL2BRvMw=Qz7ub1TOjOn2XQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAP145pjuQ=Ja6bQLBFdOptzRG29qL2BRvMw=Qz7ub1TOjOn2XQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 3268c63eded4612a3d07b56d1e02ce7731e6608e introduced two potential NULL dereferences.
Move the mmput calls into the if arms that have already tested for a valid mm.

Reported-by: Robert Święcki <robert@swiecki.net>
Cc: Christoph Lameter <cl@linux.com>
Signed-off-by: Dave Jones <davej@redhat.com>

diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index cfb6c86..6de4850 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -1361,13 +1361,12 @@ SYSCALL_DEFINE4(migrate_pages, pid_t, pid, unsigned long, maxnode,
 
 	mm = get_task_mm(task);
 	put_task_struct(task);
-	if (mm)
+	if (mm) {
 		err = do_migrate_pages(mm, old, new,
 			capable(CAP_SYS_NICE) ? MPOL_MF_MOVE_ALL : MPOL_MF_MOVE);
-	else
+		mmput(mm);
+	} else
 		err = -EINVAL;
-
-	mmput(mm);
 out:
 	NODEMASK_SCRATCH_FREE(scratch);
 
diff --git a/mm/migrate.c b/mm/migrate.c
index 51c08a0..d73d860 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -1389,15 +1389,15 @@ SYSCALL_DEFINE6(move_pages, pid_t, pid, unsigned long, nr_pages,
 	put_task_struct(task);
 
 	if (mm) {
-		if (nodes)
+		if (nodes) {
 			err = do_pages_move(mm, task_nodes, nr_pages, pages,
 					    nodes, status, flags);
-		else
+			mmput(mm);
+		} else
 			err = do_pages_stat(mm, nr_pages, pages, status);
 	} else
 		err = -EINVAL;
 
-	mmput(mm);
 	return err;
 
 out:
