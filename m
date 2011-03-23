Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932802Ab1CWOuk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 10:50:40 -0400
Received: from mout.perfora.net ([74.208.4.195]:60219 "EHLO mout.perfora.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932438Ab1CWOui (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 10:50:38 -0400
From: Stephen Wilson <wilsons@start.ca>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Michel Lespinasse <walken@google.com>, Andi Kleen <ak@linux.intel.com>,
        Rik van Riel <riel@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Matt Mackall <mpm@selenic.com>, David Rientjes <rientjes@google.com>,
        Nick Piggin <npiggin@kernel.dk>,
        Andrea Arcangeli <aarcange@redhat.com>, Mel Gorman <mel@csn.ul.ie>,
        Hugh Dickins <hughd@google.com>, x86@kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Stephen Wilson <wilsons@start.ca>
Subject: [PATCH v2 resend 09/12] proc: disable mem_write after exec
Date: Wed, 23 Mar 2011 10:43:58 -0400
Message-Id: <1300891441-16280-10-git-send-email-wilsons@start.ca>
X-Mailer: git-send-email 1.7.3.5
In-Reply-To: <1300891441-16280-1-git-send-email-wilsons@start.ca>
References: <1300891441-16280-1-git-send-email-wilsons@start.ca>
X-Provags-ID: V02:K0:sYBGW34gTgzVBZLhbI0Ev9Lhbe8+CdEghamowS/hrk0
 laqrxXzrayFio5Y7U+e7T+LJqK4MD6frUAsSrlRqiuSk0XJC9X
 K1FXkfNNHxjfnVjfxB4c/hi4mzIbtcCC7AmQxiZZZWPaYnBwLQ
 iKinbZHtHmAT36NyZO2okcnfkaju20H/VzO4vv2C9fGwg0qQDy
 FCJ/1rUTGbwAoRmygvQdXWVuTQ3PQl7vA34c+epkrg=
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
index d49c4b5..13c5e8c 100644
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

