Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756943Ab1CIAow (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Mar 2011 19:44:52 -0500
Received: from mout.perfora.net ([74.208.4.194]:57872 "EHLO mout.perfora.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756881Ab1CIAou (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Mar 2011 19:44:50 -0500
From: Stephen Wilson <wilsons@start.ca>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Rik van Riel <riel@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Roland McGrath <roland@redhat.com>, Matt Mackall <mpm@selenic.com>,
        David Rientjes <rientjes@google.com>, Nick Piggin <npiggin@kernel.dk>,
        Andrea Arcangeli <aarcange@redhat.com>, Mel Gorman <mel@csn.ul.ie>,
        Ingo Molnar <mingo@elte.hu>, Michel Lespinasse <walken@google.com>,
        Hugh Dickins <hughd@google.com>, linux-kernel@vger.kernel.org,
        Stephen Wilson <wilsons@start.ca>
Subject: [PATCH 4/6] proc: disable mem_write after exec
Date: Tue,  8 Mar 2011 19:42:21 -0500
Message-Id: <1299631343-4499-5-git-send-email-wilsons@start.ca>
X-Mailer: git-send-email 1.7.3.5
In-Reply-To: <1299631343-4499-1-git-send-email-wilsons@start.ca>
References: <1299631343-4499-1-git-send-email-wilsons@start.ca>
X-Provags-ID: V02:K0:df7N76WAs5BLsQiMgbZ0/e1xtsTwkzQezoe2DTZVtci
 UDK/KRNai3NgakutO8HrAokYtVgeZpGfqZO2Vi+OLez2UR3Kt5
 6HXakvCPccE3pG5w7D4tGkAtnFh5Uu3Hbo3W0AKuGgboHzTov7
 hcHYv3cKUIPzHpF6th2mehN3DKMdlrEhsG+AG6Du+KiK9DRmHQ
 2dLcop5s0KG3NKoXXHqzcSSx8yQMoqhAamr9I+lazk=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This change makes mem_write() observe the same constraints as mem_read().  This
is particularly important for mem_write as an accidental leak of the fd across
an exec could result in arbitrary modification of the target process' memory.
IOW, /proc/pid/mem is implicitly close-on-exec.

Signed-off-by: Stephen Wilson <wilsons@start.ca>
---
 fs/proc/base.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/fs/proc/base.c b/fs/proc/base.c
index 9d096e8..e52702d 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -848,6 +848,10 @@ static ssize_t mem_write(struct file * file, const char __user *buf,
 	if (check_mem_permission(task))
 		goto out;
 
+	copied = -EIO;
+	if (file->private_data != (void *)((long)current->self_exec_id))
+		goto out;
+
 	copied = -ENOMEM;
 	page = (char *)__get_free_page(GFP_TEMPORARY);
 	if (!page)
-- 
1.7.3.5

